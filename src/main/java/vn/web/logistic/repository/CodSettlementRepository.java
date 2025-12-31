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
 * Quyết Toán COD của Manager.
 */
@Repository
public interface CodSettlementRepository extends JpaRepository<CodTransaction, Long> {

    // LẤY DANH SÁCH SHIPPER CÓ COD CHỜ QUYẾT TOÁN

    /**
     * Lấy danh sách Shipper có COD đã thu (collected) nhưng chưa quyết toán trong
     * Hub.
     * 
     * @param hubId ID của Hub mà Manager quản lý
     * @return Danh sách Shipper có COD chờ quyết toán
     */
    @Query("SELECT DISTINCT c.shipper FROM CodTransaction c " +
            "WHERE c.status = 'collected' " +
            "AND c.shipper.hub.hubId = :hubId")
    List<Shipper> findShippersWithPendingCodByHubId(@Param("hubId") Long hubId);

    // LẤY CHI TIẾT COD CỦA SHIPPER

    /**
     * Lấy danh sách COD đã thu (collected) của một Shipper - sắp xếp theo thời gian
     * thu.
     * Dùng để hiển thị chi tiết các đơn COD cần quyết toán.
     * 
     * @param shipperId ID của Shipper
     * @return Danh sách CodTransaction với trạng thái collected
     */
    @Query("SELECT c FROM CodTransaction c " +
            "JOIN FETCH c.request r " +
            "JOIN FETCH c.shipper s " +
            "JOIN FETCH s.user u " +
            "WHERE c.shipper.shipperId = :shipperId " +
            "AND c.status = 'collected' " +
            "ORDER BY c.collectedAt ASC")
    List<CodTransaction> findCollectedByShipperId(@Param("shipperId") Long shipperId);

    // ===================== THỐNG KÊ COD CỦA SHIPPER =====================

    /**
     * Tính tổng tiền COD đã thu (collected) của một Shipper.
     * 
     * @param shipperId ID của Shipper
     * @return Tổng số tiền COD đã thu
     */
    @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
            "WHERE c.shipper.shipperId = :shipperId " +
            "AND c.status = 'collected'")
    BigDecimal sumCollectedByShipperId(@Param("shipperId") Long shipperId);

    /**
     * Đếm số đơn COD đã thu (collected) của một Shipper.
     * 
     * @param shipperId ID của Shipper
     * @return Số lượng đơn COD đã thu
     */
    @Query("SELECT COUNT(c) FROM CodTransaction c " +
            "WHERE c.shipper.shipperId = :shipperId " +
            "AND c.status = 'collected'")
    Long countCollectedByShipperId(@Param("shipperId") Long shipperId);

    // ===================== LỊCH SỬ QUYẾT TOÁN =====================

    /**
     * Lấy danh sách COD đã quyết toán (settled) của một Shipper - sắp xếp theo thời
     * gian quyết toán.
     * Dùng để xem lịch sử quyết toán.
     * 
     * @param shipperId ID của Shipper
     * @return Danh sách CodTransaction đã quyết toán
     */
    @Query("SELECT c FROM CodTransaction c " +
            "JOIN FETCH c.request r " +
            "JOIN FETCH c.shipper s " +
            "WHERE c.shipper.shipperId = :shipperId " +
            "AND c.status = 'settled' " +
            "ORDER BY c.settledAt DESC")
    List<CodTransaction> findSettledByShipperId(@Param("shipperId") Long shipperId);

    // ===================== THỐNG KÊ THEO HUB =====================

    /**
     * Tính tổng tiền COD đã thu (collected) trong Hub - shipper đang nợ.
     * 
     * @param hubId ID của Hub
     * @return Tổng số tiền COD shipper đang giữ
     */
    @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
            "JOIN c.shipper s " +
            "WHERE c.status = 'collected' " +
            "AND s.hub.hubId = :hubId")
    BigDecimal sumCollectedCodByHubId(@Param("hubId") Long hubId);

    /**
     * Đếm số đơn COD đã thu (collected) trong Hub.
     * 
     * @param hubId ID của Hub
     * @return Số lượng đơn COD shipper đang giữ
     */
    @Query("SELECT COUNT(c) FROM CodTransaction c " +
            "JOIN c.shipper s " +
            "WHERE c.status = 'collected' " +
            "AND s.hub.hubId = :hubId")
    Long countCollectedCodByHubId(@Param("hubId") Long hubId);

    // ===================== THỐNG KÊ QUYẾT TOÁN HÔM NAY =====================

    /**
     * Tính tổng tiền COD đã quyết toán trong ngày hôm nay của Hub.
     * 
     * @param hubId ID của Hub
     * @return Tổng số tiền COD đã quyết toán hôm nay
     */
    @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
            "JOIN c.shipper s " +
            "WHERE c.status = 'settled' " +
            "AND s.hub.hubId = :hubId " +
            "AND FUNCTION('DATE', c.settledAt) = CURRENT_DATE")
    BigDecimal sumSettledTodayByHubId(@Param("hubId") Long hubId);
}
