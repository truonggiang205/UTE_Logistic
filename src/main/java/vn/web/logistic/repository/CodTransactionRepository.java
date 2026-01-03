package vn.web.logistic.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.dto.response.admin.HighDebtShipperDTO;
import vn.web.logistic.entity.CodTransaction;

@Repository
public interface CodTransactionRepository extends
                JpaRepository<CodTransaction, Long>,
                JpaSpecificationExecutor<CodTransaction> {

        // 1. Tính tổng tiền Shipper đang giữ (Status = collected)
        // Dùng JPQL để tính tổng nhanh DB
        @Query("SELECT SUM(c.amount) FROM CodTransaction c " +
                        "WHERE c.status = 'collected' " +
                        "AND (:shipperId IS NULL OR c.shipper.shipperId = :shipperId)")
        BigDecimal sumHoldingAmountByShipper(@Param("shipperId") Long shipperId);

        // 2. [Chức năng 5] Cảnh báo Shipper nợ COD theo 3 mức:
        // - Nợ > 10 triệu VÀ quá 2 ngày
        // - HOẶC Nợ > 2 triệu VÀ quá 3 ngày
        // - HOẶC chưa nộp COD sau 7 ngày (bất kể số tiền)

        // Query 1: Nợ > 10 triệu VÀ quá 2 ngày
        @Query("SELECT new vn.web.logistic.dto.response.admin.HighDebtShipperDTO(" +
                        "  t.shipper.shipperId, " +
                        "  t.shipper.user.fullName, " +
                        "  t.shipper.user.phone, " +
                        "  SUM(t.amount) " +
                        ") " +
                        "FROM CodTransaction t " +
                        "WHERE t.status = 'collected' " +
                        "AND t.collectedAt < :twoDaysAgo " +
                        "GROUP BY t.shipper.shipperId, t.shipper.user.fullName, t.shipper.user.phone " +
                        "HAVING SUM(t.amount) > :highLimit")
        List<HighDebtShipperDTO> findHighDebtOver10M(
                        @Param("highLimit") BigDecimal highLimit,
                        @Param("twoDaysAgo") LocalDateTime twoDaysAgo);

        // Query 2: Nợ > 2 triệu VÀ quá 3 ngày
        @Query("SELECT new vn.web.logistic.dto.response.admin.HighDebtShipperDTO(" +
                        "  t.shipper.shipperId, " +
                        "  t.shipper.user.fullName, " +
                        "  t.shipper.user.phone, " +
                        "  SUM(t.amount) " +
                        ") " +
                        "FROM CodTransaction t " +
                        "WHERE t.status = 'collected' " +
                        "AND t.collectedAt < :threeDaysAgo " +
                        "GROUP BY t.shipper.shipperId, t.shipper.user.fullName, t.shipper.user.phone " +
                        "HAVING SUM(t.amount) > :mediumLimit")
        List<HighDebtShipperDTO> findMediumDebtOver2M(
                        @Param("mediumLimit") BigDecimal mediumLimit,
                        @Param("threeDaysAgo") LocalDateTime threeDaysAgo);

        // Query 3: Chưa nộp COD quá 7 ngày (bất kể số tiền)
        @Query("SELECT new vn.web.logistic.dto.response.admin.HighDebtShipperDTO(" +
                        "  t.shipper.shipperId, " +
                        "  t.shipper.user.fullName, " +
                        "  t.shipper.user.phone, " +
                        "  SUM(t.amount) " +
                        ") " +
                        "FROM CodTransaction t " +
                        "WHERE t.status = 'collected' " +
                        "AND t.collectedAt < :sevenDaysAgo " +
                        "GROUP BY t.shipper.shipperId, t.shipper.user.fullName, t.shipper.user.phone " +
                        "HAVING SUM(t.amount) > 0")
        List<HighDebtShipperDTO> findOverdueOver7Days(
                        @Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);

        // ==================== MANAGER DASHBOARD ====================

        // Tính tổng tiền COD đang pending theo Hub (Shipper thuộc Hub đó)
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "JOIN c.shipper s " +
                        "WHERE c.status = 'pending' " +
                        "AND s.hub.hubId = :hubId")
        BigDecimal sumPendingCodByHubId(@Param("hubId") Long hubId);

        // Tính tổng tiền COD đã thu (collected) theo Hub
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "JOIN c.shipper s " +
                        "WHERE c.status = 'collected' " +
                        "AND s.hub.hubId = :hubId")
        BigDecimal sumCollectedCodByHubId(@Param("hubId") Long hubId);

<<<<<<< HEAD
        // Xóa tất cả giao dịch COD của một đơn hàng
        void deleteByRequest_RequestId(Long requestId);

        // [MẶC ĐỊNH] save(CodTransaction entity): Lưu giao dịch thu tiền tại quầy hoặc
        // thu tiền hộ.
=======
        // Đếm số COD còn pending (chưa thu) của shipper
        @Query("SELECT COUNT(c) FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = 'pending'")
        long countPendingByShipperId(@Param("shipperId") Long shipperId);

        // Tính tổng tiền COD còn pending của shipper
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = 'pending'")
        BigDecimal sumPendingByShipperId(@Param("shipperId") Long shipperId);
>>>>>>> refs/heads/fea/test-security
}