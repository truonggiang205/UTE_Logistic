package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Shipper;

@Repository
public interface ShipperRepository extends JpaRepository<Shipper, Long> {

    // Tìm shipper by id
    @Query("SELECT s FROM Shipper s WHERE s.user.id = :userId")
    Optional<Shipper> findByUserId(@Param("userId") Long userId);

    // Tìm shipper by email
    @Query("SELECT s FROM Shipper s WHERE s.user.email = :email")
    Optional<Shipper> findByUserEmail(@Param("email") String email);
}
