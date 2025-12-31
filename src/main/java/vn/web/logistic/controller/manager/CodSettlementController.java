package vn.web.logistic.controller.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.CodSettlementRequest;
import vn.web.logistic.dto.response.manager.CodSettlementResultDTO;
import vn.web.logistic.dto.response.manager.ShipperCodSummaryDTO;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CodSettlementRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.CodSettlementService;

/**
 * REST API Controller cho Quyết toán COD (Manager)
 * 
 * Chức năng:
 * 1. Xem danh sách shipper có COD chưa quyết toán
 * 2. Xem chi tiết COD của một shipper
 * 3. Thực hiện quyết toán COD
 * 4. Xem lịch sử quyết toán
 */
@RestController
@RequestMapping("/api/manager/cod")
@RequiredArgsConstructor
@Slf4j
public class CodSettlementController {

    private final CodSettlementService codSettlementService;
    private final CodSettlementRepository codSettlementRepository;
    private final UserRepository userRepository;

    /**
     * API lấy danh sách shipper có COD chưa quyết toán trong Hub
     * GET /api/manager/cod/pending
     */
    @GetMapping("/pending")
    public ResponseEntity<?> getShippersWithPendingCod() {
        // Lấy user từ SecurityContext
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            log.warn("COD Settlement: Chưa đăng nhập");
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        // Lấy hub_id
        Long hubId = getHubIdFromUser(currentUser);

        if (hubId == null) {
            log.warn("COD Settlement: Không tìm thấy Hub cho user {}", currentUser.getUsername());
            return ResponseEntity.badRequest().body(
                    createErrorResponse("Không tìm thấy thông tin Hub. Bạn cần được gán vào một Hub."));
        }

        List<ShipperCodSummaryDTO> shippers = codSettlementService.getShippersWithPendingCod(hubId);

        // Lấy tổng tiền đã quyết toán hôm nay
        java.math.BigDecimal settledToday = codSettlementRepository.sumSettledTodayByHubId(hubId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", shippers);
        response.put("count", shippers.size());
        response.put("hubId", hubId);
        response.put("settledToday", settledToday);

        return ResponseEntity.ok(response);
    }

    /**
     * API lấy chi tiết COD của một shipper
     * GET /api/manager/cod/shipper/{shipperId}
     */
    @GetMapping("/shipper/{shipperId}")
    public ResponseEntity<?> getShipperCodDetail(@PathVariable Long shipperId) {
        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        ShipperCodSummaryDTO detail = codSettlementService.getShipperCodDetail(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", detail);

        return ResponseEntity.ok(response);
    }

    /**
     * API thực hiện quyết toán COD cho shipper
     * POST /api/manager/cod/settle
     */
    @PostMapping("/settle")
    public ResponseEntity<?> settleCod(@RequestBody CodSettlementRequest request) {
        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            log.warn("COD Settle: Chưa đăng nhập");
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        // Lấy tên manager
        String managerName = currentUser.getFullName();
        if (managerName == null || managerName.isEmpty()) {
            managerName = currentUser.getUsername();
        }

        CodSettlementResultDTO result = codSettlementService.settleCod(request, managerName);

        Map<String, Object> response = new HashMap<>();
        response.put("success", result.isSuccess());
        response.put("message", result.getMessage());
        response.put("data", result);

        if (result.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * API lấy lịch sử quyết toán COD của một shipper
     * GET /api/manager/cod/history/{shipperId}
     */
    @GetMapping("/history/{shipperId}")
    public ResponseEntity<?> getSettlementHistory(@PathVariable Long shipperId) {
        // Kiểm tra đăng nhập
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("Vui lòng đăng nhập"));
        }

        ShipperCodSummaryDTO history = codSettlementService.getSettlementHistory(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", history);

        return ResponseEntity.ok(response);
    }

    /**
     * Lấy User từ SecurityContext
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        Object principal = authentication.getPrincipal();
        if (principal instanceof UserDetails) {
            String email = ((UserDetails) principal).getUsername();
            return userRepository.findByEmail(email).orElse(null);
        }

        return null;
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
