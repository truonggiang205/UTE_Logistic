package vn.web.logistic.controller.admin;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import vn.web.logistic.entity.Role;
import vn.web.logistic.repository.RoleRepository;

@RestController
@RequestMapping(path = "/api/admin/roles", produces = MediaType.APPLICATION_JSON_VALUE)
public class AdminRoleRestController {

    private final RoleRepository roleRepository;

    public AdminRoleRestController(RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
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

    public static class RoleSummary {
        public Long roleId;
        public String roleName;
        public String description;
        public String status;
        public int userCount;
    }
}
