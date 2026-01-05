package vn.web.logistic.controller.admin;

import java.util.HashMap;
import java.util.Map;

import java.security.Principal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.service.NotificationService;

@RestController
@RequestMapping(path = "/api/admin/notifications", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class AdminNotificationRestController {

    private static final Logger log = LoggerFactory.getLogger(AdminNotificationRestController.class);

    private final NotificationService notificationService;

    @PostMapping(path = "/send", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> send(@RequestBody NotificationRequest request, Principal principal) {
        String title = request != null ? request.title : null;
        String target = request != null ? request.target : null;
        String body = request != null ? request.body : null;

        String createdByEmail = principal != null ? principal.getName() : null;

        log.info("[ADMIN_NOTIFY] target={} title={}", target, title);

        Map<String, Object> res = new HashMap<>();
        try {
            notificationService.create(title, body, target, createdByEmail);
            res.put("ok", true);
            res.put("message", "Đã gửi thông báo thành công.");
        } catch (Exception e) {
            res.put("ok", false);
            res.put("message", e.getMessage() != null ? e.getMessage() : "Không thể gửi thông báo.");
        }
        return res;
    }

    public static class NotificationRequest {
        public String title;
        public String target;
        public String body;
    }
}
