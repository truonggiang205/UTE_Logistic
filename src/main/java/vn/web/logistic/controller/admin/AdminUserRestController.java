package vn.web.logistic.controller.admin;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.UUID;
import java.util.Set;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;

import jakarta.validation.Valid;

import vn.web.logistic.dto.request.admin.AdminResetPasswordRequest;
import vn.web.logistic.dto.request.admin.AdminUserUpsertRequest;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.Staff;
import vn.web.logistic.entity.User;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.StaffRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.SecurityContextService;

@RestController
@RequestMapping(path = "/api/admin/users", produces = MediaType.APPLICATION_JSON_VALUE)
public class AdminUserRestController {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final HubRepository hubRepository;
    private final StaffRepository staffRepository;
    private final PasswordEncoder passwordEncoder;
    private final SystemLogRepository systemLogRepository;
    private final SecurityContextService securityContextService;

    public AdminUserRestController(
            UserRepository userRepository,
            RoleRepository roleRepository,
            HubRepository hubRepository,
            StaffRepository staffRepository,
            PasswordEncoder passwordEncoder,
            SystemLogRepository systemLogRepository,
            SecurityContextService securityContextService
    ) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.hubRepository = hubRepository;
        this.staffRepository = staffRepository;
        this.passwordEncoder = passwordEncoder;
        this.systemLogRepository = systemLogRepository;
        this.securityContextService = securityContextService;
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

