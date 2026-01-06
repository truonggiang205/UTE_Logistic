package vn.web.logistic.controller.customer;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaymentResultController {

    @GetMapping("/payment-success")
    public String paymentSuccess(HttpServletRequest request, Model model) {
        // Chuyển đổi số tiền từ xu sang VNĐ (VNPay x100)
        long amount = Long.parseLong(request.getParameter("vnp_Amount")) / 100;

        model.addAttribute("orderId", request.getParameter("vnp_TxnRef"));
        model.addAttribute("amount", amount);
        model.addAttribute("bankCode", request.getParameter("vnp_BankCode"));
        model.addAttribute("payDate", formatVnpayDate(request.getParameter("vnp_PayDate")));
        return "customer/payment-success";
    }

    @GetMapping("/payment-failure")
    public String paymentFailure(HttpServletRequest request, Model model) {
        model.addAttribute("orderId", request.getParameter("vnp_TxnRef"));
        model.addAttribute("responseCode", request.getParameter("vnp_ResponseCode"));
        return "customer/payment-failure";
    }

    // Helper: Định dạng lại chuỗi ngày của VNPay (yyyyMMddHHmmss -> dd/MM/yyyy
    // HH:mm:ss)
    private String formatVnpayDate(String raw) {
        if (raw == null || raw.length() < 14)
            return raw;
        return String.format("%s/%s/%s %s:%s:%s",
                raw.substring(6, 8), raw.substring(4, 6), raw.substring(0, 4),
                raw.substring(8, 10), raw.substring(10, 12), raw.substring(12, 14));
    }
}