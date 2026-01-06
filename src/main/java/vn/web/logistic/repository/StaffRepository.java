package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Staff;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {

    // Tìm staff theo user_id
    Optional<Staff> findByUserUserId(Long userId);

    // Tìm staff theo username
    Optional<Staff> findByUserUsername(String username);

    // Tìm staff theo email
    Optional<Staff> findByUserEmail(String email);

    // Kiểm tra user đã có staff chưa
    boolean existsByUserUserId(Long userId);
}
