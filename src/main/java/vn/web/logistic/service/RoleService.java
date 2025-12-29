package vn.web.logistic.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.RoleForm;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.RoleStatus;
import vn.web.logistic.repository.RoleRepository;

@Service
@RequiredArgsConstructor
public class RoleService {

    private final RoleRepository roleRepository;

    @Transactional(readOnly = true)
    public List<Role> findAll() {
        return roleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Role getRequired(Long id) {
        return roleRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Role not found: " + id));
    }

    @Transactional
    public Role create(RoleForm form) {
        roleRepository.findByRoleName(form.getRoleName()).ifPresent(r -> {
            throw new IllegalArgumentException("Role name đã tồn tại");
        });

        Role role = Role.builder()
                .roleName(form.getRoleName())
                .description(form.getDescription())
            .status(form.getStatus() == null ? RoleStatus.active : form.getStatus())
                .build();
        return roleRepository.save(role);
    }

    @Transactional
    public Role update(Long id, RoleForm form) {
        Role role = getRequired(id);

        if (!role.getRoleName().equalsIgnoreCase(form.getRoleName())) {
            roleRepository.findByRoleName(form.getRoleName()).ifPresent(r -> {
                throw new IllegalArgumentException("Role name đã tồn tại");
            });
        }

        role.setRoleName(form.getRoleName());
        role.setDescription(form.getDescription());
        if (form.getStatus() != null) {
            role.setStatus(form.getStatus());
        }
        return roleRepository.save(role);
    }

    @Transactional
    public void delete(Long id) {
        long inUse = roleRepository.countUsersUsingRole(id);
        if (inUse > 0) {
            throw new IllegalArgumentException("Không thể xóa role vì đang có user sử dụng");
        }
        roleRepository.deleteById(id);
    }
}
