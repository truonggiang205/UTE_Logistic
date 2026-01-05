package vn.web.logistic.controller.manager;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.CodSettlementRequest;
import vn.web.logistic.dto.response.ApiResponse;
import vn.web.logistic.dto.response.manager.CodSettlementResultDTO;
import vn.web.logistic.dto.response.manager.ShipperCodSummaryDTO;
import vn.web.logistic.entity.User;
import vn.web.logistic.service.CodSettlementService;
import vn.web.logistic.service.SecurityContextService;

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
    private final SecurityContextService securityContextService;

    // Lấy danh sách shipper có COD chưa quyết toán trong Hub

    @GetMapping("/pending")
    public ResponseEntity<?> getShippersWithPendingCod() {
        // Lấy user từ SecurityContext
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            log.warn("COD Settlement: Chưa đăng nhập");
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
        }

        // Lấy hub_id
        Long hubId = securityContextService.getCurrentHubId();

        if (hubId == null) {
            log.warn("COD Settlement: Không tìm thấy Hub cho user {}", currentUser.getUsername());
            return ResponseEntity.badRequest().body(
                    ApiResponse.message("Không tìm thấy thông tin Hub. Bạn cần được gán vào một Hub."));
        }

        List<ShipperCodSummaryDTO> shippers = codSettlementService.getShippersWithPendingCod(hubId);

        // Lấy thống kê từ Service (không gọi Repository trực tiếp)
        Map<String, BigDecimal> stats = codSettlementService.getHubStatistics(hubId);

        Map<String, Object> response = new HashMap<>();

        response.put("data", shippers);
        response.put("count", shippers.size());

        response.put("settledToday", stats.get("settledToday"));
        response.put("pendingTotal", stats.get("pendingTotal"));
        response.put("totalSettled", stats.get("totalSettled"));

        return ResponseEntity.ok(response);
    }

    // Lấy danh sách shipper đang giữ tiền COD (pending - chưa nộp về Hub)
    @GetMapping("/pending-hold")
    public ResponseEntity<?> getShippersWithPendingHoldCod() {
        // Lấy user từ SecurityContext
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            log.warn("COD Settlement: Chưa đăng nhập");
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
        }

        // Lấy hub_id
        Long hubId = securityContextService.getCurrentHubId();

        if (hubId == null) {
            log.warn("COD Settlement: Không tìm thấy Hub cho user {}", currentUser.getUsername());
            return ResponseEntity.badRequest().body(
                    ApiResponse.message("Không tìm thấy thông tin Hub. Bạn cần được gán vào một Hub."));
        }

        List<ShipperCodSummaryDTO> shippers = codSettlementService.getShippersWithPendingHoldCod(hubId);

        // Lấy thống kê từ Service
        Map<String, BigDecimal> stats = codSettlementService.getHubStatistics(hubId);

        Map<String, Object> response = new HashMap<>();
        response.put("data", shippers);
        response.put("count", shippers.size());
        response.put("pendingTotal", stats.get("pendingTotal"));

        return ResponseEntity.ok(response);
    }

    // Lấy chi tiết COD pending của một shipper (đang giữ tiền, chưa nộp)
    @GetMapping("/shipper/{shipperId}/pending")
    public ResponseEntity<?> getShipperPendingCodDetail(@PathVariable Long shipperId) {
        // Kiểm tra đăng nhập
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
        }

        ShipperCodSummaryDTO detail = codSettlementService.getShipperPendingCodDetail(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", detail);

        return ResponseEntity.ok(response);
    }

    // Lấy chi tiết COD của một shipper (đã nộp, chờ duyệt)
    @GetMapping("/shipper/{shipperId}")
    public ResponseEntity<?> getShipperCodDetail(@PathVariable Long shipperId) {
        // Kiểm tra đăng nhập
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
        }

        ShipperCodSummaryDTO detail = codSettlementService.getShipperCodDetail(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", detail);

        return ResponseEntity.ok(response);
    }

    // Thực hiện quyết toán COD cho shipper
    @PostMapping("/settle")
    public ResponseEntity<?> settleCod(@RequestBody CodSettlementRequest request) {
        // Kiểm tra đăng nhập
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            log.warn("COD Settle: Chưa đăng nhập");
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
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

    // Lấy lịch sử quyết toán COD của một shipper
    @GetMapping("/history/{shipperId}")
    public ResponseEntity<?> getSettlementHistory(@PathVariable Long shipperId) {
        // Kiểm tra đăng nhập
        User currentUser = securityContextService.getCurrentUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(ApiResponse.message("Vui lòng đăng nhập"));
        }

        ShipperCodSummaryDTO history = codSettlementService.getSettlementHistory(shipperId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", history);

        return ResponseEntity.ok(response);
    }
}
