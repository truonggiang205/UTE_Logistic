package vn.web.logistic;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utility class để generate BCrypt password hash
 * Sử dụng để tạo password hash cho việc insert vào database
 */
public class PasswordHashGenerator {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        // Test passwords
        String[] passwords = {
                "password123",
                "admin123",
                "staff123",
                "shipper123",
                "customer123"
        };

        System.out.println("========================================");
        System.out.println("BCrypt Password Hash Generator");
        System.out.println("========================================");

        for (String password : passwords) {
            String encodedPassword = encoder.encode(password);
            System.out.println("\nRaw Password: " + password);
            System.out.println("Encoded Hash: " + encodedPassword);
            System.out.println("----------------------------------------");
        }

        System.out.println("\nVerification Test:");
        String testPassword = "password123";
        String hash1 = encoder.encode(testPassword);
        String hash2 = encoder.encode(testPassword);

        System.out.println("Same password generates different hash:");
        System.out.println("Hash 1: " + hash1);
        System.out.println("Hash 2: " + hash2);
        System.out.println("\nBut both match: " + encoder.matches(testPassword, hash1) +
                " and " + encoder.matches(testPassword, hash2));

        System.out.println("\n========================================");
        System.out.println("Copy the encoded hash and use in SQL INSERT");
        System.out.println("========================================");
    }
}
