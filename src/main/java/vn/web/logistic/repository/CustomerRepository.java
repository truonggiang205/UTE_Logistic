package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Customer;

import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    /**
     * Tìm Customer theo số điện thoại
     */
    Optional<Customer> findByPhone(String phone);

    /**
     * Tìm Customer theo email
     */
    Optional<Customer> findByEmail(String email);

    /**
     * Tìm Customer theo User ID
     */
    Optional<Customer> findByUserUserId(Long userId);
}