    @PostMapping
    @Transactional
    public ResponseEntity<UserSummary> createUser(@Valid @RequestBody AdminUserUpsertRequest request) {
        String username = trimToNull(request.getUsername());
        String email = trimToNull(request.getEmail());
        String phone = trimToNull(request.getPhone());
        String password = request.getPassword();

        if (password == null || password.isBlank()) {
            throw new RuntimeException("Password là bắt buộc khi tạo user");
        }

        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username đã tồn tại");
        }
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email đã tồn tại");
        }
        if (phone != null && userRepository.existsByPhone(phone)) {
            throw new RuntimeException("SĐT đã tồn tại");
        }

        User user = User.builder()
                .username(username)
                .email(email)
                .phone(phone)
                .fullName(trimToNull(request.getFullName()))
                .passwordHash(passwordEncoder.encode(password))
                .status(User.UserStatus.active)
                .build();

        applyRoles(user, request.getRoles());
        User saved = userRepository.save(user);

        upsertStaffIfNeeded(saved, request);
        logAdminAction("ADMIN_CREATE_USER", "USER", saved.getUserId());

        return ResponseEntity.ok(UserSummary.from(saved, roleNames(saved)));
    }

    @PutMapping("/{userId}")
    @Transactional
    public ResponseEntity<UserSummary> updateUser(@PathVariable Long userId, @Valid @RequestBody AdminUserUpsertRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        String username = trimToNull(request.getUsername());
        String email = trimToNull(request.getEmail());
        String phone = trimToNull(request.getPhone());

        if (!Objects.equals(user.getUsername(), username) && userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username đã tồn tại");
        }
        if (!Objects.equals(user.getEmail(), email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email đã tồn tại");
        }
        if (phone != null && !Objects.equals(user.getPhone(), phone) && userRepository.existsByPhone(phone)) {
            throw new RuntimeException("SĐT đã tồn tại");
        }

        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setFullName(trimToNull(request.getFullName()));

        // password: optional on update
        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }

        applyRoles(user, request.getRoles());
        User saved = userRepository.save(user);

        upsertStaffIfNeeded(saved, request);
        logAdminAction("ADMIN_UPDATE_USER", "USER", saved.getUserId());

        return ResponseEntity.ok(UserSummary.from(saved, roleNames(saved)));
    }

    @PatchMapping("/{userId}/lock")
    @Transactional
    public ResponseEntity<UserSummary> lockUser(@PathVariable Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));
        user.setStatus(User.UserStatus.inactive);
        User saved = userRepository.save(user);
        logAdminAction("ADMIN_LOCK_USER", "USER", saved.getUserId());
        return ResponseEntity.ok(UserSummary.from(saved, roleNames(saved)));
    }

    @PatchMapping("/{userId}/unlock")
    @Transactional
    public ResponseEntity<UserSummary> unlockUser(@PathVariable Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));
        user.setStatus(User.UserStatus.active);
        User saved = userRepository.save(user);
        logAdminAction("ADMIN_UNLOCK_USER", "USER", saved.getUserId());
        return ResponseEntity.ok(UserSummary.from(saved, roleNames(saved)));
    }

    @PostMapping("/{userId}/reset-password")
    @Transactional
    public ResponseEntity<ResetPasswordResponse> resetPassword(
            @PathVariable Long userId,
            @RequestBody(required = false) AdminResetPasswordRequest request
    ) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        String newPassword = request != null ? trimToNull(request.getNewPassword()) : null;
        if (newPassword == null) {
            newPassword = generateRandomPassword();
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        logAdminAction("ADMIN_RESET_PASSWORD", "USER", user.getUserId());

        return ResponseEntity.ok(new ResetPasswordResponse(user.getUserId(), newPassword));
    }

    private void applyRoles(User user, List<String> roles) {
        user.getRoles().clear();
        if (roles == null || roles.isEmpty()) {
            return;
        }

        for (String rn : roles) {
            String roleName = normalizeRoleName(rn);
            if (roleName == null) {
                continue;
            }

            Role role = roleRepository.findByRoleName(roleName)
                    .orElseThrow(() -> new RuntimeException("Role không tồn tại: " + roleName));
            if (role.getStatus() == Role.RoleStatus.inactive) {
                throw new RuntimeException("Role đang inactive: " + roleName);
            }
            user.getRoles().add(role);
        }
    }

    private void upsertStaffIfNeeded(User user, AdminUserUpsertRequest request) {
        boolean wantsStaff = user.getRoles().stream()
                .anyMatch(r -> r != null && r.getRoleName() != null && r.getRoleName().equalsIgnoreCase("STAFF"));

        if (!wantsStaff && request.getHubId() == null && trimToNull(request.getStaffPosition()) == null) {
            return;
        }

        if (!wantsStaff && staffRepository.existsByUser_UserId(user.getUserId())) {
            // keep existing staff record as-is; do not delete automatically
            return;
        }

        Staff staff = staffRepository.findByUser_UserId(user.getUserId())
                .orElseGet(() -> Staff.builder()
                        .user(user)
                        .joinedAt(LocalDateTime.now())
                        .status(vn.web.logistic.entity.StaffStatus.active)
                        .build());

        if (request.getHubId() != null) {
            Hub hub = hubRepository.findById(request.getHubId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Hub"));
            staff.setHub(hub);
        }
        staff.setStaffPosition(trimToNull(request.getStaffPosition()));

        staffRepository.save(staff);
    }

    private List<String> roleNames(User u) {
        List<String> roles = new ArrayList<>();
        Set<Role> roleSet = u.getRoles();
        if (roleSet != null) {
            for (Role r : roleSet) {
                if (r != null && r.getRoleName() != null) {
                    roles.add(r.getRoleName());
                }
            }
        }
        return roles;
    }

    private String normalizeRoleName(String roleName) {
        if (roleName == null) {
            return null;
        }
        String v = roleName.trim();
        return v.isEmpty() ? null : v.toUpperCase(Locale.ROOT);
    }

    private String trimToNull(String v) {
        if (v == null) {
            return null;
        }
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }

    private String generateRandomPassword() {
        // Simple, deterministic length; ok for assignment usage.
        return "PW-" + UUID.randomUUID().toString().replace("-", "").substring(0, 10);
    }

    private void logAdminAction(String action, String objectType, Long objectId) {
        var actor = securityContextService.getCurrentUser();
        if (actor == null) {
            return;
        }

        systemLogRepository.save(SystemLog.builder()
                .user(actor)
                .action(action)
                .objectType(objectType)
                .objectId(objectId)
                .logTime(LocalDateTime.now())
                .build());
    }

    public static class ResetPasswordResponse {
        public Long userId;
        public String newPassword;

        public ResetPasswordResponse(Long userId, String newPassword) {
            this.userId = userId;
            this.newPassword = newPassword;
        }
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
