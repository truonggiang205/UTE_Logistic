package vn.web.logistic.controller.manager;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.service.HubOrdersService;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/manager/hub-orders")
@RequiredArgsConstructor
public class HubOrdersController {

    private final HubOrdersService hubOrdersService;

    /**
     * Lấy danh sách đơn hàng theo Hub
     * GET /api/manager/hub-orders/{hubId}/orders
     */
    @GetMapping("/{hubId}/orders")
    public ResponseEntity<?> getOrdersByHub(
            @PathVariable Long hubId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        try {
            List<Map<String, Object>> orders = hubOrdersService.getOrdersByHub(hubId, status, keyword);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", orders));
        } catch (Exception e) {
            log.error("Lỗi lấy danh sách đơn hàng: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Cập nhật đơn hàng
     * PUT /api/manager/hub-orders/{requestId}
     */
    @PutMapping("/{requestId}")
    public ResponseEntity<?> updateOrder(
            @PathVariable Long requestId,
            @RequestBody Map<String, Object> updateData) {
        try {
            ServiceRequest updated = hubOrdersService.updateOrder(requestId, updateData);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Cập nhật đơn hàng thành công",
                    "data", Map.of("requestId", updated.getRequestId())));
        } catch (Exception e) {
            log.error("Lỗi cập nhật đơn hàng: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi: " + e.getMessage()));
        }
    }

    /**
     * Xóa đơn hàng và các dữ liệu liên quan
     * DELETE /api/manager/hub-orders/{requestId}
     */
    @DeleteMapping("/{requestId}")
    public ResponseEntity<?> deleteOrder(@PathVariable Long requestId) {
        try {
            hubOrdersService.deleteOrder(requestId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã xóa đơn hàng thành công"));
        } catch (Exception e) {
            log.error("Lỗi xóa đơn hàng: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Lỗi: " + e.getMessage()));
        }
    }
}
