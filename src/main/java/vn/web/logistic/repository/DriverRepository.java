package vn.web.logistic.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Driver;
import vn.web.logistic.entity.Driver.DriverStatus;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Long> {

    boolean existsByIdentityCard(String identityCard);

    boolean existsByLicenseNumber(String licenseNumber);

    boolean existsByIdentityCardAndDriverIdNot(String identityCard, Long driverId);

    boolean existsByLicenseNumberAndDriverIdNot(String licenseNumber, Long driverId);

    @Query("SELECT d FROM Driver d " +
            "WHERE (:status IS NULL OR d.status = :status) " +
            "AND (:keyword IS NULL OR d.fullName LIKE %:keyword% OR d.phoneNumber LIKE %:keyword%)")
    Page<Driver> findAllWithFilters(
            @Param("status") DriverStatus status,
            @Param("keyword") String keyword,
            Pageable pageable);

    long countByStatus(DriverStatus status);
}
