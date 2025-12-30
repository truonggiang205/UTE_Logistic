package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.CustomerAddress;

import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, Long> {

    /**
     * Lấy danh sách địa chỉ của một khách hàng
     */
    List<CustomerAddress> findByCustomerCustomerId(Long customerId);

    /**
     * Lấy địa chỉ mặc định của khách hàng
     */
    Optional<CustomerAddress> findByCustomerCustomerIdAndIsDefaultTrue(Long customerId);
}
