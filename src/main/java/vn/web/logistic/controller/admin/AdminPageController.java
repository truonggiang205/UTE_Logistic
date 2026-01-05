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

    // ==================== Nhân sự & Quyền ====================

    @GetMapping("/staff-accounts")
    public String viewStaffAccounts() {
        return "admin/staff-accounts";
    }

    @GetMapping("/role-management")
    public String viewRoleManagement() {
        return "admin/role-management";
    }

    @GetMapping("/notifications")
    public String viewNotifications() {
        return "admin/notifications";
    }

    @GetMapping("/customer-management")
    public String viewCustomerManagement() {
        return "admin/customer-management";
    }

    // ==================== Mạng lưới bưu cục ====================

    @GetMapping("/hub-management")
    public String viewHubManagement() {
        // Trả về file: /WEB-INF/views/admin/hub-management.jsp
        return "admin/hub-management";
    }

    @GetMapping("/route-management")
    public String viewRouteManagement() {
        // Trả về file: /WEB-INF/views/admin/route-management.jsp
        return "admin/route-management";
    }

    // ==================== Vận tải & Trung chuyển ====================

    @GetMapping("/vehicle-management")
    public String viewVehicleManagement() {
        // Trả về file: /WEB-INF/views/admin/vehicle-management.jsp
        return "admin/vehicle-management";
    }

    @GetMapping("/driver-management")
    public String viewDriverManagement() {
        // Trả về file: /WEB-INF/views/admin/driver-management.jsp
        return "admin/driver-management";
    }

    @GetMapping("/trip-monitor")
    public String viewTripMonitor() {
        // Trả về file: /WEB-INF/views/admin/trip-monitor.jsp
        return "admin/trip-monitor";
    }

    @GetMapping("/container-management")
    public String viewContainerManagement() {
        // Trả về file: /WEB-INF/views/admin/container-management.jsp
        return "admin/container-management";
    }

    // ==================== Cấu hình chung ====================

    @GetMapping("/order-status-config")
    public String viewOrderStatusConfig() {
        return "admin/order-status-config";
    }
}