package vn.web.logistic.controller.customer;

import org.springframework.web.bind.annotation.GetMapping;

/**
 * DEPRECATED: Conflicts with HomeController at "/" and "/access-denied"
 */
// @Controller // DISABLED - conflicts with HomeController
public class PublicController {

    @GetMapping("/")
    public String showHomePage(org.springframework.security.core.Authentication auth) {
        return "home";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "error/403";
    }
}