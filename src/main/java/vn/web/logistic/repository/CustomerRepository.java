package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.Customer.CustomerStatus;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    // ========Các phương thức dùng cho Inbound
    // [MẶC ĐỊNH] save(Customer entity): Dùng để thêm mới hoặc cập nhật khách hàng.
    // [MẶC ĐỊNH] findById(Long id): Tìm khách hàng theo khóa chính customer_id.

    // [TÙY CHỈNH] Tìm khách hàng qua số điện thoại để kiểm tra tồn tại
    // (Dùng cho logic 1.1)
    Optional<Customer> findByPhone(String phone);

    // Tìm Customer theo email
    Optional<Customer> findByEmail(String email);

    // Tìm Customer theo User ID
    Optional<Customer> findByUserUserId(Long userId);

    // =============== Admin CRUD Methods ===============

    // Lấy Customer với eager loading User
    @Query("SELECT c FROM Customer c LEFT JOIN FETCH c.user WHERE c.customerId = :id")
    Optional<Customer> findByIdWithUser(@Param("id") Long id);

    // Tìm kiếm Customer với filter và phân trang
    @Query(value = "SELECT c FROM Customer c LEFT JOIN c.user u WHERE " +
            "(:status IS NULL OR c.status = :status) " +
            "AND (:keyword IS NULL OR :keyword = '' OR " +
            "     LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "     LOWER(c.businessName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "     LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "     LOWER(c.phone) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "     LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')))", countQuery = "SELECT COUNT(c) FROM Customer c LEFT JOIN c.user u WHERE "
                    +
                    "(:status IS NULL OR c.status = :status) " +
                    "AND (:keyword IS NULL OR :keyword = '' OR " +
                    "     LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                    "     LOWER(c.businessName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                    "     LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                    "     LOWER(c.phone) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                    "     LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Customer> findWithFilters(
            @Param("status") CustomerStatus status,
            @Param("keyword") String keyword,
            Pageable pageable);

    // Đếm số customer theo status
    long countByStatus(CustomerStatus status);
}
