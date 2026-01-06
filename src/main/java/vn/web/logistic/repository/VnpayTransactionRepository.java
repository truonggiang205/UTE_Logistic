package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.entity.VnpayTransaction.VnpayPaymentStatus;
import vn.web.logistic.entity.Customer;
import java.util.List;
import java.util.Optional;

@Repository
public interface VnpayTransactionRepository
                extends JpaRepository<VnpayTransaction, Long>, JpaSpecificationExecutor<VnpayTransaction> {

        // Cần cái này để filter động
        // JpaSpecificationExecutor: Là cái giúp phân trang khi filter
        // Lấy tất cả hub và sắp xếp theo tên cho người dùng dễ tìm
        /**
         * Tìm giao dịch dựa trên mã tham chiếu của VNPAY (vnp_txn_ref).
         * Rất quan trọng để kiểm tra lại trạng thái sau khi thanh toán xong.
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

        /**
         * Tìm tất cả giao dịch VNPAY của một khách hàng.
         * Đi qua thuộc tính: VnpayTransaction -> ServiceRequest (request) -> Customer.
         */
        List<VnpayTransaction> findByRequest_CustomerOrderByCreatedAtDesc(Customer customer);

        /**
         * Tìm lịch sử thanh toán cho một mã đơn hàng cụ thể.
         */
        List<VnpayTransaction> findByRequest_RequestId(Long requestId);

        /**
         * Lấy các giao dịch thành công để tính toán tổng phí đã chi trả.
         */
        List<VnpayTransaction> findByRequest_CustomerAndPaymentStatus(Customer customer, VnpayPaymentStatus status);

}