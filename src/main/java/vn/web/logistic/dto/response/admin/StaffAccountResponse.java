package vn.web.logistic.dto.response.admin;

import java.time.LocalDateTime;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StaffAccountResponse {
    private Long userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String status;
    private String avatarUrl;
    private Set<String> roles;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Thông tin liên kết Staff/Shipper nếu có
    private Long staffId;
    private Long shipperId;
    private Long hubId;
    private String hubName;
}
