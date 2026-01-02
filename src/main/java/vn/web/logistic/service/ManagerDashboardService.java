package vn.web.logistic.service;

import vn.web.logistic.dto.response.manager.ManagerDashboardStatsResponse;
import vn.web.logistic.dto.response.manager.OrderTrackingResponse;

import java.util.List;

public interface ManagerDashboardService {

    /**
     * Lấy thống kê tổng quan cho Manager Dashboard
     * Logic A: Đếm số lượng đơn hàng theo trạng thái trong Hub
     * Logic B: Tính tổng tiền COD đang pending (chưa thu/chưa nộp)
     * Logic C: Tính tỉ lệ giao hàng thành công
     * 
     * @param hubId ID của Hub mà Manager quản lý
     * @return ManagerDashboardStatsResponse chứa các thống kê
     */
    ManagerDashboardStatsResponse getManagerStats(Long hubId);

    /**
     * Tra cứu đơn hàng theo keyword (mã đơn hoặc SĐT người gửi)
     * Bước 1: Tìm đơn hàng theo requestId hoặc senderPhone
     * Bước 2: Nếu tìm thấy, lấy thông tin chi tiết đơn hàng
     * Bước 3: Lấy lịch sử hành trình (ParcelAction) theo thời gian giảm dần
     * 
     * @param keyword Từ khóa tìm kiếm (mã đơn hoặc SĐT)
     * @return Danh sách OrderTrackingResponse
     */
    List<OrderTrackingResponse> trackOrder(String keyword);

    /**
     * Tra cứu chi tiết một đơn hàng cụ thể theo requestId
     * 
     * @param requestId ID của đơn hàng
     * @return OrderTrackingResponse hoặc null nếu không tìm thấy
     */
    OrderTrackingResponse getOrderDetail(Long requestId);

    /**
     * Tra cứu đơn hàng theo tracking code (mã vận đơn)
     * 
     * @param trackingCode Mã vận đơn
     * @return OrderTrackingResponse hoặc null nếu không tìm thấy
     */
    OrderTrackingResponse trackByTrackingCode(String trackingCode);

    /**
     * Lấy danh sách đơn hàng theo Hub và trạng thái (cho click KPI)
     * 
     * @param hubId  ID của Hub
     * @param status Trạng thái đơn hàng (pending, picked, in_transit, delivered,
     *               cancelled, failed, all)
     * @return Danh sách OrderTrackingResponse
     */
    List<OrderTrackingResponse> getOrdersByHubAndStatus(Long hubId, String status);
}
