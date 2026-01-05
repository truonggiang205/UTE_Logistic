package vn.web.logistic.controller.admin;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;

@RestController
@RequestMapping(path = "/api/admin/users", produces = MediaType.APPLICATION_JSON_VALUE)
public class AdminUserRestController {

    private final UserRepository userRepository;

    public AdminUserRestController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<UserSummary> listUsers(@RequestParam(name = "role", required = false) String role) {
        List<User> users = userRepository.findAll();
        List<UserSummary> result = new ArrayList<>();

        String roleFilter = role != null ? role.trim().toUpperCase() : null;

        for (User u : users) {
            List<String> roles = new ArrayList<>();
            Set<Role> roleSet = u.getRoles();
            if (roleSet != null) {
                for (Role r : roleSet) {
                    if (r != null && r.getRoleName() != null) {
                        roles.add(r.getRoleName());
                    }
                }
            }

            if (roleFilter != null && !roleFilter.isEmpty()) {
                boolean matched = false;
                for (String rn : roles) {
                    if (roleFilter.equalsIgnoreCase(rn)) {
                        matched = true;
                        break;
                    }
                }
                if (!matched) continue;
            }

            result.add(UserSummary.from(u, roles));
        }

        return result;
    }

    public static class UserSummary {
        public Long userId;
        public String username;
        public String fullName;
        public String email;
        public String phone;
        public String status;
        public LocalDateTime lastLoginAt;
        public List<String> roles;

        public static UserSummary from(User u, List<String> roles) {
            UserSummary s = new UserSummary();
            s.userId = u.getUserId();
            s.username = u.getUsername();
            s.fullName = u.getFullName();
            s.email = u.getEmail();
            s.phone = u.getPhone();
            s.status = u.getStatus() != null ? u.getStatus().name() : null;
            s.lastLoginAt = u.getLastLoginAt();
            s.roles = roles;
            return s;
        }
    }
}
