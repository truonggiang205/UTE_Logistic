package vn.web.logistic.controller.admin;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.service.NotificationService;

@RestController
@RequestMapping(path = "/api/admin/notifications", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class AdminNotificationRestController {

    private static final Logger log = LoggerFactory.getLogger(AdminNotificationRestController.class);

    private final NotificationService notificationService;

    /**
     * POST /api/admin/notifications/send
     * Gửi thông báo mới
     */
    @PostMapping(path = "/send", consumes = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> send(@RequestBody NotificationRequest request, Principal principal) {
        String title = request != null ? request.title : null;
        String target = request != null ? request.target : null;
        String body = request != null ? request.body : null;
        boolean sendEmail = request != null && Boolean.TRUE.equals(request.sendEmail);

        String createdByEmail = principal != null ? principal.getName() : null;

        log.info("[ADMIN_NOTIFY] target={} title={} sendEmail={}", target, title, sendEmail);

        Map<String, Object> res = new HashMap<>();
        try {
            Notification saved = notificationService.create(title, body, target, createdByEmail, sendEmail);
            res.put("ok", true);
            res.put("message", sendEmail
                    ? "Đã gửi thông báo và email thành công."
                    : "Đã gửi thông báo thành công.");
            res.put("notificationId", saved.getNotificationId());
        } catch (Exception e) {
            res.put("ok", false);
            res.put("message", e.getMessage() != null ? e.getMessage() : "Không thể gửi thông báo.");
        }
        return res;
    }

    /**
     * GET /api/admin/notifications?page=0&size=10
     * Lấy lịch sử thông báo với phân trang
     */
    @GetMapping
    public Map<String, Object> getHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Map<String, Object> res = new HashMap<>();
        try {
            Page<Notification> pageResult = notificationService.getNotificationHistory(page, size);
            res.put("ok", true);
            res.put("content", pageResult.getContent());
            res.put("totalElements", pageResult.getTotalElements());
            res.put("totalPages", pageResult.getTotalPages());
            res.put("currentPage", page);
            res.put("size", size);
        } catch (Exception e) {
            res.put("ok", false);
            res.put("message", e.getMessage());
        }
        return res;
    }

    /**
     * GET /api/admin/notifications/stats
     * Lấy thống kê số lượng theo role
     */
    @GetMapping("/stats")
    public Map<String, Object> getStats() {
        Map<String, Object> res = new HashMap<>();
        try {
            Map<String, Long> stats = notificationService.getNotificationStats();
            res.put("ok", true);
            res.put("stats", stats);
        } catch (Exception e) {
            res.put("ok", false);
            res.put("message", e.getMessage());
        }
        return res;
    }

    /**
     * GET /api/admin/notifications/recent
     * Lấy 5 thông báo mới nhất cho Admin (target = ALL hoặc ADMIN)
     */
    @GetMapping("/recent")
    public java.util.List<NotificationDto> getRecent() {
        return notificationService.getRecentForRole("ADMIN")
                .stream()
                .map(NotificationDto::from)
                .toList();
    }

    public static class NotificationDto {
        public Long id;
        public String title;
        public String body;
        public String target;
        public String createdAt;

        static NotificationDto from(Notification n) {
            NotificationDto dto = new NotificationDto();
            dto.id = n.getNotificationId();
            dto.title = n.getTitle();
            dto.body = n.getBody();
            dto.target = n.getTargetRole();
            dto.createdAt = n.getCreatedAt() != null ? n.getCreatedAt().toString() : null;
            return dto;
        }
    }

    /**
     * DELETE /api/admin/notifications/{id}
     * Xóa thông báo
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        try {
            notificationService.delete(id);
            res.put("ok", true);
            res.put("message", "Đã xóa thông báo thành công.");
        } catch (Exception e) {
            res.put("ok", false);
            res.put("message", e.getMessage() != null ? e.getMessage() : "Không thể xóa thông báo.");
        }
        return res;
    }

    // ==================== Request DTO ====================

    public static class NotificationRequest {
        public String title;
        public String target;
        public String body;
        public Boolean sendEmail; // NEW: option gửi kèm email
    }
}
