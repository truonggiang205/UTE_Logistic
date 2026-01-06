package vn.web.logistic.service.customer.impl;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.response.TransactionResponse;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.PaymentStatus;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.entity.SupportTicket;
import vn.web.logistic.entity.SupportTicket.TicketStatus;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.NotificationRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.SupportTicketRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.repository.VnpayTransactionRepository;
import vn.web.logistic.service.EmailService;
import vn.web.logistic.service.customer.CustomerDashboardService;

/**
 * Implementation của CustomerDashboardService
 * Chứa toàn bộ logic nghiệp vụ cho Customer Portal
 */
@Service
@RequiredArgsConstructor
public class CustomerDashboardServiceImpl implements CustomerDashboardService {

    private final UserRepository userRepository;
    private final CustomerRepository customerRepository;
    private final CustomerAddressRepository customerAddressRepository;
    private final ServiceRequestRepository serviceRequestRepository;
    private final CodTransactionRepository codTransactionRepository;
    private final VnpayTransactionRepository vnpayTransactionRepository;
    private final NotificationRepository notificationRepository;
    private final HubRepository hubRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final SupportTicketRepository supportTicketRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    // ==================== CUSTOMER CONTEXT ====================

    @Override
    public Customer getLoggedInCustomer(Principal principal) {
        if (principal == null) {
            throw new RuntimeException("Chưa đăng nhập");
        }
        String username = principal.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng: " + username));

        return customerRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hồ sơ Shop"));
    }

