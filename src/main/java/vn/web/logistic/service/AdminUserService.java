package vn.web.logistic.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.UserForm;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.Staff;
import vn.web.logistic.entity.User;
import vn.web.logistic.entity.UserStatus;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class AdminUserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final HubRepository hubRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<User> findAll() {
        return userRepository.findAllWithRoles();
    }

    @Transactional(readOnly = true)
    public User getRequired(Long id) {
        return userRepository.findByIdWithRoles(id).orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
    }

    @Transactional
    public User create(UserForm form) {
        if (userRepository.existsByUsername(form.getUsername())) {
            throw new IllegalArgumentException("Username đã tồn tại");
        }
        if (form.getEmail() != null && !form.getEmail().isBlank() && userRepository.existsByEmail(form.getEmail())) {
            throw new IllegalArgumentException("Email đã tồn tại");
        }

        Role role = roleRepository.findByRoleName(form.getRoleName())
                .orElseThrow(() -> new IllegalArgumentException("Role không tồn tại: " + form.getRoleName()));

        String rawPassword = (form.getPassword() == null || form.getPassword().isBlank()) ? generateTempPassword() : form.getPassword();

        User user = User.builder()
                .username(form.getUsername())
                .passwordHash(passwordEncoder.encode(rawPassword))
                .fullName(form.getFullName())
                .email(form.getEmail())
                .phone(form.getPhone())
            .status(form.getStatus() == null ? UserStatus.active : form.getStatus())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .roles(Set.of(role))
                .build();

        attachOrUpdateStaffProfile(user, form);

        return userRepository.save(user);
    }

    @Transactional
    public User update(Long id, UserForm form) {
        User user = getRequired(id);

        if (!user.getUsername().equalsIgnoreCase(form.getUsername())) {
            if (userRepository.existsByUsername(form.getUsername())) {
                throw new IllegalArgumentException("Username đã tồn tại");
            }
            user.setUsername(form.getUsername());
        }

        if (form.getEmail() != null && !form.getEmail().isBlank()) {
            if (!form.getEmail().equalsIgnoreCase(user.getEmail()) && userRepository.existsByEmail(form.getEmail())) {
                throw new IllegalArgumentException("Email đã tồn tại");
            }
        }

        Role role = roleRepository.findByRoleName(form.getRoleName())
                .orElseThrow(() -> new IllegalArgumentException("Role không tồn tại: " + form.getRoleName()));

        user.setFullName(form.getFullName());
        user.setEmail(form.getEmail());
        user.setPhone(form.getPhone());
        user.setRoles(Set.of(role));
        if (form.getStatus() != null) {
            user.setStatus(form.getStatus());
        }
        user.setUpdatedAt(LocalDateTime.now());

        if (form.getPassword() != null && !form.getPassword().isBlank()) {
            user.setPasswordHash(passwordEncoder.encode(form.getPassword()));
        }

        attachOrUpdateStaffProfile(user, form);

        return userRepository.save(user);
    }

    @Transactional
    public User toggleLock(Long id) {
        User user = getRequired(id);
        if (user.getStatus() == UserStatus.active) {
            user.setStatus(UserStatus.inactive);
        } else {
            user.setStatus(UserStatus.active);
        }
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    @Transactional
    public String resetPassword(Long id) {
        User user = getRequired(id);
        String temp = generateTempPassword();
        user.setPasswordHash(passwordEncoder.encode(temp));
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        return temp;
    }

    private void attachOrUpdateStaffProfile(User user, UserForm form) {
        boolean isStaff = "STAFF".equalsIgnoreCase(form.getRoleName());

        if (!isStaff) {
            user.setStaff(null);
            return;
        }

        Hub hub = null;
        if (form.getHubId() != null) {
            hub = hubRepository.findById(form.getHubId())
                    .orElseThrow(() -> new IllegalArgumentException("Hub không tồn tại: " + form.getHubId()));
        }

        if (user.getStaff() == null) {
            Staff staff = Staff.builder()
                    .user(user)
                    .hub(hub)
                    .staffPosition(form.getStaffPosition())
                    .joinedAt(LocalDateTime.now())
                    .build();
            user.setStaff(staff);
        } else {
            user.getStaff().setHub(hub);
            user.getStaff().setStaffPosition(form.getStaffPosition());
        }
    }

    private String generateTempPassword() {
        final String alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#$%";
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10; i++) {
            sb.append(alphabet.charAt(rnd.nextInt(alphabet.length())));
        }
        return sb.toString();
    }
}
