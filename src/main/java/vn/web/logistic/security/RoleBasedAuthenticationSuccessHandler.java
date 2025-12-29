package vn.web.logistic.security;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Set;

import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.repository.UserRepository;

@Component
@RequiredArgsConstructor
public class RoleBasedAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final UserRepository userRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        // Update last login
        userRepository.findByUsername(authentication.getName()).ifPresent(u -> {
            u.setLastLoginAt(LocalDateTime.now());
            u.setUpdatedAt(LocalDateTime.now());
            userRepository.save(u);
        });

        Set<String> roles = authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(java.util.stream.Collectors.toSet());

        if (roles.contains("ROLE_ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        if (roles.contains("ROLE_MANAGER")) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }
        if (roles.contains("ROLE_STAFF")) {
            response.sendRedirect(request.getContextPath() + "/staff");
            return;
        }
        if (roles.contains("ROLE_SHIPPER")) {
            response.sendRedirect(request.getContextPath() + "/shipper");
            return;
        }
        if (roles.contains("ROLE_CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/customer");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
}
