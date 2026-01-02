package vn.web.logistic.controller.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;
import vn.web.logistic.service.LastMileService;
import vn.web.logistic.service.SecurityContextService;

@RestController
@RequestMapping("/api/manager/lastmile")
@RequiredArgsConstructor
@Slf4j
public class LastMileController {

    private final LastMileService lastMileService;
    private final SecurityContextService securityContextService;

    // LẤY DANH SÁCH SHIPPERS
    @GetMapping("/shippers")
    public ResponseEntity<?> getShippers(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status) {
        try {
            // Lấy hubId từ parameter hoặc từ user đang đăng nhập
            Long managerHubId = hubId;
            if (managerHubId == null) {
                managerHubId = securityContextService.getCurrentHubId();
            }

            // Gọi service để lấy danh sách shipper
            List<Map<String, Object>> data = lastMileService.getShippers(managerHubId, status);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách shipper: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // LẤY DANH SÁCH ĐƠN HÀNG CHỜ GIAO
    @GetMapping("/orders")
    public ResponseEntity<?> getOrdersForDelivery(
            @RequestParam(required = false) Long hubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String trackingCode) {
        try {
            // Lấy hubId từ parameter hoặc từ user đang đăng nhập
            Long managerHubId = hubId;
            if (managerHubId == null) {
                managerHubId = securityContextService.getCurrentHubId();
            }

            // Gọi service để lấy danh sách đơn hàng
            List<Map<String, Object>> data = lastMileService.getOrdersForDelivery(managerHubId, status, trackingCode);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách đơn hàng: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // LẤY DANH SÁCH TASK ĐANG THỰC HIỆN
    @GetMapping("/tasks")
    public ResponseEntity<?> getShipperTasks(
            @RequestParam(required = false) Long shipperId,
            @RequestParam(required = false) String status) {
        try {
            // Lấy hubId từ user đang đăng nhập
            Long managerHubId = securityContextService.getCurrentHubId();

            // Gọi service để lấy danh sách tasks
            List<Map<String, Object>> data = lastMileService.getShipperTasks(managerHubId, shipperId, status);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách task: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // CHỨC NĂNG 1: PHÂN CÔNG SHIPPER
    @PostMapping("/assign-task")
    public ResponseEntity<?> assignTask(
            @Valid @RequestBody AssignTaskRequest request) {
        try {
            Long actorUserId = getActorIdFromSecurityContext();
            AssignTaskResponse response = lastMileService.assignTask(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi phân công shipper: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi phân công shipper: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi phân công shipper: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.message("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // CHỨC NĂNG 2: XÁC NHẬN GIAO XONG
    @PostMapping("/confirm-delivery")
    public ResponseEntity<?> confirmDelivery(
            @Valid @RequestBody ConfirmDeliveryRequest request) {
        try {
            Long actorUserId = getActorIdFromSecurityContext();
            ConfirmDeliveryResponse response = lastMileService.confirmDelivery(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi xác nhận giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi xác nhận giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi xác nhận giao: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.message("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // CHỨC NĂNG 3: XÁC NHẬN HẸN LẠI
    @PostMapping("/delivery-delay")
    public ResponseEntity<?> deliveryDelay(
            @Valid @RequestBody DeliveryDelayRequest request) {
        try {
            Long actorUserId = getActorIdFromSecurityContext();
            DeliveryDelayResponse response = lastMileService.deliveryDelay(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi hẹn lại giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi hẹn lại giao: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi hẹn lại giao: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.message("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // CHỨC NĂNG 4: KHÁCH NHẬN TẠI QUẦY
    @PostMapping("/counter-pickup")
    public ResponseEntity<?> counterPickup(
            @Valid @RequestBody CounterPickupRequest request) {
        try {
            Long actorUserId = getActorIdFromSecurityContext();
            CounterPickupResponse response = lastMileService.counterPickup(request, actorUserId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi khách nhận tại quầy: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (IllegalStateException e) {
            log.error("Lỗi trạng thái khi khách nhận tại quầy: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi khách nhận tại quầy: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(ApiResponse.message("Có lỗi xảy ra, vui lòng thử lại sau"));
        }
    }

    // CHỨC NĂNG 5: HOÀN HÀNG
    // LẤY DANH SÁCH ĐƠN CẦN HOÀN HÀNG (3+ lần thất bại)
    @GetMapping("/return-goods/pending")
    public ResponseEntity<?> getOrdersPendingReturnGoods() {
        try {
            // Lấy hubId của manager từ SecurityContext
            Long managerHubId = securityContextService.getCurrentHubId();

            // Gọi service để lấy danh sách đơn cần hoàn
            List<Map<String, Object>> data = lastMileService.getOrdersPendingReturnGoods(managerHubId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách đơn cần hoàn: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // LẤY DANH SÁCH ĐƠN CHỜ TRẢ SHOP (đã hoàn về Hub gốc, status=failed)
    @GetMapping("/return-shop/pending")
    public ResponseEntity<?> getOrdersPendingReturnShop() {
        try {
            // Lấy hubId của manager từ SecurityContext
            Long managerHubId = securityContextService.getCurrentHubId();

            // Gọi service để lấy danh sách đơn chờ trả shop
            List<Map<String, Object>> data = lastMileService.getOrdersPendingReturnShop(managerHubId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", data);
            result.put("count", data.size());
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách đơn chờ trả shop: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // KÍCH HOẠT HOÀN HÀNG THỦ CÔNG
    @PostMapping("/return-goods/activate")
    public ResponseEntity<?> activateReturnGoods(@RequestBody Map<String, Object> request) {
        try {
            Long requestId = Long.valueOf(request.get("requestId").toString());

            // Gọi service để kích hoạt hoàn hàng
            Map<String, Object> result = lastMileService.activateReturnGoods(requestId);
            return ResponseEntity.ok(result);

        } catch (IllegalArgumentException | IllegalStateException e) {
            log.error("Lỗi khi kích hoạt hoàn hàng: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi kích hoạt hoàn hàng: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // HOÀN TẤT TRẢ HÀNG CHO SHOP (RETURN COMPLETED)
    @PostMapping("/return-goods/complete")
    public ResponseEntity<?> completeReturnGoods(@RequestBody Map<String, Object> request) {
        try {
            Long requestId = Long.valueOf(request.get("requestId").toString());
            Long actorUserId = getActorIdFromSecurityContext();

            // Gọi service để hoàn tất trả hàng
            Map<String, Object> result = lastMileService.completeReturnGoods(requestId, actorUserId);
            return ResponseEntity.ok(result);

        } catch (IllegalArgumentException | IllegalStateException e) {
            log.error("Lỗi khi hoàn tất trả hàng: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.message(e.getMessage()));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi hoàn tất trả hàng: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.message("Lỗi hệ thống"));
        }
    }

    // Lấy actorUserId từ SecurityContext
    private Long getActorIdFromSecurityContext() {
        Long userId = securityContextService.getCurrentUserId();
        if (userId != null) {
            return userId;
        }
        log.warn("Không tìm thấy user trong SecurityContext, sử dụng ID mặc định = 1");
        return 1L;
    }
}
