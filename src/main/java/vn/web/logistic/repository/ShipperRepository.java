package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.Shipper.ShipperStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShipperRepository extends JpaRepository<Shipper, Long> {

    // Tìm shipper theo user_id
    Optional<Shipper> findByUserUserId(Long userId);

    // Tìm shipper theo hub_id
    List<Shipper> findByHubHubId(Long hubId);

    // Đếm số shipper đang hoạt động theo Hub
    @Query("SELECT COUNT(s) FROM Shipper s WHERE s.hub.hubId = :hubId AND s.status = :status")
    long countByHubIdAndStatus(@Param("hubId") Long hubId, @Param("status") ShipperStatus status);

    // Đếm số shipper active hoặc busy (đang làm việc) theo Hub
    @Query("SELECT COUNT(s) FROM Shipper s WHERE s.hub.hubId = :hubId AND s.status IN :statuses")
    long countActiveShippersByHubId(@Param("hubId") Long hubId, @Param("statuses") List<ShipperStatus> statuses);
}
