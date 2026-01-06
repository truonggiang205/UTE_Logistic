package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    // Tìm user bằng email hoặc username để hỗ trợ đăng nhập linh hoạt
    Optional<User> findByEmailOrUsername(String email, String username);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    boolean existsByPhone(String phone);

    boolean existsByRoles_RoleId(Long roleId);

        @org.springframework.data.jpa.repository.Query(
            "SELECT DISTINCT u FROM User u " +
            "JOIN u.roles r " +
            "LEFT JOIN FETCH u.staff s " +
            "WHERE UPPER(r.roleName) = UPPER(:roleName) " +
            "AND r.status = 'active' " +
            "AND u.status = 'active' " +
            "AND u.email IS NOT NULL AND u.email <> ''")
        java.util.List<User> findActiveUsersByRoleName(@org.springframework.data.repository.query.Param("roleName") String roleName);

        @org.springframework.data.jpa.repository.Query(
            "SELECT DISTINCT u FROM User u " +
            "JOIN u.roles r " +
            "JOIN u.staff s " +
            "WHERE UPPER(r.roleName) = UPPER(:roleName) " +
            "AND r.status = 'active' " +
            "AND u.status = 'active' " +
            "AND s.hub.hubId = :hubId " +
            "AND u.email IS NOT NULL AND u.email <> ''")
        java.util.List<User> findActiveUsersByRoleNameAndHubId(
            @org.springframework.data.repository.query.Param("roleName") String roleName,
            @org.springframework.data.repository.query.Param("hubId") Long hubId);
}
