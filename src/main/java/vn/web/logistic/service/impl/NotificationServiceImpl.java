package vn.web.logistic.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.NotificationRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.EmailService;
import vn.web.logistic.service.NotificationService;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationServiceImpl.class);

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Override
    public Notification create(String title, String body, String targetRole, String createdByEmail) {
        return create(title, body, targetRole, createdByEmail, false);
    }

    @Override
    @Transactional
    public Notification create(String title, String body, String targetRole, String createdByEmail, boolean sendEmail) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống.");
        }
        if (body == null || body.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống.");
        }

        String normalizedTarget = (targetRole == null || targetRole.isBlank()) ? "ALL"
                : targetRole.trim().toUpperCase();

        Notification n = Notification.builder()
                .title(title.trim())
                .body(body.trim())
                .targetRole(normalizedTarget)
                .createdByEmail(createdByEmail)
                .emailSent(false)
                .emailCount(0)
                .build();

        Notification saved = notificationRepository.save(n);

        // Gửi email nếu được yêu cầu
        if (sendEmail) {
            try {
                List<User> recipients = findRecipientsByRole(normalizedTarget);
                if (!recipients.isEmpty()) {
                    log.info("[NOTIFY] Sending email to {} recipients for role: {}", recipients.size(),
                            normalizedTarget);
                    emailService.sendBulkNotificationEmails(recipients, saved);

                    // Cập nhật tracking (async nên không chờ kết quả thực sự)
                    saved.setEmailSent(true);
                    saved.setEmailCount(recipients.size());
                    notificationRepository.save(saved);
                } else {
                    log.info("[NOTIFY] No recipients found for role: {}", normalizedTarget);
                }
            } catch (Exception e) {
                log.error("[NOTIFY] Failed to send emails: {}", e.getMessage());
                // Không throw exception - notification đã được lưu
            }
        }

        return saved;
    }

    @Override
    public List<Notification> getRecentForRole(String role) {
        String r = (role == null || role.isBlank()) ? "" : role.trim();
        // luôn nhận ALL + role
        return notificationRepository.findTop20ByTargetRoleInOrderByCreatedAtDesc(List.of("ALL", r));
    }

    @Override
    public Page<Notification> getNotificationHistory(int page, int size) {
        return notificationRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size));
    }

    @Override
    @Transactional
    public void delete(Long notificationId) {
        if (notificationId == null) {
            throw new IllegalArgumentException("ID không hợp lệ.");
        }
        if (!notificationRepository.existsById(notificationId)) {
            throw new IllegalArgumentException("Không tìm thấy thông báo với ID: " + notificationId);
        }
        notificationRepository.deleteById(notificationId);
        log.info("[NOTIFY] Deleted notification ID: {}", notificationId);
    }

    @Override
    public Map<String, Long> getNotificationStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("total", notificationRepository.count());
        stats.put("ALL", notificationRepository.countByTargetRole("ALL"));
        stats.put("ADMIN", notificationRepository.countByTargetRole("ADMIN"));
        stats.put("MANAGER", notificationRepository.countByTargetRole("MANAGER"));
        stats.put("SHIPPER", notificationRepository.countByTargetRole("SHIPPER"));
        stats.put("CUSTOMER", notificationRepository.countByTargetRole("CUSTOMER"));
        return stats;
    }

    /**
     * Tìm users theo role để gửi email
     */
    private List<User> findRecipientsByRole(String targetRole) {
        if ("ALL".equals(targetRole)) {
            // Lấy tất cả users có email
            return userRepository.findAll().stream()
                    .filter(u -> u.getEmail() != null && !u.getEmail().isBlank())
                    .toList();
        }
        // Lấy users theo role cụ thể
        return userRepository.findByRoleName(targetRole).stream()
                .filter(u -> u.getEmail() != null && !u.getEmail().isBlank())
                .toList();
    }
}
