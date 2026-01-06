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
public class ActionTypeUpsertRequest {

    @NotBlank
    @Size(max = 20)
    private String actionCode;

    @NotBlank
    @Size(max = 100)
    private String actionName;

    @Size(max = 255)
    private String description;
}
