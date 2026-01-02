package vn.web.logistic.config;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
// 1. Kế thừa OncePerRequestFilter: Đảm bảo bộ lọc này chỉ chạy đúng 1 lần cho
// mỗi request
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    @Autowired
    private JwtTokenProvider tokenProvider; // Class tiện ích dùng để check và parse token

    @Autowired
    private UserDetailsService userDetailsService; // Service dùng để load thông tin user từ DB

    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        try {
            // 2. Lấy chuỗi JWT từ Header "Authorization" của request
            String jwt = getJwtFromRequest(request);

            // 3. Kiểm tra: Có token không? Token có hợp lệ (đúng chữ ký, chưa hết hạn)
            // không?
            if (StringUtils.hasText(jwt) && tokenProvider.validateToken(jwt)) {

                // 4. Lấy username từ trong token ra
                String username = tokenProvider.getUsernameFromToken(jwt);

                // 5. Load thông tin đầy đủ của user (Role, Password...) từ Database
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                // 6. Tạo đối tượng Authentication chuẩn của Spring Security
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // 7. QUAN TRỌNG NHẤT: Set thông tin user vào Context
                // Hành động này chính thức xác nhận với hệ thống: "User này ĐÃ ĐĂNG NHẬP"
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception ex) {
            logger.error("Could not set user authentication in security context", ex);
        }

        // 8. Cho phép request đi tiếp đến các filter khác hoặc vào Controller
        filterChain.doFilter(request, response);
    }

    /**
     * Helper: Tách phần "Bearer " ra để lấy đúng chuỗi token
     */
    private String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7); // Cắt bỏ 7 ký tự đầu ("Bearer ")
        }
        return null;
    }
}