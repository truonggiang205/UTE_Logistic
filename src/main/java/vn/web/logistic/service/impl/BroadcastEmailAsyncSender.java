package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.List;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.SystemLogRepository;

@Service
@RequiredArgsConstructor
public class BroadcastEmailAsyncSender {

    private static final Logger log = LoggerFactory.getLogger(BroadcastEmailAsyncSender.class);

    private final ObjectProvider<JavaMailSender> mailSenderProvider;
    private final SystemLogRepository systemLogRepository;

    @Value("${spring.mail.host:}")
    private String mailHost;

    @Async("appTaskExecutor")
    public void sendAsync(User actor, List<String> recipients, String subject, String body, String objectType, Long objectId) {
        boolean configured = mailHost != null && !mailHost.isBlank();

        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();

        if (!configured || mailSender == null) {
            log.warn("[BROADCAST_EMAIL] Mail not configured/available; skip sending. configured={} senderPresent={} recipients={}",
                configured,
                mailSender != null,
                recipients != null ? recipients.size() : 0);
            systemLogRepository.save(SystemLog.builder()
                    .user(actor)
                .action("BROADCAST_EMAIL_SKIPPED configured=" + configured + " senderPresent=" + (mailSender != null)
                    + " recipients=" + (recipients != null ? recipients.size() : 0))
                    .objectType(objectType)
                    .objectId(objectId)
                    .logTime(LocalDateTime.now())
                    .build());
            return;
        }

        int success = 0;
        int fail = 0;

        if (recipients != null) {
            for (String email : recipients) {
                if (email == null || email.isBlank()) {
                    continue;
                }
                try {
                    SimpleMailMessage msg = new SimpleMailMessage();
                    msg.setTo(email);
                    msg.setSubject(subject);
                    msg.setText(body);
                    mailSender.send(msg);
                    success++;
                } catch (Exception e) {
                    fail++;
                    log.warn("[BROADCAST_EMAIL] Failed to send to {}: {}", email, e.getMessage());
                }
            }
        }

        systemLogRepository.save(SystemLog.builder()
                .user(actor)
                .action("BROADCAST_EMAIL_DONE s=" + success + " f=" + fail)
                .objectType(objectType)
                .objectId(objectId)
                .logTime(LocalDateTime.now())
                .build());
    }
}
