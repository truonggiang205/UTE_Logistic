package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.entity.VnpayTransaction.VnpayPaymentStatus;

@Repository
public interface VnpayTransactionRepository extends
                JpaRepository<VnpayTransaction, Long>,
                JpaSpecificationExecutor<VnpayTransaction> {
        // Cần cái này để filter động
        // JpaSpecificationExecutor: Là cái giúp phân trang khi filter
        // Lấy tất cả hub và sắp xếp theo tên cho người dùng dễ tìm

        /**
         * Tìm giao dịch theo mã tham chiếu VNPAY
         */
        Optional<VnpayTransaction> findByVnpTxnRef(String vnpTxnRef);

        /**
         * Tìm giao dịch theo mã giao dịch VNPAY
         */
        Optional<VnpayTransaction> findByVnpTransactionNo(String vnpTransactionNo);

        /**
         * Tìm giao dịch pending mới nhất theo requestId
         */
        Optional<VnpayTransaction> findTopByRequest_RequestIdAndPaymentStatusOrderByCreatedAtDesc(
                        Long requestId, VnpayPaymentStatus paymentStatus);
}