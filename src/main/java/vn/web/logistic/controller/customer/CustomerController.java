package vn.web.logistic.controller.customer;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.service.customer.CustomerDashboardService;

@Controller
@RequestMapping("/customer")
@RequiredArgsConstructor
public class CustomerController {

    // Chỉ còn 1 dependency duy nhất - Service Layer
    private final CustomerDashboardService customerDashboardService;

    // ==================== TRANG THÔNG BÁO ====================

    @GetMapping("/notifications")
    public String showNotifications(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("allNotifications", customerDashboardService.getNotifications());
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "notifications");
        return "customer/notifications";
    }

    // ==================== TRANG TỔNG QUAN (OVERVIEW) ====================

    @GetMapping("/overview")
    public String showOverview(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        // Lấy thống kê từ Service
        var orderCounts = customerDashboardService.getOrderCountStats(customer);
        var codStats = customerDashboardService.getCodStats(customer);
        var perfStats = customerDashboardService.getPerformanceStats(customer);
        var trendData = customerDashboardService.getTrendChartData(customer);

        // Đẩy dữ liệu vào Model
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "overview");

        model.addAttribute("pendingCount", orderCounts.get("pending"));
        model.addAttribute("successCount", orderCounts.get("success"));
        model.addAttribute("deliveringCount", orderCounts.get("delivering"));
        model.addAttribute("failedCount", perfStats.get("failedCount"));

        model.addAttribute("pendingCod", codStats.get("pending"));
        model.addAttribute("successCod", codStats.get("success"));
        model.addAttribute("deliveringCod", codStats.get("delivering"));

        model.addAttribute("totalShippingFee", perfStats.get("totalShippingFee"));
        model.addAttribute("returnRate", perfStats.get("returnRate"));

        model.addAttribute("trendLabelsJson", trendData.get("labels"));
        model.addAttribute("trendOrderCountsJson", trendData.get("counts"));
        model.addAttribute("trendCodAmountsJson", trendData.get("amounts"));

        return "customer/overview";
    }

    // ==================== TRANG DÒNG TIỀN (CASH FLOW) ====================

    @GetMapping("/cashflow")
    public String getCashFlow(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("codHolding", customerDashboardService.getCodHolding(customer));
        model.addAttribute("history", customerDashboardService.getTransactionHistory(customer));
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "cashflow");

        return "customer/cashflow";
    }

    // ==================== QUẢN LÝ ĐƠN HÀNG (ORDER MANAGEMENT) ====================

    @GetMapping("/orders")
    public String manageOrders(@RequestParam(required = false) Long orderId,
            @RequestParam(required = false) RequestStatus status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
            Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("orders",
                customerDashboardService.searchOrders(customer, status, orderId, fromDate, toDate));
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

    // ==================== QUẢN LÝ ĐỊA CHỈ (ADDRESS MANAGEMENT)
    // ====================

    @GetMapping("/addressbook")
    public String getAddressBook(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("addresses", customerDashboardService.getAddresses(customer));
        model.addAttribute("hubs", customerDashboardService.getActiveHubs());
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "addressbook");

        return "customer/addressbook";
    }

    @PostMapping("/addressbook/add")
    public String addAddress(@ModelAttribute CustomerAddress address, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        customerDashboardService.addAddress(customer, address);
        return "redirect:/customer/addressbook";
    }

    @GetMapping("/addressbook/delete")
    public String deleteAddress(@RequestParam Long id, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        try {
            customerDashboardService.deleteAddress(customer, id);
        } catch (Exception ignored) {
            // Không có quyền hoặc không tìm thấy
        }
        return "redirect:/customer/addressbook";
    }

    @GetMapping("/addresses")
    public String showAddresses(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("addresses", customerDashboardService.getAddresses(customer));
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "addresses");
        return "customer/addresses";
    }

    @PostMapping("/addresses/add")
    public String addNewAddress(@ModelAttribute CustomerAddress address, Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        customerDashboardService.addAddress(customer, address);
        ra.addFlashAttribute("message", "Đã thêm địa chỉ mới!");
        return "redirect:/customer/addresses";
    }

    @PostMapping("/addresses/update/{id}")
    public String updateAddress(@PathVariable Long id, @ModelAttribute CustomerAddress addressData,
            Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        try {
            customerDashboardService.updateAddress(customer, id, addressData);
            ra.addFlashAttribute("message", "Đã cập nhật địa chỉ!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/customer/addresses";
    }

    @PostMapping("/addresses/delete/{id}")
    public String deleteAddressById(@PathVariable Long id, Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        try {
            customerDashboardService.deleteAddress(customer, id);
            ra.addFlashAttribute("message", "Đã xóa địa chỉ!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/customer/addresses";
    }

    @PostMapping("/addresses/set-default/{id}")
    public String setDefaultAddress(@PathVariable Long id, Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        try {
            customerDashboardService.setDefaultAddress(customer, id);
            ra.addFlashAttribute("message", "Đã đặt địa chỉ mặc định!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/customer/addresses";
    }

    // ==================== HELP CENTER ====================

    @GetMapping("/support")
    public String getHelpCenter(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("orders", customerDashboardService.getOrdersForTicket(customer));
        model.addAttribute("hubs", customerDashboardService.getActiveHubs());
        model.addAttribute("myTickets", customerDashboardService.getMyTickets(customer));
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "help");

        return "customer/support";
    }

    @PostMapping("/support/ticket/add")
    public String submitTicket(@RequestParam Long requestId, @RequestParam String subject,
            @RequestParam String message, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        customerDashboardService.submitTicket(customer, requestId, subject, message);
        return "redirect:/customer/support?success=true";
    }

    // ==================== CUSTOMER PROFILE ====================

    @GetMapping("/profile")
    public String getProfile(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("customer", customer);
        model.addAttribute("user", customer.getUser());
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "profile");

        return "customer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName, @RequestParam String email,
            @RequestParam String businessName, @RequestParam String phone,
            Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        customerDashboardService.updateProfile(customer, fullName, email, businessName, phone);
        ra.addFlashAttribute("message", "Cập nhật hồ sơ thành công!");
        return "redirect:/customer/profile";
    }

    @PostMapping("/profile/send-otp")
    @ResponseBody
    public ResponseEntity<?> sendOtp(@RequestParam String newEmail, Principal principal, HttpSession session) {
        if (customerDashboardService.isEmailExists(newEmail)) {
            return ResponseEntity.badRequest().body("Email này đã được sử dụng!");
        }

        String otp = String.format("%06d", new java.util.Random().nextInt(1000000));
        session.setAttribute("emailOtp", otp);
        session.setAttribute("pendingEmail", newEmail);

        try {
            customerDashboardService.sendEmailOtp(newEmail);
            return ResponseEntity.ok("Mã xác thực đã được gửi đến " + newEmail);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

    @PostMapping("/profile/update-final")
    public String updateProfileFinal(@RequestParam String fullName, @RequestParam String businessName,
            @RequestParam String phone,
            @RequestParam(required = false) String bankName,
            @RequestParam(required = false) String bankBranch,
            @RequestParam(required = false) String accountHolderName,
            @RequestParam(required = false) String accountNumber,
            @RequestParam(required = false) String otp,
            @RequestParam(required = false) MultipartFile avatarFile,
            Principal principal, HttpSession session, RedirectAttributes ra) throws IOException {

        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        String pendingEmail = (String) session.getAttribute("pendingEmail");
        String serverOtp = (String) session.getAttribute("emailOtp");

        // Upload Avatar nếu có
        if (avatarFile != null && !avatarFile.isEmpty()) {
            customerDashboardService.uploadAvatar(customer, avatarFile);
        }

        try {
            customerDashboardService.updateProfileWithOtp(customer, fullName, businessName,
                    phone, pendingEmail, otp, serverOtp);

            // Clear session sau khi cập nhật thành công
            session.removeAttribute("emailOtp");
            session.removeAttribute("pendingEmail");

            ra.addFlashAttribute("message", "Cập nhật hồ sơ thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/customer/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam String currentPassword, @RequestParam String newPassword,
            Principal principal, RedirectAttributes ra) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        try {
            customerDashboardService.changePassword(customer, currentPassword, newPassword);
            ra.addFlashAttribute("message", "Đổi mật khẩu thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/customer/profile";
    }

    // ==================== TẠO ĐƠN HÀNG (CREATE ORDER) ====================

    @GetMapping("/create-order")
    public String showCreateOrder(Model model, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        model.addAttribute("savedAddresses", customerDashboardService.getSavedAddresses(customer));
        model.addAttribute("defaultAddress", customerDashboardService.getDefaultAddress(customer));
        model.addAttribute("allHubs", customerDashboardService.getActiveHubs());
        model.addAttribute("serviceTypes", customerDashboardService.getActiveServiceTypes());
        model.addAttribute("username", customer.getUser().getUsername());
        model.addAttribute("businessName", customer.getBusinessName());
        model.addAttribute("currentPage", "create-order");

        return "customer/create-order";
    }

    @PostMapping("/create-order/save")
    public String saveOrder(@ModelAttribute ServiceRequest orderData,
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam String addressDetail,
            @RequestParam String province,
            @RequestParam String district,
            @RequestParam String ward,
            @RequestParam Long hubId,
            @RequestParam("imageFile") MultipartFile imageFile,
            Principal principal,
            RedirectAttributes ra) {

        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        // Đóng gói thông tin người nhận
        Map<String, String> recipientInfo = new HashMap<>();
        recipientInfo.put("fullName", fullName);
        recipientInfo.put("phone", phone);
        recipientInfo.put("addressDetail", addressDetail);
        recipientInfo.put("province", province);
        recipientInfo.put("district", district);
        recipientInfo.put("ward", ward);

        try {
            customerDashboardService.createOrder(customer, orderData, recipientInfo, hubId, imageFile);
            ra.addFlashAttribute("message", "Đã tạo đơn hàng thành công!");
            return "redirect:/customer/orders";
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
            return "redirect:/customer/addresses";
        }
    }

    // ==================== API ENDPOINTS ====================

    @PostMapping("/api/addresses/save")
    @ResponseBody
    public ResponseEntity<CustomerAddress> saveAddressFromAjax(@RequestBody CustomerAddress addressDto,
            Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        return ResponseEntity.ok(customerDashboardService.saveAddressIfNotExists(customer, addressDto));
    }

    @GetMapping("/api/addresses/search")
    @ResponseBody
    public List<CustomerAddress> searchAddresses(@RequestParam String q, Principal principal) {
        Customer customer = customerDashboardService.getLoggedInCustomer(principal);
        return customerDashboardService.searchAddresses(customer, q);
    }

    @PostMapping("/api/payment/create-vnpay")
    @ResponseBody
    public ResponseEntity<?> createVNPayUrl(
            @ModelAttribute ServiceRequest orderData,
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam String addressDetail,
            @RequestParam String province,
            @RequestParam String district,
            @RequestParam String ward,
            @RequestParam Long hubId,
            @RequestParam("imageFile") MultipartFile imageFile,
            HttpServletRequest request,
            Principal principal) {

        Customer customer = customerDashboardService.getLoggedInCustomer(principal);

        // Đóng gói thông tin người nhận
        Map<String, String> recipientInfo = new HashMap<>();
        recipientInfo.put("fullName", fullName);
        recipientInfo.put("phone", phone);
        recipientInfo.put("addressDetail", addressDetail);
        recipientInfo.put("province", province);
        recipientInfo.put("district", district);
        recipientInfo.put("ward", ward);

        try {
            String paymentUrl = customerDashboardService.createVnpayPaymentUrl(
                    customer, orderData, recipientInfo, hubId, imageFile, request);
            return ResponseEntity.ok(Map.of("code", "00", "url", paymentUrl));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("code", "99", "message", "Lưu đơn hàng thất bại"));
        }
    }

    @GetMapping("/api/payment/vnpay-return")
    public String vnpayReturn(HttpServletRequest request) throws IOException {
        String redirectPath = customerDashboardService.processVnpayReturn(request);
        return "redirect:" + redirectPath;
    }
}