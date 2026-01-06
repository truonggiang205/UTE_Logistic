package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BroadcastEmailResponse {

    private boolean queued;
    private String message;
    private int recipientCount;
    private String resolvedRole;
    private Long hubId;
    private boolean mailConfigured;
}
