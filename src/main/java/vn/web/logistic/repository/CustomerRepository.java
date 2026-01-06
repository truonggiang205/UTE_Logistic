package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Customer;

import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    // ========Các phương thức dùng cho Inbound
    // [MẶC ĐỊNH] save(Customer entity): Dùng để thêm mới hoặc cập nhật khách hàng.
    // [MẶC ĐỊNH] findById(Long id): Tìm khách hàng theo khóa chính customer_id.

    // [TÙY CHỈNH] Tìm khách hàng qua số điện thoại để kiểm tra tồn tại
    // (Dùng cho logic 1.1)
    Optional<Customer> findByPhone(String phone);

    // Nếu dữ liệu đã lỡ có trùng SĐT, lấy bản ghi "đầu tiên" để dùng ổn định
    Optional<Customer> findFirstByPhoneOrderByCustomerIdAsc(String phone);

    // Tìm Customer theo email
    Optional<Customer> findByEmail(String email);

    // Tìm Customer theo User ID
    Optional<Customer> findByUserUserId(Long userId);
}
