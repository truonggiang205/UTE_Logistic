package vn.web.logistic.advice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.UserRepository;

import java.security.Principal;

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

    /**
     * Tự động nạp thông tin người dùng vào Model trước khi render bất kỳ trang nào.
     * Điều này đảm bảo ${username}, ${email}, ${businessName} luôn có sẵn trong layout.
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
                    // Bạn có thể thêm các thông tin toàn cục khác tại đây như số dư ví, cấp độ shop...
                });
            });
        }
    }
}