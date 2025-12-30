package vn.web.logistic.controller.manager;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.response.manager.ManagerDashboardStatsResponse;
import vn.web.logistic.dto.response.manager.OrderTrackingResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.service.ManagerDashboardService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST API Controller cho Manager Dashboard (Trưởng bưu cục)
 * 
 * Chức năng 1: Lấy thống kê tổng quan của Hub
 * Chức năng 2: Tra cứu đơn hàng theo mã đơn hoặc SĐT người gửi
 */
@RestController
@RequestMapping("/api/manager")
@RequiredArgsConstructor
public class ManagerDashboardController {

    private final ManagerDashboardService managerDashboardService;

    /**
     * API lấy thống kê tổng quan cho Manager Dashboard
     * GET /api/manager/dashboard/stats
     * 
     * Yêu cầu: Manager phải đăng nhập và có hub_id
     */
    @GetMapping("/dashboard/stats")
    public ResponseEntity<?> getManagerStats(HttpSession session) {
        // Lấy thông tin user từ session
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        // Lấy hub_id từ Staff của user (Manager là staff của Hub)
        Long hubId = getHubIdFromUser(currentUser);

        if (hubId == null) {
            return ResponseEntity.badRequest().body(
                    createErrorResponse(
                            "Không tìm thấy thông tin Hub. Bạn cần được gán vào một Hub để sử dụng chức năng này."));
        }

        ManagerDashboardStatsResponse stats = managerDashboardService.getManagerStats(hubId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", stats);
        response.put("hubId", hubId);

        return ResponseEntity.ok(response);
    }

    /**
     * API tra cứu đơn hàng theo keyword (mã đơn hoặc SĐT người gửi)
     * GET /api/manager/tracking?keyword=xxx
     */
    @GetMapping("/tracking")
    public ResponseEntity<?> trackOrder(
            @RequestParam(required = false) String keyword,
            HttpSession session) {

        // Kiểm tra đăng nhập
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(
                    createErrorResponse("Vui lòng nhập mã đơn hàng hoặc số điện thoại người gửi"));
        }

        List<OrderTrackingResponse> results = managerDashboardService.trackOrder(keyword.trim());

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", results);
        response.put("count", results.size());
        response.put("keyword", keyword.trim());

        return ResponseEntity.ok(response);
    }

    /**
     * API lấy chi tiết một đơn hàng cụ thể
     * GET /api/manager/tracking/{requestId}
     */
    @GetMapping("/tracking/{requestId}")
    public ResponseEntity<?> getOrderDetail(
            @PathVariable Long requestId,
            HttpSession session) {

        // Kiểm tra đăng nhập
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        OrderTrackingResponse order = managerDashboardService.getOrderDetail(requestId);

        if (order == null) {
            return ResponseEntity.status(404).body(
                    createErrorResponse("Không tìm thấy đơn hàng với mã: " + requestId));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", order);

        return ResponseEntity.ok(response);
    }

    /**
     * Lấy hub_id từ User (qua Staff hoặc Shipper)
     */
    private Long getHubIdFromUser(User user) {
        // Ưu tiên lấy từ Staff (Manager là staff)
        if (user.getStaff() != null && user.getStaff().getHub() != null) {
            return user.getStaff().getHub().getHubId();
        }

        // Fallback: lấy từ Shipper nếu có
        if (user.getShipper() != null && user.getShipper().getHub() != null) {
            return user.getShipper().getHub().getHubId();
        }

        return null;
    }

    /**
     * Tạo response lỗi chuẩn
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        return error;
    }
}