    // ==================== OVERVIEW / DASHBOARD ====================

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getOrderCountStats(Customer customer) {
        Map<String, Long> stats = new HashMap<>();

        stats.put("pending", serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.pending));
        stats.put("success", serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.delivered));
        stats.put("failed", serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.failed));

        long delivering = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.picked)
                + serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.in_transit);
        stats.put("delivering", delivering);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, BigDecimal> getCodStats(Customer customer) {
        Map<String, BigDecimal> stats = new HashMap<>();

        stats.put("pending", safeValue(
                serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.pending)));
        stats.put("success", safeValue(
                serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.delivered)));

        BigDecimal delivering = safeAdd(
                serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.picked),
                serviceRequestRepository.sumCodAmountByCustomerAndStatus(customer, RequestStatus.in_transit));
        stats.put("delivering", delivering);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getPerformanceStats(Customer customer) {
        Map<String, Object> stats = new HashMap<>();

        BigDecimal totalShippingFee = safeValue(serviceRequestRepository.sumTotalShippingFee(customer));
        long totalOrders = serviceRequestRepository.countByCustomer(customer);
        long failedCount = serviceRequestRepository.countByCustomerAndStatus(customer, RequestStatus.failed);
        double returnRate = (totalOrders > 0) ? (double) failedCount / totalOrders * 100 : 0;

        stats.put("totalShippingFee", totalShippingFee);
        stats.put("totalOrders", totalOrders);
        stats.put("failedCount", failedCount);
        stats.put("returnRate", Math.round(returnRate));

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, String> getTrendChartData(Customer customer) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(6).withHour(0).withMinute(0).withSecond(0);
        List<Object[]> trendData = serviceRequestRepository.getDailyStatsLast7Days(customer.getCustomerId(), startDate);

        String labelsJson = trendData.stream()
                .map(row -> "'" + row[0].toString() + "'")
                .collect(Collectors.joining(","));
        String countsJson = trendData.stream()
                .map(row -> String.valueOf(((Number) row[1]).longValue()))
                .collect(Collectors.joining(","));
        String amountsJson = trendData.stream()
                .map(row -> String.valueOf(row[2] != null ? row[2] : 0))
                .collect(Collectors.joining(","));

        Map<String, String> chartData = new HashMap<>();
        chartData.put("labels", labelsJson);
        chartData.put("counts", countsJson);
        chartData.put("amounts", amountsJson);

        return chartData;
    }

    // ==================== CASH FLOW ====================

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getCodHolding(Customer customer) {
        return serviceRequestRepository
                .findByCustomerAndStatusAndPaymentStatus(customer, RequestStatus.delivered, PaymentStatus.unpaid)
                .stream()
                .map(ServiceRequest::getCodAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TransactionResponse> getTransactionHistory(Customer customer) {
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
        return history;
    }

    // ==================== ORDER MANAGEMENT ====================

    @Override
    @Transactional(readOnly = true)
    public List<ServiceRequest> searchOrders(Customer customer, RequestStatus status, Long orderId,
            LocalDate fromDate, LocalDate toDate) {
        // Thiết lập khoảng thời gian lọc (Mặc định 30 ngày)
        LocalDateTime start = (fromDate != null) ? fromDate.atStartOfDay() : LocalDateTime.now().minusMonths(1);
        LocalDateTime end = (toDate != null) ? toDate.atTime(LocalTime.MAX) : LocalDateTime.now();

        return serviceRequestRepository.searchOrders(customer, status, orderId, start, end);
    }

    // ==================== ADDRESS MANAGEMENT ====================

    @Override
    @Transactional(readOnly = true)
    public List<CustomerAddress> getAddresses(Customer customer) {
        return customerAddressRepository.findByCustomerOrderByAddressIdDesc(customer);
    }

    @Override
    @Transactional
    public CustomerAddress addAddress(Customer customer, CustomerAddress address) {
        address.setCustomer(customer);
        address.setIsDefault(false);
        return customerAddressRepository.save(address);
    }

    @Override
    @Transactional
    public CustomerAddress updateAddress(Customer customer, Long addressId, CustomerAddress addressData) {
        CustomerAddress addr = customerAddressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ"));

        // Kiểm tra quyền sở hữu
        if (!addr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Không có quyền sửa địa chỉ này!");
        }

        // Cập nhật thông tin
        addr.setContactName(addressData.getContactName());
        addr.setContactPhone(addressData.getContactPhone());
        addr.setAddressDetail(addressData.getAddressDetail());
        addr.setWard(addressData.getWard());
        addr.setDistrict(addressData.getDistrict());
        addr.setProvince(addressData.getProvince());

        return customerAddressRepository.save(addr);
    }

    @Override
    @Transactional
    public void deleteAddress(Customer customer, Long addressId) {
        CustomerAddress addr = customerAddressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ"));

        // Kiểm tra quyền sở hữu
        if (!addr.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Không có quyền xóa địa chỉ này!");
        }

        // Không cho xóa địa chỉ mặc định
        if (addr.getIsDefault()) {
            throw new RuntimeException("Không thể xóa địa chỉ mặc định! Vui lòng đặt địa chỉ khác làm mặc định trước.");
        }

        customerAddressRepository.delete(addr);
    }

    @Override
    @Transactional
    public void setDefaultAddress(Customer customer, Long addressId) {
        CustomerAddress newDefault = customerAddressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ"));

        // Kiểm tra quyền sở hữu
        if (!newDefault.getCustomer().getCustomerId().equals(customer.getCustomerId())) {
            throw new RuntimeException("Không có quyền thay đổi địa chỉ này!");
        }

        // Bỏ mặc định tất cả các địa chỉ khác của customer này
        List<CustomerAddress> allAddresses = customerAddressRepository.findByCustomer(customer);
        for (CustomerAddress addr : allAddresses) {
            if (addr.getIsDefault()) {
                addr.setIsDefault(false);
                customerAddressRepository.save(addr);
            }
        }

        // Đặt địa chỉ mới làm mặc định
        newDefault.setIsDefault(true);
        customerAddressRepository.save(newDefault);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CustomerAddress> searchAddresses(Customer customer, String query) {
        return customerAddressRepository.searchByCustomer(customer, query);
    }

    @Override
    @Transactional
    public CustomerAddress saveAddressIfNotExists(Customer customer, CustomerAddress address) {
        return customerAddressRepository
                .findByCustomerAndContactPhoneAndAddressDetail(customer, address.getContactPhone(),
                        address.getAddressDetail())
                .orElseGet(() -> {
                    address.setCustomer(customer);
                    address.setIsDefault(false);
                    return customerAddressRepository.save(address);
                });
    }

    // ==================== SUPPORT TICKETS ====================

    @Override
    @Transactional(readOnly = true)
    public List<SupportTicket> getMyTickets(Customer customer) {
        return supportTicketRepository.findByCustomerOrderByCreatedAtDesc(customer);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceRequest> getOrdersForTicket(Customer customer) {
        return serviceRequestRepository.findByCustomerOrderByCreatedAtDesc(customer);
    }

    @Override
    @Transactional
    public SupportTicket submitTicket(Customer customer, Long requestId, String subject, String message) {
        ServiceRequest order = serviceRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        SupportTicket ticket = SupportTicket.builder()
                .customer(customer)
                .serviceRequest(order)
                .subject(subject)
                .message(message)
                .status(TicketStatus.pending)
                .build();

        return supportTicketRepository.save(ticket);
    }

    // ==================== NOTIFICATIONS ====================

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getNotifications() {
        return notificationRepository.findTop20ByTargetRoleInOrderByCreatedAtDesc(
                Arrays.asList("ALL", "CUSTOMER"));
    }

    // ==================== PROFILE MANAGEMENT ====================

    @Override
    @Transactional
    public void updateProfile(Customer customer, String fullName, String email,
            String businessName, String phone) {
        User user = customer.getUser();

        // Cập nhật bảng USERS
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        userRepository.save(user);

        // Cập nhật bảng CUSTOMERS
        customer.setBusinessName(businessName);
        customer.setPhone(phone);
        customerRepository.save(customer);
    }

    @Override
    @Transactional
    public void updateProfileWithOtp(Customer customer, String fullName, String businessName,
            String phone, String pendingEmail, String otp, String serverOtp) {
        User user = customer.getUser();

        // Nếu khách hàng đổi sang email mới (khác email hiện tại)
        if (pendingEmail != null && !pendingEmail.equals(user.getEmail())) {
            if (otp == null || !otp.equals(serverOtp)) {
                throw new RuntimeException("Mã xác thực không chính xác hoặc đã hết hạn!");
            }
            user.setEmail(pendingEmail);
        }

        // Cập nhật các thông tin khác
        user.setFullName(fullName);
        user.setPhone(phone);
        userRepository.save(user);

        customer.setBusinessName(businessName);
        customer.setPhone(phone);
        customerRepository.save(customer);
    }

    @Override
    public void sendEmailOtp(String newEmail, String otp) {
        try {
            emailService.sendOtpEmail(newEmail, otp);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi gửi email: " + e.getMessage());
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    @Transactional
    public void changePassword(Customer customer, String currentPassword, String newPassword) {
        User user = customer.getUser();

        // Kiểm tra mật khẩu cũ
        if (!passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            throw new RuntimeException("Mật khẩu hiện tại không chính xác!");
        }

        // Cập nhật mật khẩu mới
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional
    public String uploadAvatar(Customer customer, MultipartFile avatarFile) throws IOException {
        User user = customer.getUser();

        String fileName = "avatar_" + user.getUserId() + "_" + System.currentTimeMillis() + ".jpg";
        String uploadDir = "src/main/resources/static/uploads/avatars/";

        // Lưu file vật lý vào server
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        try (InputStream inputStream = avatarFile.getInputStream()) {
            Files.copy(inputStream, uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
        }

        // Cập nhật trường avatar_url vào entity User
        String avatarUrl = "/uploads/avatars/" + fileName;
        user.setAvatarUrl(avatarUrl);
        userRepository.save(user);

        return avatarUrl;
    }

    // ==================== CREATE ORDER HELPERS ====================

    @Override
    @Transactional(readOnly = true)
    public List<CustomerAddress> getSavedAddresses(Customer customer) {
        return customerAddressRepository.findByCustomerAndIsDefaultFalseOrderByAddressIdDesc(customer);
    }

    @Override
    @Transactional(readOnly = true)
    public CustomerAddress getDefaultAddress(Customer customer) {
        return customerAddressRepository.findByCustomer(customer).stream()
                .filter(CustomerAddress::getIsDefault)
                .findFirst()
                .orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Hub> getActiveHubs() {
        return hubRepository.findAllActiveHubs();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceType> getActiveServiceTypes() {
        return serviceTypeRepository.findAllByIsActiveTrue();
    }

    // ==================== HELPER METHODS ====================

    private BigDecimal safeValue(BigDecimal value) {
        return (value != null) ? value : BigDecimal.ZERO;
    }

    private BigDecimal safeAdd(BigDecimal b1, BigDecimal b2) {
        return safeValue(b1).add(safeValue(b2));
    }

    // ==================== ORDER CREATION ====================

    @Override
    @Transactional(readOnly = true)
    public Hub getHubById(Long hubId) {
        return hubRepository.findById(hubId)
                .orElseThrow(() -> new RuntimeException("Hub không tồn tại"));
    }

    @Override
    public String uploadOrderImage(MultipartFile imageFile) throws IOException {
        if (imageFile == null || imageFile.isEmpty()) {
            return null;
        }

        String originalFilename = imageFile.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileName = "order_" + System.currentTimeMillis() + extension;
        String uploadDir = "src/main/resources/static/uploads/orders/";

        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        try (InputStream inputStream = imageFile.getInputStream()) {
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return "/uploads/orders/" + fileName;
    }

    @Override
    @Transactional
    public ServiceRequest createOrder(Customer customer, ServiceRequest orderData,
            Map<String, String> recipientInfo, Long hubId,
            MultipartFile imageFile) throws IOException {
        orderData.setCustomer(customer);

        // Set Hub cho đơn hàng
        Hub selectedHub = getHubById(hubId);
        orderData.setCurrentHub(selectedHub);

        // Xử lý địa chỉ lấy hàng
        if (orderData.getPickupAddress() == null || orderData.getPickupAddress().getAddressId() == null) {
            CustomerAddress defaultAddr = getDefaultAddress(customer);
            if (defaultAddr == null) {
                throw new RuntimeException("Bạn chưa thiết lập địa chỉ lấy hàng mặc định!");
            }
            orderData.setPickupAddress(defaultAddr);
        }

        // Upload ảnh đơn hàng
        String imagePath = uploadOrderImage(imageFile);
        if (imagePath != null) {
            orderData.setImageOrder(imagePath);
        }

        // Thiết lập trạng thái mặc định
        orderData.setStatus(RequestStatus.pending);
        orderData.setPaymentStatus(PaymentStatus.unpaid);

        return orderService.createNewOrder(orderData, recipientInfo);
    }

    // ==================== VNPAY PAYMENT ====================

    @Override
    @Transactional
    public String createVnpayPaymentUrl(Customer customer, ServiceRequest orderData,
            Map<String, String> recipientInfo, Long hubId,
            MultipartFile imageFile,
            jakarta.servlet.http.HttpServletRequest request) throws Exception {
        // Tạo đơn hàng trước
        ServiceRequest savedOrder = createOrder(customer, orderData, recipientInfo, hubId, imageFile);

        // Tạo COD và VNPAY transactions
        if (savedOrder.getCodAmount() != null && savedOrder.getCodAmount().compareTo(BigDecimal.ZERO) > 0) {
            orderService.createCodTransaction(savedOrder, "Chuyển khoản");
        }
        orderService.createVnpayTransaction(savedOrder);

        // Tạo VNPAY payment URL
        Map<String, String> vnp_Params = new java.util.HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", vn.web.logistic.config.VNPAYConfig.vnp_TmnCode);

        long vnp_Amount = savedOrder.getTotalPrice()
                .multiply(new BigDecimal(100))
                .longValue();
        vnp_Params.put("vnp_Amount", String.valueOf(vnp_Amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        String txnRef = String.valueOf(savedOrder.getRequestId());
        vnp_Params.put("vnp_TxnRef", txnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang: " + txnRef);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", vn.web.logistic.config.VNPAYConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vn.web.logistic.config.VNPAYConfig.getClientIp(request));

        java.util.Calendar cld = java.util.Calendar.getInstance(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
        vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));
        cld.add(java.util.Calendar.MINUTE, 15);
        vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

        java.util.List<String> fieldNames = new java.util.ArrayList<>(vnp_Params.keySet());
        java.util.Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        java.util.Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                String encodedValue = java.net.URLEncoder.encode(fieldValue,
                        java.nio.charset.StandardCharsets.US_ASCII);
                hashData.append(fieldName).append("=").append(encodedValue);
                query.append(java.net.URLEncoder.encode(fieldName, java.nio.charset.StandardCharsets.US_ASCII))
                        .append("=").append(encodedValue);
                if (itr.hasNext()) {
                    hashData.append("&");
                    query.append("&");
                }
            }
        }

        String secureHash = vn.web.logistic.config.VNPAYConfig.hmacSHA512(
                vn.web.logistic.config.VNPAYConfig.vnp_HashSecret, hashData.toString());
        return vn.web.logistic.config.VNPAYConfig.vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    @Override
    public String processVnpayReturn(jakarta.servlet.http.HttpServletRequest request) throws IOException {
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        Map<String, String> vnp_Params = new java.util.HashMap<>();
        java.util.Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                vnp_Params.put(fieldName, fieldValue);
            }
        }

        vnp_Params.remove("vnp_SecureHash");
        vnp_Params.remove("vnp_SecureHashType");

        java.util.List<String> fieldNames = new java.util.ArrayList<>(vnp_Params.keySet());
        java.util.Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        java.util.Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            hashData.append(fieldName).append('=')
                    .append(java.net.URLEncoder.encode(fieldValue,
                            java.nio.charset.StandardCharsets.US_ASCII.toString()));
            if (itr.hasNext()) {
                hashData.append('&');
            }
        }

        String calculatedHash = vn.web.logistic.config.VNPAYConfig.hmacSHA512(
                vn.web.logistic.config.VNPAYConfig.vnp_HashSecret, hashData.toString());

        if (calculatedHash.equalsIgnoreCase(vnp_SecureHash)) {
            String orderId = request.getParameter("vnp_TxnRef");
            String responseCode = request.getParameter("vnp_ResponseCode");

            String queryString = "?vnp_TxnRef=" + orderId +
                    "&vnp_Amount=" + request.getParameter("vnp_Amount") +
                    "&vnp_BankCode=" + request.getParameter("vnp_BankCode") +
                    "&vnp_PayDate=" + request.getParameter("vnp_PayDate") +
                    "&vnp_ResponseCode=" + responseCode;

            if ("00".equals(responseCode)) {
                orderService.updatePaymentStatus(orderId, "PAID");
                return "/payment-success" + queryString;
            } else {
                return "/payment-failure" + queryString;
            }
        }
        return "/payment-failure?error=invalid_signature";
    }

    // Inject OrderService
    private final vn.web.logistic.service.OrderService orderService;
}
