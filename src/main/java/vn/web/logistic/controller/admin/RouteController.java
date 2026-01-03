package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import vn.web.logistic.dto.response.admin.RouteAdminResponse;
import vn.web.logistic.entity.Route;
import vn.web.logistic.repository.RouteRepository;

import java.util.List;

@RestController
@RequestMapping("/api/admin/routes")
@RequiredArgsConstructor
public class RouteController {

    private final RouteRepository routeRepository;

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
                        r.getDescription()))
                .toList();

        return ResponseEntity.ok(response);
    }
}
