package vn.web.logistic.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO.TodayOrderDTO;

public interface ShipperDashboardService {

    // Lấy dữ liệu dashboard cho shipper dựa trên email đăng nhập
    ShipperDashboardDTO getDashboardData(String email);

    // Lấy dữ liệu dashboard cho shipper dựa trên shipper ID
    ShipperDashboardDTO getDashboardDataByShipperId(Long shipperId);

    // Shipper update pickup status
    void updatePickupStatus(Long taskId, String status, String note, String shipperEmail);

    // Shipper update delivery status
    void updateDeliveryStatus(Long taskId, String status, String note, String shipperEmail);

    // Lấy tất cả đơn hàng của shipper với filter
    List<TodayOrderDTO> getAllOrdersByShipper(String shipperEmail, String taskType, String status);

    // Lấy các đơn đang xử lý (in_progress) - cho trang "Đang giao hàng"
    List<TodayOrderDTO> getInProgressTasks(String shipperEmail);

    // Lấy lịch sử đơn hàng (completed/failed) với filter theo ngày và phân trang
    Page<TodayOrderDTO> getOrderHistory(String shipperEmail, LocalDate fromDate, LocalDate toDate,
            String status, Pageable pageable);
}
