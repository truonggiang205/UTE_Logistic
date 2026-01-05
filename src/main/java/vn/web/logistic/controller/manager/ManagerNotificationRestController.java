package vn.web.logistic.controller.manager;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.Notification;
import vn.web.logistic.service.NotificationService;

@RestController
@RequestMapping(path = "/api/manager/notifications", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class ManagerNotificationRestController {

    private final NotificationService notificationService;

    @GetMapping("/recent")
    public List<NotificationDto> recent() {
        return notificationService.getRecentForRole("MANAGER")
                .stream()
                .map(NotificationDto::from)
                .collect(Collectors.toList());
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
}
