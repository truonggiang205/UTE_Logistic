package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.Role.RoleStatus;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByRoleName(String roleName);

    boolean existsByRoleName(String roleName);

    // Lấy tất cả roles sắp xếp theo tên
    List<Role> findAllByOrderByRoleNameAsc();

    // Lấy tất cả roles active
    List<Role> findByStatusOrderByRoleNameAsc(RoleStatus status);

    // Đếm số user có role này
    @Query("SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.roleId = :roleId")
    Integer countUsersByRoleId(@Param("roleId") Long roleId);

    // Kiểm tra trùng tên role (case insensitive)
    @Query("SELECT r FROM Role r WHERE LOWER(r.roleName) = LOWER(:roleName)")
    Optional<Role> findByRoleNameIgnoreCase(@Param("roleName") String roleName);
}
