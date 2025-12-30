package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.dto.response.admin.HubFilterResponse;

public interface HubService {
    List<HubFilterResponse> getHubsForFilter();
}