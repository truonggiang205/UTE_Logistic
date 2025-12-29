package vn.web.logistic.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.RouteForm;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.HubStatus;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.RouteStatus;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RouteRepository;

@Service
@RequiredArgsConstructor
public class RouteService {

    private final RouteRepository routeRepository;
    private final HubRepository hubRepository;

    @Transactional(readOnly = true)
    public List<Route> findAll() {
        return routeRepository.findAllWithHubs();
    }

    @Transactional(readOnly = true)
    public Route getRequired(Long id) {
        return routeRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Route not found: " + id));
    }

    @Transactional
    public Route create(RouteForm form) {
        Hub from = getActiveHubRequired(form.getFromHubId());
        Hub to = getActiveHubRequired(form.getToHubId());
        validateRoute(from, to);

        Route route = Route.builder()
                .fromHub(from)
                .toHub(to)
                .estimatedTime(form.getLeadTime())
                .status(RouteStatus.active)
                .description(form.getDescription())
                .build();

        return routeRepository.save(route);
    }

    @Transactional
    public Route update(Long id, RouteForm form) {
        Route route = getRequired(id);
        Hub from = getActiveHubRequired(form.getFromHubId());
        Hub to = getActiveHubRequired(form.getToHubId());
        validateRoute(from, to);

        route.setFromHub(from);
        route.setToHub(to);
        route.setEstimatedTime(form.getLeadTime());
        route.setDescription(form.getDescription());
        return routeRepository.save(route);
    }

    @Transactional
    public Route toggleInactive(Long id) {
        Route route = getRequired(id);
        if (route.getStatus() == RouteStatus.active) {
            route.setStatus(RouteStatus.inactive);
        } else {
            route.setStatus(RouteStatus.active);
        }
        return routeRepository.save(route);
    }

    private Hub getActiveHubRequired(Long hubId) {
        Hub hub = hubRepository.findById(hubId).orElseThrow(() -> new IllegalArgumentException("Hub not found: " + hubId));
        if (hub.getStatus() != HubStatus.active) {
            throw new IllegalArgumentException("Hub is locked/inactive and cannot be used: " + hubId);
        }
        return hub;
    }

    private void validateRoute(Hub from, Hub to) {
        if (from.getHubId().equals(to.getHubId())) {
            throw new IllegalArgumentException("From Hub và To Hub không được trùng nhau");
        }
    }
}
