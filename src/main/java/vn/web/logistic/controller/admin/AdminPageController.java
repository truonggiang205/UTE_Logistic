package vn.web.logistic.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminPageController {

    @GetMapping("/dashboard")
    public String viewDashboard() {
        // Trả về file: /WEB-INF/views/admin/dashboard.jsp
        return "admin/dashboard";
    }

    @GetMapping("/service-type-config")
    public String viewServiceTypeConfig() {
        // Trả về file: /WEB-INF/views/admin/service-type-config.jsp
        return "admin/service-type-config";
    }

    @GetMapping("/transactions-reconciliation")
    public String viewTransactionsReconciliation() {
        // Trả về file: /WEB-INF/views/admin/reconciliation_vnpay.jsp
        return "admin/reconciliation_vnpay";
    }

    @GetMapping("/cod-management")
    public String viewCodManagement() {
        // Trả về file: /WEB-INF/views/admin/cod-management.jsp
        return "admin/cod-management";
    }

    @GetMapping("/system-monitoring")
    public String viewSystemMonitoring() {
        // Trả về file: /WEB-INF/views/admin/system-logs.jsp
        return "admin/system-logs";
    }

    @GetMapping("/risk-alerts")
    public String viewRiskAlerts() {
        // Trả về file: /WEB-INF/views/admin/risk-alerts.jsp
        return "admin/risk-alerts";
    }

    @GetMapping("/export-reports")
    public String viewReports() {
        // Trả về file: /WEB-INF/views/admin/reports.jsp
        return "admin/reports";
    }
}