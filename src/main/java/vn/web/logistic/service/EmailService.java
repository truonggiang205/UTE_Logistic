package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.entity.Notification;
import vn.web.logistic.entity.User;

/**
 * Service gửi email thông báo
 */
public interface EmailService {

    /**
     * Gửi email thông báo đến một user (async)
     */
    void sendNotificationEmail(String toEmail, String toName, Notification notification);

    /**
     * Gửi email thông báo đến nhiều users (async, bulk)
     * 
     * @return số lượng email đã gửi thành công
     */
    void sendBulkNotificationEmails(List<User> recipients, Notification notification);
}
