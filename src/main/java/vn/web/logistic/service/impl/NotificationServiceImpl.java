package vn.web.logistic.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.repository.NotificationRepository;
import vn.web.logistic.service.NotificationService;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;

    @Override
    public Notification create(String title, String body, String targetRole, String createdByEmail) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống.");
        }
        if (body == null || body.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống.");
        }

        String normalizedTarget = (targetRole == null || targetRole.isBlank()) ? "ALL" : targetRole.trim();

        Notification n = Notification.builder()
                .title(title.trim())
                .body(body.trim())
                .targetRole(normalizedTarget)
                .createdByEmail(createdByEmail)
                .build();

        return notificationRepository.save(n);
    }

    @Override
    public List<Notification> getRecentForRole(String role) {
        String r = (role == null || role.isBlank()) ? "" : role.trim();
        // luôn nhận ALL + role
        return notificationRepository.findTop20ByTargetRoleInOrderByCreatedAtDesc(List.of("ALL", r));
    }
}
