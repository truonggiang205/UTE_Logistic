package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.admin.HubRequest;
import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.dto.response.admin.HubResponse;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.service.HubService;

@Slf4j
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

    @Override
    public PageResponse<HubResponse> getAll(String status, String hubLevel, String keyword, Pageable pageable) {
        Hub.HubStatus hubStatus = null;
        Hub.HubLevel level = null;

        if (status != null && !status.isEmpty()) {
            try {
                hubStatus = Hub.HubStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status value: {}", status);
            }
        }

        if (hubLevel != null && !hubLevel.isEmpty()) {
            try {
                level = Hub.HubLevel.valueOf(hubLevel);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid hubLevel value: {}", hubLevel);
            }
        }

        Page<Hub> page = hubRepository.findWithFilters(hubStatus, level, keyword, pageable);

        List<HubResponse> content = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());

        return PageResponse.<HubResponse>builder()
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
    public HubResponse getById(Long id) {
        Hub hub = hubRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub với ID: " + id));
        return toResponse(hub);
    }

    @Override
    @Transactional
    public HubResponse create(HubRequest request) {
        // Kiểm tra trùng tên
        if (hubRepository.findByHubNameIgnoreCase(request.getHubName()).isPresent()) {
            throw new RuntimeException("Tên Hub đã tồn tại: " + request.getHubName());
        }

        Hub hub = Hub.builder()
                .hubName(request.getHubName())
                .address(request.getAddress())
                .ward(request.getWard())
                .district(request.getDistrict())
                .province(request.getProvince())
                .hubLevel(parseHubLevel(request.getHubLevel()))
                .contactPhone(request.getContactPhone())
                .email(request.getEmail())
                .status(Hub.HubStatus.active)
                .createdAt(LocalDateTime.now())
                .build();

        hub = hubRepository.save(hub);
        log.info("Created new Hub: {} (ID: {})", hub.getHubName(), hub.getHubId());
        return toResponse(hub);
    }

    @Override
    @Transactional
    public HubResponse update(Long id, HubRequest request) {
        Hub hub = hubRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub với ID: " + id));

        // Kiểm tra trùng tên với Hub khác
        hubRepository.findByHubNameIgnoreCase(request.getHubName())
                .ifPresent(existingHub -> {
                    if (!existingHub.getHubId().equals(id)) {
                        throw new RuntimeException("Tên Hub đã tồn tại: " + request.getHubName());
                    }
                });

        hub.setHubName(request.getHubName());
        hub.setAddress(request.getAddress());
        hub.setWard(request.getWard());
        hub.setDistrict(request.getDistrict());
        hub.setProvince(request.getProvince());
        hub.setHubLevel(parseHubLevel(request.getHubLevel()));
        hub.setContactPhone(request.getContactPhone());
        hub.setEmail(request.getEmail());

        hub = hubRepository.save(hub);
        log.info("Updated Hub: {} (ID: {})", hub.getHubName(), hub.getHubId());
        return toResponse(hub);
    }

    @Override
    @Transactional
    public HubResponse updateStatus(Long id, String status) {
        Hub hub = hubRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub với ID: " + id));

        try {
            hub.setStatus(Hub.HubStatus.valueOf(status));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + status);
        }

        hub = hubRepository.save(hub);
        log.info("Updated Hub status: {} -> {} (ID: {})", hub.getHubName(), status, hub.getHubId());
        return toResponse(hub);
    }

    // =============== Helper Methods ===============

    private HubResponse toResponse(Hub hub) {
        return HubResponse.builder()
                .hubId(hub.getHubId())
                .hubName(hub.getHubName())
                .address(hub.getAddress())
                .ward(hub.getWard())
                .district(hub.getDistrict())
                .province(hub.getProvince())
                .hubLevel(hub.getHubLevel() != null ? hub.getHubLevel().name() : null)
                .status(hub.getStatus() != null ? hub.getStatus().name() : null)
                .contactPhone(hub.getContactPhone())
                .email(hub.getEmail())
                .createdAt(hub.getCreatedAt())
                .build();
    }

    private Hub.HubLevel parseHubLevel(String hubLevel) {
        if (hubLevel == null || hubLevel.isEmpty()) {
            return Hub.HubLevel.local;
        }
        try {
            return Hub.HubLevel.valueOf(hubLevel);
        } catch (IllegalArgumentException e) {
            return Hub.HubLevel.local;
        }
    }
}