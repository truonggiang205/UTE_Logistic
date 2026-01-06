package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;
import vn.web.logistic.dto.response.admin.RouteAdminResponse;
import vn.web.logistic.dto.request.admin.RouteUpsertRequest;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.RouteStatus;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RouteRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.service.SecurityContextService;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/admin/routes")
@RequiredArgsConstructor
public class RouteController {

    private final RouteRepository routeRepository;
    private final HubRepository hubRepository;
    private final SystemLogRepository systemLogRepository;
    private final SecurityContextService securityContextService;

    @GetMapping
    public ResponseEntity<List<RouteAdminResponse>> getAllRoutes() {
        List<Route> routes = routeRepository.findAllWithHubs();
        List<RouteAdminResponse> response = routes.stream()
                .map(r -> new RouteAdminResponse(
                        r.getRouteId(),
                        r.getFromHub() != null ? r.getFromHub().getHubId() : null,
                        r.getFromHub() != null ? r.getFromHub().getHubName() : null,
                        r.getToHub() != null ? r.getToHub().getHubId() : null,
                        r.getToHub() != null ? r.getToHub().getHubName() : null,
                        r.getEstimatedTime(),
                        r.getDescription(),
                        r.getStatus() != null ? r.getStatus().name() : null))
                .toList();

        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<RouteAdminResponse> createRoute(@Valid @RequestBody RouteUpsertRequest request) {
        if (request.getFromHubId().equals(request.getToHubId())) {
            throw new RuntimeException("fromHub và toHub không được trùng nhau");
        }

        Hub fromHub = getActiveHubOrThrow(request.getFromHubId());
        Hub toHub = getActiveHubOrThrow(request.getToHubId());

        Route route = Route.builder()
                .fromHub(fromHub)
                .toHub(toHub)
                .estimatedTime(request.getEstimatedTime())
                .description(request.getDescription())
                .status(RouteStatus.active)
                .build();

        Route saved = routeRepository.save(route);
        logAdminAction("ADMIN_CREATE_ROUTE", "ROUTE", saved.getRouteId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PutMapping("/{routeId}")
    public ResponseEntity<RouteAdminResponse> updateRoute(
            @PathVariable Long routeId,
            @Valid @RequestBody RouteUpsertRequest request
    ) {
        Route route = routeRepository.findByIdWithHubs(routeId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Route"));

        if (request.getFromHubId().equals(request.getToHubId())) {
            throw new RuntimeException("fromHub và toHub không được trùng nhau");
        }

        Hub fromHub = getActiveHubOrThrow(request.getFromHubId());
        Hub toHub = getActiveHubOrThrow(request.getToHubId());

        route.setFromHub(fromHub);
        route.setToHub(toHub);
        route.setEstimatedTime(request.getEstimatedTime());
        route.setDescription(request.getDescription());

        Route saved = routeRepository.save(route);
        logAdminAction("ADMIN_UPDATE_ROUTE", "ROUTE", saved.getRouteId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PatchMapping("/{routeId}/activate")
    public ResponseEntity<RouteAdminResponse> activateRoute(@PathVariable Long routeId) {
        Route route = routeRepository.findById(routeId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Route"));
        route.setStatus(RouteStatus.active);
        Route saved = routeRepository.save(route);
        logAdminAction("ADMIN_ACTIVATE_ROUTE", "ROUTE", saved.getRouteId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PatchMapping("/{routeId}/deactivate")
    public ResponseEntity<RouteAdminResponse> deactivateRoute(@PathVariable Long routeId) {
        Route route = routeRepository.findById(routeId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Route"));
        route.setStatus(RouteStatus.inactive);
        Route saved = routeRepository.save(route);
        logAdminAction("ADMIN_DEACTIVATE_ROUTE", "ROUTE", saved.getRouteId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    private RouteAdminResponse toAdminResponse(Route r) {
        return new RouteAdminResponse(
                r.getRouteId(),
                r.getFromHub() != null ? r.getFromHub().getHubId() : null,
                r.getFromHub() != null ? r.getFromHub().getHubName() : null,
                r.getToHub() != null ? r.getToHub().getHubId() : null,
                r.getToHub() != null ? r.getToHub().getHubName() : null,
                r.getEstimatedTime(),
                r.getDescription(),
                r.getStatus() != null ? r.getStatus().name() : null);
    }

    private Hub getActiveHubOrThrow(Long hubId) {
        Hub hub = hubRepository.findById(hubId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub"));

        // Hub inactive tương ứng với trạng thái bị lock
        if (hub.getStatus() != null && hub.getStatus().name().equalsIgnoreCase("inactive")) {
            throw new RuntimeException("Hub đang bị khóa (inactive)");
        }
        return hub;
    }

    private void logAdminAction(String action, String objectType, Long objectId) {
        var actor = securityContextService.getCurrentUser();
        if (actor == null) {
            return;
        }

        systemLogRepository.save(SystemLog.builder()
                .user(actor)
                .action(action)
                .objectType(objectType)
                .objectId(objectId)
                .logTime(LocalDateTime.now())
                .build());
    }
}
