package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.entity.Notification;

public interface NotificationService {

    Notification create(String title, String body, String targetRole, String createdByEmail);

    List<Notification> getRecentForRole(String role);
}
