package vn.web.logistic.config;

import java.util.Arrays;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;


@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
    
    @Autowired
    private CustomSuccessHandler customSuccessHandler;

    /**
     * Security filter cho API endpoints - sử dụng JWT (stateless)
     */
    @Bean
    @Order(1)
    public SecurityFilterChain apiFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/api/**")
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(csrf -> csrf.disable())
                // Cho phép cả JWT và Session
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/public/**").permitAll()
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/staff/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/api/shipper/**").hasAnyRole("ADMIN", "SHIPPER")
                        .requestMatchers("/api/customer/**").hasAnyRole("ADMIN", "CUSTOMER")
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * Security filter cho Web pages - sử dụng Form Login (session-based)
     */
 // SecurityConfig.java

    @Bean
    @Order(2)
    public SecurityFilterChain webFilterChain(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/**")
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
            .authorizeHttpRequests(auth -> {
                // 1. CHO PHÉP FORWARD NỘI BỘ (Rất quan trọng cho JSP và SiteMesh)
                auth.dispatcherTypeMatchers(jakarta.servlet.DispatcherType.FORWARD).permitAll();

                // 2. Tài nguyên tĩnh
                auth.requestMatchers("/css/**", "/js/**", "/images/**", "/fonts/**", "/webjars/**", "/static/**").permitAll();

                // 3. Các trang công cộng và trang LỖI
                auth.requestMatchers(
                    "/auth/login", 
                    "/auth/process-login", 
                    "/", 
                    "/error", 
                    "/favicon.ico",
                    "/access-denied" // Phải permitAll trang này
                ).permitAll();

                // 4. Bảo vệ vùng Dashboard
                auth.requestMatchers("/customer/**").hasRole("CUSTOMER");

                auth.anyRequest().authenticated();
            })
            //ĐỌC JWT TỪ COOKIE
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/process-login")
                .usernameParameter("identifier")
                .passwordParameter("password")
                .successHandler(customSuccessHandler) //
                .failureUrl("/auth/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/")
                .deleteCookies("JWT_TOKEN", "JSESSIONID")
            )
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/access-denied")
            );

        return http.build();
    }

    
    
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:9090", "http://localhost:3000"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setExposedHeaders(Arrays.asList("Authorization"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
    
    //newwwwwwwwwwwwwwwwwwwwwwwwwww
    @Bean
    public HttpFirewall allowDoubleSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        // Cho phép dấu gạch chéo kép để SiteMesh 3 hoạt động ổn định
        firewall.setAllowUrlEncodedDoubleSlash(true);
        return firewall;
    }
}