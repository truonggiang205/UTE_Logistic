package vn.web.logistic.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import vn.web.logistic.dto.response.admin.HubFilterResponse;
import vn.web.logistic.dto.response.admin.HubAdminResponse;
import vn.web.logistic.dto.request.admin.HubUpsertRequest;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.service.SecurityContextService;
import vn.web.logistic.service.HubService;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

@RestController
@RequestMapping("/api/admin/hubs")
@RequiredArgsConstructor
public class HubController {

    private final HubService hubService;
    private final HubRepository hubRepository;
    private final SystemLogRepository systemLogRepository;
    private final SecurityContextService securityContextService;

    @GetMapping("/filter")
    public ResponseEntity<List<HubFilterResponse>> getHubsForFilter() {
        return ResponseEntity.ok(hubService.getHubsForFilter());
    }

    @GetMapping
    public ResponseEntity<List<HubAdminResponse>> getAllHubs() {
        List<HubAdminResponse> hubs = hubRepository.findAll().stream()
                .sorted(Comparator.comparing(Hub::getHubName, Comparator.nullsLast(String::compareToIgnoreCase)))
                .map(this::toAdminResponse)
                .toList();
        return ResponseEntity.ok(hubs);
    }

    @PostMapping
    public ResponseEntity<HubAdminResponse> createHub(@Valid @org.springframework.web.bind.annotation.RequestBody HubUpsertRequest request) {
        Hub hub = Hub.builder()
                .hubName(request.getHubName())
                .address(request.getAddress())
                .ward(request.getWard())
                .district(request.getDistrict())
                .province(request.getProvince())
                .contactPhone(request.getContactPhone())
                .email(request.getEmail())
                .createdAt(LocalDateTime.now())
                .build();

        if (request.getHubLevel() != null && !request.getHubLevel().isBlank()) {
            hub.setHubLevel(parseHubLevelOrThrow(request.getHubLevel()));
        }

        Hub saved = hubRepository.save(hub);
        logAdminAction("ADMIN_CREATE_HUB", "HUB", saved.getHubId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PutMapping("/{hubId}")
    public ResponseEntity<HubAdminResponse> updateHub(
            @PathVariable Long hubId,
            @Valid @org.springframework.web.bind.annotation.RequestBody HubUpsertRequest request
    ) {
        Hub hub = hubRepository.findById(hubId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub"));

        hub.setHubName(request.getHubName());
        hub.setAddress(request.getAddress());
        hub.setWard(request.getWard());
        hub.setDistrict(request.getDistrict());
        hub.setProvince(request.getProvince());
        hub.setContactPhone(request.getContactPhone());
        hub.setEmail(request.getEmail());

        if (request.getHubLevel() != null && !request.getHubLevel().isBlank()) {
            hub.setHubLevel(parseHubLevelOrThrow(request.getHubLevel()));
        }

        Hub saved = hubRepository.save(hub);
        logAdminAction("ADMIN_UPDATE_HUB", "HUB", saved.getHubId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PatchMapping("/{hubId}/lock")
    public ResponseEntity<HubAdminResponse> lockHub(@PathVariable Long hubId) {
        Hub hub = hubRepository.findById(hubId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub"));
        hub.setStatus(vn.web.logistic.entity.HubStatus.inactive);
        Hub saved = hubRepository.save(hub);
        logAdminAction("ADMIN_LOCK_HUB", "HUB", saved.getHubId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    @PatchMapping("/{hubId}/unlock")
    public ResponseEntity<HubAdminResponse> unlockHub(@PathVariable Long hubId) {
        Hub hub = hubRepository.findById(hubId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub"));
        hub.setStatus(vn.web.logistic.entity.HubStatus.active);
        Hub saved = hubRepository.save(hub);
        logAdminAction("ADMIN_UNLOCK_HUB", "HUB", saved.getHubId());
        return ResponseEntity.ok(toAdminResponse(saved));
    }

    private HubAdminResponse toAdminResponse(Hub hub) {
        return HubAdminResponse.builder()
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

    private vn.web.logistic.entity.HubLevel parseHubLevelOrThrow(String hubLevel) {
        try {
            return vn.web.logistic.entity.HubLevel.valueOf(hubLevel.trim());
        } catch (Exception e) {
            throw new RuntimeException("HubLevel không hợp lệ (central|regional|local)");
        }
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