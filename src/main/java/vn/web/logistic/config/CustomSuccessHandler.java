package vn.web.logistic.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class CustomSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        // Lấy danh sách quyền của người dùng vừa đăng nhập
        String role = authentication.getAuthorities().stream()
                .map(r -> r.getAuthority())
                .findFirst()
                .orElse("");

        // Điều hướng dựa trên quyền thực tế
        if (role.contains("ADMIN")) {
            getRedirectStrategy().sendRedirect(request, response, "/admin/dashboard");
        } else if (role.contains("CUSTOMER")) {
            getRedirectStrategy().sendRedirect(request, response, "/customer/overview");
        } else {
            getRedirectStrategy().sendRedirect(request, response, "/");
        }
    }
}