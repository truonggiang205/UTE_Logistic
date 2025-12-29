package vn.web.logistic.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RoleHomeController {

    @GetMapping("/admin")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    public String adminHome() {
        return "admin/index";
    }

    @GetMapping("/staff")
    @PreAuthorize("hasRole('STAFF')")
    public String staffHome() {
        return "staff/index";
    }

    @GetMapping("/shipper")
    @PreAuthorize("hasRole('SHIPPER')")
    public String shipperHome() {
        return "shipper/index";
    }

    @GetMapping("/customer")
    @PreAuthorize("hasRole('CUSTOMER')")
    public String customerHome() {
        return "customer/index";
    }
}
