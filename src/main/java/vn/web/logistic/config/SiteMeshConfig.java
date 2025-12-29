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
                // Exclude các đường dẫn không cần decorator (phải đặt trước)
                builder.addExcludedPath("/api/*");
                builder.addExcludedPath("/assets/*");
                builder.addExcludedPath("/static/*");
                builder.addExcludedPath("/uploads/*");
                builder.addExcludedPath("/commons/*");
                builder.addExcludedPath("/auth/*"); // Exclude login, register, forgot-password

                // Mapping decorators - SiteMesh sẽ tìm trong /WEB-INF/decorators/
                builder.addDecoratorPath("/admin", "/admin.jsp");
                builder.addDecoratorPath("/admin/*", "/admin.jsp");
                builder.addDecoratorPath("/*", "/web.jsp");
            }
        });
        registration.addUrlPatterns("/*");
        registration.setName("sitemesh3");
        registration.setOrder(1);
        return registration;
    }
}