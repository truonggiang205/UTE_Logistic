package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.Shipper.ShipperStatus;

@Repository
public interface ShipperRepository extends JpaRepository<Shipper, Long> {

    // Tìm shipper theo user_id
    Optional<Shipper> findByUserUserId(Long userId);

        // Tìm shipper theo email
        Optional<Shipper> findByUserEmail(String email);

    // Tìm shipper theo hub_id
    List<Shipper> findByHubHubId(Long hubId);

    // Tìm shipper chưa được gán Hub
    List<Shipper> findByHubIsNull();

    // Đếm tổng shipper trong Hub
    long countByHubHubId(Long hubId);

    // Đếm shipper theo Hub và status
    @Query("SELECT COUNT(s) FROM Shipper s WHERE s.hub.hubId = :hubId AND s.status = :status")
    long countByHubIdAndStatus(@Param("hubId") Long hubId, @Param("status") ShipperStatus status);

    // Đếm shipper active hoặc busy (cho Dashboard)
    @Query("SELECT COUNT(s) FROM Shipper s WHERE s.hub.hubId = :hubId AND s.status IN :statuses")
    long countActiveShippersByHubId(@Param("hubId") Long hubId, @Param("statuses") List<ShipperStatus> statuses);

    // Lấy tất cả shipper theo Hub
    @Query("SELECT s FROM Shipper s JOIN FETCH s.user u WHERE s.hub.hubId = :hubId")
    Page<Shipper> findByHubIdWithUserPaged(@Param("hubId") Long hubId, Pageable pageable);

    // Lấy shipper theo Hub và status
    @Query("SELECT s FROM Shipper s JOIN FETCH s.user u WHERE s.hub.hubId = :hubId AND s.status = :status")
    Page<Shipper> findByHubIdAndStatusPaged(@Param("hubId") Long hubId, @Param("status") ShipperStatus status,
            Pageable pageable);

    // Tìm kiếm shipper theo keyword (tên/SĐT/email)
    @Query("SELECT s FROM Shipper s JOIN FETCH s.user u WHERE s.hub.hubId = :hubId AND " +
            "(LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.phone) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Shipper> searchByHubIdAndKeywordPaged(@Param("hubId") Long hubId, @Param("keyword") String keyword,
            Pageable pageable);
}
