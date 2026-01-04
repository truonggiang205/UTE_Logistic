package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.User;
import vn.web.logistic.enums.PaymentStatus;
import vn.web.logistic.enums.RequestStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ServiceRequestRepository extends JpaRepository<ServiceRequest, Long> {

	// 1. Đếm số lượng đơn theo trạng thái
	long countByCustomerAndStatus(Customer customer, RequestStatus status);

	// 2. Tính tổng tiền COD (Thu hộ)
	@Query("SELECT SUM(s.codAmount) FROM ServiceRequest s WHERE s.customer = :customer AND s.status = :status")
	BigDecimal sumCodAmountByCustomerAndStatus(@Param("customer") Customer customer,
			@Param("status") RequestStatus status);

	// 3. Tính tổng phí vận chuyển (Cho thẻ Phí vận chuyển)
	@Query("SELECT SUM(s.shippingFee) FROM ServiceRequest s WHERE s.customer = :customer AND s.status != 'cancelled'")
	BigDecimal sumTotalShippingFee(@Param("customer") Customer customer);

	// 4. Tính tỷ lệ đơn thành công / đơn lỗi cho biểu đồ
	long countByCustomer(Customer customer);

	@Query(value = "SELECT DATE(s.created_at) as date, COUNT(*) as total_orders, SUM(s.cod_amount) as total_cod "
			+ "FROM service_requests s "
			+ "WHERE s.customer_id = :customerId AND s.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) "
			+ "GROUP BY DATE(s.created_at) " + "ORDER BY DATE(s.created_at) ASC", nativeQuery = true)
	List<Object[]> getDailyStatsLast7Days(@Param("customerId") Long customerId);

	// Lấy đơn hàng theo Customer và trạng thái cụ thể
	List<ServiceRequest> findByCustomerAndStatusOrderByCreatedAtDesc(Customer customer, String status);

	// Tham số thứ 2 phải là RequestStatus, không phải String
	List<ServiceRequest> findByCustomerAndStatusOrderByCreatedAtDesc(Customer customer, RequestStatus status);

	List<ServiceRequest> findByCustomerAndStatusInOrderByCreatedAtDesc(Customer customer, List<RequestStatus> statuses);

	List<ServiceRequest> findByCustomerOrderByCreatedAtDesc(Customer customer);

	List<ServiceRequest> findByCustomerAndStatusAndPaymentStatus(Customer customer, RequestStatus status, PaymentStatus unpaid);
	
	@Query("SELECT s FROM ServiceRequest s WHERE s.customer = :customer " +
	           "AND (:status IS NULL OR s.status = :status) " +
	           "AND (:requestId IS NULL OR s.requestId = :requestId) " +
	           "AND (s.createdAt BETWEEN :startDate AND :endDate) " +
	           "ORDER BY s.createdAt DESC")
	    List<ServiceRequest> searchOrders(
	        @Param("customer") Customer customer,
	        @Param("status") RequestStatus status,
	        @Param("requestId") Long requestId,
	        @Param("startDate") LocalDateTime startDate,
	        @Param("endDate") LocalDateTime endDate
	    );
}