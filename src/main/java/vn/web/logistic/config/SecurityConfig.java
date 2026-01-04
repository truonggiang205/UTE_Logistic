package vn.web.logistic.config;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
// Kích hoạt tính năng phân quyền trực tiếp trên method (Controller/Service)
// Ví dụ: @PreAuthorize("hasRole('ADMIN')")
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Value("${app.cors.allowed-origins:http://localhost:9090,http://localhost:3000}")
    private String allowedOrigins;

    // 1. Bean mã hóa mật khẩu
    // Sử dụng BCrypt để băm mật khẩu (hash) trước khi lưu vào DB hoặc khi so sánh
    // đăng nhập
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 2. Bean quản lý xác thực
    // Cần thiết để Spring Security thực hiện việc kiểm tra user/pass
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    /**
     * PHẦN QUAN TRỌNG 1: Cấu hình bảo mật cho API (Mobile/Frontend riêng)
     * @Order(1): Đánh dấu bộ lọc này chạy TRƯỚC bộ lọc Web
     */
    @Bean
    @Order(1)
    public SecurityFilterChain apiFilterChain(HttpSecurity http) throws Exception {
        http
                // Chỉ áp dụng cấu hình này cho các URL bắt đầu bằng /api/
                .securityMatcher("/api/**")

                // Cấu hình CORS (cho phép frontend từ domain khác gọi vào)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))

                // Tắt CSRF vì API dùng Token, không dùng Session Cookie nên không sợ lỗi này
                .csrf(csrf -> csrf.disable())

                // API: hỗ trợ cả JWT (stateless) lẫn session (JSP pages gọi AJAX /api/**)
                // Nếu để STATELESS thì SecurityContext không đọc từ HttpSession => các page sẽ bị 401 khi fetch /api/**
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))

                // Phân quyền chi tiết cho từng API URL
                .authorizeHttpRequests(auth -> auth
                        // Cho phép truy cập tự do (login, register API)
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/public/**").permitAll()
                        // VNPAY Payment APIs - PHẢI permitAll để VNPAY callback
                        .requestMatchers("/api/payment/**").permitAll()

                        // Các API cần quyền cụ thể
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/staff/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/api/shipper/**").hasAnyRole("ADMIN", "SHIPPER")
                        .requestMatchers("/api/customer/**").hasAnyRole("ADMIN", "CUSTOMER")

                        // Tất cả request API còn lại phải có Token hợp lệ
                        .anyRequest().authenticated())

                // QUAN TRỌNG: Chèn filter kiểm tra JWT vào trước filter đăng nhập mặc định
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * PHẦN QUAN TRỌNG 2: Cấu hình bảo mật cho Web truyền thống (JSP/Thymeleaf)
     * @Order(2): Chạy SAU khi check API xong. Nếu URL không phải /api/** thì sẽ rơi
     * vào đây.
     */
    @Bean
    @Order(2)
    public SecurityFilterChain webFilterChain(HttpSecurity http) throws Exception {
        http
                // Áp dụng cho tất cả các URL còn lại
                .securityMatcher("/**")
                .csrf(csrf -> csrf.disable()) // Tắt CSRF (trong thực tế Web nên bật cái này, nhưng demo thì tắt cho dễ)

                .authorizeHttpRequests(auth -> auth
                        // Cho phép tải tài nguyên tĩnh (CSS, JS, ảnh) không cần đăng nhập
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/vendor/**", "/fonts/**", "/webjars/**")
                        .permitAll()
                        .requestMatchers("/WEB-INF/**").permitAll()

                        // Các trang Public
                        .requestMatchers("/", "/home", "/login", "/register", "/error").permitAll()
                        .requestMatchers("/forgot-password", "/reset-password").permitAll()
                        // VNPAY Payment return page - PHẢI permitAll để VNPAY redirect về
                        .requestMatchers("/payment/**").permitAll()

                        // Phân quyền truy cập trang theo Role
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/staff/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/manager/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/shipper/**").hasAnyRole("ADMIN", "SHIPPER")
                        .requestMatchers("/customer/**").hasAnyRole("ADMIN", "CUSTOMER")

                        // Các trang khác bắt buộc phải đăng nhập
                        .anyRequest().authenticated())

                // Cấu hình Form Login (Giao diện đăng nhập)
                .formLogin(form -> form
                        .loginPage("/login") // URL trang login custom của bạn
                        .loginProcessingUrl("/do-login") // URL action trong thẻ <form> để submit username/password
                        .usernameParameter("email") // Tên field input email trong form
                        .passwordParameter("password") // Tên field input password trong form
                        .defaultSuccessUrl("/login-success", true) // Chuyển hướng sau khi login thành công
                        .failureUrl("/login?error=true") // Chuyển hướng khi login sai
                        .permitAll())

                // Cấu hình Đăng xuất
                .logout(logout -> logout
                        .logoutUrl("/logout") // URL để gọi logout
                        .logoutSuccessUrl("/login?logout=true") // Chuyển hướng sau khi logout
                        .invalidateHttpSession(true) // Hủy session
                        .deleteCookies("JSESSIONID") // Xóa cookie
                        .permitAll())

                // Xử lý khi user cố truy cập trang không đủ quyền (403 Forbidden)
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/access-denied"));

        return http.build();
    }

    /**
     * Cấu hình CORS: Cho phép ai được gọi API của server này?
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Allowed origins cấu hình qua application.properties (comma-separated)
        List<String> origins = Arrays.stream(allowedOrigins.split(","))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .collect(Collectors.toList());
        configuration.setAllowedOrigins(origins);

        // Cho phép các method HTTP
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));

        // Cho phép gửi kèm mọi header
        configuration.setAllowedHeaders(Arrays.asList("*"));

        // Cho phép client đọc được header Authorization (chứa Token) trả về
        configuration.setExposedHeaders(Arrays.asList("Authorization"));

        // API JWT thường không cần cookie; để true có thể gây conflict nếu origins='*'
        configuration.setAllowCredentials(false);
        configuration.setMaxAge(3600L); // Cache cấu hình này trong 1 giờ

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}