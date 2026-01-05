package vn.web.logistic.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.admin.RouteRequest;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.RouteAdminResponse;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Route;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RouteRepository;
import vn.web.logistic.service.RouteService;

@Slf4j
@Service
@RequiredArgsConstructor
public class RouteServiceImpl implements RouteService {

    private final RouteRepository routeRepository;
    private final HubRepository hubRepository;

    @Override
    public List<RouteAdminResponse> getAll() {
        return routeRepository.findAllWithHubs().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public PageResponse<RouteAdminResponse> getAll(String keyword, Pageable pageable) {
        Page<Route> page = routeRepository.findWithFilters(keyword, pageable);

        List<RouteAdminResponse> content = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());

        return PageResponse.<RouteAdminResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    @Override
    public RouteAdminResponse getById(Long id) {
        Route route = routeRepository.findByIdWithHubs(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tuyến với ID: " + id));
        return toResponse(route);
    }

    @Override
    @Transactional
    public RouteAdminResponse create(RouteRequest request) {
        // Validate: fromHub != toHub
        if (request.getFromHubId().equals(request.getToHubId())) {
            throw new RuntimeException("Hub xuất phát và Hub đích không được trùng nhau");
        }

        // Kiểm tra trùng lặp tuyến
        routeRepository.findByFromHubIdAndToHubId(request.getFromHubId(), request.getToHubId())
                .ifPresent(existing -> {
                    throw new RuntimeException("Tuyến vận chuyển từ Hub này đến Hub kia đã tồn tại");
                });

        // Lấy Hub entities
        Hub fromHub = hubRepository.findById(request.getFromHubId())
                .orElseThrow(
                        () -> new RuntimeException("Không tìm thấy Hub xuất phát với ID: " + request.getFromHubId()));
        Hub toHub = hubRepository.findById(request.getToHubId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub đích với ID: " + request.getToHubId()));

        Route route = Route.builder()
                .fromHub(fromHub)
                .toHub(toHub)
                .estimatedTime(request.getEstimatedTime())
                .description(request.getDescription())
                .build();

        route = routeRepository.save(route);
        log.info("Created new Route: {} -> {} (ID: {})", fromHub.getHubName(), toHub.getHubName(), route.getRouteId());

        return toResponse(route);
    }

    @Override
    @Transactional
    public RouteAdminResponse update(Long id, RouteRequest request) {
        Route route = routeRepository.findByIdWithHubs(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tuyến với ID: " + id));

        // Validate: fromHub != toHub
        if (request.getFromHubId().equals(request.getToHubId())) {
            throw new RuntimeException("Hub xuất phát và Hub đích không được trùng nhau");
        }

        // Kiểm tra trùng lặp tuyến (nếu thay đổi hub)
        boolean hubsChanged = !route.getFromHub().getHubId().equals(request.getFromHubId()) ||
                !route.getToHub().getHubId().equals(request.getToHubId());
        if (hubsChanged) {
            routeRepository.findByFromHubIdAndToHubId(request.getFromHubId(), request.getToHubId())
                    .ifPresent(existing -> {
                        if (!existing.getRouteId().equals(id)) {
                            throw new RuntimeException("Tuyến vận chuyển từ Hub này đến Hub kia đã tồn tại");
                        }
                    });

            // Lấy Hub entities mới
            Hub fromHub = hubRepository.findById(request.getFromHubId())
                    .orElseThrow(() -> new RuntimeException(
                            "Không tìm thấy Hub xuất phát với ID: " + request.getFromHubId()));
            Hub toHub = hubRepository.findById(request.getToHubId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub đích với ID: " + request.getToHubId()));

            route.setFromHub(fromHub);
            route.setToHub(toHub);
        }

        route.setEstimatedTime(request.getEstimatedTime());
        route.setDescription(request.getDescription());

        route = routeRepository.save(route);
        log.info("Updated Route ID: {}", route.getRouteId());

        return toResponse(route);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Route route = routeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tuyến với ID: " + id));

        routeRepository.delete(route);
        log.info("Deleted Route ID: {}", id);
    }

    // =============== Helper Methods ===============

    private RouteAdminResponse toResponse(Route route) {
        return RouteAdminResponse.builder()
                .routeId(route.getRouteId())
                .fromHubId(route.getFromHub() != null ? route.getFromHub().getHubId() : null)
                .fromHubName(route.getFromHub() != null ? route.getFromHub().getHubName() : null)
                .fromHubProvince(route.getFromHub() != null ? route.getFromHub().getProvince() : null)
                .toHubId(route.getToHub() != null ? route.getToHub().getHubId() : null)
                .toHubName(route.getToHub() != null ? route.getToHub().getHubName() : null)
                .toHubProvince(route.getToHub() != null ? route.getToHub().getProvince() : null)
                .estimatedTime(route.getEstimatedTime())
                .description(route.getDescription())
                .build();
    }
}
