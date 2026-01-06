package vn.web.logistic.service.customer;

import java.security.Principal;
import java.util.List;

import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.TrackingCode;

/**
 * Operation Service Interface
 * Xử lý logic nghiệp vụ cho trang Operation của Customer (theo dõi đơn hàng)
 */
public interface OperationService {

    // ==================== CUSTOMER CONTEXT ====================

    /**
     * Lấy thông tin Customer đang đăng nhập từ Principal
     */
    Customer getLoggedInCustomer(Principal principal);

    // ==================== ORDER OPERATIONS ====================

    /**
     * Lấy tất cả đơn hàng của customer, sắp xếp theo ngày tạo giảm dần
     */
    List<ServiceRequest> getAllOrders(Customer customer);

    /**
     * Lấy đơn hàng đang chờ xử lý (pending)
     */
    List<ServiceRequest> getPendingOrders(Customer customer);

    /**
     * Lấy đơn hàng đang giao (picked, in_transit)
     */
    List<ServiceRequest> getDeliveringOrders(Customer customer);

    /**
     * Lấy đơn hàng đã giao thành công (delivered)
     */
    List<ServiceRequest> getDeliveredOrders(Customer customer);

    /**
     * Lấy đơn hàng giao thất bại (failed)
     */
    List<ServiceRequest> getFailedOrders(Customer customer);

    /**
     * Lấy đơn hàng theo tab filter
     * 
     * @param tab Tên tab (all, pending, delivering, delivered, failed)
     * @return Danh sách đơn hàng theo filter
     */
    List<ServiceRequest> getOrdersByTab(Customer customer, String tab);

    // ==================== TRACKING ====================

    /**
     * Lấy lịch sử tracking (timeline) của đơn hàng
     */
    List<TrackingCode> getTrackingHistory(Long requestId);
}
