package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.service.HubService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HubServiceImpl implements HubService {

    private final HubRepository hubRepository;

    @Override
    public List<HubFilterResponse> getHubsForFilter() {
        return hubRepository.findAllActiveHubs().stream()
                .map(hub -> new HubFilterResponse(hub.getHubId(), hub.getHubName()))
                .collect(Collectors.toList());
    }
}