package vn.web.logistic.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Supports legacy seed format: "seed:<plain>".
 * - If encoded password starts with "seed:", matches raw with the suffix.
 * - Otherwise uses BCrypt.
 */
public class SeedCompatiblePasswordEncoder implements PasswordEncoder {

    private static final String SEED_PREFIX = "seed:";

    private final BCryptPasswordEncoder bcrypt;

    public SeedCompatiblePasswordEncoder() {
        this.bcrypt = new BCryptPasswordEncoder();
    }

    @Override
    public String encode(CharSequence rawPassword) {
        return bcrypt.encode(rawPassword);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if (encodedPassword == null) {
            return false;
        }
        if (encodedPassword.startsWith(SEED_PREFIX)) {
            String seededPlain = encodedPassword.substring(SEED_PREFIX.length());
            return seededPlain.contentEquals(rawPassword);
        }
        return bcrypt.matches(rawPassword, encodedPassword);
    }
}
