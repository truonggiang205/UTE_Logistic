package vn.web.logistic.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ServiceRequest;
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

<<<<<<< HEAD
}
=======
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

        /* ========================= PHÂN CÔNG SHIPPER =========================== */

        // Kiểm tra đơn đã được gán task loại này chưa (bất kỳ trạng thái)
        boolean existsByRequestAndTaskType(
                        vn.web.logistic.entity.ServiceRequest request,
                        ShipperTask.TaskType taskType);

        // Kiểm tra đơn đã có task ĐANG ACTIVE (assigned/in_progress) chưa
        // Dùng để cho phép phân công lại khi task cũ đã failed
        @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END " +
                        "FROM ShipperTask t " +
                        "WHERE t.request = :request " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus IN ('assigned', 'in_progress')")
        boolean existsActiveTaskByRequestAndType(
                        @Param("request") ServiceRequest request,
                        @Param("taskType") ShipperTask.TaskType taskType);

        // Lấy danh sách task của shipper theo taskType và status
        @Query("SELECT t FROM ShipperTask t " +
                        "JOIN FETCH t.request r " +
                        "JOIN FETCH r.pickupAddress " +
                        "JOIN FETCH r.deliveryAddress " +
                        "WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus = :status")
        List<ShipperTask> findByShipperAndTypeAndStatus(
                        @Param("shipperId") Long shipperId,
                        @Param("taskType") ShipperTask.TaskType taskType,
                        @Param("status") ShipperTask.TaskStatus status);

        // HOÀN HÀNG
        // Đếm số lần giao thất bại của một đơn hàng
        @Query("SELECT COUNT(t) FROM ShipperTask t " +
                        "WHERE t.request.requestId = :requestId " +
                        "AND t.taskType = 'delivery' " +
                        "AND t.taskStatus = 'failed'")
        long countFailedDeliveryByRequestId(@Param("requestId") Long requestId);

        // Lấy danh sách requestId có >= 3 lần giao thất bại
        @Query("SELECT t.request.requestId FROM ShipperTask t " +
                        "WHERE t.taskType = 'delivery' " +
                        "AND t.taskStatus = 'failed' " +
                        "GROUP BY t.request.requestId " +
                        "HAVING COUNT(t) >= 3")
        List<Long> findRequestIdsWithFailedDeliveries();

        // Tìm tất cả task của một đơn hàng theo requestId
        List<ShipperTask> findByRequestRequestId(Long requestId);
}
>>>>>>> refs/heads/fea/test-security
