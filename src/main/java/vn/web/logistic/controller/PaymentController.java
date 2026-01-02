package vn.web.logistic.controller;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.service.VnpayService;

/**
 * PaymentController - API endpoints cho thanh toán VNPAY
 */
@RestController
@RequestMapping("/api/payment/vnpay")
public class PaymentController {

    private static final Logger logger = LoggerFactory.getLogger(PaymentController.class);

    @Autowired
    private VnpayService vnpayService;

    /**
     * Tạo URL thanh toán VNPAY
     * * @param requestId ID của đơn hàng
     * 
     * @param amount  Số tiền thanh toán (VND)
     * @param request HttpServletRequest
     * @return URL redirect đến VNPAY + vnpTxnRef để polling
     */
    @GetMapping("/create-payment-url")
    public ResponseEntity<?> createPaymentUrl(
            @RequestParam("requestId") Long requestId,
            @RequestParam("amount") Long amount,
            HttpServletRequest request) {
        try {
            // 1. Validate amount
            if (amount == null || amount < 5000) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Số tiền thanh toán tối thiểu là 5,000 VND");
                return ResponseEntity.badRequest().body(response);
            }

            // 2. Gọi service tạo URL.
            // Chúng ta truyền "127.0.0.1" vì Service đã tự gán cứng bên trong rồi.
            logger.info("Yêu cầu tạo link VNPAY cho đơn hàng: {}, số tiền: {}", requestId, amount);
            Map<String, String> paymentData = vnpayService.createPaymentUrl(requestId, amount, "127.0.0.1");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("paymentUrl", paymentData.get("paymentUrl"));
            response.put("vnpTxnRef", paymentData.get("vnpTxnRef")); // Dùng để polling trạng thái
            response.put("message", "Tạo URL thanh toán thành công");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Lỗi khi tạo URL VNPAY", e);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * VNPAY IPN (Instant Payment Notification)
     * Nhận thông báo tự động từ Server VNPAY khi có biến động giao dịch
     */
    @GetMapping("/ipn")
    public ResponseEntity<?> vnpayIpn(HttpServletRequest request) {
        try {
            Map<String, String> params = extractParams(request);
            logger.info("Nhận IPN từ VNPAY: {}", params);

            Map<String, String> result = vnpayService.processIpn(params);
            // VNPAY yêu cầu trả về format JSON đặc thù
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            logger.error("Lỗi xử lý IPN", e);
            Map<String, String> result = new HashMap<>();
            result.put("RspCode", "99");
            result.put("Message", "Unknown error");
            return ResponseEntity.ok(result);
        }
    }

    /**
     * Kiểm tra trạng thái thanh toán (Polling API)
     * Frontend gọi API này mỗi 3s để biết khách đã quét mã thành công chưa
     */
    @GetMapping("/check-status")
    public ResponseEntity<?> checkPaymentStatus(@RequestParam("vnpTxnRef") String vnpTxnRef) {
        try {
            VnpayTransaction transaction = vnpayService.findByVnpTxnRef(vnpTxnRef);

            Map<String, Object> response = new HashMap<>();
            if (transaction != null) {
                response.put("success", true);
                response.put("vnpTxnRef", transaction.getVnpTxnRef());
                // Trả về PENDING, SUCCESS hoặc FAILED
                response.put("paymentStatus", transaction.getPaymentStatus().name().toLowerCase());
                response.put("amount", transaction.getAmount());
                response.put("requestId", transaction.getRequest().getRequestId());
            } else {
                response.put("success", false);
                response.put("message", "Giao dịch không tồn tại");
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Lỗi check status", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Trích xuất tham số từ HttpServletRequest thành Map
     */
    private Map<String, String> extractParams(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            params.put(paramName, request.getParameter(paramName));
        }
        return params;
    }
}