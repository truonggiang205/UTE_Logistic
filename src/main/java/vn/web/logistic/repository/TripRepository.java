package vn.web.logistic.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Trip;
import vn.web.logistic.entity.Trip.TripStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TripRepository extends JpaRepository<Trip, Long> {

    @Query("SELECT t FROM Trip t " +
            "LEFT JOIN FETCH t.vehicle " +
            "LEFT JOIN FETCH t.driver " +
            "LEFT JOIN FETCH t.fromHub " +
            "LEFT JOIN FETCH t.toHub " +
            "WHERE t.tripId = :tripId")
    Optional<Trip> findByIdWithDetails(@Param("tripId") Long tripId);

    @Query("SELECT t FROM Trip t " +
            "LEFT JOIN FETCH t.vehicle " +
            "LEFT JOIN FETCH t.driver " +
            "LEFT JOIN FETCH t.fromHub " +
            "LEFT JOIN FETCH t.toHub " +
            "WHERE (:fromHubId IS NULL OR t.fromHub.hubId = :fromHubId) " +
            "AND (:toHubId IS NULL OR t.toHub.hubId = :toHubId) " +
            "AND (:status IS NULL OR t.status = :status) " +
            "AND (:startDate IS NULL OR t.createdAt >= :startDate) " +
            "AND (:endDate IS NULL OR t.createdAt <= :endDate)")
    Page<Trip> findAllWithFilters(
            @Param("fromHubId") Long fromHubId,
            @Param("toHubId") Long toHubId,
            @Param("status") TripStatus status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            Pageable pageable);

    @Query("SELECT COUNT(t) FROM Trip t WHERE t.createdAt >= :startOfDay AND t.createdAt < :endOfDay")
    long countTripsToday(@Param("startOfDay") LocalDateTime startOfDay, @Param("endOfDay") LocalDateTime endOfDay);

    @Query("SELECT COUNT(t) FROM Trip t WHERE t.status IN :statuses")
    long countByStatusIn(@Param("statuses") List<TripStatus> statuses);

    @Query("SELECT COUNT(t) FROM Trip t WHERE t.status = :status AND t.createdAt >= :startDate AND t.createdAt <= :endDate")
    long countByStatusAndCreatedAtBetween(
            @Param("status") TripStatus status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(t) FROM Trip t WHERE t.status IN :statuses AND t.createdAt >= :startDate AND t.createdAt <= :endDate")
    long countByStatusInAndCreatedAtBetween(
            @Param("statuses") List<TripStatus> statuses,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query("SELECT t FROM Trip t WHERE t.status = :status")
    List<Trip> findByStatus(@Param("status") TripStatus status);
}
