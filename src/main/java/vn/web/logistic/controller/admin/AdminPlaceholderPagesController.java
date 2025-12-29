package vn.web.logistic.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
public class AdminPlaceholderPagesController {

    @GetMapping("/finance/services")
    public String financeServices() {
        return "admin/finance/services";
    }

    @GetMapping("/finance/vnpay")
    public String financeVnpay() {
        return "admin/finance/vnpay";
    }

    @GetMapping("/finance/cod")
    public String financeCod() {
        return "admin/finance/cod";
    }

    @GetMapping("/broadcast-email")
    public String broadcastEmail() {
        return "admin/broadcast-email";
    }

    @GetMapping("/monitoring/center")
    public String monitoringCenter() {
        return "admin/monitoring/center";
    }

    @GetMapping("/monitoring/risk-alerts")
    public String monitoringRiskAlerts() {
        return "admin/monitoring/risk-alerts";
    }

    @GetMapping("/reporting")
    public String reporting() {
        return "admin/reporting";
    }
}
