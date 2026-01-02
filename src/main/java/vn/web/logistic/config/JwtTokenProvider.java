package vn.web.logistic.config;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;

@Component
public class JwtTokenProvider {

    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);

    @Value("${jwt.secret}")
    private String jwtSecret; // Lấy chuỗi bí mật từ file application.properties

    @Value("${jwt.expiration}")
    private long jwtExpiration; // Lấy thời gian hết hạn token từ config

    private SecretKey key; // Đối tượng Key chuẩn dùng để ký và xác thực

    @PostConstruct
    public void init() {
        // Chuyển chuỗi bí mật thành Key thuật toán HMAC-SHA ngay khi ứng dụng chạy
        this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * Tạo JWT token từ Authentication object
     */
    public String generateToken(Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);

        return Jwts.builder()
                .subject(userDetails.getUsername()) // Đưa username vào phần payload của token
                .issuedAt(now) // Thời điểm tạo
                .expiration(expiryDate) // Thời điểm hết hạn
                .signWith(key) // Ký token bằng Key bí mật (quan trọng nhất)
                .compact(); // Đóng gói thành chuỗi JWT
    }

    /**
     * Tạo JWT token từ username
     */
    public String generateTokenFromUsername(String username) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);

        return Jwts.builder()
                .subject(username) // Đưa username vào token
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(key) // Ký token
                .compact();
    }

    /**
     * Lấy username từ JWT token
     */
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(key) // Dùng Key để xác minh chữ ký token
                .build()
                .parseSignedClaims(token) // Giải mã token
                .getPayload();

        return claims.getSubject(); // Trả về username đã lưu trong token
    }

    /**
     * Validate JWT token
     */
    public boolean validateToken(String authToken) {
        try {
            Jwts.parser()
                    .verifyWith(key) // Kiểm tra xem token có đúng chữ ký của server không
                    .build()
                    .parseSignedClaims(authToken); // Nếu giải mã thành công -> Token hợp lệ
            return true;
        } catch (io.jsonwebtoken.security.SignatureException ex) {
            logger.error("Invalid JWT signature"); // Lỗi: Chữ ký sai (token bị sửa đổi)
        } catch (MalformedJwtException ex) {
            logger.error("Invalid JWT token"); // Lỗi: Token sai định dạng/cấu trúc
        } catch (ExpiredJwtException ex) {
            logger.error("Expired JWT token"); // Lỗi: Token đã hết hạn
        } catch (UnsupportedJwtException ex) {
            logger.error("Unsupported JWT token"); // Lỗi: Token không hỗ trợ
        } catch (IllegalArgumentException ex) {
            logger.error("JWT claims string is empty"); // Lỗi: Token rỗng
        }
        return false;
    }
}