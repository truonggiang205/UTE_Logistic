package vn.web.logistic.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import vn.web.logistic.security.RoleBasedAuthenticationSuccessHandler;
import vn.web.logistic.security.SeedCompatiblePasswordEncoder;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {
    
    private final RoleBasedAuthenticationSuccessHandler successHandler;
    
    @Autowired
    public SecurityConfig(RoleBasedAuthenticationSuccessHandler successHandler) {
        this.successHandler = successHandler;
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new SeedCompatiblePasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/assets/**", "/static/**", "/commons/**", "/uploads/**").permitAll()
                .requestMatchers("/", "/home", "/error").permitAll()
                .requestMatchers("/auth/**").permitAll()
                .requestMatchers("/admin/**").hasAnyRole("ADMIN", "MANAGER")
                .requestMatchers("/staff/**").hasRole("STAFF")
                .requestMatchers("/shipper/**").hasRole("SHIPPER")
                .requestMatchers("/customer/**").hasRole("CUSTOMER")
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/login")
                .successHandler(successHandler)
                .failureUrl("/auth/login?error")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/auth/login?logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
            )
            .httpBasic(Customizer.withDefaults());
        return http.build();
    }
}