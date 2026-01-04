package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.User;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    // Tìm thông tin khách hàng dựa trên tài khoản User
    Optional<Customer> findByUser(User user);
}