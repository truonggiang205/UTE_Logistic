package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.dto.response.WarningResponse.HighDebtShipperDTO;
import vn.web.logistic.entity.CodTransaction;

import java.math.BigDecimal;
import java.util.List;

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
}