package vn.web.logistic.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;

/**
 * Component tự động hash password cho các user có password chưa được hash.
 * Chạy khi ứng dụng khởi động.
 * 
 * Password để đăng nhập là FULL string, ví dụ: "seed:admin123"
 */
@Component
@Slf4j
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        log.info("=== DataInitializer: Kiểm tra và hash password cho users ===");

        int updatedCount = 0;

        for (User user : userRepository.findAll()) {
            String currentHash = user.getPasswordHash();

            // Kiểm tra nếu password có format "seed:xxx" (chưa hash)
            if (currentHash != null && currentHash.startsWith("seed:")) {
                // Hash full password (giữ nguyên giá trị gốc)
                String hashedPassword = passwordEncoder.encode(currentHash);
                user.setPasswordHash(hashedPassword);
                userRepository.save(user);

                log.info("  ✓ Đã hash password cho user: {} ({}) - password: {}",
                        user.getUsername(), user.getEmail(), currentHash);
                updatedCount++;
            }
        }

        if (updatedCount > 0) {
            log.info("=== Đã cập nhật password cho {} user(s) ===", updatedCount);
        } else {
            log.info("=== Tất cả user đã có password được hash. Không cần cập nhật. ===");
        }
    }
}
