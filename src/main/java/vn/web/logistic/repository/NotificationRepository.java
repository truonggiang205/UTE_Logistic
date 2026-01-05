package vn.web.logistic.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Notification;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> findTop20ByTargetRoleInOrderByCreatedAtDesc(List<String> targetRoles);

    // Phân trang cho admin history
    Page<Notification> findAllByOrderByCreatedAtDesc(Pageable pageable);

    // Thống kê theo role
    long countByTargetRole(String targetRole);

    // Tìm theo tiêu đề
    Page<Notification> findByTitleContainingIgnoreCaseOrderByCreatedAtDesc(String keyword, Pageable pageable);
}
