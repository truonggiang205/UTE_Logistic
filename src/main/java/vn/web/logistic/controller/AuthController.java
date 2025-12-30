package vn.web.logistic.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.config.JwtTokenProvider;
import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.response.AuthResponse;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.getEmail(),
                            loginRequest.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);

            String jwt = jwtTokenProvider.generateToken(authentication);
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            return ResponseEntity.ok(AuthResponse.builder()
                    .success(true)
                    .message("Đăng nhập thành công")
                    .token(jwt)
                    .email(userDetails.getUsername())
                    .roles(userDetails.getAuthorities().stream()
                            .map(a -> a.getAuthority())
                            .toList())
                    .build());

        } catch (BadCredentialsException e) {
            return ResponseEntity.badRequest().body(AuthResponse.builder()
                    .success(false)
                    .message("Email hoặc mật khẩu không đúng")
                    .build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(AuthResponse.builder()
                    .success(false)
                    .message("Đăng nhập thất bại: " + e.getMessage())
                    .build());
        }
    }
}
