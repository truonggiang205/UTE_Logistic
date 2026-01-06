package vn.web.logistic.service.impl;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.entity.User;
import vn.web.logistic.service.EmailService;

/**
 * Implementation gửi email với JavaMailSender.
 * Sử dụng @Async để không block request.
 */
@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailServiceImpl.class);

    private final JavaMailSender mailSender;

    @Value("${app.mail.from-name:UTE Logistic}")
    private String fromName;

    @Value("${app.mail.from-address:noreply@utelogistic.vn}")
    private String fromAddress;

    @Override
    @Async
    public void sendNotificationEmail(String toEmail, String toName, Notification notification) {
        if (toEmail == null || toEmail.isBlank()) {
            log.warn("[EMAIL] Skip - empty email address");
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromAddress, fromName);
            helper.setTo(toEmail);
            helper.setSubject("[UTE Logistic] " + notification.getTitle());
            helper.setText(buildHtmlContent(toName, notification), true);

            mailSender.send(message);
            log.info("[EMAIL] Sent to {} - subject: {}", toEmail, notification.getTitle());

        } catch (MessagingException e) {
            log.error("[EMAIL] Failed to send to {}: {}", toEmail, e.getMessage());
        } catch (Exception e) {
            log.error("[EMAIL] Unexpected error sending to {}: {}", toEmail, e.getMessage());
        }
    }

    @Override
    @Async
    public void sendBulkNotificationEmails(List<User> recipients, Notification notification) {
        if (recipients == null || recipients.isEmpty()) {
            log.info("[EMAIL] No recipients for bulk send");
            return;
        }

        log.info("[EMAIL] Starting bulk send to {} recipients", recipients.size());
        int successCount = 0;

        for (User user : recipients) {
            if (user.getEmail() != null && !user.getEmail().isBlank()) {
                try {
                    MimeMessage message = mailSender.createMimeMessage();
                    MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

                    helper.setFrom(fromAddress, fromName);
                    helper.setTo(user.getEmail());
                    helper.setSubject("[UTE Logistic] " + notification.getTitle());
                    helper.setText(buildHtmlContent(user.getFullName(), notification), true);

                    mailSender.send(message);
                    successCount++;
                    log.debug("[EMAIL] Sent to {}", user.getEmail());

                } catch (Exception e) {
                    log.error("[EMAIL] Failed to send to {}: {}", user.getEmail(), e.getMessage());
                }
            }
        }

        log.info("[EMAIL] Bulk send completed: {}/{} successful", successCount, recipients.size());
    }

    /**
     * Tạo nội dung HTML email (không dùng Thymeleaf)
     */
    private String buildHtmlContent(String recipientName, Notification notification) {
        String formattedDate = notification.getCreatedAt() != null
                ? notification.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                : "";

        String displayName = (recipientName != null && !recipientName.isBlank())
                ? recipientName
                : "Quý khách";

        // Escape HTML để tránh XSS
        String safeTitle = escapeHtml(notification.getTitle());
        String safeBody = escapeHtml(notification.getBody()).replace("\n", "<br>");

        return """
                <!DOCTYPE html>
                <html lang="vi">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                </head>
                <body style="margin:0; padding:0; font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f4f4;">
                    <table width="100%%" cellpadding="0" cellspacing="0" style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                        <!-- Header -->
                        <tr>
                            <td style="background: linear-gradient(135deg, #4e73df 0%%, #224abe 100%%); padding: 24px; text-align: center;">
                                <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 600;">
                                    📦 UTE Logistic
                                </h1>
                            </td>
                        </tr>

                        <!-- Content -->
                        <tr>
                            <td style="padding: 32px 24px;">
                                <p style="color: #5a5c69; font-size: 14px; margin: 0 0 16px 0;">
                                    Xin chào <strong>%s</strong>,
                                </p>

                                <div style="background-color: #f8f9fc; border-left: 4px solid #4e73df; padding: 16px; margin-bottom: 24px; border-radius: 0 4px 4px 0;">
                                    <h2 style="color: #2e59d9; margin: 0 0 12px 0; font-size: 18px;">
                                        %s
                                    </h2>
                                    <p style="color: #5a5c69; margin: 0; line-height: 1.6; font-size: 14px;">
                                        %s
                                    </p>
                                </div>

                                <p style="color: #858796; font-size: 12px; margin: 0;">
                                    Thời gian: %s
                                </p>
                            </td>
                        </tr>

                        <!-- Footer -->
                        <tr>
                            <td style="background-color: #f8f9fc; padding: 16px 24px; text-align: center; border-top: 1px solid #e3e6f0;">
                                <p style="color: #858796; font-size: 12px; margin: 0;">
                                    © 2026 UTE Logistic. Đây là email tự động, vui lòng không trả lời.
                                </p>
                            </td>
                        </tr>
                    </table>
                </body>
                </html>
                """
                .formatted(displayName, safeTitle, safeBody, formattedDate);
    }

    /**
     * Escape HTML special characters
     */
    private String escapeHtml(String text) {
        if (text == null)
            return "";
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    @Override
    public void sendOtpEmail(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("NGHV Logistics <your-email@gmail.com>");
        message.setTo(to);
        message.setSubject("MÃ XÁC THỰC EMAIL - NGHV LOGISTICS");
        message.setText("Chào bạn,\n\n" +
                "Mã xác thực (OTP) để cập nhật email của bạn là: " + otp + "\n" +
                "Mã này có hiệu lực trong vòng 5 phút.\n\n" +
                "Trân trọng,\nĐội ngũ NGHV Logistics.");

        mailSender.send(message);
    }
}
