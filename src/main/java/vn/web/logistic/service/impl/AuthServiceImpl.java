package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.config.JwtTokenProvider;
import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.response.AuthResponse;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.AuthService;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    @Transactional
    public AuthResponse login(LoginRequest loginRequest) {
        try {
            // Authenticate user với email
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.getEmail(),
                            loginRequest.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Generate JWT token
            String jwt = tokenProvider.generateToken(authentication);

            // Get user details bằng email
            User user = userRepository.findByEmail(loginRequest.getEmail())
                    .orElseThrow(() -> new BadCredentialsException("Không tìm thấy người dùng"));

            // Update last login
            user.setLastLoginAt(LocalDateTime.now());
            userRepository.save(user);

            // Get roles
            Set<String> roles = authentication.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .map(role -> role.replace("ROLE_", ""))
                    .collect(Collectors.toSet());

            return AuthResponse.builder()
                    .token(jwt)
                    .type("Bearer")
                    .userId(user.getUserId())
                    .username(user.getUsername())
                    .fullName(user.getFullName())
                    .email(user.getEmail())
                    .roles(roles)
                    .build();

        } catch (BadCredentialsException e) {
            throw new BadCredentialsException("Email hoặc mật khẩu không đúng");
        }
    }

    @Override
    public void logout(String token) {
        // Clear security context
        SecurityContextHolder.clearContext();
    }
}
