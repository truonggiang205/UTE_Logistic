package vn.web.logistic.controller.manager;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.inbound.DropOffRequest;
import vn.web.logistic.dto.request.inbound.ScanInRequest;
import vn.web.logistic.dto.response.inbound.DropOffResponse;
import vn.web.logistic.dto.response.inbound.ScanInResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.service.InboundService;

import java.util.HashMap;
import java.util.Map;

/**
 * REST Controller cho phân hệ NHẬP KHO (INBOUND) - Manager Portal
 * Xử lý các API liên quan đến việc nhập hàng vào kho
 * 
 * Endpoints:
 * - POST /api/manager/inbound/scan-in : Quét nhập kho
 * - POST /api/manager/inbound/drop-off : Tạo đơn tại quầy
 */
@Slf4j
@RestController
@RequestMapping("/api/manager/inbound")
@RequiredArgsConstructor
public class InboundController {

    private final InboundService inboundService;

    // ===================================================================
    // CHỨC NĂNG 1: QUÉT NHẬP (SCAN IN)
    // ===================================================================

    /**
     * API Quét nhập kho
     * Nhân viên kho quét mã đơn hàng để xác nhận hàng đã về kho hiện tại
     *
     * @param request Thông tin quét nhập (danh sách mã đơn, kho hiện tại, tripId
     *                optional)
     * @param session HttpSession để lấy thông tin user đăng nhập
     * @return ScanInResponse Kết quả quét nhập với chi tiết từng đơn
     */
    @PostMapping("/scan-in")
    public ResponseEntity<?> scanIn(
            @Valid @RequestBody ScanInRequest request,
            HttpSession session) {

        log.info("=== API QUÉT NHẬP KHO ===");
        log.info("Request: {} đơn, Hub: {}, Trip: {}",
                request.getRequestIds().size(),
                request.getCurrentHubId(),
                request.getTripId());

        try {
            // Lấy user từ session
            Long actorId = getActorIdFromSession(session);

            // Gọi service xử lý
            ScanInResponse response = inboundService.scanIn(request, actorId);

            log.info("Kết quả: Thành công {}/{} đơn", response.getSuccessCount(), response.getTotalScanned());

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            log.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));

        } catch (Exception e) {
            log.error("Lỗi khi quét nhập kho: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // CHỨC NĂNG 2: TẠO ĐƠN TẠI QUẦY (DROP-OFF)
    // ===================================================================

    /**
     * API Tạo đơn tại quầy
     * Khách mang hàng ra bưu cục gửi trực tiếp
     *
     * @param request Thông tin tạo đơn (sender, receiver, weight, serviceType, ...)
     * @param session HttpSession để lấy thông tin user đăng nhập
     * @return DropOffResponse Thông tin đơn hàng vừa tạo với chi tiết phí
     */
    @PostMapping("/drop-off")
    public ResponseEntity<?> createDropOffOrder(
            @Valid @RequestBody DropOffRequest request,
            HttpSession session) {

        log.info("=== API TẠO ĐƠN TẠI QUẦY ===");
        log.info("Request - Sender: {}, Receiver: {}, Weight: {} kg, ServiceType: {}",
                request.getSenderInfo().getContactPhone(),
                request.getReceiverInfo().getContactPhone(),
                request.getWeight(),
                request.getServiceTypeId());

        try {
            // Lấy user từ session
            Long actorId = getActorIdFromSession(session);

            // Gọi service xử lý
            DropOffResponse response = inboundService.createDropOffOrder(request, actorId);

            log.info("Đã tạo đơn thành công: {} - Tổng tiền: {}",
                    response.getRequestId(),
                    response.getFeeDetails().getTotalPrice());

            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (IllegalArgumentException e) {
            log.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));

        } catch (Exception e) {
            log.error("Lỗi khi tạo đơn tại quầy: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Lỗi hệ thống: " + e.getMessage()));
        }
    }

    // ===================================================================
    // HELPER METHODS
    // ===================================================================

    /**
     * Lấy Actor ID từ session
     * Nếu không có user trong session -> trả về ID mặc định (1) cho testing
     */
    private Long getActorIdFromSession(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user.getUserId();
        }

        // Fallback cho testing - trong production cần throw exception
        log.warn("Không tìm thấy user trong session, sử dụng ID mặc định = 1");
        return 1L;
    }

    /**
     * Tạo response error chuẩn
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        error.put("timestamp", System.currentTimeMillis());
        return error;
    }
}
