package vn.web.logistic.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class RouteForm {

    @NotNull
    private Long fromHubId;

    @NotNull
    private Long toHubId;

    @NotNull
    @Min(1)
    private Integer leadTime;

    private String description;

    public Long getFromHubId() {
        return fromHubId;
    }

    public void setFromHubId(Long fromHubId) {
        this.fromHubId = fromHubId;
    }

    public Long getToHubId() {
        return toHubId;
    }

    public void setToHubId(Long toHubId) {
        this.toHubId = toHubId;
    }

    public Integer getLeadTime() {
        return leadTime;
    }

    public void setLeadTime(Integer leadTime) {
        this.leadTime = leadTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
