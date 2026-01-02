package vn.web.logistic.controller;

import java.time.format.DateTimeFormatter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.service.VnpayService;

/**
 * PaymentPageController - Xử lý các trang thanh toán (JSP views)
 */
@Controller
@RequestMapping("/payment")
public class PaymentPageController {

    private static final Logger logger = LoggerFactory.getLogger(PaymentPageController.class);

    @Autowired
    private VnpayService vnpayService;

    /**
     * Trang kết quả thanh toán VNPAY
     * User được redirect về đây sau khi thanh toán
     */
    @GetMapping("/vnpay/return")
    public String vnpayReturn(HttpServletRequest request, Model model) {
        try {
            Map<String, String> params = extractParams(request);
            logger.info("VNPAY Return URL params: {}", params);

            VnpayTransaction transaction = vnpayService.processReturnUrl(params);

            if (transaction != null) {
                model.addAttribute("paymentSuccess", "00".equals(transaction.getVnpResponseCode()));
                model.addAttribute("requestId", transaction.getRequest().getRequestId());
                model.addAttribute("vnpTransactionNo", transaction.getVnpTransactionNo());
                model.addAttribute("vnpTxnRef", transaction.getVnpTxnRef());
                model.addAttribute("amount", transaction.getAmount());
                model.addAttribute("vnpResponseCode", transaction.getVnpResponseCode());

                if (transaction.getPaidAt() != null) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
                    model.addAttribute("paymentTime", transaction.getPaidAt().format(formatter));
                } else {
                    model.addAttribute("paymentTime", "N/A");
                }

                if (!"00".equals(transaction.getVnpResponseCode())) {
                    model.addAttribute("errorMessage", getVnpayErrorMessage(transaction.getVnpResponseCode()));
                }
            } else {
                model.addAttribute("paymentSuccess", false);
                model.addAttribute("errorMessage", "Không thể xác thực giao dịch");
                model.addAttribute("requestId", params.get("vnp_TxnRef"));
                model.addAttribute("vnpTransactionNo", params.get("vnp_TransactionNo"));
                model.addAttribute("vnpTxnRef", params.get("vnp_TxnRef"));
                model.addAttribute("amount", 0);
                model.addAttribute("paymentTime", "N/A");
            }

        } catch (Exception e) {
            logger.error("Error processing VNPAY return", e);
            model.addAttribute("paymentSuccess", false);
            model.addAttribute("errorMessage", "Lỗi xử lý kết quả thanh toán: " + e.getMessage());
        }

        return "payment/vnpay-result";
    }

    /**
     * Extract tất cả parameters từ request
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

    /**
     * Lấy message lỗi từ mã response VNPAY
     */
    private String getVnpayErrorMessage(String responseCode) {
        switch (responseCode) {
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking.";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản bị khóa.";
            case "13":
                return "Giao dịch không thành công do: Quý khách nhập sai mật khẩu xác thực (OTP).";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch.";
            case "51":
                return "Giao dịch không thành công do: Tài khoản không đủ số dư để thực hiện giao dịch.";
            case "65":
                return "Giao dịch không thành công do: Tài khoản đã vượt quá hạn mức giao dịch trong ngày.";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì.";
            case "79":
                return "Giao dịch không thành công do: Nhập sai mật khẩu thanh toán quá số lần quy định.";
            case "99":
                return "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi).";
            default:
                return "Giao dịch thất bại. Mã lỗi: " + responseCode;
        }
    }
}
