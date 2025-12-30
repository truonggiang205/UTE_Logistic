package vn.web.logistic.service;

import vn.web.logistic.dto.response.manager.ManagerDashboardStatsResponse;
import vn.web.logistic.dto.response.manager.OrderTrackingResponse;

import java.util.List;

public interface ManagerDashboardService {

    /**
     * Lấy thống kê tổng quan cho Manager Dashboard
     * Logic A: Đếm số lượng đơn hàng theo trạng thái trong Hub
     * Logic B: Tính tổng tiền COD đang pending (chưa thu/chưa nộp)
     * 
     * @param hubId ID của Hub mà Manager quản lý
     * @return ManagerDashboardStatsResponse chứa các thống kê
     */
    ManagerDashboardStatsResponse getManagerStats(Long hubId);

    /**
     * Tra cứu đơn hàng theo mã đơn hoặc số điện thoại người gửi
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
}
