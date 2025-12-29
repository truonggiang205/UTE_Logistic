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
}