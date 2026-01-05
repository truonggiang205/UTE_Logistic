package vn.web.logistic.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.admin.StaffAccountRequest;
import vn.web.logistic.dto.response.admin.PageResponse;
import vn.web.logistic.dto.response.admin.StaffAccountResponse;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.User;
import vn.web.logistic.entity.User.UserStatus;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.StaffAccountService;

@Slf4j
@Service
@RequiredArgsConstructor
public class StaffAccountServiceImpl implements StaffAccountService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public PageResponse<StaffAccountResponse> getAll(String status, String keyword, Pageable pageable) {
        UserStatus userStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                userStatus = UserStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status value: {}", status);
            }
        }

        Page<User> page = userRepository.findStaffWithFilters(userStatus, keyword, pageable);

        List<StaffAccountResponse> content = page.getContent().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());

        return PageResponse.<StaffAccountResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    @Override
    public StaffAccountResponse getById(Long id) {
        User user = userRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản với ID: " + id));
        return toResponse(user);
    }

    @Override
    public List<String> getAllRoles() {
        return roleRepository.findAll().stream()
                .map(Role::getRoleName)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public StaffAccountResponse create(StaffAccountRequest request) {
        // Kiểm tra trùng username
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username đã tồn tại: " + request.getUsername());
        }

        // Kiểm tra trùng email
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email đã tồn tại: " + request.getEmail());
        }

        // Kiểm tra trùng phone (nếu có)
        if (request.getPhone() != null && !request.getPhone().isEmpty()) {
            if (userRepository.existsByPhone(request.getPhone())) {
                throw new RuntimeException("Số điện thoại đã tồn tại: " + request.getPhone());
            }
        }

        // Validate password bắt buộc khi tạo mới
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            throw new RuntimeException("Mật khẩu không được để trống khi tạo tài khoản mới");
        }

        // Lấy roles
        Set<Role> roles = new HashSet<>();
        if (request.getRoleNames() != null && !request.getRoleNames().isEmpty()) {
            for (String roleName : request.getRoleNames()) {
                Role role = roleRepository.findByRoleName(roleName)
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy vai trò: " + roleName));
                roles.add(role);
            }
        } else {
            // Default role: STAFF
            roleRepository.findByRoleName("STAFF").ifPresent(roles::add);
        }

        // Xác định status
        UserStatus userStatus = UserStatus.active;
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            try {
                userStatus = UserStatus.valueOf(request.getStatus());
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status, using default 'active': {}", request.getStatus());
            }
        }

        User user = User.builder()
                .username(request.getUsername().trim())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName().trim())
                .email(request.getEmail().trim())
                .phone(request.getPhone())
                .status(userStatus)
                .avatarUrl(request.getAvatarUrl())
                .roles(roles)
                .build();

        user = userRepository.save(user);
        log.info("Created new Staff Account: {} (ID: {})", user.getUsername(), user.getUserId());

        return getById(user.getUserId());
    }

    @Override
    @Transactional
    public StaffAccountResponse update(Long id, StaffAccountRequest request) {
        User user = userRepository.findByIdWithRoles(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản với ID: " + id));

        // Kiểm tra trùng username (nếu thay đổi)
        if (!user.getUsername().equals(request.getUsername())) {
            if (userRepository.existsByUsername(request.getUsername())) {
                throw new RuntimeException("Username đã tồn tại: " + request.getUsername());
            }
            user.setUsername(request.getUsername().trim());
        }

        // Kiểm tra trùng email (nếu thay đổi)
        if (!user.getEmail().equals(request.getEmail())) {
            if (userRepository.existsByEmail(request.getEmail())) {
                throw new RuntimeException("Email đã tồn tại: " + request.getEmail());
            }
            user.setEmail(request.getEmail().trim());
        }

        // Kiểm tra trùng phone (nếu thay đổi)
        if (request.getPhone() != null && !request.getPhone().isEmpty()) {
            if (user.getPhone() == null || !user.getPhone().equals(request.getPhone())) {
                if (userRepository.existsByPhone(request.getPhone())) {
                    throw new RuntimeException("Số điện thoại đã tồn tại: " + request.getPhone());
                }
            }
        }

        // Cập nhật thông tin cơ bản
        user.setFullName(request.getFullName().trim());
        user.setPhone(request.getPhone());
        user.setAvatarUrl(request.getAvatarUrl());

        // Cập nhật password nếu có
        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        }

        // Cập nhật status
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            try {
                user.setStatus(UserStatus.valueOf(request.getStatus()));
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status, keeping current: {}", request.getStatus());
            }
        }

        // Cập nhật roles
        if (request.getRoleNames() != null) {
            Set<Role> newRoles = new HashSet<>();
            for (String roleName : request.getRoleNames()) {
                roleRepository.findByRoleName(roleName).ifPresent(newRoles::add);
            }
            user.setRoles(newRoles);
        }

        user = userRepository.save(user);
        log.info("Updated Staff Account ID: {} -> {}", id, user.getUsername());

        return getById(id);
    }

    @Override
    @Transactional
    public StaffAccountResponse updateStatus(Long id, String status) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản với ID: " + id));

        try {
            user.setStatus(UserStatus.valueOf(status));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + status);
        }

        user = userRepository.save(user);
        log.info("Updated Staff Account status: ID {} -> {}", id, status);

        return getById(id);
    }

    @Override
    @Transactional
    public void resetPassword(Long id, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản với ID: " + id));

        if (newPassword == null || newPassword.length() < 6) {
            throw new RuntimeException("Mật khẩu mới phải ít nhất 6 ký tự");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        log.info("Reset password for Staff Account ID: {}", id);
    }

    // =============== Helper Methods ===============

    private StaffAccountResponse toResponse(User user) {
        Set<String> roleNames = user.getRoles() != null
                ? user.getRoles().stream().map(Role::getRoleName).collect(Collectors.toSet())
                : new HashSet<>();

        Long hubId = null;
        String hubName = null;

        // Lấy hub từ Staff hoặc Shipper
        if (user.getStaff() != null && user.getStaff().getHub() != null) {
            hubId = user.getStaff().getHub().getHubId();
            hubName = user.getStaff().getHub().getHubName();
        } else if (user.getShipper() != null && user.getShipper().getHub() != null) {
            hubId = user.getShipper().getHub().getHubId();
            hubName = user.getShipper().getHub().getHubName();
        }

        return StaffAccountResponse.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .status(user.getStatus() != null ? user.getStatus().name() : null)
                .avatarUrl(user.getAvatarUrl())
                .roles(roleNames)
                .lastLoginAt(user.getLastLoginAt())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .staffId(user.getStaff() != null ? user.getStaff().getStaffId() : null)
                .shipperId(user.getShipper() != null ? user.getShipper().getShipperId() : null)
                .hubId(hubId)
                .hubName(hubName)
                .build();
    }
}
