package vn.web.logistic.controller.manager;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.AssignTaskRequest;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.manager.OrderForAssignDTO;
import vn.web.logistic.dto.response.manager.UpdateStatusResult;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.service.SecurityContextService;
import vn.web.logistic.service.TaskAssignmentService;

@RestController
@RequestMapping("/api/manager/tasks")
@RequiredArgsConstructor
public class TaskAssignmentController {

    private final TaskAssignmentService taskAssignmentService;
    private final SecurityContextService securityContextService;

    // Lấy danh sách đơn cần PICKUP trong khu vực Hub (có phân trang)
    @GetMapping("/pending-pickup")
    public ResponseEntity<?> getPendingPickupOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Hub hub = securityContextService.getCurrentHub();
        if (hub == null) {
            return ResponseEntity.badRequest().body(ApiResponse.message("Không tìm thấy Hub"));
        }

        Page<OrderForAssignDTO> ordersPage = taskAssignmentService.getPendingPickupOrdersPaged(hub.getHubId(), page,
                size);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", ordersPage.getContent());
        response.put("page", ordersPage.getNumber());
        response.put("size", ordersPage.getSize());
        response.put("totalElements", ordersPage.getTotalElements());
        response.put("totalPages", ordersPage.getTotalPages());
        response.put("count", ordersPage.getTotalElements());
        response.put("taskType", "pickup");

        return ResponseEntity.ok(response);
    }

    // Lấy danh sách đơn cần DELIVERY (đã đến Hub) (có phân trang)
    @GetMapping("/pending-delivery")
    public ResponseEntity<?> getPendingDeliveryOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Hub hub = securityContextService.getCurrentHub();
        if (hub == null) {
            return ResponseEntity.badRequest().body(ApiResponse.message("Không tìm thấy Hub"));
        }

        Page<OrderForAssignDTO> ordersPage = taskAssignmentService.getPendingDeliveryOrdersPaged(hub.getHubId(), page,
                size);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", ordersPage.getContent());
        response.put("page", ordersPage.getNumber());
        response.put("size", ordersPage.getSize());
        response.put("totalElements", ordersPage.getTotalElements());
        response.put("totalPages", ordersPage.getTotalPages());
        response.put("count", ordersPage.getTotalElements());
        response.put("taskType", "delivery");

        return ResponseEntity.ok(response);
    }

    // Phân công shipper cho đơn hàng
    @PostMapping("/assign")
    public ResponseEntity<?> assignShipper(@Valid @RequestBody AssignTaskRequest request) {
        Hub hub = securityContextService.getCurrentHub();
        if (hub == null) {
            return ResponseEntity.badRequest().body(ApiResponse.message("Không tìm thấy Hub"));
        }

        UpdateStatusResult result = taskAssignmentService.assignShipper(request, hub.getHubId());

        Map<String, Object> response = new HashMap<>();
        response.put("success", result.isSuccess());
        response.put("message", result.getMessage());
        if (result.getErrorCode() != null) {
            response.put("errorCode", result.getErrorCode());
        }

        if (result.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Hủy phân công
    @DeleteMapping("/{taskId}")
    public ResponseEntity<?> unassignShipper(@PathVariable Long taskId) {
        UpdateStatusResult result = taskAssignmentService.unassignShipper(taskId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", result.isSuccess());
        response.put("message", result.getMessage());

        if (result.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

}
