package vn.web.logistic.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import jakarta.servlet.DispatcherType;
import java.util.EnumSet;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> registration = new FilterRegistrationBean<>();

        registration.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {

                // -------------------------------------------------------------
                // 1. LOẠI TRỪ (EXCLUDE): Các file không cần giao diện
                // -------------------------------------------------------------
                builder.addExcludedPath("/static/**");
                builder.addExcludedPath("/resources/**");
                builder.addExcludedPath("/css/**");
                builder.addExcludedPath("/js/**");
                builder.addExcludedPath("/images/**");
                builder.addExcludedPath("/vendor/**");
                builder.addExcludedPath("/api/**"); // API trả về JSON
                builder.addExcludedPath("/login**"); // Trang Login riêng
                builder.addExcludedPath("/register**"); // Trang Register riêng

                // -------------------------------------------------------------
                // 2. KHU VỰC MANAGER (Trưởng bưu cục)
                // -------------------------------------------------------------
                // Hễ URL bắt đầu bằng /manager/ -> dùng manager-layout.jsp
                builder.addDecoratorPath("/manager/**", "/manager-layout.jsp");

                // -------------------------------------------------------------
                // 3. KHU VỰC ADMIN (Quản trị hệ thống cấp cao)
                // -------------------------------------------------------------
                // Hễ URL bắt đầu bằng /admin/ -> dùng admin-layout.jsp
                builder.addDecoratorPath("/admin/**", "/admin-layout.jsp");

                // -------------------------------------------------------------
                // 4. KHU VỰC SHIPPER / STAFF
                // -------------------------------------------------------------
                // builder.addDecoratorPath("/shipper/**",
                // "/shipper-layout.jsp");
            }
        });

        registration.addUrlPatterns("/*");
        registration.setDispatcherTypes(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD));
        registration.setName("sitemesh3");
        registration.setOrder(1);

        return registration;
    }
}