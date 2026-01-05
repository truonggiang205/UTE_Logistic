package vn.web.logistic.dto.response.admin;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HubResponse {
    private Long hubId;
    private String hubName;
    private String address;
    private String ward;
    private String district;
    private String province;
    private String hubLevel;
    private String status;
    private String contactPhone;
    private String email;
    private LocalDateTime createdAt;
}
