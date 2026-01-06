package vn.web.logistic.service.customer;

import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import vn.web.logistic.dto.response.TransactionResponse;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.entity.SupportTicket;

/**
 * Customer Dashboard Service
 * Xử lý toàn bộ logic nghiệp vụ cho Customer Portal (Overview, CashFlow,
 * Orders, etc.)
 */
public interface CustomerDashboardService {

        // ==================== CUSTOMER CONTEXT ====================

        /**
         * Lấy thông tin Customer đang đăng nhập từ Principal
         */
        Customer getLoggedInCustomer(Principal principal);

        // ==================== OVERVIEW / DASHBOARD ====================

        /**
         * Lấy thống kê số lượng đơn hàng theo trạng thái
         */
        Map<String, Long> getOrderCountStats(Customer customer);

        /**
         * Lấy thống kê tiền COD theo trạng thái
         */
        Map<String, BigDecimal> getCodStats(Customer customer);

        /**
         * Lấy các chỉ số hiệu suất (tổng phí ship, tỷ lệ hoàn)
         */
        Map<String, Object> getPerformanceStats(Customer customer);

        /**
         * Lấy dữ liệu biểu đồ trend 7 ngày
         */
        Map<String, String> getTrendChartData(Customer customer);

        // ==================== CASH FLOW ====================

        /**
         * Tính số dư COD đang giữ hộ (Delivered & Unpaid)
         */
        BigDecimal getCodHolding(Customer customer);

        /**
         * Lấy lịch sử giao dịch (COD + VNPAY)
         */
        List<TransactionResponse> getTransactionHistory(Customer customer);

        // ==================== ORDER MANAGEMENT ====================

        /**
         * Tìm kiếm đơn hàng với các bộ lọc
         */
        List<ServiceRequest> searchOrders(Customer customer, RequestStatus status, Long orderId,
                        LocalDate fromDate, LocalDate toDate);

        // ==================== ADDRESS MANAGEMENT ====================

        /**
         * Lấy danh sách địa chỉ của customer
         */
        List<CustomerAddress> getAddresses(Customer customer);

        /**
         * Thêm địa chỉ mới
         */
        CustomerAddress addAddress(Customer customer, CustomerAddress address);

        /**
         * Cập nhật địa chỉ
         */
        CustomerAddress updateAddress(Customer customer, Long addressId, CustomerAddress addressData);

        /**
         * Xóa địa chỉ
         */
        void deleteAddress(Customer customer, Long addressId);

        /**
         * Đặt địa chỉ mặc định
         */
        void setDefaultAddress(Customer customer, Long addressId);

        /**
         * Tìm kiếm địa chỉ (AJAX)
         */
        List<CustomerAddress> searchAddresses(Customer customer, String query);

        /**
         * Lưu địa chỉ từ AJAX (kiểm tra trùng lặp)
         */
        CustomerAddress saveAddressIfNotExists(Customer customer, CustomerAddress address);

        // ==================== SUPPORT TICKETS ====================

        /**
         * Lấy danh sách ticket của customer
         */
        List<SupportTicket> getMyTickets(Customer customer);

        /**
         * Lấy danh sách đơn hàng để chọn khi gửi ticket
         */
        List<ServiceRequest> getOrdersForTicket(Customer customer);

        /**
         * Gửi ticket hỗ trợ
         */
        SupportTicket submitTicket(Customer customer, Long requestId, String subject, String message);

        // ==================== NOTIFICATIONS ====================

        /**
         * Lấy danh sách thông báo cho customer
         */
        List<Notification> getNotifications();

        // ==================== PROFILE MANAGEMENT ====================

        /**
         * Cập nhật hồ sơ (không có email mới)
         */
        void updateProfile(Customer customer, String fullName, String email,
                        String businessName, String phone);

        /**
         * Cập nhật hồ sơ với xác thực OTP (có email mới)
         */
        void updateProfileWithOtp(Customer customer, String fullName, String businessName,
                        String phone, String pendingEmail, String otp, String serverOtp);

        /**
         * Gửi OTP xác thực email mới
         */
        void sendEmailOtp(String newEmail);

        /**
         * Kiểm tra email đã tồn tại
         */
        boolean isEmailExists(String email);

        /**
         * Đổi mật khẩu
         */
        void changePassword(Customer customer, String currentPassword, String newPassword);

        /**
         * Upload avatar
         */
        String uploadAvatar(Customer customer, org.springframework.web.multipart.MultipartFile avatarFile)
                        throws java.io.IOException;

        // ==================== CREATE ORDER HELPERS ====================

        /**
         * Lấy danh sách địa chỉ đã lưu (không phải mặc định)
         */
        List<CustomerAddress> getSavedAddresses(Customer customer);

        /**
         * Lấy địa chỉ mặc định
         */
        CustomerAddress getDefaultAddress(Customer customer);

        /**
         * Lấy danh sách Hub đang hoạt động
         */
        List<Hub> getActiveHubs();

        /**
         * Lấy danh sách loại dịch vụ đang hoạt động
         */
        List<ServiceType> getActiveServiceTypes();

        // ==================== ORDER CREATION ====================

        /**
         * Lấy Hub theo ID
         */
        Hub getHubById(Long hubId);

        /**
         * Upload ảnh đơn hàng
         */
        String uploadOrderImage(org.springframework.web.multipart.MultipartFile imageFile) throws java.io.IOException;

        /**
         * Tạo đơn hàng mới
         */
        ServiceRequest createOrder(Customer customer, ServiceRequest orderData,
                        Map<String, String> recipientInfo, Long hubId,
                        org.springframework.web.multipart.MultipartFile imageFile) throws java.io.IOException;

        // ==================== VNPAY PAYMENT ====================

        /**
         * Tạo URL thanh toán VNPAY
         */
        String createVnpayPaymentUrl(Customer customer, ServiceRequest orderData,
                        Map<String, String> recipientInfo, Long hubId,
                        org.springframework.web.multipart.MultipartFile imageFile,
                        jakarta.servlet.http.HttpServletRequest request) throws Exception;

        /**
         * Xử lý callback từ VNPAY
         * 
         * @return redirect URL
         */
        String processVnpayReturn(jakarta.servlet.http.HttpServletRequest request) throws java.io.IOException;
}
