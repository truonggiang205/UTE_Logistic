package vn.web.logistic.dto.request;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginRequest {
    private String identifier; // Chứa Số điện thoại hoặc Username
    private String password;
}