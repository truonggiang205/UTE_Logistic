package vn.web.logistic.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.repository.projection.TopPerformerProjection;

@Repository
public interface ShipperTaskRepository extends JpaRepository<ShipperTask, Long> {

        /* =========================DASHBOARD=========================== */
        // Danh sách top shipper/hub
        // 5. Top Shippers hiệu quả nhất (theo số đơn giao thành công)
        @Query("""
                            SELECT
                                u.id AS id,
                                u.fullName AS name,
                                u.phone AS extraInfo,
                                SUM(CASE WHEN t.taskStatus = vn.web.logistic.entity.ShipperTask.TaskStatus.completed THEN 1 ELSE 0 END) AS successCount,
                                SUM(CASE WHEN t.taskStatus IN (
                                    vn.web.logistic.entity.ShipperTask.TaskStatus.assigned,
                                    vn.web.logistic.entity.ShipperTask.TaskStatus.in_progress
                                ) THEN 1 ELSE 0 END) AS pendingCount

                            FROM ShipperTask t
                            JOIN t.shipper s
                            JOIN s.user u
                            GROUP BY u.id, u.fullName, u.phone
                            ORDER BY successCount DESC
                        """)
        List<TopPerformerProjection> getTopShippers(Pageable pageable);

        /* ========================= MANAGER DASHBOARD =========================== */

        // Đếm số task hôm nay theo Hub (của các shipper thuộc Hub)
        @Query("SELECT COUNT(t) FROM ShipperTask t " +
                        "JOIN t.shipper s " +
                        "WHERE s.hub.hubId = :hubId " +
                        "AND t.assignedAt >= :startOfDay")
        long countTodayTasksByHubId(@Param("hubId") Long hubId,
                        @Param("startOfDay") LocalDateTime startOfDay);

        // Đếm số task theo trạng thái và Hub
        @Query("SELECT COUNT(t) FROM ShipperTask t " +
                        "JOIN t.shipper s " +
                        "WHERE s.hub.hubId = :hubId " +
                        "AND t.taskStatus = :status")
        long countByHubIdAndStatus(@Param("hubId") Long hubId,
                        @Param("status") ShipperTask.TaskStatus status);

        // Đếm số task đang xử lý (assigned hoặc in_progress) của shipper
        @Query("SELECT COUNT(t) FROM ShipperTask t " +
                        "WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN ('assigned', 'in_progress')")
        long countActiveTasksByShipperId(@Param("shipperId") Long shipperId);
}