package vn.web.logistic.service.impl;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.SecurityContextService;

@Service
@RequiredArgsConstructor
@Slf4j
public class SecurityContextServiceImpl implements SecurityContextService {

    private final UserRepository userRepository;

    @Override
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }

        Object principal = authentication.getPrincipal();
        if (principal instanceof UserDetails) {
            // getUsername() trả về username (không phải email)
            String identifier = ((UserDetails) principal).getUsername();
            // Dùng findByIdentifier để tìm theo username, email hoặc phone
            return userRepository.findByIdentifier(identifier).orElse(null);
        }

        return null;
    }

    @Override
    public Long getCurrentUserId() {
        User user = getCurrentUser();
        if (user != null) {
            return user.getUserId();
        }
        log.warn("Không tìm thấy user trong SecurityContext");
        return null;
    }

    @Override
    public Long getCurrentHubId() {
        Hub hub = getCurrentHub();
        return hub != null ? hub.getHubId() : null;
    }

    @Override
    public Hub getCurrentHub() {
        User user = getCurrentUser();
        if (user == null) {
            return null;
        }

        // Ưu tiên lấy từ Staff (Manager là staff)
        if (user.getStaff() != null && user.getStaff().getHub() != null) {
            return user.getStaff().getHub();
        }

        // Fallback: lấy từ Shipper nếu có
        if (user.getShipper() != null && user.getShipper().getHub() != null) {
            return user.getShipper().getHub();
        }

        return null;
    }

    @Override
    public boolean belongsToHub(Long hubId) {
        if (hubId == null) {
            return false;
        }
        Long currentHubId = getCurrentHubId();
        return hubId.equals(currentHubId);
    }
}
