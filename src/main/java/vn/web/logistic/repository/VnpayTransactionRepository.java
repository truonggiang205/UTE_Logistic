package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.enums.VnpayPaymentStatus;
import vn.web.logistic.entity.Customer;
import java.util.List;
import java.util.Optional;

@Repository
public interface VnpayTransactionRepository extends JpaRepository<VnpayTransaction, Long> {

    /**
     * Tìm tất cả giao dịch VNPAY của một khách hàng.
     * Đi qua thuộc tính: VnpayTransaction -> ServiceRequest (request) -> Customer.
     */
    List<VnpayTransaction> findByRequest_CustomerOrderByCreatedAtDesc(Customer customer);

    /**
     * Tìm giao dịch dựa trên mã tham chiếu của VNPAY (vnp_txn_ref).
     * Rất quan trọng để kiểm tra lại trạng thái sau khi thanh toán xong.
     */
    Optional<VnpayTransaction> findByVnpTxnRef(String vnpTxnRef);

    /**
     * Tìm lịch sử thanh toán cho một mã đơn hàng cụ thể.
     */
    List<VnpayTransaction> findByRequest_RequestId(Long requestId);
    
    /**
     * Lấy các giao dịch thành công để tính toán tổng phí đã chi trả.
     */
    List<VnpayTransaction> findByRequest_CustomerAndPaymentStatus(Customer customer, VnpayPaymentStatus status);
}