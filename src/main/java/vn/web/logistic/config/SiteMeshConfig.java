package vn.web.logistic.config;

import java.util.EnumSet;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import jakarta.servlet.DispatcherType;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> registration = new FilterRegistrationBean<>();

        registration.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                // 1. Loại bỏ các đường dẫn API và Tài nguyên tĩnh
                // Dùng /** để chặn toàn bộ các thư mục con, tránh việc CSS/JS không load được
                builder.addExcludedPath("/api/**");
                builder.addExcludedPath("/static/**");
                builder.addExcludedPath("/css/**");
                builder.addExcludedPath("/js/**");
                builder.addExcludedPath("/images/**");
                builder.addExcludedPath("/uploads/**");

                // 2. Loại bỏ các trang xác thực (Login/Register thường có giao diện riêng,
                // không dùng chung decorator)
                builder.addExcludedPath("/auth/**");
                builder.addExcludedPath("/login**");
                builder.addExcludedPath("/register**");

                // 3. Cấu hình Decorator cho Admin (Dashboard, Quản lý,..)
                builder.addDecoratorPath("/admin", "admin-layout.jsp");
                builder.addDecoratorPath("/admin/**", "admin-layout.jsp");

                // 4. Cấu hình Decorator cho Shipper
                builder.addDecoratorPath("/shipper", "shipper-layout.jsp");
                builder.addDecoratorPath("/shipper/**", "shipper-layout.jsp");

                // 5. Cấu hình Decorator cho phía người dùng (Trang chủ, Tra cứu đơn hàng...)
                // "/**" sẽ khớp với tất cả các đường dẫn còn lại
                builder.addDecoratorPath("/**", "admin-layout.jsp");
            }
        });

        // 5. Thiết lập phạm vi hoạt động của Filter
        registration.addUrlPatterns("/*");
        registration.setDispatcherTypes(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD));

        registration.setName("sitemesh3");
        registration.setOrder(1); // Chạy đầu tiên để bao bọc các filter khác

        return registration;
    }
}