package vn.web.logistic.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceRequest.RequestStatus;
import vn.web.logistic.repository.projection.RevenueChartProjection;
import vn.web.logistic.repository.projection.TopPerformerProjection;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@Repository
public interface ServiceRequestRepository extends JpaRepository<ServiceRequest, Long> {

    /* =========================DASHBOARD=========================== */
    // Thẻ KPI
    // 1. Đếm theo Enum (Đếm số lượng đơn mới, hoàn thành)(2 thẻ KPI)
    long countByStatus(ServiceRequest.RequestStatus status);

    // 2. Đếm theo danh sách Enum(Đếm số đơn hàng đã hủy/ giao thất bại)(1 thẻ KPI)
    long countByStatusIn(Collection<ServiceRequest.RequestStatus> statuses);

    // 3. Tổng doanh thu (Tính tổng doanh thu từ các đơn)(1 thẻ KPI)
    @Query("SELECT COALESCE(SUM(s.totalPrice), 0) FROM ServiceRequest s WHERE s.paymentStatus = :paymentStatus")
    BigDecimal sumTotalRevenue(@Param("paymentStatus") ServiceRequest.PaymentStatus paymentStatus);

    // Biểu đồ
    // 4. Biểu đồ doanh thu(Tính tổng doanh thu theo ngày trong 7 ngày gần nhất)
    @Query("""
                SELECT
                    function('date', s.createdAt) AS date,
                    COALESCE(SUM(s.totalPrice), 0) AS revenue
                FROM ServiceRequest s
                WHERE s.createdAt >= :startDate
                  AND s.paymentStatus = :paymentStatus
                GROUP BY function('date', s.createdAt)
                ORDER BY function('date', s.createdAt)
            """)
    List<RevenueChartProjection> getRevenueLast7Days(
            @Param("startDate") LocalDateTime startDate,
            @Param("paymentStatus") ServiceRequest.PaymentStatus paymentStatus);

    // Danh sách top shipper/hub
    // 5. Top Hubs hiệu quả nhất (theo số đơn giao thành công)
    @Query("""
                SELECT
                    h.id AS id,
                    h.hubName AS name,
                    h.address AS extraInfo,
                    SUM(CASE WHEN s.status IN :successStatuses THEN 1 ELSE 0 END) AS successCount,
                    SUM(CASE WHEN s.status IN :pendingStatuses THEN 1 ELSE 0 END) AS pendingCount

                FROM ServiceRequest s
                JOIN s.currentHub h
                GROUP BY h.id, h.hubName, h.address
                ORDER BY successCount DESC
            """)
    List<TopPerformerProjection> getTopHubs(
            @Param("successStatuses") Collection<ServiceRequest.RequestStatus> successStatuses,
            @Param("pendingStatuses") Collection<ServiceRequest.RequestStatus> pendingStatuses,
            Pageable pageable);

    /* ========================= Giám sát & Báo cáo=========================== */
    // 6. Tìm đơn hàng có trạng thái KHÔNG PHẢI (delivered, cancelled, failed)
    // VÀ thời gian tạo nhỏ hơn ngưỡng thời gian (ví dụ: cách đây 3 ngày)
    @Query("SELECT r FROM ServiceRequest r WHERE r.status NOT IN (:finishedStatuses) AND r.createdAt < :thresholdDate")
    List<ServiceRequest> findStuckOrders(
            @Param("finishedStatuses") List<RequestStatus> finishedStatuses,
            @Param("thresholdDate") LocalDateTime thresholdDate);

    /* ========================= MANAGER DASHBOARD =========================== */

    // Đếm số đơn hàng theo Hub và trạng thái
    @Query("SELECT COUNT(s) FROM ServiceRequest s WHERE s.currentHub.hubId = :hubId AND s.status = :status")
    long countByHubIdAndStatus(@Param("hubId") Long hubId, @Param("status") RequestStatus status);

    // Đếm tổng số đơn hàng theo Hub
    @Query("SELECT COUNT(s) FROM ServiceRequest s WHERE s.currentHub.hubId = :hubId")
    long countByHubId(@Param("hubId") Long hubId);

