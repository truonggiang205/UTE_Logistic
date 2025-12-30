package vn.web.logistic.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.entity.ShipperTask.TaskStatus;
import vn.web.logistic.entity.ShipperTask.TaskType;
import vn.web.logistic.repository.projection.TopPerformerProjection;

@Repository
public interface ShipperTaskRepository extends JpaRepository<ShipperTask, Long> {

        // DASHBOARD
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

        // SHIPPER DASHBOARD STATISTICS

        // Đếm số đơn hàng được giao cho shipper hôm nay theo loại task
        // (pickup/delivery)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay")
        Long countTodayTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Đếm tổng số đơn hôm nay (không phân biệt loại)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay")
        Long countTodayTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Đếm số đơn đang giao (assigned hoặc in_progress) theo loại task
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus IN (:statuses)")
        Long countTasksByShipperTypeAndStatuses(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("statuses") List<TaskStatus> statuses);

        // Đếm số đơn đang giao (không phân biệt loại)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN (:statuses)")
        Long countTasksByShipperAndStatuses(@Param("shipperId") Long shipperId,
                        @Param("statuses") List<TaskStatus> statuses);

        // Đếm số đơn đã hoàn thành hôm nay theo loại task
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfDay AND t.completedAt < :endOfDay")
        Long countCompletedTodayByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("status") TaskStatus status,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Đếm số đơn đã hoàn thành hôm nay (không phân biệt loại)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfDay AND t.completedAt < :endOfDay")
        Long countCompletedTodayByShipper(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Đếm tổng số đơn đã hoàn thành trong tháng theo loại task
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfMonth AND t.completedAt < :endOfMonth")
        Long countCompletedMonthlyByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("status") TaskStatus status,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        // Đếm tổng số đơn đã hoàn thành trong tháng (không phân biệt loại)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status " +
                        "AND t.completedAt >= :startOfMonth AND t.completedAt < :endOfMonth")
        Long countCompletedMonthlyByShipper(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        // Đếm tổng số đơn được giao trong tháng theo loại task (để tính tỉ lệ thành
        // công)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfMonth AND t.assignedAt < :endOfMonth")
        Long countTotalMonthlyTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        // Đếm tổng số đơn được giao trong tháng (không phân biệt loại) (để tính tỉ lệ
        // thành công)
        @Query("SELECT COUNT(t) FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfMonth AND t.assignedAt < :endOfMonth")
        Long countTotalMonthlyTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfMonth") LocalDateTime startOfMonth,
                        @Param("endOfMonth") LocalDateTime endOfMonth);

        // Lấy danh sách task hôm nay của shipper theo loại
        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskType = :taskType " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay " +
                        "ORDER BY t.assignedAt DESC")
        List<ShipperTask> findTodayTasksByShipperAndType(@Param("shipperId") Long shipperId,
                        @Param("taskType") TaskType taskType,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Lấy danh sách tất cả task hôm nay của shipper
        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.assignedAt >= :startOfDay AND t.assignedAt < :endOfDay " +
                        "ORDER BY t.assignedAt DESC")
        List<ShipperTask> findTodayTasksByShipper(@Param("shipperId") Long shipperId,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Lấy tất cả task của shipper (không giới hạn thời gian)
        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId ORDER BY t.assignedAt DESC")
        List<ShipperTask> findByShipperShipperId(@Param("shipperId") Long shipperId);

        // Lấy task của shipper theo status (cho trang Đang giao hàng)
        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus = :status ORDER BY t.assignedAt DESC")
        List<ShipperTask> findByShipperShipperIdAndTaskStatus(@Param("shipperId") Long shipperId,
                        @Param("status") TaskStatus status);

        // Lấy lịch sử đơn hàng (completed/failed) với filter theo ngày và phân trang
        @Query("SELECT t FROM ShipperTask t WHERE t.shipper.shipperId = :shipperId " +
                        "AND t.taskStatus IN :statusList " +
                        "AND t.completedAt >= :startDate AND t.completedAt <= :endDate " +
                        "ORDER BY t.completedAt DESC")
        org.springframework.data.domain.Page<ShipperTask> findHistoryByShipperAndStatusAndDateRange(
                        @Param("shipperId") Long shipperId,
                        @Param("statusList") List<TaskStatus> statusList,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate,
                        org.springframework.data.domain.Pageable pageable);
}
