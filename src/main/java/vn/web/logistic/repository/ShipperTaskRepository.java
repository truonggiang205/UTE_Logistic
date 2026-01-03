package vn.web.logistic.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.entity.ShipperTask.TaskStatus;
import vn.web.logistic.entity.ShipperTask.TaskType;
import vn.web.logistic.repository.projection.TopPerformerProjection;

@Repository
public interface ShipperTaskRepository extends JpaRepository<ShipperTask, Long> {

        /* ========================= DASHBOARD =========================== */
        // 5. Top Shippers hiệu quả nhất (theo số đơn giao thành công)
        @Query("""
                            SELECT
                                u.userId AS id,
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
                            GROUP BY u.userId, u.fullName, u.phone
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
                        @Param("status") TaskStatus status);

        /* ========================= PHÂN CÔNG SHIPPER =========================== */
        // Kiểm tra đơn đã được gán task loại này chưa (bất kỳ trạng thái)
        boolean existsByRequestAndTaskType(ServiceRequest request, TaskType taskType);

        // Kiểm tra đơn đã có task ĐANG ACTIVE (assigned/in_progress) chưa
        @Query("SELECT CASE WHEN COUNT(t) > 0 THEN true ELSE false END " +
                        "FROM ShipperTask t " +
                        "WHERE t.request = :request " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus IN ('assigned', 'in_progress')")
        boolean existsActiveTaskByRequestAndType(
                        @Param("request") ServiceRequest request,
                        @Param("taskType") TaskType taskType);

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
                        @Param("taskType") TaskType taskType,
                        @Param("status") TaskStatus status);

        // Đếm số task đang xử lý (assigned hoặc in_progress) của shipper
        @Query("SELECT COUNT(t) FROM ShipperTask t " +
                        "WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN ('assigned', 'in_progress')")
        long countActiveTasksByShipperId(@Param("shipperId") Long shipperId);

        /* ========================= HOÀN HÀNG =========================== */
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

        /* ========================= SHIPPER DASHBOARD STATISTICS =========================== */
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay")
        Long countTodayTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay")
        Long countTodayTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus IN (:statuses)")
        Long countTasksByShipperTypeAndStatuses(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("statuses") List<TaskStatus> statuses);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN (:statuses)")
        Long countTasksByShipperAndStatuses(@Param("shipperId") Long shipperId,
                        @Param("statuses") List<TaskStatus> statuses);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfDay AND t.completedAt < :endOfDay")
        Long countCompletedTodayByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("status") TaskStatus status,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfDay AND t.completedAt < :endOfDay")
        Long countCompletedTodayByShipper(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfMonth AND t.completedAt < :endOfMonth")
        Long countCompletedMonthlyByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("status") TaskStatus status,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfMonth AND t.completedAt < :endOfMonth")
        Long countCompletedMonthlyByShipper(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfMonth AND t.assignedAt < :endOfMonth")
        Long countTotalMonthlyTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfMonth AND t.assignedAt < :endOfMonth")
        Long countTotalMonthlyTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay " +
                        "ORDER BY t.assignedAt DESC")
        List<ShipperTask> findTodayTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay " +
                        "ORDER BY t.assignedAt DESC")
        List<ShipperTask> findTodayTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId ORDER BY t.assignedAt DESC")
        List<ShipperTask> findByShipperShipperId(@Param("shipperId") Long shipperId);

        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status ORDER BY t.assignedAt DESC")
        List<ShipperTask> findByShipperShipperIdAndTaskStatus(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status);

        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN :statusList " +
                        "AND t.completedAt >= :startDate AND t.completedAt <= :endDate " +
                        "ORDER BY t.completedAt DESC")
        Page<ShipperTask> findHistoryByShipperAndStatusAndDateRange(
                        @Param("shipperId") Long shipperId,
                        @Param("statusList") List<TaskStatus> statusList,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate,
                        Pageable pageable);
}
