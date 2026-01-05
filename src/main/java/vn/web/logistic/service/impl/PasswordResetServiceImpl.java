package vn.web.logistic.service.impl;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.PasswordResetToken;
import vn.web.logistic.repository.PasswordResetTokenRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.PasswordResetService;

@Service
@RequiredArgsConstructor
public class PasswordResetServiceImpl implements PasswordResetService {

    private static final int TOKEN_BYTES = 32;
    private static final int EXPIRE_MINUTES = 30;

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public String createResetToken(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        var userOpt = userRepository.findByEmail(email.trim());
        if (userOpt.isEmpty()) {
            return null;
        }

        String rawToken = generateToken();
        String hash = sha256Hex(rawToken);

        PasswordResetToken prt = PasswordResetToken.builder()
                .tokenHash(hash)
                .userId(userOpt.get().getUserId())
                .expiresAt(LocalDateTime.now().plusMinutes(EXPIRE_MINUTES))
                .build();

        tokenRepository.save(prt);
        return rawToken;
    }

    @Override
    public boolean isTokenValid(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return false;
        }

        String hash = sha256Hex(rawToken);
        var tokenOpt = tokenRepository.findByTokenHash(hash);
        if (tokenOpt.isEmpty()) {
            return false;
        }

        var token = tokenOpt.get();
        LocalDateTime now = LocalDateTime.now();
        return !token.isUsed() && !token.isExpired(now);
    }

    @Override
    public void resetPassword(String rawToken, String newPassword, String confirmPassword) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new IllegalArgumentException("Token không hợp lệ.");
        }
        if (newPassword == null || newPassword.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống.");
        }
        if (confirmPassword == null || confirmPassword.isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập lại mật khẩu.");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
        }
        if (newPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu tối thiểu 6 ký tự.");
        }

        String hash = sha256Hex(rawToken);
        PasswordResetToken token = tokenRepository.findByTokenHash(hash)
                .orElseThrow(() -> new IllegalArgumentException("Token không hợp lệ hoặc đã hết hạn."));

        LocalDateTime now = LocalDateTime.now();
        if (token.isUsed() || token.isExpired(now)) {
            throw new IllegalArgumentException("Token không hợp lệ hoặc đã hết hạn.");
        }

        var user = userRepository.findById(token.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("Tài khoản không tồn tại."));

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        token.setUsedAt(now);
        tokenRepository.save(token);
    }

    private static String generateToken() {
        byte[] bytes = new byte[TOKEN_BYTES];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private static String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(digest.length * 2);
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new IllegalStateException("Không thể tạo hash token", e);
        }
    }
}
