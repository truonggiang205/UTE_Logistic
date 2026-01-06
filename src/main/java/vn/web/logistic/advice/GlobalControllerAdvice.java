package vn.web.logistic.advice;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import vn.web.logistic.entity.Notification;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.NotificationRepository;
import vn.web.logistic.repository.UserRepository;

/**
 * ControllerAdvice này tự động cung cấp dữ liệu cho tất cả các View (JSP)
 * thuộc các Controller trong package customer.
 */
@ControllerAdvice(basePackages = "vn.web.logistic.controller.customer")
public class GlobalControllerAdvice {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private NotificationRepository notificationRepository;

    /**
     * Tự động nạp thông tin người dùng vào Model trước khi render bất kỳ trang nào.
     * Điều này đảm bảo ${username}, ${email}, ${businessName}, ${notifications}
     * luôn có sẵn trong
     * layout.
     */
    @ModelAttribute
    public void addGlobalAttributes(Model model, Principal principal) {
        if (principal != null) {
            String username = principal.getName();

            // Tìm User từ database
            userRepository.findByUsername(username).ifPresent(user -> {
                model.addAttribute("username", user.getUsername());
                model.addAttribute("email", user.getEmail());

                model.addAttribute("avatarUrl", user.getAvatarUrl());
                // Tìm thông tin Shop tương ứng
                customerRepository.findByUser(user).ifPresent(customer -> {
                    model.addAttribute("businessName", customer.getBusinessName());
                    // Bạn có thể thêm các thông tin toàn cục khác tại đây như số dư ví, cấp độ
                    // shop...
                });
            });

            // Load 5 thông báo mới nhất cho Customer (ALL hoặc CUSTOMER)
            List<Notification> notifications = notificationRepository
                    .findTop20ByTargetRoleInOrderByCreatedAtDesc(Arrays.asList("ALL", "CUSTOMER"));
            // Chỉ lấy 5 thông báo đầu tiên để hiển thị trong dropdown
            if (notifications.size() > 5) {
                notifications = notifications.subList(0, 5);
            }
            model.addAttribute("notifications", notifications);
            model.addAttribute("notificationCount", notifications.size());
        }
    }
}