package vn.web.logistic.controller.manager;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller để render các trang JSP cho Manager
 */
@Controller
@RequestMapping("/manager")
public class ManagerPageController {

    @GetMapping("/dashboard")
    public String viewDashboard() {
        // Trả về file: /WEB-INF/views/manager/dashboard.jsp
        return "manager/dashboard";
    }

    @GetMapping("/tracking")
    public String viewTracking() {
        // Trả về file: /WEB-INF/views/manager/tracking.jsp
        return "manager/tracking";
    }

    @GetMapping("/inbound/scan")
    public String viewInboundScan() {
        return "manager/inbound-scan";
    }

    @GetMapping("/inbound/drop-off")
    public String viewInboundDropOff() {
        return "manager/inbound-dropoff";
    }

    @GetMapping("/outbound/consolidate")
    public String viewOutboundConsolidate() {
        return "manager/outbound-consolidate";
    }

    @GetMapping("/outbound/trip-planning")
    public String viewOutboundTripPlanning() {
        return "manager/outbound-trip-planning";
    }

    @GetMapping("/outbound/gate-out")
    public String viewOutboundGateOut() {
        return "manager/outbound-gate-out";
    }
}
