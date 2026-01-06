package vn.web.logistic.dto.request.admin;

import java.util.List;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserUpsertRequest {

    @NotBlank
    @Size(max = 50)
    private String username;

    @NotBlank
    @Email
    @Size(max = 100)
    private String email;

    @Size(max = 20)
    private String phone;

    @Size(max = 100)
    private String fullName;

    // Only required when creating a new user.
    @Size(min = 6, max = 100)
    private String password;

    // Example: ["ADMIN"], ["STAFF"], ["SHIPPER"], ["CUSTOMER"]
    private List<String> roles;

    // Optional for STAFF: link to hub
    private Long hubId;

    // Optional: "MANAGER" or "STAFF" (free text)
    private String staffPosition;
}
