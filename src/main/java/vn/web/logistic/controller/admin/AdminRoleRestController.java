package vn.web.logistic.controller.admin;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.dto.request.admin.RoleUpsertRequest;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.SecurityContextService;

@RestController
@RequestMapping(path = "/api/admin/roles", produces = MediaType.APPLICATION_JSON_VALUE)
public class AdminRoleRestController {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final SystemLogRepository systemLogRepository;
    private final SecurityContextService securityContextService;

    public AdminRoleRestController(
            RoleRepository roleRepository,
            UserRepository userRepository,
            SystemLogRepository systemLogRepository,
            SecurityContextService securityContextService
    ) {
        this.roleRepository = roleRepository;
        this.userRepository = userRepository;
        this.systemLogRepository = systemLogRepository;
        this.securityContextService = securityContextService;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<RoleSummary> listRoles() {
        List<Role> roles = roleRepository.findAll();
        List<RoleSummary> result = new ArrayList<>();

        for (Role r : roles) {
            RoleSummary s = new RoleSummary();
            s.roleId = r.getRoleId();
            s.roleName = r.getRoleName();
            s.description = r.getDescription();
            s.status = r.getStatus() != null ? r.getStatus().name() : null;
            s.userCount = (r.getUsers() != null) ? r.getUsers().size() : 0;
            result.add(s);
        }

        return result;
    }

    @PostMapping
    @Transactional
    public ResponseEntity<RoleSummary> createRole(@Valid @RequestBody RoleUpsertRequest request) {
        String roleName = normalizeRoleName(request.getRoleName());
        if (roleRepository.existsByRoleName(roleName)) {
            throw new RuntimeException("RoleName đã tồn tại");
        }

        Role role = Role.builder()
                .roleName(roleName)
                .description(trimToNull(request.getDescription()))
                .status(Role.RoleStatus.active)
                .build();

        Role saved = roleRepository.save(role);
        logAdminAction("ADMIN_CREATE_ROLE", "ROLE", saved.getRoleId());
        return ResponseEntity.ok(toSummary(saved));
    }

    @PutMapping("/{roleId}")
    @Transactional
    public ResponseEntity<RoleSummary> updateRole(@PathVariable Long roleId, @Valid @RequestBody RoleUpsertRequest request) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role"));

        String roleName = normalizeRoleName(request.getRoleName());
        roleRepository.findByRoleName(roleName).ifPresent(existing -> {
            if (!existing.getRoleId().equals(roleId)) {
                throw new RuntimeException("RoleName đã tồn tại");
            }
        });

        role.setRoleName(roleName);
        role.setDescription(trimToNull(request.getDescription()));

        Role saved = roleRepository.save(role);
        logAdminAction("ADMIN_UPDATE_ROLE", "ROLE", saved.getRoleId());
        return ResponseEntity.ok(toSummary(saved));
    }

    @PatchMapping("/{roleId}/activate")
    @Transactional
    public ResponseEntity<RoleSummary> activateRole(@PathVariable Long roleId) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role"));
        role.setStatus(Role.RoleStatus.active);
        Role saved = roleRepository.save(role);
        logAdminAction("ADMIN_ACTIVATE_ROLE", "ROLE", saved.getRoleId());
        return ResponseEntity.ok(toSummary(saved));
    }

    @PatchMapping("/{roleId}/deactivate")
    @Transactional
    public ResponseEntity<RoleSummary> deactivateRole(@PathVariable Long roleId) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy role"));
        role.setStatus(Role.RoleStatus.inactive);
        Role saved = roleRepository.save(role);
        logAdminAction("ADMIN_DEACTIVATE_ROLE", "ROLE", saved.getRoleId());
        return ResponseEntity.ok(toSummary(saved));
    }

    @DeleteMapping("/{roleId}")
    @Transactional
    public ResponseEntity<?> deleteRole(@PathVariable Long roleId) {
        if (!roleRepository.existsById(roleId)) {
            throw new RuntimeException("Không tìm thấy role");
        }
        if (userRepository.existsByRoles_RoleId(roleId)) {
            throw new RuntimeException("Không thể xóa role vì đang được gán cho user");
        }

        roleRepository.deleteById(roleId);
        logAdminAction("ADMIN_DELETE_ROLE", "ROLE", roleId);
        return ResponseEntity.ok().build();
    }

    private RoleSummary toSummary(Role r) {
        RoleSummary s = new RoleSummary();
        s.roleId = r.getRoleId();
        s.roleName = r.getRoleName();
        s.description = r.getDescription();
        s.status = r.getStatus() != null ? r.getStatus().name() : null;
        s.userCount = (r.getUsers() != null) ? r.getUsers().size() : 0;
        return s;
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

    public static class RoleSummary {
        public Long roleId;
        public String roleName;
        public String description;
        public String status;
        public int userCount;
    }
}
