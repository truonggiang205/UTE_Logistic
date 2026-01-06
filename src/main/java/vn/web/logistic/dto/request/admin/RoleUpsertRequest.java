package vn.web.logistic.dto.request.admin;

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
public class RoleUpsertRequest {

    @NotBlank
    @Size(max = 50)
    private String roleName;

    @Size(max = 255)
    private String description;
}
