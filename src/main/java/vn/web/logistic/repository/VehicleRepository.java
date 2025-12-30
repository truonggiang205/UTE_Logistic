package vn.web.logistic.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Vehicle;
import vn.web.logistic.entity.Vehicle.VehicleStatus;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {

    boolean existsByPlateNumber(String plateNumber);

    boolean existsByPlateNumberAndVehicleIdNot(String plateNumber, Long vehicleId);

    @Query("SELECT v FROM Vehicle v LEFT JOIN FETCH v.currentHub " +
            "WHERE (:hubId IS NULL OR v.currentHub.hubId = :hubId) " +
            "AND (:status IS NULL OR v.status = :status) " +
            "AND (:plateNumber IS NULL OR v.plateNumber LIKE %:plateNumber%)")
    Page<Vehicle> findAllWithFilters(
            @Param("hubId") Long hubId,
            @Param("status") VehicleStatus status,
            @Param("plateNumber") String plateNumber,
            Pageable pageable);

    long countByStatus(VehicleStatus status);

    @Query("SELECT COUNT(v) FROM Vehicle v")
    long countAllVehicles();

    @Query("SELECT COALESCE(SUM(v.loadCapacity), 0) FROM Vehicle v WHERE v.status = :status")
    java.math.BigDecimal sumLoadCapacityByStatus(@Param("status") VehicleStatus status);
}
