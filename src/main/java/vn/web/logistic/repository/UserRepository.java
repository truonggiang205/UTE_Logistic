package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.User;
import vn.web.logistic.entity.User.UserStatus;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
        Optional<User> findByUsername(String username);

        Optional<User> findByEmail(String email);

        // Tìm user bằng email hoặc username để hỗ trợ đăng nhập linh hoạt
        Optional<User> findByEmailOrUsername(String email, String username);

        boolean existsByUsername(String username);

        boolean existsByEmail(String email);

        boolean existsByPhone(String phone);

        // =============== Staff Account CRUD Methods ===============

        // Lấy user theo ID với eager loading roles
        @Query("SELECT u FROM User u LEFT JOIN FETCH u.roles WHERE u.userId = :id")
        Optional<User> findByIdWithRoles(@Param("id") Long id);

        // Lấy user theo ID với đầy đủ thông tin (roles, staff, shipper)
        @Query("SELECT u FROM User u " +
                        "LEFT JOIN FETCH u.roles " +
                        "LEFT JOIN FETCH u.staff s " +
                        "LEFT JOIN FETCH s.hub " +
                        "LEFT JOIN FETCH u.shipper sh " +
                        "LEFT JOIN FETCH sh.hub " +
                        "WHERE u.userId = :id")
        Optional<User> findByIdWithDetails(@Param("id") Long id);

        // Tìm các user có role nhất định
        @Query("SELECT DISTINCT u FROM User u " +
                        "LEFT JOIN FETCH u.roles r " +
                        "WHERE r.roleName = :roleName " +
                        "ORDER BY u.createdAt DESC")
        List<User> findByRoleName(@Param("roleName") String roleName);

        // Tìm kiếm với filter (status, keyword) và phân trang - chỉ lấy staff (không
        // phải customer)
        @Query(value = "SELECT DISTINCT u FROM User u " +
                        "LEFT JOIN u.roles r " +
                        "WHERE r.roleName IN ('ADMIN', 'MANAGER', 'SHIPPER', 'STAFF') " +
                        "AND (:status IS NULL OR u.status = :status) " +
                        "AND (:keyword IS NULL OR :keyword = '' OR " +
                        "     LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "     LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "     LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "     LOWER(u.phone) LIKE LOWER(CONCAT('%', :keyword, '%')))", countQuery = "SELECT COUNT(DISTINCT u) FROM User u "
                                        +
                                        "LEFT JOIN u.roles r " +
                                        "WHERE r.roleName IN ('ADMIN', 'MANAGER', 'SHIPPER', 'STAFF') " +
                                        "AND (:status IS NULL OR u.status = :status) " +
                                        "AND (:keyword IS NULL OR :keyword = '' OR " +
                                        "     LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                                        "     LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                                        "     LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                                        "     LOWER(u.phone) LIKE LOWER(CONCAT('%', :keyword, '%')))")
        Page<User> findStaffWithFilters(
                        @Param("status") UserStatus status,
                        @Param("keyword") String keyword,
                        Pageable pageable);

        // Đếm số staff theo status
        @Query("SELECT COUNT(DISTINCT u) FROM User u " +
                        "LEFT JOIN u.roles r " +
                        "WHERE r.roleName IN ('ADMIN', 'MANAGER', 'SHIPPER', 'STAFF') " +
                        "AND u.status = :status")
        long countStaffByStatus(@Param("status") UserStatus status);

        @Query("SELECT u FROM User u WHERE u.username = :id OR u.email = :id OR u.phone = :id")
        Optional<User> findByIdentifier(@Param("id") String identifier);
}
