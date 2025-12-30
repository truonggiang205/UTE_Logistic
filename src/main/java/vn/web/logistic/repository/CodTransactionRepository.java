package vn.web.logistic.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.dto.response.WarningResponse.HighDebtShipperDTO;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.CodTransaction.CodStatus;

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

        // 2. [Chức năng 5]Group by Shipper, tính tổng tiền, lọc những ai > limit
        @Query("SELECT new vn.web.logistic.dto.response.WarningResponse$HighDebtShipperDTO(" +
                        "  t.shipper.shipperId, " +
                        "  t.shipper.user.fullName, " +
                        "  t.shipper.user.phone, " +
                        "  SUM(t.amount) " +
                        ") " +
                        "FROM CodTransaction t " +
                        "WHERE t.status = 'pending' " +
                        "GROUP BY t.shipper.shipperId, t.shipper.user.fullName, t.shipper.user.phone " +
                        "HAVING SUM(t.amount) > :debtLimit")
        List<HighDebtShipperDTO> findHighDebtShippers(@Param("debtLimit") BigDecimal debtLimit);

        // STATICTIS SHIPPER
        // Tính tổng tiền COD chưa nộp của shipper (status = collected)
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = :status")
        BigDecimal sumCodByShipperAndStatus(@Param("shipperId") Long shipperId,
                        @Param("status") CodStatus status);

        // Tính tổng tiền COD đã nộp hôm nay của shipper
        @Query("SELECT COALESCE(SUM(c.amount), 0) FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = :status " +
                        "AND c.settledAt >= :startOfDay AND c.settledAt < :endOfDay")
        BigDecimal sumCodSettledTodayByShipper(@Param("shipperId") Long shipperId,
                        @Param("status") CodStatus status,
                        @Param("startOfDay") LocalDateTime startOfDay,
                        @Param("endOfDay") LocalDateTime endOfDay);

        // Đếm số đơn COD chưa nộp của shipper

        @Query("SELECT COUNT(c) FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = :status")
        Long countCodByShipperAndStatus(@Param("shipperId") Long shipperId,
                        @Param("status") CodStatus status);

        // Lấy danh sách COD transactions chưa nộp (collected) của shipper
        @Query("SELECT c FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = :status " +
                        "ORDER BY c.collectedAt DESC")
        List<CodTransaction> findByShipperIdAndStatus(@Param("shipperId") Long shipperId,
                        @Param("status") CodStatus status);

        // Lấy danh sách COD đã xác nhận (settled)
        @Query("SELECT c FROM CodTransaction c " +
                        "WHERE c.shipper.shipperId = :shipperId " +
                        "AND c.status = 'settled' " +
                        "ORDER BY c.settledAt DESC")
        List<CodTransaction> findSettledByShipperId(@Param("shipperId") Long shipperId);
}
