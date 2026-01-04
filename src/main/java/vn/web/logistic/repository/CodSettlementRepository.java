package vn.web.logistic.repository;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.Shipper;

/**
 * Repository cho nghiệp vụ Quyết toán COD
 * 
 * FLOW COD:
 * 1. pending: Shipper giao hàng xong, đang giữ tiền, CHƯA NỘP về bưu cục
 * 2. collected: Shipper ĐÃ NỘP tiền về bưu cục, chờ Manager duyệt
 * 3. settled: Manager đã duyệt, hoàn tất quyết toán
 */
@Repository
public interface CodSettlementRepository extends JpaRepository<CodTransaction, Long> {

        // ==================== SHIPPER ĐÃ NỘP, CHỜ DUYỆT (collected) ====================
        
        // Lấy danh sách Shipper có COD đã nộp, chờ duyệt trong Hub
        @Query("SELECT DISTINCT c.shipper FROM CodTransaction c WHERE c.status = 'collected' AND c.shipper.hub.hubId = :hubId")
        List<Shipper> findShippersWithPendingCodByHubId(@Param("hubId") Long hubId);

        // Lấy chi tiết COD đã nộp, chờ duyệt của một Shipper
        @Query("SELECT c FROM CodTransaction c JOIN FETCH c.request r JOIN FETCH c.shipper s JOIN FETCH s.user u WHERE c.shipper.shipperId = :shipperId AND c.status = 'collected' ORDER BY c.collectedAt ASC")
        List<CodTransaction> findCollectedByShipperId(@Param("shipperId") Long shipperId);

        // Tổng tiền COD đã nộp, chờ duyệt
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c WHERE c.shipper.shipperId = :shipperId AND c.status = 'collected'")
        BigDecimal sumCollectedByShipperId(@Param("shipperId") Long shipperId);

        // Đếm số đơn COD đã nộp, chờ duyệt
        @Query("SELECT COUNT(c) FROM CodTransaction c WHERE c.shipper.shipperId = :shipperId AND c.status = 'collected'")
        Long countCollectedByShipperId(@Param("shipperId") Long shipperId);

        // ==================== LỊCH SỬ ĐÃ QUYẾT TOÁN (settled) ====================

        // Lấy lịch sử quyết toán của Shipper
        @Query("SELECT c FROM CodTransaction c JOIN FETCH c.request r JOIN FETCH c.shipper s WHERE c.shipper.shipperId = :shipperId AND c.status = 'settled' ORDER BY c.settledAt DESC")
        List<CodTransaction> findSettledByShipperId(@Param("shipperId") Long shipperId);

        // ==================== THỐNG KÊ HUB ====================

        // Tổng tiền COD đã nộp, chờ duyệt trong Hub (collected)
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c JOIN c.shipper s WHERE c.status = 'collected' AND s.hub.hubId = :hubId")
        BigDecimal sumCollectedCodByHubId(@Param("hubId") Long hubId);

        // Đếm số đơn COD đã nộp, chờ duyệt trong Hub (collected)
        @Query("SELECT COUNT(c) FROM CodTransaction c JOIN c.shipper s WHERE c.status = 'collected' AND s.hub.hubId = :hubId")
        Long countCollectedCodByHubId(@Param("hubId") Long hubId);

        // Tổng tiền quyết toán hôm nay trong Hub (bao gồm cả COD shipper và counter pickup)
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "LEFT JOIN c.shipper s " +
                        "LEFT JOIN c.request r " +
                        "WHERE c.status = 'settled' " +
                        "AND FUNCTION('DATE', c.settledAt) = CURRENT_DATE " +
                        "AND (s.hub.hubId = :hubId OR (c.shipper IS NULL AND r.currentHub.hubId = :hubId))")
        BigDecimal sumSettledTodayByHubId(@Param("hubId") Long hubId);

        // Tổng tiền pending (shipper đang giữ, chưa nộp) trong Hub
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c JOIN c.shipper s WHERE c.status = 'pending' AND s.hub.hubId = :hubId")
        BigDecimal sumPendingCodByHubId(@Param("hubId") Long hubId);

        // Tổng doanh thu đã settled trong Hub (bao gồm cả COD shipper và COD counter pickup)
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "LEFT JOIN c.shipper s " +
                        "LEFT JOIN c.request r " +
                        "WHERE c.status = 'settled' " +
                        "AND (s.hub.hubId = :hubId OR (c.shipper IS NULL AND r.currentHub.hubId = :hubId))")
        BigDecimal sumTotalSettledByHubId(@Param("hubId") Long hubId);
}
