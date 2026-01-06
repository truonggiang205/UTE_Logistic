package vn.web.logistic.dto.request.admin;

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
public class HubUpsertRequest {

    @NotBlank
    @Size(max = 100)
    private String hubName;

    @Size(max = 255)
    private String address;

    @Size(max = 50)
    private String ward;

    @Size(max = 50)
    private String district;

    @Size(max = 50)
    private String province;

    // central | regional | local
    @Size(max = 20)
    private String hubLevel;

    @Size(max = 20)
    private String contactPhone;

    @Email
    @Size(max = 100)
    private String email;
}
