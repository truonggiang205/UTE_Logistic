package vn.web.logistic.controller.customer;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
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