package vn.web.logistic.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.HubForm;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.HubStatus;
import vn.web.logistic.repository.HubRepository;

@Service
@RequiredArgsConstructor
public class HubService {

    private final HubRepository hubRepository;

    @Transactional(readOnly = true)
    public List<Hub> findAll() {
        return hubRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Hub> findAllActive() {
        return hubRepository.findAllActiveOrderByName();
    }

    @Transactional(readOnly = true)
    public Hub getRequired(Long id) {
        return hubRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Hub not found: " + id));
    }

    @Transactional
    public Hub create(HubForm form) {
        Hub hub = Hub.builder()
                .hubName(form.getHubName())
                .address(form.getAddress())
                .ward(form.getWard())
                .district(form.getDistrict())
                .province(form.getProvince())
                .hubLevel(form.getHubLevel())
                .status(HubStatus.active)
                .contactPhone(form.getContactPhone())
                .email(form.getEmail())
                .createdAt(LocalDateTime.now())
                .build();

        return hubRepository.save(hub);
    }

    @Transactional
    public Hub update(Long id, HubForm form) {
        Hub hub = getRequired(id);
        hub.setHubName(form.getHubName());
        hub.setAddress(form.getAddress());
        hub.setWard(form.getWard());
        hub.setDistrict(form.getDistrict());
        hub.setProvince(form.getProvince());
        hub.setHubLevel(form.getHubLevel());
        hub.setContactPhone(form.getContactPhone());
        hub.setEmail(form.getEmail());
        return hubRepository.save(hub);
    }

    @Transactional
    public Hub toggleLock(Long id) {
        Hub hub = getRequired(id);
        if (hub.getStatus() == HubStatus.active) {
            hub.setStatus(HubStatus.inactive);
        } else {
            hub.setStatus(HubStatus.active);
        }
        return hubRepository.save(hub);
    }
}
