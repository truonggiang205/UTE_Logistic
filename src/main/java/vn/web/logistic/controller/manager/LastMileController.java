package vn.web.logistic.controller.manager;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ShipperRepository;
import vn.web.logistic.repository.ShipperTaskRepository;
import vn.web.logistic.service.LastMileService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// Controller cho phân hệ LAST MILE (Giao hàng)
// Các API dành cho Manager và Shipper thao tác giao hàng
@RestController
@RequestMapping("/api/manager/lastmile")
@RequiredArgsConstructor
@Slf4j
public class LastMileController {

    private final LastMileService lastMileService;
    private final ShipperRepository shipperRepository;
    private final ShipperTaskRepository shipperTaskRepository;
    private final ServiceRequestRepository serviceRequestRepository;

    // ====================== API LẤY DANH SÁCH SHIPPERS ======================
    // GET /api/manager/lastmile/shippers?hubId=1&status=active
    @GetMapping("/shippers")
    public ResponseEntity<?> getShippers(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status) {
        try {
            List<Shipper> shippers;
            if (hubId != null) {
                shippers = shipperRepository.findByHubHubId(hubId);
            } else {
                shippers = shipperRepository.findAll();
            }

            // Filter theo status nếu có
            if (status != null && !status.isEmpty()) {
                Shipper.ShipperStatus shipperStatus = Shipper.ShipperStatus.valueOf(status);
                shippers = shippers.stream()
                        .filter(s -> s.getStatus() == shipperStatus)
                        .collect(Collectors.toList());
            }

            // Convert to DTO
            List<Map<String, Object>> data = shippers.stream().map(s -> {
                Map<String, Object> map = new HashMap<>();
                map.put("shipperId", s.getShipperId());
                map.put("shipperName", s.getUser() != null ? s.getUser().getFullName() : "N/A");
                map.put("phone", s.getUser() != null ? s.getUser().getPhone() : "N/A");
                map.put("status", s.getStatus().name());
                map.put("vehicleType", s.getVehicleType());
                map.put("rating", s.getRating());
                if (s.getHub() != null) {
                    map.put("hubId", s.getHub().getHubId());
                    map.put("hubName", s.getHub().getHubName());
                }
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách shipper: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(createErrorResponse("Lỗi hệ thống"));
        }
    }

    // ====================== API LẤY DANH SÁCH ĐƠN HÀNG CHỜ GIAO
    // ======================
    // GET /api/manager/lastmile/orders?hubId=1&status=picked
    @GetMapping("/orders")
    public ResponseEntity<?> getOrdersForDelivery(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status) {
        try {
            List<ServiceRequest> orders = serviceRequestRepository.findAll();

            // Filter theo hubId nếu có
            if (hubId != null) {
                orders = orders.stream()
                        .filter(o -> o.getCurrentHub() != null &&
                                o.getCurrentHub().getHubId().equals(hubId))
                        .collect(Collectors.toList());
            }

            // Filter theo status (mặc định là picked - sẵn sàng giao)
            ServiceRequest.RequestStatus requestStatus = ServiceRequest.RequestStatus.picked;
            if (status != null && !status.isEmpty()) {
                requestStatus = ServiceRequest.RequestStatus.valueOf(status);
            }
            final ServiceRequest.RequestStatus finalStatus = requestStatus;
            orders = orders.stream()
                    .filter(o -> o.getStatus() == finalStatus)
                    .collect(Collectors.toList());

            // Convert to DTO
            List<Map<String, Object>> data = orders.stream().map(o -> {
                Map<String, Object> map = new HashMap<>();
                map.put("requestId", o.getRequestId());
                map.put("trackingCode", "TK" + String.format("%08d", o.getRequestId()));
                map.put("status", o.getStatus().name());
                map.put("codAmount", o.getCodAmount());
                map.put("itemName", o.getItemName());
                if (o.getDeliveryAddress() != null) {
                    map.put("receiverName", o.getDeliveryAddress().getContactName());
                    map.put("receiverPhone", o.getDeliveryAddress().getContactPhone());
                    map.put("receiverAddress", buildAddress(o.getDeliveryAddress()));
                }
                if (o.getCurrentHub() != null) {
                    map.put("hubId", o.getCurrentHub().getHubId());
                    map.put("hubName", o.getCurrentHub().getHubName());
                }
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách đơn hàng: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(createErrorResponse("Lỗi hệ thống"));
        }
    }

    // ====================== API LẤY DANH SÁCH TASK ĐANG THỰC HIỆN
    // ======================
    // GET /api/manager/lastmile/tasks?shipperId=1&status=assigned
    @GetMapping("/tasks")
    public ResponseEntity<?> getShipperTasks(
            @RequestParam(required = false) Long shipperId,
            @RequestParam(required = false) String status) {
        try {
            List<ShipperTask> tasks = shipperTaskRepository.findAll();

            // Filter theo shipperId nếu có
            if (shipperId != null) {
                tasks = tasks.stream()
                        .filter(t -> t.getShipper().getShipperId().equals(shipperId))
                        .collect(Collectors.toList());
            }

            // Filter theo status nếu có
            if (status != null && !status.isEmpty()) {
                ShipperTask.TaskStatus taskStatus = ShipperTask.TaskStatus.valueOf(status);
                tasks = tasks.stream()
                        .filter(t -> t.getTaskStatus() == taskStatus)
                        .collect(Collectors.toList());
            }

            // Convert to DTO
            List<Map<String, Object>> data = tasks.stream().map(t -> {
                Map<String, Object> map = new HashMap<>();
                map.put("taskId", t.getTaskId());
                map.put("taskType", t.getTaskType().name());
                map.put("taskStatus", t.getTaskStatus().name());
                map.put("assignedAt", t.getAssignedAt());
                map.put("completedAt", t.getCompletedAt());
                map.put("resultNote", t.getResultNote());

                // Thông tin shipper
                if (t.getShipper() != null) {
                    map.put("shipperId", t.getShipper().getShipperId());
                    map.put("shipperName",
                            t.getShipper().getUser() != null ? t.getShipper().getUser().getFullName() : "N/A");
                }

                // Thông tin đơn hàng
                if (t.getRequest() != null) {
                    map.put("requestId", t.getRequest().getRequestId());
                    map.put("trackingCode", "TK" + String.format("%08d", t.getRequest().getRequestId()));
                    map.put("requestStatus", t.getRequest().getStatus().name());
                    map.put("codAmount", t.getRequest().getCodAmount());
                    if (t.getRequest().getDeliveryAddress() != null) {
                        map.put("receiverName", t.getRequest().getDeliveryAddress().getContactName());
                        map.put("receiverPhone", t.getRequest().getDeliveryAddress().getContactPhone());
                        map.put("receiverAddress", buildAddress(t.getRequest().getDeliveryAddress()));
                    }
                }
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách task: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(createErrorResponse("Lỗi hệ thống"));
        }
    }

    // Helper method build địa chỉ từ CustomerAddress
    private String buildAddress(vn.web.logistic.entity.CustomerAddress address) {
        if (address == null)
            return "N/A";
        StringBuilder sb = new StringBuilder();
        if (address.getAddressDetail() != null)
            sb.append(address.getAddressDetail());
        if (address.getWard() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getWard());
        }
        if (address.getDistrict() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getDistrict());
        }
        if (address.getProvince() != null) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(address.getProvince());
        }
        return sb.length() > 0 ? sb.toString() : "N/A";
    }

    // ====================== CHỨC NĂNG 1: PHÂN CÔNG SHIPPER ======================
    // POST /api/manager/lastmile/assign-task
    // Input: { shipperId, requestIds: [1,2,3] }
    // Output: { shipperId, shipperName, assignedCount, tasks: [...] }
    @PostMapping("/assign-task")
    public ResponseEntity<?> assignTask(
            @Valid @RequestBody AssignTaskRequest request,
            HttpSession session) {
        try {
            Long actorUserId = getActorIdFromSession(session);
            AssignTaskResponse response = lastMileService.assignTask(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi phân công shipper: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi phân công shipper: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi phân công shipper: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(createErrorResponse("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // ====================== CHỨC NĂNG 2: XÁC NHẬN GIAO XONG ======================
    // POST /api/manager/lastmile/confirm-delivery
    // Input: { taskId, codCollected, note }
    // Output: { taskId, requestId, taskStatus, codCollected, codTxId, ... }
    @PostMapping("/confirm-delivery")
    public ResponseEntity<?> confirmDelivery(
            @Valid @RequestBody ConfirmDeliveryRequest request,
            HttpSession session) {
        try {
            Long actorUserId = getActorIdFromSession(session);
            ConfirmDeliveryResponse response = lastMileService.confirmDelivery(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi xác nhận giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi xác nhận giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi xác nhận giao: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(createErrorResponse("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // ====================== CHỨC NĂNG 3: XÁC NHẬN HẸN LẠI ======================
    // POST /api/manager/lastmile/delivery-delay
    // Input: { taskId, reason }
    // Output: { taskId, requestId, taskStatus, reason, actionId, ... }
    @PostMapping("/delivery-delay")
    public ResponseEntity<?> deliveryDelay(
            @Valid @RequestBody DeliveryDelayRequest request,
            HttpSession session) {
        try {
            Long actorUserId = getActorIdFromSession(session);
            DeliveryDelayResponse response = lastMileService.deliveryDelay(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi hẹn lại giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi hẹn lại giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi hẹn lại giao: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(createErrorResponse("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // ====================== CHỨC NĂNG 4: KHÁCH NHẬN TẠI QUẦY
    // ======================
    // POST /api/manager/lastmile/counter-pickup
    // Input: { requestId, customerIdCard, currentHubId }
    // Output: { requestId, requestStatus, codAmount, codTxId, actionId, ... }
    @PostMapping("/counter-pickup")
    public ResponseEntity<?> counterPickup(
            @Valid @RequestBody CounterPickupRequest request,
            HttpSession session) {
        try {
            Long actorUserId = getActorIdFromSession(session);
            CounterPickupResponse response = lastMileService.counterPickup(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi khách nhận tại quầy: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi khách nhận tại quầy: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi khách nhận tại quầy: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(createErrorResponse("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // Helper method lấy userId từ session
    private Long getActorIdFromSession(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user.getUserId();
        }
        log.warn("Không tìm thấy user trong session, sử dụng ID mặc định = 1");
        return 1L;
    }

    // Helper method tạo response lỗi
    private Map<String, String> createErrorResponse(String message) {
        Map<String, String> error = new HashMap<>();
        error.put("error", message);
        return error;
    }
}
