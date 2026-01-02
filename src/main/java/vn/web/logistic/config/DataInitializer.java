package vn.web.logistic.config;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.UserRepository;

/**
 * Component tự động tạo roles và users mặc định nếu DB trống.
 * Chạy khi ứng dụng khởi động.
 */
@Component
@Slf4j
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        log.info("=== DataInitializer: Kiểm tra và khởi tạo dữ liệu ===");

        // 1. Tạo roles nếu chưa có
        createRolesIfNotExist();

        // 2. Tạo hoặc cập nhật demo users (LUÔN LUÔN chạy mỗi lần khởi động)
        ensureDemoUsers();

        log.info("=== DataInitializer: Hoàn tất ===");
    }

    private void createRolesIfNotExist() {
        String[] roleNames = { "ADMIN", "STAFF", "SHIPPER", "CUSTOMER" };
        String[] descriptions = { "System administrator", "Hub staff", "Delivery shipper", "Customer user" };

        for (int i = 0; i < roleNames.length; i++) {
            String roleName = roleNames[i];
            if (roleRepository.findByRoleName(roleName).isEmpty()) {
                Role role = Role.builder()
                        .roleName(roleName)
                        .description(descriptions[i])
                        .build();
                roleRepository.save(role);
                log.info("  ✓ Đã tạo role: {}", roleName);
            }
        }
    }

    /**
     * Tạo hoặc cập nhật demo users.
     * Mỗi lần app khởi động sẽ đảm bảo các demo users có password đúng.
     */
    private void ensureDemoUsers() {
        log.info("  → Đảm bảo demo users có password đúng...");

        // Lấy roles
        Role adminRole = roleRepository.findByRoleName("ADMIN").orElse(null);
        Role staffRole = roleRepository.findByRoleName("STAFF").orElse(null);
        Role shipperRole = roleRepository.findByRoleName("SHIPPER").orElse(null);
        Role customerRole = roleRepository.findByRoleName("CUSTOMER").orElse(null);

        // Tạo hoặc cập nhật các demo users
        ensureUser("admin", "admin@logistic.local", "admin123", "Admin User", "0900000001", adminRole);
        ensureUser("staff01", "staff01@logistic.local", "staff123", "Staff One", "0900000002", staffRole);
        ensureUser("shipper01", "shipper01@logistic.local", "shipper123", "Shipper One", "0900000003", shipperRole);
        ensureUser("cust01", "cust01@logistic.local", "cust123", "Customer One", "0900000004", customerRole);

        log.info("  ✓ Đã đảm bảo 4 demo users");
    }

    /**
     * Tạo user mới nếu chưa có, hoặc cập nhật password nếu đã tồn tại.
     */
    private void ensureUser(String username, String email, String rawPassword, String fullName, String phone,
            Role role) {
        java.util.Optional<User> existingUser = userRepository.findByEmail(email);

        String hashedPassword = passwordEncoder.encode(rawPassword);

        // DEBUG: Kiểm tra hash có đúng không
        boolean matches = passwordEncoder.matches(rawPassword, hashedPassword);
        log.info("    DEBUG: rawPassword='{}', hash='{}...', matches={}",
                rawPassword, hashedPassword.substring(0, 20), matches);

        if (existingUser.isPresent()) {
            // User đã tồn tại - cập nhật password
            User user = existingUser.get();
            user.setPasswordHash(hashedPassword);
            userRepository.save(user);
            log.info("    ↻ Đã cập nhật password cho: {} - password: {}", email, rawPassword);
        } else {
            // User chưa có - tạo mới
            Set<Role> roles = new HashSet<>();
            if (role != null) {
                roles.add(role);
            }

            User user = User.builder()
                    .username(username)
                    .email(email)
                    .passwordHash(hashedPassword)
                    .fullName(fullName)
                    .phone(phone)
                    .status(User.UserStatus.active)
                    .roles(roles)
                    .build();

            userRepository.save(user);
            log.info("    + Đã tạo mới user: {} ({}) - password: {}", username, email, rawPassword);
        }
    }
}
