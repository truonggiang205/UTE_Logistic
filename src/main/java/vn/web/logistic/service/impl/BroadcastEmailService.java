package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.dto.request.admin.BroadcastEmailRequest;
import vn.web.logistic.dto.response.admin.BroadcastEmailResponse;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class BroadcastEmailService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final SystemLogRepository systemLogRepository;
    private final BroadcastEmailAsyncSender asyncSender;

    @Value("${spring.mail.host:}")
    private String mailHost;

    @Transactional
    public BroadcastEmailResponse broadcast(User actor, BroadcastEmailRequest request) {
        String target = request.getTarget() != null ? request.getTarget().trim().toUpperCase(Locale.ROOT) : null;
        Long hubId = request.getHubId();

        String resolvedRole = resolveManagerRole();

        List<User> users;
        if ("ALL_MANAGERS".equals(target)) {
            users = userRepository.findActiveUsersByRoleName(resolvedRole);
        } else if ("HUB_MANAGERS".equals(target)) {
            if (hubId == null) {
                throw new RuntimeException("hubId là bắt buộc khi target=HUB_MANAGERS");
            }
            users = userRepository.findActiveUsersByRoleNameAndHubId(resolvedRole, hubId);
        } else {
            throw new RuntimeException("target không hợp lệ (ALL_MANAGERS|HUB_MANAGERS)");
        }

        Set<String> emails = new LinkedHashSet<>();
        if (users != null) {
            for (User u : users) {
                if (u != null && u.getEmail() != null && !u.getEmail().isBlank()) {
                    emails.add(u.getEmail().trim());
                }
            }
        }

        List<String> recipients = new ArrayList<>(emails);
        boolean mailConfigured = mailHost != null && !mailHost.isBlank();

        // Log queued
        systemLogRepository.save(SystemLog.builder()
                .user(actor)
                .action("BROADCAST_EMAIL_QUEUED target=" + target + " recipients=" + recipients.size())
                .objectType("BROADCAST_EMAIL")
                .objectId(hubId)
                .logTime(LocalDateTime.now())
                .build());

        asyncSender.sendAsync(actor, recipients, request.getSubject(), request.getBody(), "BROADCAST_EMAIL", hubId);

        return BroadcastEmailResponse.builder()
                .queued(true)
                .message(mailConfigured ? "Đã xếp hàng gửi email (async)." : "Chưa cấu hình SMTP: đã ghi log, không gửi email."
                )
                .recipientCount(recipients.size())
                .resolvedRole(resolvedRole)
                .hubId(hubId)
                .mailConfigured(mailConfigured)
                .build();
    }

    private String resolveManagerRole() {
        // If MANAGER role exists, use it; otherwise, fall back to STAFF (repo currently uses STAFF for manager portal).
        return roleRepository.existsByRoleName("MANAGER") ? "MANAGER" : "STAFF";
    }
}
