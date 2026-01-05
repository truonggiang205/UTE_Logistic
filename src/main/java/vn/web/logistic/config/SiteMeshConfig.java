package vn.web.logistic.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> registration = new FilterRegistrationBean<>();

        registration.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                // 1. Loại trừ các đường dẫn không cần trang trí (Phải đặt trên cùng)
                builder.addExcludedPath("/api/*")
                       .addExcludedPath("/assets/*")
                       .addExcludedPath("/static/*")
                       .addExcludedPath("/js/*")    // Loại trừ để file register.js chạy chuẩn
                       .addExcludedPath("/css/*")
                       .addExcludedPath("/images/*")
                       .addExcludedPath("/auth/request-otp") // Không bọc layout vào kết quả trả về của OTP
                       .addExcludedPath("/auth/verify-otp")
                       .addExcludedPath("/payment-success*")
                       .addExcludedPath("/payment-failure*")
                       .addExcludedPath("/api/payment/vnpay-return*")
                       .addExcludedPath("/error");

                builder.addDecoratorPath("/customer/*", "/customer-layout.jsp")
                       .addDecoratorPath("/*", "/main-layout.jsp");
            }
        });

        registration.addUrlPatterns("/*");
        registration.setName("sitemesh3");
        registration.setOrder(1); // Ưu tiên chạy sớm để bao bọc các filter khác
        return registration;
    }
}