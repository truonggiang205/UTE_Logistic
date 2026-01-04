package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Role;
import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    // Tìm kiếm Role theo tên (VD: ROLE_CUSTOMER, ROLE_ADMIN)
    Optional<Role> findByRoleName(String roleName);
}