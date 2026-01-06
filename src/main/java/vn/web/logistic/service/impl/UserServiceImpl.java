package vn.web.logistic.service.impl;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.UserService;

/**
 * Implementation của UserService
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        String identifier = authentication.getName(); // Đây là username (không phải email)
        if (identifier == null || "anonymousUser".equals(identifier)) {
            return null;
        }

        // Dùng findByIdentifier vì authentication.getName() trả về username
        return userRepository.findByIdentifier(identifier).orElse(null);
    }

    @Override
    public Long getHubIdFromUser(User user) {
        if (user == null) {
            return null;
        }

        // Ưu tiên lấy từ Staff (Manager là staff)
        if (user.getStaff() != null && user.getStaff().getHub() != null) {
            return user.getStaff().getHub().getHubId();
        }

        // Fallback: lấy từ Shipper nếu có
        if (user.getShipper() != null && user.getShipper().getHub() != null) {
            return user.getShipper().getHub().getHubId();
        }

        return null;
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    @Override
    public User findById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }
}
