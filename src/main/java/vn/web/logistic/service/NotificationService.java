package vn.web.logistic.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import vn.web.logistic.entity.Notification;

public interface NotificationService {

    /**
     * Tạo notification (legacy - không gửi email)
     */
    Notification create(String title, String body, String targetRole, String createdByEmail);

    /**
     * Tạo notification với option gửi email
     */
    Notification create(String title, String body, String targetRole, String createdByEmail, boolean sendEmail);

    /**
     * Lấy notifications gần đây cho role (cho user views)
     */
    List<Notification> getRecentForRole(String role);

    /**
     * Lịch sử notifications với pagination (cho admin)
     */
    Page<Notification> getNotificationHistory(int page, int size);

    /**
     * Xóa notification theo ID
     */
    void delete(Long notificationId);

    /**
     * Thống kê số lượng theo role
     */
    Map<String, Long> getNotificationStats();
}
