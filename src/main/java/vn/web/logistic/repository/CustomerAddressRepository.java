package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;

import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, Long> {

    /**
     * Hàm: findByCustomer_CustomerId
     * Tác dụng: Lấy tất cả địa chỉ mà khách hàng này từng sử dụng.
     * Sử dụng trong: Sau khi tìm thấy Customer qua SĐT, gọi hàm này để hiển thị
     * một danh sách (Dropdown hoặc Table) trên giao diện cho Manager chọn.
     */
    List<CustomerAddress> findByCustomer_CustomerId(Long customerId);

    // [GIỮ NGUYÊN] Dùng để kiểm tra xem địa chỉ nhập mới có thực sự "mới" không hay
    // trùng địa chỉ cũ
    Optional<CustomerAddress> findByCustomerAndAddressDetailAndWardAndDistrictAndProvince(
            Customer customer, String addressDetail, String ward, String district, String province);

    /**
     * Lấy danh sách địa chỉ của một khách hàng
     */
    List<CustomerAddress> findByCustomerCustomerId(Long customerId);

    /**
     * Lấy địa chỉ mặc định của khách hàng
     */
    Optional<CustomerAddress> findByCustomerCustomerIdAndIsDefaultTrue(Long customerId);
}
