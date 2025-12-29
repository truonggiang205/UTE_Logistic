package vn.web.logistic.service;

import vn.web.logistic.dto.response.HubFilterResponse;
import java.util.List;

public interface HubService {
    List<HubFilterResponse> getHubsForFilter();
}