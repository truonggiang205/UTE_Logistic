package vn.web.logistic.dto.response.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActionTypeAdminResponse {

    private Long actionTypeId;
    private String actionCode;
    private String actionName;
    private String description;
}
