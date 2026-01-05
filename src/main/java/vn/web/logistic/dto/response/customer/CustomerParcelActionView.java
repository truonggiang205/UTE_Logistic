package vn.web.logistic.dto.response.customer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerParcelActionView {
    private String actionName;
    private String fromHubName;
    private String toHubName;
    private String actorName;
    private String note;
    private String timeText;
}
