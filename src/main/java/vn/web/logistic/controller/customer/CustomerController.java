package vn.web.logistic.controller.customer;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.security.crypto.password.PasswordEncoder;

import jakarta.servlet.http.HttpSession;
import vn.web.logistic.entity.User;
import vn.web.logistic.config.VNPAYConfig;
import vn.web.logistic.dto.response.TransactionResponse;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.SupportTicket;
import vn.web.logistic.enums.HubLevel;
import vn.web.logistic.enums.HubStatus;
import vn.web.logistic.enums.PaymentStatus;
import vn.web.logistic.enums.RequestStatus;
import vn.web.logistic.enums.TicketStatus;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.SupportTicketRepository;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.VnpayTransactionRepository;
import vn.web.logistic.service.EmailService;
import vn.web.logistic.service.OrderService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;


import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ServiceRequestRepository serviceRequestRepository;
    
    @Autowired
    private CodTransactionRepository codTransactionRepository;

    @Autowired
    private VnpayTransactionRepository vnpayTransactionRepository;

    /**
     * TRANG TỔNG QUAN (OVERVIEW)
     */
    @GetMapping("/overview")
    public String showOverview(Model model, Principal principal) {
        // 1. Sử dụng hàm bổ trợ để lấy thông tin Shop
        Customer customer = getLoggedInCustomer(principal);
        User user = customer.getUser(); // Lấy thông tin user từ thực thể Customer

        // 2. Thống kê số lượng đơn hàng
        long pendingCount = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.pending);
        long successCount = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.delivered);
        long failedCount = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.failed);
        
        long deliveringCount = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.picked) 
                             + serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.in_transit);

        // 3. Tính toán dòng tiền COD dự kiến
        BigDecimal pendingCod = safeValue(serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.pending));
        BigDecimal successCod = safeValue(serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.delivered));
        BigDecimal deliveringCod = safeAdd(
            serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.picked),
            serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.in_transit)
        );

        // 4. Các chỉ số hiệu suất
        BigDecimal totalShippingFee = safeValue(serviceRequestRepository.sumTotalShippingFee(customer));
        long totalOrders = serviceRequestRepository.countByCustomer(customer);
        double returnRate = (totalOrders > 0) ? (double) failedCount / totalOrders * 100 : 0;

        // 5. Chuẩn bị dữ liệu Biểu đồ (Trend 7 ngày)
        List<Object[]> trendData = serviceRequestRepository.getDailyStatsLast7Days(customer.getCustomerId());
        
        String labelsJson = trendData.stream().map(row -> "'" + row[0].toString() + "'").collect(Collectors.joining(","));
        String countsJson = trendData.stream().map(row -> String.valueOf(((Number) row[1]).longValue())).collect(Collectors.joining(","));
        String amountsJson = trendData.stream().map(row -> String.valueOf(row[2] != null ? row[2] : 0)).collect(Collectors.joining(","));

        // 6. Đẩy dữ liệu vào Model
        model.addAttribute("username", user.getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "overview");

        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("pendingCod", pendingCod);
        model.addAttribute("successCount", successCount);
        model.addAttribute("successCod", successCod);
        model.addAttribute("deliveringCount", deliveringCount);
        model.addAttribute("deliveringCod", deliveringCod);
        model.addAttribute("totalShippingFee", totalShippingFee);
        model.addAttribute("failedCount", failedCount);
        model.addAttribute("returnRate", Math.round(returnRate));

        model.addAttribute("trendLabelsJson", labelsJson);
        model.addAttribute("trendOrderCountsJson", countsJson);
        model.addAttribute("trendCodAmountsJson", amountsJson);

        return "customer/overview";
    }

    /**
     * TRANG DÒNG TIỀN (CASH FLOW)
     */
    @GetMapping("/cashflow")
    public String getCashFlow(Model model, Principal principal) {
        Customer customer = getLoggedInCustomer(principal);

        // 1. Tính số dư COD đang giữ hộ (Delivered & Unpaid)
        BigDecimal codHolding = serviceRequestRepository
            .findByCustomerAndStatusAndPaymentStatus(customer, RequestStatus.delivered, PaymentStatus.unpaid)
            .stream()
            .map(ServiceRequest::getCodAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 2. Gộp lịch sử giao dịch từ COD và VNPAY
        List<TransactionResponse> history = new ArrayList<>();

        // Giao dịch COD (Tiền thu hộ và Đối soát)
        codTransactionRepository.findByRequest_CustomerOrderByCollectedAtDesc(customer).forEach(ct -> {
            if (ct.getCollectedAt() != null) {
                history.add(TransactionResponse.builder()
                    .transactionDate(ct.getFormattedCollectedAt())
                    .transactionType("Thu hộ COD")
                    .orderId("#" + ct.getRequest().getRequestId())
                    .amount(ct.getAmount())
                    .flowType("IN")
                    .status(ct.getStatus().name())
                    .build());
            }
            if (ct.getSettledAt() != null) {
                history.add(TransactionResponse.builder()
                    .transactionDate(ct.getFormattedSettledAt())
                    .transactionType("Đối soát trả tiền")
                    .orderId("#" + ct.getRequest().getRequestId())
                    .amount(ct.getAmount())
                    .flowType("OUT")
                    .status("Completed")
                    .build());
            }
        });

        // Giao dịch VNPAY (Thanh toán phí)
        vnpayTransactionRepository.findByRequest_CustomerOrderByCreatedAtDesc(customer).forEach(vt -> {
            history.add(TransactionResponse.builder()
                .transactionDate(vt.getFormattedCreatedAt())
                .transactionType("Thanh toán VNPAY")
                .orderId("#" + vt.getRequest().getRequestId())
                .amount(vt.getAmount())
                .flowType("OUT")
                .status(vt.getPaymentStatus().name())
                .build());
        });

        // Sắp xếp theo thời gian giảm dần
        history.sort((a, b) -> b.getTransactionDate().compareTo(a.getTransactionDate()));

        model.addAttribute("codHolding", codHolding);
        model.addAttribute("history", history);
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "cashflow");
        
        return "customer/cashflow";
    }

    /**
     * QUẢN LÝ ĐƠN HÀNG (ORDER MANAGEMENT)
     */
    @GetMapping("/orders")
    public String manageOrders(
        @RequestParam(required = false) Long orderId,
        @RequestParam(required = false) RequestStatus status,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
        Model model, Principal principal
    ) {
        Customer customer = getLoggedInCustomer(principal);

        // Thiết lập khoảng thời gian lọc (Mặc định 30 ngày)
        LocalDateTime start = (fromDate != null) ? fromDate.atStartOfDay() : LocalDateTime.now().minusMonths(1);
        LocalDateTime end = (toDate != null) ? toDate.atTime(LocalTime.MAX) : LocalDateTime.now();

        List<ServiceRequest> orders = serviceRequestRepository.searchOrders(customer, status, orderId, start, end);

        model.addAttribute("orders", orders);
        model.addAttribute("statuses", RequestStatus.values());
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "orders");
        
        // Trả lại các tham số lọc về giao diện
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedId", orderId);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);

        return "customer/orders";
    }

    /**
     * HÀM BỔ TRỢ (HELPER METHODS)
     */
    private Customer getLoggedInCustomer(Principal principal) {
        if (principal == null) throw new RuntimeException("Chưa đăng nhập");
        String username = principal.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng: " + username));
        
        return customerRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hồ sơ Shop"));
    }

    private BigDecimal safeValue(BigDecimal value) {
        return (value != null) ? value : BigDecimal.ZERO;
    }

    private BigDecimal safeAdd(BigDecimal b1, BigDecimal b2) {
        return safeValue(b1).add(safeValue(b2));
    }
    
    /**
     * QUẢN LÝ ĐỊA CHỈ, HUBS
     */
    @Autowired
    private CustomerAddressRepository customerAddressRepository;

    @Autowired
    private HubRepository hubRepository;

    @GetMapping("/addressbook")
    public String getAddressBook(Model model, Principal principal) {
        Customer customer = getLoggedInCustomer(principal); // Sử dụng hàm bổ trợ đã viết

        // 1. Lấy danh sách địa chỉ của Shop
        List<CustomerAddress> addresses = customerAddressRepository.findByCustomerOrderByAddressIdDesc(customer);
        
        // 2. Lấy danh sách bưu cục gửi hàng
        List<Hub> hubs = hubRepository.findAll();

        model.addAttribute("addresses", addresses);
        model.addAttribute("hubs", hubs);
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "addressbook");
        
        return "customer/addressbook";
    }

    @PostMapping("/addressbook/add")
    public String addAddress(@ModelAttribute CustomerAddress address, Principal principal) {
        Customer customer = getLoggedInCustomer(principal);
        address.setCustomer(customer);
        customerAddressRepository.save(address);
        return "redirect:/customer/addressbook";
    }

    @GetMapping("/addressbook/delete")
    public String deleteAddress(@RequestParam Long id, Principal principal) {
        // Kiểm tra quyền sở hữu trước khi xóa để đảm bảo an toàn
        Customer customer = getLoggedInCustomer(principal);
        CustomerAddress addr = customerAddressRepository.findById(id).orElseThrow();
        if(addr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            customerAddressRepository.delete(addr);
        }
        return "redirect:/customer/addressbook";
    }
    
    /**
     * HELP CENTER
     */
    @Autowired
    private SupportTicketRepository supportTicketRepository;
    

    @GetMapping("/support")
    public String getHelpCenter(Model model, Principal principal) {
        // 1. Lấy thông tin Shop đang đăng nhập
        Customer customer = getLoggedInCustomer(principal);
        
        // 2. Lấy danh sách đơn hàng để khách chọn khi gửi khiếu nại
        List<ServiceRequest> orders = serviceRequestRepository.findByCustomerOrderByCreatedAtDesc(customer);
        
        // 3. Lấy danh sách bưu cục hệ thống
        List<Hub> hubs = hubRepository.findAll();
        
        // 4. Lấy lịch sử khiếu nại của chính khách hàng này
        List<SupportTicket> myTickets = supportTicketRepository.findByCustomerOrderByCreatedAtDesc(customer);

        model.addAttribute("orders", orders);
        model.addAttribute("hubs", hubs);
        model.addAttribute("myTickets", myTickets);
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "help");
        
        return "customer/support";
    }

    @PostMapping("/support/ticket/add")
    public String submitTicket(@RequestParam Long requestId, 
                               @RequestParam String subject, 
                               @RequestParam String message, 
                               Principal principal) {
        Customer customer = getLoggedInCustomer(principal);
        ServiceRequest order = serviceRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));
        
        // Tạo đối tượng Ticket mới theo mẫu Builder bạn đã định nghĩa
        SupportTicket ticket = SupportTicket.builder()
                .customer(customer)
                .serviceRequest(order)
                .subject(subject)
                .message(message)
                .status(TicketStatus.pending)
                .build();
        
        supportTicketRepository.save(ticket);
        return "redirect:/customer/support?success=true";
    }
    
    /**
     * CUSTOMER PROFILE
     */
    @Autowired
    private EmailService emailService;
    
    @GetMapping("/profile")
    public String getProfile(Model model, Principal principal) {
        Customer customer = getLoggedInCustomer(principal); // Hàm bổ trợ bạn đã có
        User user = customer.getUser(); // Lấy từ liên kết OneToOne

        model.addAttribute("customer", customer);
        model.addAttribute("user", user);
        model.addAttribute("username", user.getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "profile");
        
        return "customer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName, 
                                 @RequestParam String email,
                                 @RequestParam String businessName,
                                 @RequestParam String phone,
                                 Principal principal, RedirectAttributes ra) {
        Customer customer = getLoggedInCustomer(principal);
        User user = customer.getUser();

        // 1. Cập nhật bảng USERS
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        userRepository.save(user);

        // 2. Cập nhật bảng CUSTOMERS
        customer.setBusinessName(businessName);
        customer.setPhone(phone); // Đồng bộ SĐT
        customerRepository.save(customer);

        ra.addFlashAttribute("message", "Cập nhật hồ sơ thành công!");
        return "redirect:/customer/profile";
    }
    
    @PostMapping("/profile/send-otp")
    @ResponseBody
    public ResponseEntity<?> sendOtp(@RequestParam String newEmail, Principal principal, HttpSession session) {
        if (userRepository.existsByEmail(newEmail)) {
            return ResponseEntity.badRequest().body("Email này đã được sử dụng!");
        }

        String otp = String.format("%06d", new java.util.Random().nextInt(1000000));
        
        session.setAttribute("emailOtp", otp);
        session.setAttribute("pendingEmail", newEmail);

        // Gửi Mail thật thay vì in console
        try {
            emailService.sendOtpEmail(newEmail, otp);
            return ResponseEntity.ok("Mã xác thực đã được gửi đến " + newEmail);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi khi gửi email: " + e.getMessage());
        }
    }

    // 2. Endpoint xác nhận OTP và cập nhật toàn bộ hồ sơ
    @PostMapping("/profile/update-final")
    public String updateProfileFinal(
            @RequestParam String fullName, @RequestParam String businessName, @RequestParam String phone,
            @RequestParam String bankName,           
            @RequestParam String bankBranch,         
            @RequestParam String accountHolderName,  
            @RequestParam String accountNumber,
            @RequestParam(required = false) String otp,
            @RequestParam(required = false) MultipartFile avatarFile, // Nhận file ảnh
            Principal principal, HttpSession session, RedirectAttributes ra) throws IOException {
        Customer customer = getLoggedInCustomer(principal);
        User user = customer.getUser();
        String pendingEmail = (String) session.getAttribute("pendingEmail");
        String serverOtp = (String) session.getAttribute("emailOtp");
        
     // 1. Xử lý Upload Avatar
        if (avatarFile != null && !avatarFile.isEmpty()) {
            String fileName = "avatar_" + user.getUserId() + "_" + System.currentTimeMillis() + ".jpg";
            String uploadDir = "src/main/resources/static/uploads/avatars/";
            
            // Lưu file vật lý vào server
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);
            try (InputStream inputStream = avatarFile.getInputStream()) {
                Files.copy(inputStream, uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Cập nhật trường avatar_url vào entity User
            user.setAvatarUrl("/uploads/avatars/" + fileName);
        }
        
     // 2. Logic cập nhật thông tin khác
        // Nếu khách hàng đổi sang email mới (khác email hiện tại)
        if (pendingEmail != null && !pendingEmail.equals(user.getEmail())) {
            if (otp == null || !otp.equals(serverOtp)) {
                ra.addFlashAttribute("error", "Mã xác thực không chính xác hoặc đã hết hạn!");
                return "redirect:/customer/profile";
            }
            user.setEmail(pendingEmail); // Cập nhật email thật sau khi xác thực
            session.removeAttribute("emailOtp");
            session.removeAttribute("pendingEmail");
        }

        // Cập nhật các thông tin khác
        user.setFullName(fullName);
        user.setPhone(phone);
        userRepository.save(user);

        customer.setBusinessName(businessName);
        customer.setPhone(phone);
        customer.setBankName(bankName);
        customer.setBankBranch(bankBranch);
        customer.setAccountHolderName(accountHolderName);
        customer.setAccountNumber(accountNumber);
        customerRepository.save(customer);

        ra.addFlashAttribute("message", "Cập nhật hồ sơ thành công!");
        return "redirect:/customer/profile";
    }
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam String currentPassword, 
                                 @RequestParam String newPassword, 
                                 Principal principal, RedirectAttributes ra) {
        Customer customer = getLoggedInCustomer(principal);
        User user = customer.getUser();

        // 1. Kiểm tra mật khẩu cũ (Sử dụng PasswordEncoder)
        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            ra.addFlashAttribute("error", "Mật khẩu hiện tại không chính xác!");
            return "redirect:/customer/profile";
        }

        // 2. Cập nhật mật khẩu mới
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        ra.addFlashAttribute("message", "Đổi mật khẩu thành công!");
        return "redirect:/customer/profile";
    }
    
    /**
     * TẠO ĐƠN HÀNG (CREATE ORDER)
     */
    @Autowired
    private OrderService orderService;

    @GetMapping("/create-order")
    public String showCreateOrder(Model model, Principal principal) {
        Customer customer = getLoggedInCustomer(principal);
        
        // BỔ SUNG: Lấy danh sách địa chỉ đã lưu để hiển thị ở dropdown
        List<CustomerAddress> savedAddresses = customerAddressRepository
                .findByCustomerAndIsDefaultFalseOrderByAddressIdDesc(customer);
        
        CustomerAddress defaultAddress = customerAddressRepository.findByCustomer(customer)
                .stream()
                .filter(CustomerAddress::getIsDefault)
                .findFirst()
                .orElse(null);
        
        List<Hub> nearbyHubs = new ArrayList<>();
        if (defaultAddress != null) {
            // 2. SỬ DỤNG TẠI ĐÂY: Lọc bưu cục cùng tỉnh, mức độ bưu cục lẻ (local) và đang hoạt động (active)
            nearbyHubs = hubRepository.findByProvinceAndHubLevelAndStatus(
            		defaultAddress.getProvince(), 
                    HubLevel.local, 
                    HubStatus.active
            );
        }
        
        model.addAttribute("savedAddresses", savedAddresses);
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "create-order");
        model.addAttribute("defaultAddress", defaultAddress);
        model.addAttribute("nearbyHubs", nearbyHubs);
        return "customer/create-order";
    }

    @PostMapping("/create-order/save")
    public String saveOrder(
            @ModelAttribute ServiceRequest orderData,
            @RequestParam String fullName,     
            @RequestParam String phone,        
            @RequestParam String addressDetail,
            @RequestParam String province,     
            @RequestParam String district,     
            @RequestParam String ward,         
            @RequestParam("imageFile") MultipartFile imageFile,
            Principal principal, RedirectAttributes ra) throws IOException {

        Customer customer = getLoggedInCustomer(principal);
        orderData.setCustomer(customer);

        // --- BỔ SUNG: XỬ LÝ ĐỊA CHỈ LẤY HÀNG (PICKUP ADDRESS) ---
        // Nếu pickupAddress trong orderData bị null (do form không gửi hoặc gửi thiếu ID)
        if (orderData.getPickupAddress() == null || orderData.getPickupAddress().getAddressId() == null) {
            // Tìm địa chỉ mặc định của khách hàng này trong DB
            CustomerAddress defaultAddr = customerAddressRepository.findByCustomer(customer)
                    .stream()
                    .filter(CustomerAddress::getIsDefault)
                    .findFirst()
                    .orElse(null);
            
            if (defaultAddr == null) {
                ra.addFlashAttribute("error", "Bạn chưa thiết lập địa chỉ lấy hàng mặc định!");
                return "redirect:/customer/addresses"; // Chuyển hướng yêu cầu khách tạo địa chỉ
            }
            orderData.setPickupAddress(defaultAddr);
        }

        // 1. Xử lý lưu ảnh đơn hàng (Giữ nguyên code của bạn)
        if (imageFile != null && !imageFile.isEmpty()) {
            String originalFilename = imageFile.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String fileName = "order_" + System.currentTimeMillis() + extension;
            String uploadDir = "src/main/resources/static/uploads/orders/";
            saveFile(uploadDir, fileName, imageFile); 
            orderData.setImageOrder("/uploads/orders/" + fileName);
        }

        // 2. Đóng gói thông tin người nhận (Giữ nguyên code của bạn)
        java.util.Map<String, String> recipientInfo = new java.util.HashMap<>();
        recipientInfo.put("fullName", fullName);
        recipientInfo.put("phone", phone);
        recipientInfo.put("addressDetail", addressDetail);
        recipientInfo.put("province", province);
        recipientInfo.put("district", district);
        recipientInfo.put("ward", ward);

        // 3. Thiết lập các giá trị mặc định cho đơn hàng
        orderData.setStatus(RequestStatus.pending); // Trạng thái: Chờ xử lý
        orderData.setPaymentStatus(PaymentStatus.unpaid); // Trạng thái thanh toán: Chưa thanh toán

        // Gọi Service xử lý
        orderService.createNewOrder(orderData, recipientInfo);

        ra.addFlashAttribute("message", "Đã tạo đơn hàng thành công!");
        return "redirect:/customer/orders"; 
    }

    // 3. BỔ SUNG: API xử lý lưu địa chỉ mới từ giao diện qua AJAX
    @PostMapping("/api/addresses/save")
    @ResponseBody
    public ResponseEntity<CustomerAddress> saveAddressFromAjax(@RequestBody CustomerAddress addressDto, Principal principal) {
        Customer customer = getLoggedInCustomer(principal);
        
        // Kiểm tra trùng lặp để không lưu rác
        return customerAddressRepository.findByCustomerAndContactPhoneAndAddressDetail(
                customer, addressDto.getContactPhone(), addressDto.getAddressDetail())
            .map(ResponseEntity::ok)
            .orElseGet(() -> {
                addressDto.setCustomer(customer);
                addressDto.setIsDefault(false);
                return ResponseEntity.ok(customerAddressRepository.save(addressDto));
            });
    }

    // API phục vụ AJAX tìm kiếm nhanh địa chỉ
    @GetMapping("/api/addresses/search")
    @ResponseBody
    public List<CustomerAddress> searchAddresses(@RequestParam String q, Principal principal) {
        Customer customer = getLoggedInCustomer(principal);
        return customerAddressRepository.searchByCustomer(customer, q);
    }

    private void saveFile(String uploadDir, String fileName, MultipartFile multipartFile) throws IOException {
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        try (InputStream inputStream = multipartFile.getInputStream()) {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
    }
    
    @GetMapping("/api/payment/create-vnpay")
    @ResponseBody
    public ResponseEntity<?> createVNPayUrl(
            @RequestParam("amount") long amount,
            @RequestParam("orderId") String orderId,
            HttpServletRequest request) {

        Map<String, String> vnp_Params = new HashMap<>();

        // ===== BASIC PARAMS =====
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPAYConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
        vnp_Params.put("vnp_CurrCode", "VND");

        String txnRef = orderId + "_" + System.currentTimeMillis();
        vnp_Params.put("vnp_TxnRef", txnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang: " + txnRef);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");

        vnp_Params.put("vnp_ReturnUrl", VNPAYConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpnUrl", VNPAYConfig.vnp_IpnUrl);
        vnp_Params.put("vnp_IpAddr", VNPAYConfig.getClientIp(request));

        // ===== DATE =====
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));

        cld.add(Calendar.MINUTE, 15);
        vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

        // ===== SORT PARAMS =====
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();

        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {

                // 🔥 HASH DATA: KHÔNG ENCODE
                hashData.append(fieldName)
                        .append("=")
                        .append(fieldValue);

                // 🔥 QUERY STRING: CÓ ENCODE
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII))
                     .append("=")
                     .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));

                if (itr.hasNext()) {
                    hashData.append("&");
                    query.append("&");
                }
            }
        }

        // ===== SECURE HASH =====
        String secureHash = VNPAYConfig.hmacSHA512(
                VNPAYConfig.vnp_HashSecret,
                hashData.toString()
        );
        
        // ===== FINAL URL =====
        String paymentUrl = VNPAYConfig.vnp_PayUrl
                + "?" + query
                + "&vnp_SecureHash=" + secureHash;

        // ===== LOG =====
        System.out.println("HASH DATA = " + hashData);
        System.out.println("SECURE HASH = " + secureHash);
        System.out.println("PAY URL = " + paymentUrl);

        return ResponseEntity.ok(Map.of(
                "code", "00",
                "message", "success",
                "url", paymentUrl
        ));
    }




    @GetMapping("/vnpay-payment-return")
    public String vnpayReturn(HttpServletRequest request, Model model) {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        // Dùng hàm hashAllFields để nối chuỗi tham số trả về (không cần encode lại)
        String signValue = VNPAYConfig.hmacSHA512(VNPAYConfig.vnp_HashSecret, VNPAYConfig.hashAllFields(fields));

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                // Cập nhật trạng thái PAID vào database
                String orderId = request.getParameter("vnp_TxnRef");
                orderService.updatePaymentStatus(orderId, "PAID");
                return "customer/payment-success";
            }
        }
        return "customer/payment-failed";
    }
}