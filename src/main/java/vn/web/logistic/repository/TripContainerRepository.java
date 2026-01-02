package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.TripContainer;
import vn.web.logistic.entity.TripContainer.TripContainerStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TripContainerRepository extends JpaRepository<TripContainer, Long> {

        @Query("SELECT tc FROM TripContainer tc " +
                        "LEFT JOIN FETCH tc.container c " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "WHERE tc.trip.tripId = :tripId " +
                        "AND tc.status = :status")
        List<TripContainer> findByTripIdAndStatus(
                        @Param("tripId") Long tripId,
                        @Param("status") TripContainerStatus status);

        @Query("SELECT tc FROM TripContainer tc " +
                        "LEFT JOIN FETCH tc.container c " +
                        "LEFT JOIN FETCH c.destinationHub " +
                        "WHERE tc.trip.tripId = :tripId")
        List<TripContainer> findByTripIdWithContainerDetails(@Param("tripId") Long tripId);

        @Query("SELECT COALESCE(SUM(tc.container.weight), 0) FROM TripContainer tc " +
                        "WHERE tc.trip.tripId = :tripId AND tc.status = 'loaded'")
        BigDecimal sumWeightByTripId(@Param("tripId") Long tripId);

        @Query("SELECT COALESCE(SUM(c.weight), 0) FROM TripContainer tc " +
                        "JOIN tc.container c " +
                        "JOIN tc.trip t " +
                        "WHERE t.status = 'on_way' AND tc.status = 'loaded'")
        BigDecimal sumWeightOfActiveTrips();

        @Query("SELECT COALESCE(SUM(c.weight), 0) FROM TripContainer tc " +
                        "JOIN tc.container c " +
                        "JOIN tc.trip t " +
                        "WHERE t.createdAt >= :startDate AND t.createdAt <= :endDate")
        BigDecimal sumWeightByTripCreatedAtBetween(
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);

        // Fix: Container entity uses containerId as PK, not id
        List<TripContainer> findByContainerContainerId(Long containerId);

        // Thêm cho ResourceController
        List<TripContainer> findByTrip_TripId(Long tripId);

        long countByTrip_TripId(Long tripId);
}
