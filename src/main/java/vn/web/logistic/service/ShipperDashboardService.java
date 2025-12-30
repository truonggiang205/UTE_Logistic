package vn.web.logistic.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import vn.web.logistic.dto.response.CodHistoryDTO;
import vn.web.logistic.dto.response.OrderDetailDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO;
import vn.web.logistic.dto.response.ShipperDashboardDTO.TodayOrderDTO;
import vn.web.logistic.dto.response.ShipperEarningsDTO;
import vn.web.logistic.dto.response.ShipperProfileDTO;

/**
 * Service interface cho Shipper Dashboard
 */
public interface ShipperDashboardService {

    // DASHBOARD

    ShipperDashboardDTO getDashboardData(String email);

    ShipperDashboardDTO getDashboardDataByShipperId(Long shipperId);

    // TASK MANAGEMENT

    void updatePickupStatus(Long taskId, String status, String note, String shipperEmail);

    void updateDeliveryStatus(Long taskId, String status, String note, String shipperEmail);

    // ORDER MANAGEMENT

    List<TodayOrderDTO> getAllOrdersByShipper(String shipperEmail, String taskType, String status);

    List<TodayOrderDTO> getInProgressTasks(String shipperEmail);

    Page<TodayOrderDTO> getOrderHistory(String shipperEmail, LocalDate fromDate, LocalDate toDate,
            String status, Pageable pageable);

    OrderDetailDTO getOrderDetail(Long taskId, String shipperEmail);

    // COD MANAGEMENT

    List<TodayOrderDTO> getUnpaidCodOrders(String shipperEmail);

    java.math.BigDecimal getTotalUnpaidCod(String shipperEmail);

    void submitCod(String shipperEmail, java.util.List<Long> codTxIds, String paymentMethod, String note);

    List<CodHistoryDTO> getCodHistory(String shipperEmail);

    // EARNINGS MANAGEMENT

    ShipperEarningsDTO getEarningsData(String shipperEmail);

    // PROFILE MANAGEMENT

    ShipperProfileDTO getProfile(String shipperEmail);
}
