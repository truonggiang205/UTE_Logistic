package vn.web.logistic.controller.manager;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.outbound.ConsolidateRequest;
import vn.web.logistic.dto.request.outbound.GateOutRequest;
import vn.web.logistic.dto.request.outbound.TripPlanningRequest;
import vn.web.logistic.dto.response.outbound.ConsolidateResponse;
import vn.web.logistic.dto.response.outbound.GateOutResponse;
import vn.web.logistic.dto.response.outbound.TripPlanningResponse;
import vn.web.logistic.entity.Container;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.ContainerRepository;
import vn.web.logistic.service.OutboundService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * REST Controller cho PHÂN HỆ XUẤT KHO (MIDDLE MILE) - Manager Portal
 * 
 * Endpoints:
 * - POST /api/manager/outbound/consolidate : Đóng bao
 * - POST /api/manager/outbound/trip : Tạo chuyến xe
 * - POST /api/manager/outbound/gate-out : Xuất bến
 */
@Slf4j
@RestController
@RequestMapping("/api/manager/outbound")
@RequiredArgsConstructor
public class OutboundController {

    private final OutboundService outboundService;
    private final ContainerRepository containerRepository;

    // ===================================================================
    // API LẤY DANH SÁCH CONTAINERS CHO GATE-OUT
    // ===================================================================

    /**
     * API lấy danh sách containers theo status và hub đích
     * GET /api/manager/containers?status=closed&toHubId=1
     */
    @GetMapping("/containers")
    public ResponseEntity<?> getContainers(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long toHubId) {

        log.info("Lấy danh sách containers - status: {}, toHubId: {}", status, toHubId);

        try {
            List<Container> containers;

            if (status != null && toHubId != null) {
                Container.ContainerStatus containerStatus = Container.ContainerStatus.valueOf(status);
                containers = containerRepository.findByStatusAndDestinationHub(containerStatus, toHubId);
            } else if (status != null) {
                Container.ContainerStatus containerStatus = Container.ContainerStatus.valueOf(status);
                containers = containerRepository.findByStatus(containerStatus);
            } else {
                containers = containerRepository.findAll();
            }

            // Convert to DTO
            List<Map<String, Object>> data = containers.stream().map(c -> {
                Map<String, Object> map = new HashMap<>();
                map.put("containerId", c.getContainerId());
                map.put("containerCode", c.getContainerCode());
                map.put("containerType", c.getType() != null ? c.getType().name() : "standard");
                map.put("status", c.getStatus().name());
                map.put("totalWeight", c.getWeight() != null ? c.getWeight() : 0);
                map.put("itemCount", 0); // Sẽ cần query ContainerDetail để đếm số đơn
                if (c.getCreatedAtHub() != null) {
                    map.put("fromHub", c.getCreatedAtHub().getHubName());
                }
                if (c.getDestinationHub() != null) {
                    map.put("toHub", c.getDestinationHub().getHubName());
                }
                return map;
            }).collect(Collectors.toList());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());

            return ResponseEntity.ok(result);

        } catch (IllegalArgumentException e) {
            log.warn("Invalid status: {}", status);
            return ResponseEntity.badRequest().body(createErrorResponse("Status không hợp lệ: " + status));

        } catch (Exception e) {
            log.error("Lỗi khi lấy containers: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // CHỨC NĂNG 5: ĐÓNG BAO (Consolidate)
    // ===================================================================

    /**
     * API Đóng bao - Gom nhiều đơn hàng vào một container
     * POST /api/manager/outbound/consolidate
     */
    @PostMapping("/consolidate")
    public ResponseEntity<?> consolidate(
            @Valid @RequestBody ConsolidateRequest request,
            HttpSession session) {

        log.info("=== API ĐÓNG BAO ===");
        log.info("Request: {} đơn, Hub đích: {}",
                request.getRequestIds().size(), request.getToHubId());

        try {
            Long actorId = getActorIdFromSession(session);
            ConsolidateResponse response = outboundService.consolidate(request, actorId);

            log.info("Kết quả: Thành công {}/{} đơn, Container: {}",
                    response.getSuccessCount(), response.getTotalRequested(),
                    response.getContainer().getContainerCode());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Đóng bao thành công " + response.getSuccessCount() + "/" +
                    response.getTotalRequested() + " đơn");
            result.put("data", response);

            return ResponseEntity.status(HttpStatus.CREATED).body(result);

        } catch (IllegalArgumentException e) {
            log.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));

        } catch (Exception e) {
            log.error("Lỗi khi đóng bao: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // CHỨC NĂNG 6: TẠO CHUYẾN XE (Trip Planning)
    // ===================================================================

    /**
     * API Tạo chuyến xe
     * POST /api/manager/outbound/trip
     */
    @PostMapping("/trip")
    public ResponseEntity<?> createTrip(
            @Valid @RequestBody TripPlanningRequest request,
            HttpSession session) {

        log.info("=== API TẠO CHUYẾN XE ===");
        log.info("Request: Xe {}, Tài xế {}, Từ Hub {} -> Hub {}",
                request.getVehicleId(), request.getDriverId(),
                request.getFromHubId(), request.getToHubId());

        try {
            Long actorId = getActorIdFromSession(session);
            TripPlanningResponse response = outboundService.createTrip(request, actorId);

            log.info("Đã tạo chuyến: {} - Xe: {}",
                    response.getTripCode(), response.getVehicle().getPlateNumber());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Tạo chuyến xe thành công: " + response.getTripCode());
            result.put("data", response);

            return ResponseEntity.status(HttpStatus.CREATED).body(result);

        } catch (IllegalArgumentException e) {
            log.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));

        } catch (Exception e) {
            log.error("Lỗi khi tạo chuyến xe: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // CHỨC NĂNG 7: XUẤT BẾN (Gate Out)
    // ===================================================================

    /**
     * API Xuất bến - Xác nhận xe xuất bến
     * POST /api/manager/outbound/gate-out
     */
    @PostMapping("/gate-out")
    public ResponseEntity<?> gateOut(
            @Valid @RequestBody GateOutRequest request,
            HttpSession session) {

        log.info("=== API XUẤT BẾN ===");
        log.info("Request: Trip {}, Số container: {}",
                request.getTripId(), request.getContainerIds().size());

        try {
            Long actorId = getActorIdFromSession(session);
            GateOutResponse response = outboundService.gateOut(request, actorId);

            log.info("Xuất bến thành công: {} - {} container, {} đơn hàng",
                    response.getTrip().getTripCode(),
                    response.getContainerCount(),
                    response.getTotalOrders());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Xuất bến thành công chuyến " + response.getTrip().getTripCode() +
                    " với " + response.getContainerCount() + " container, " +
                    response.getTotalOrders() + " đơn hàng");
            result.put("data", response);

            return ResponseEntity.ok(result);

        } catch (IllegalArgumentException e) {
            log.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));

        } catch (Exception e) {
            log.error("Lỗi khi xuất bến: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // HELPER METHODS
    // ===================================================================

    private Long getActorIdFromSession(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user.getUserId();
        }
        log.warn("Không tìm thấy user trong session, sử dụng ID mặc định = 1");
        return 1L;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        error.put("timestamp", System.currentTimeMillis());
        return error;
    }
}
