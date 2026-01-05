package vn.web.logistic.service;

import java.util.List;

import org.springframework.data.domain.Page;

import vn.web.logistic.dto.request.AssignTaskRequest;
import vn.web.logistic.dto.response.manager.OrderForAssignDTO;
import vn.web.logistic.dto.response.manager.UpdateStatusResult;

public interface TaskAssignmentService {

    // Lấy danh sách đơn cần PICKUP (theo currentHub_id)
    List<OrderForAssignDTO> getPendingPickupOrders(Long hubId);

    // Lấy danh sách đơn cần DELIVERY (theo hubId)
    List<OrderForAssignDTO> getPendingDeliveryOrders(Long hubId);

    // Lấy danh sách đơn cần PICKUP với phân trang
    Page<OrderForAssignDTO> getPendingPickupOrdersPaged(Long hubId, int page, int size);

    // Lấy danh sách đơn cần DELIVERY với phân trang
    Page<OrderForAssignDTO> getPendingDeliveryOrdersPaged(Long hubId, int page, int size);

    // Đếm tổng đơn cần phân công PICKUP
    long countPendingPickupOrders(Long hubId);

    long countPendingDeliveryOrders(Long hubId);

    // Phân công shipper cho đơn hàng
    UpdateStatusResult assignShipper(AssignTaskRequest request, Long hubId);

    // Hủy phân công
    UpdateStatusResult unassignShipper(Long taskId);
}
