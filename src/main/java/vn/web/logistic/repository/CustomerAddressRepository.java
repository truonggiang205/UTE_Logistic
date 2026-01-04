package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, Long> {
    List<CustomerAddress> findByCustomer(Customer customer);
    
    List<CustomerAddress> findByCustomerAndIsDefaultTrue(Customer customer);
    
    List<CustomerAddress> findByCustomerOrderByAddressIdDesc(Customer customer);
    
    // SỬA TẠI ĐÂY: Đổi receiverName -> contactName và phone -> contactPhone
    @Query("SELECT a FROM CustomerAddress a WHERE a.customer = :customer AND " +
           "(a.contactName LIKE %:q% OR a.contactPhone LIKE %:q% OR a.addressDetail LIKE %:q%)")
    List<CustomerAddress> searchByCustomer(@Param("customer") Customer customer, @Param("q") String q);

    // Phương thức này đã đúng với Entity contactPhone
    Optional<CustomerAddress> findByCustomerAndContactPhoneAndAddressDetail(
        Customer customer, 
        String contactPhone, 
        String addressDetail
    );
    
 // Lấy danh sách địa chỉ khách hàng (is_default = 0) và sắp xếp mới nhất lên đầu
    List<CustomerAddress> findByCustomerAndIsDefaultFalseOrderByAddressIdDesc(Customer customer);
}