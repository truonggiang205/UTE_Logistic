package vn.web.logistic.dto.response;

import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {

    // Legacy fields (some controllers may still use these)
    private boolean success;
    private String message;

    private String token;
    @Builder.Default
    private String type = "Bearer";
    private Long userId;
    private String username;
    private String fullName;
    private String email;
    private Set<String> roles;

    public AuthResponse(String token, Long userId, String username, String fullName, String email, Set<String> roles) {
        this.token = token;
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.roles = roles;
    }
}
