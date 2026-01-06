package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import vn.web.logistic.dto.response.manager.OrderTrackingResponse;
import vn.web.logistic.service.ManagerDashboardService;

@Controller
@RequestMapping("/admin/risk-alerts")
@RequiredArgsConstructor
public class AdminRiskAlertDetailController {

    private final ManagerDashboardService managerDashboardService;

    @GetMapping("/{requestId}")
    public String viewRiskAlertOrderDetail(@PathVariable Long requestId, Model model) {
        OrderTrackingResponse order = managerDashboardService.getOrderDetail(requestId);
        if (order == null) {
            model.addAttribute("errorMessage", "Không tìm thấy đơn hàng với mã: " + requestId);
            model.addAttribute("requestId", requestId);
            return "admin/risk-alert-detail";
        }

        model.addAttribute("order", order);
        return "admin/risk-alert-detail";
    }
}
