package vn.web.logistic.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * Cấu hình Async cho ứng dụng.
 * Enable async processing (gửi email background)
 */
@Configuration
@EnableAsync
public class AsyncConfig {
    // Spring Boot tự động cung cấp TaskExecutor mặc định
    // Nếu cần tùy chỉnh thread pool, có thể thêm @Bean ThreadPoolTaskExecutor
}
