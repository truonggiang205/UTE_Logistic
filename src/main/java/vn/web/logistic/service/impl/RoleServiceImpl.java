package vn.web.logistic.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.admin.RoleRequest;
import vn.web.logistic.dto.response.admin.RoleResponse;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.Role.RoleStatus;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.service.RoleService;

@Slf4j
@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;

    @Override
    public List<RoleResponse> getAll() {
        return roleRepository.findAllByOrderByRoleNameAsc().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public RoleResponse getById(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role với ID: " + id));
        return toResponse(role);
    }

    @Override
    @Transactional
    public RoleResponse create(RoleRequest request) {
        // Chuẩn hóa tên role thành chữ in hoa
        String roleName = request.getRoleName().trim().toUpperCase();

        // Kiểm tra trùng tên
        roleRepository.findByRoleNameIgnoreCase(roleName).ifPresent(existing -> {
            throw new RuntimeException("Tên role đã tồn tại: " + roleName);
        });

        // Xác định status
        RoleStatus status = RoleStatus.active;
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            try {
                status = RoleStatus.valueOf(request.getStatus());
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status, using default 'active': {}", request.getStatus());
            }
        }

        Role role = Role.builder()
                .roleName(roleName)
                .description(request.getDescription())
                .status(status)
                .build();

        role = roleRepository.save(role);
        log.info("Created new Role: {} (ID: {})", role.getRoleName(), role.getRoleId());

        return toResponse(role);
    }

    @Override
    @Transactional
    public RoleResponse update(Long id, RoleRequest request) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role với ID: " + id));

        // Chuẩn hóa tên role
        String newRoleName = request.getRoleName().trim().toUpperCase();

        // Kiểm tra trùng tên (nếu thay đổi)
        if (!role.getRoleName().equalsIgnoreCase(newRoleName)) {
            roleRepository.findByRoleNameIgnoreCase(newRoleName).ifPresent(existing -> {
                throw new RuntimeException("Tên role đã tồn tại: " + newRoleName);
            });
            role.setRoleName(newRoleName);
        }

        // Cập nhật mô tả
        role.setDescription(request.getDescription());

        // Cập nhật status
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            try {
                role.setStatus(RoleStatus.valueOf(request.getStatus()));
            } catch (IllegalArgumentException e) {
                log.warn("Invalid status, keeping current: {}", request.getStatus());
            }
        }

        role = roleRepository.save(role);
        log.info("Updated Role ID: {} -> {}", id, role.getRoleName());

        return toResponse(role);
    }

    @Override
    @Transactional
    public RoleResponse updateStatus(Long id, String status) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role với ID: " + id));

        try {
            role.setStatus(RoleStatus.valueOf(status));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + status);
        }

        role = roleRepository.save(role);
        log.info("Updated Role status: ID {} -> {}", id, status);

        return toResponse(role);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role với ID: " + id));

        // Kiểm tra xem có user nào đang sử dụng role này không
        Integer userCount = roleRepository.countUsersByRoleId(id);
        if (userCount != null && userCount > 0) {
            throw new RuntimeException("Không thể xóa role đang được sử dụng bởi " + userCount + " người dùng");
        }

        roleRepository.delete(role);
        log.info("Deleted Role: {} (ID: {})", role.getRoleName(), id);
    }

    // =============== Helper Methods ===============

    private RoleResponse toResponse(Role role) {
        Integer userCount = roleRepository.countUsersByRoleId(role.getRoleId());

        return RoleResponse.builder()
                .roleId(role.getRoleId())
                .roleName(role.getRoleName())
                .description(role.getDescription())
                .status(role.getStatus() != null ? role.getStatus().name() : null)
                .userCount(userCount != null ? userCount : 0)
                .build();
    }
}
