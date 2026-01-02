package vn.web.logistic.service;

import vn.web.logistic.entity.User;

/**
 * Service interface cho quản lý User
 */
public interface UserService {

    /**
     * Lấy User hiện tại đang đăng nhập từ Spring Security Context
     * 
     * @return User nếu đăng nhập, null nếu chưa đăng nhập
     */
    User getCurrentUser();

    /**
     * Lấy Hub ID của User hiện tại (qua Staff hoặc Shipper)
     * 
     * @param user User cần lấy Hub ID
     * @return Hub ID nếu có, null nếu không có
     */
    Long getHubIdFromUser(User user);

    /**
     * Tìm User theo email
     * 
     * @param email Email của User
     * @return User nếu tìm thấy, null nếu không
     */
    User findByEmail(String email);

    /**
     * Tìm User theo ID
     * 
     * @param userId ID của User
     * @return User nếu tìm thấy, null nếu không
     */
    User findById(Long userId);
}
