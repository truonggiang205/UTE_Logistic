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
public class BroadcastEmailRequest {

    // ALL_MANAGERS | HUB_MANAGERS
    @NotBlank
    private String target;

    private Long hubId;

    @NotBlank
    @Size(max = 150)
    private String subject;

    @NotBlank
    private String body;
}
