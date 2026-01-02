package vn.web.logistic.controller.manager;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.response.manager.ManagerDashboardStatsResponse;
import vn.web.logistic.dto.response.manager.OrderTrackingResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.ManagerDashboardService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST API Controller cho Manager Dashboard (Trưởng bưu cục)
 * 
 * Chức năng 1: Lấy thống kê tổng quan của Hub
 * Chức năng 2: Tra cứu đơn hàng theo mã vận đơn (tracking code)
 * Chức năng 3: Xem danh sách đơn hàng theo trạng thái (click KPI)
 */
@RestController
@RequestMapping("/api/manager")
@RequiredArgsConstructor
public class ManagerDashboardController {

    private final ManagerDashboardService managerDashboardService;
    private final UserRepository userRepository;

    /**
     * API lấy thống kê tổng quan cho Manager Dashboard
     * GET /api/manager/dashboard/stats
     * 
     * Yêu cầu: Manager phải đăng nhập và có hub_id
     */
    @GetMapping("/dashboard/stats")
    public ResponseEntity<?> getManagerStats() {
        // Lấy thông tin user từ Spring Security
        User currentUser = getCurrentUser();

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
     * API tra cứu đơn hàng theo mã vận đơn (tracking code)
     * GET /api/manager/tracking?keyword=xxx
     * 
     * Keyword có thể là:
     * - Mã vận đơn (tracking code)
     * - Request ID
     * - SĐT người gửi
     */
    @GetMapping("/tracking")
    public ResponseEntity<?> trackOrder(
            @RequestParam(required = false) String keyword) {

        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(
                    createErrorResponse("Vui lòng nhập mã vận đơn hoặc số điện thoại người gửi"));
        }

        String cleanKeyword = keyword.trim();

        // Ưu tiên tìm theo tracking code trước
        OrderTrackingResponse trackingResult = managerDashboardService.trackByTrackingCode(cleanKeyword);

        if (trackingResult != null) {
            // Tìm thấy theo tracking code
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", List.of(trackingResult));
            response.put("count", 1);
            response.put("keyword", cleanKeyword);
            response.put("searchType", "tracking_code");
            return ResponseEntity.ok(response);
        }

        // Fallback: tìm theo requestId hoặc SĐT
        List<OrderTrackingResponse> results = managerDashboardService.trackOrder(cleanKeyword);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", results);
        response.put("count", results.size());
        response.put("keyword", cleanKeyword);
        response.put("searchType", "keyword");

        return ResponseEntity.ok(response);
    }

    /**
     * API lấy chi tiết một đơn hàng cụ thể
     * GET /api/manager/tracking/{requestId}
     */
    @GetMapping("/tracking/{requestId}")
    public ResponseEntity<?> getOrderDetail(
            @PathVariable Long requestId) {

        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
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
     * API lấy danh sách đơn hàng theo trạng thái (cho click KPI)
     * GET /api/manager/orders?status=pending
     * 
     * Status có thể là: pending, picked, in_transit, delivered, cancelled, failed,
     * all
     */
    @GetMapping("/orders")
    public ResponseEntity<?> getOrdersByStatus(
            @RequestParam(required = false, defaultValue = "all") String status) {

        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        // Lấy hub_id từ user
        Long hubId = getHubIdFromUser(currentUser);
        if (hubId == null) {
            return ResponseEntity.badRequest().body(
                    createErrorResponse("Không tìm thấy thông tin Hub."));
        }

        List<OrderTrackingResponse> orders = managerDashboardService.getOrdersByHubAndStatus(hubId, status);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", orders);
        response.put("count", orders.size());
        response.put("status", status);
        response.put("hubId", hubId);

        return ResponseEntity.ok(response);
    }

    /**
     * Lấy User hiện tại từ Spring Security
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        String email = authentication.getName();
        if (email == null || "anonymousUser".equals(email)) {
            return null;
        }

        return userRepository.findByEmail(email).orElse(null);
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

    /**
     * API: Lấy thông tin User hiện tại (dùng cho frontend)
     * GET /api/manager/current-user
     */
    @GetMapping("/current-user")
    public ResponseEntity<?> getCurrentUserInfo() {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        Long hubId = getHubIdFromUser(currentUser);

        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("userId", currentUser.getUserId());
        userInfo.put("username", currentUser.getUsername());
        userInfo.put("fullName", currentUser.getFullName());
        userInfo.put("email", currentUser.getEmail());
        userInfo.put("hubId", hubId);

        return ResponseEntity.ok(userInfo);
    }
}
