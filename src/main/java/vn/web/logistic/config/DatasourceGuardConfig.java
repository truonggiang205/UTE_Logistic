package vn.web.logistic.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class DatasourceGuardConfig {

    @Bean
    public Object datasourceEnvGuard(Environment env) {
        String url = env.getProperty("spring.datasource.url", "");
        String username = env.getProperty("spring.datasource.username", "");
        String password = env.getProperty("spring.datasource.password");

        if (url.startsWith("jdbc:sqlserver:") && (password == null || password.isBlank())) {
            throw new IllegalStateException(
                "Missing database password. Set environment variable DB_PASS (and optionally DB_USER) before running. "
                    + "Example (PowerShell): $env:DB_USER='logistic_app'; $env:DB_PASS='StrongPass123'; .\\mvnw spring-boot:run. "
                    + "Current username='" + username + "'."
            );
        }

        return new Object();
    }
}