    // Tìm đơn hàng theo requestId hoặc senderPhone (pickupAddress.contactPhone)
    @Query("SELECT s FROM ServiceRequest s " +
            "LEFT JOIN FETCH s.pickupAddress " +
            "LEFT JOIN FETCH s.deliveryAddress " +
            "LEFT JOIN FETCH s.currentHub " +
            "WHERE s.requestId = :requestId " +
            "   OR s.pickupAddress.contactPhone = :senderPhone")
    List<ServiceRequest> findByRequestIdOrSenderPhone(@Param("requestId") Long requestId,
            @Param("senderPhone") String senderPhone);

    // Tìm đơn hàng theo mã đơn hàng (String search)
    @Query("SELECT s FROM ServiceRequest s " +
            "LEFT JOIN FETCH s.pickupAddress " +
            "LEFT JOIN FETCH s.deliveryAddress " +
            "LEFT JOIN FETCH s.currentHub " +
            "WHERE CAST(s.requestId AS string) LIKE %:keyword% " +
            "   OR s.pickupAddress.contactPhone LIKE %:keyword%")
    List<ServiceRequest> searchByKeyword(@Param("keyword") String keyword);

    // Đếm số đơn hàng hôm nay theo Hub
    @Query("SELECT COUNT(s) FROM ServiceRequest s " +
            "WHERE s.currentHub.hubId = :hubId " +
            "AND s.createdAt >= :startOfDay")
    long countTodayOrdersByHubId(@Param("hubId") Long hubId,
            @Param("startOfDay") LocalDateTime startOfDay);

    // Lấy danh sách đơn hàng theo Hub và trạng thái (cho KPI click)
    @Query("SELECT s FROM ServiceRequest s " +
            "LEFT JOIN FETCH s.pickupAddress " +
            "LEFT JOIN FETCH s.deliveryAddress " +
            "LEFT JOIN FETCH s.currentHub " +
            "WHERE s.currentHub.hubId = :hubId AND s.status = :status " +
            "ORDER BY s.createdAt DESC")
    List<ServiceRequest> findByHubIdAndStatus(@Param("hubId") Long hubId, @Param("status") RequestStatus status);

    // Lấy tất cả đơn hàng theo Hub (cho tổng số đơn)
    @Query("SELECT s FROM ServiceRequest s " +
            "LEFT JOIN FETCH s.pickupAddress " +
            "LEFT JOIN FETCH s.deliveryAddress " +
            "LEFT JOIN FETCH s.currentHub " +
            "WHERE s.currentHub.hubId = :hubId " +
            "ORDER BY s.createdAt DESC")
    List<ServiceRequest> findAllByHubId(@Param("hubId") Long hubId);

    // Nhóm chức năng cho Inbound
    // [MẶC ĐỊNH] save(ServiceRequest entity): Lưu thông tin đơn hàng và các khoản
    // phí tính toán.
    // [MẶC ĐỊNH] findById(Long id): Lấy thông tin chi tiết đơn hàng.

    /**
     * [TÙY CHỈNH] Tìm đơn hàng bằng mã vận đơn (Tracking Code String)
     * Tác dụng: Manager quét mã tracking_code (ví dụ: 'LOG12345'), hàm này trả về
     * đơn
     * hàng tương ứng.
     * Sử dụng trong: Chức năng 2 (Nhập kho từ xe) và Chức năng 3 (Nhập kho từ
     * Shipper).
     */
    @Query("SELECT sr FROM ServiceRequest sr JOIN TrackingCode tc ON tc.request.requestId = sr.requestId WHERE tc.code = :code")
    Optional<ServiceRequest> findByTrackingCode(@Param("code") String code);

    /**
     * [TÙY CHỈNH] Tìm đơn hàng theo trạng thái và Hub hiện tại
     * Sử dụng trong: OutboundService - Lấy đơn hàng chờ đóng gói
     */
    @Query("SELECT s FROM ServiceRequest s " +
            "LEFT JOIN FETCH s.pickupAddress " +
            "LEFT JOIN FETCH s.deliveryAddress " +
            "LEFT JOIN FETCH s.currentHub " +
            "WHERE s.status IN :statuses " +
            "AND s.currentHub.hubId = :hubId " +
            // Điều kiện quan trọng: request_id không được tồn tại trong bảng
            // container_details
            "AND NOT EXISTS (SELECT 1 FROM ContainerDetail cd WHERE cd.request.requestId = s.requestId) " +
            "ORDER BY s.createdAt ASC")
    List<ServiceRequest> findOrdersForConsolidation(
            @Param("statuses") List<ServiceRequest.RequestStatus> statuses,
            @Param("hubId") Long hubId);
}