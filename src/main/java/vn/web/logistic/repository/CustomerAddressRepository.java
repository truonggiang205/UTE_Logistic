package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;

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
                        String addressDetail);

        // Lấy danh sách địa chỉ khách hàng (is_default = 0) và sắp xếp mới nhất lên đầu
        List<CustomerAddress> findByCustomerAndIsDefaultFalseOrderByAddressIdDesc(Customer customer);

        // Kiểm tra địa chỉ trùng lặp đầy đủ (tất cả các trường)
        Optional<CustomerAddress> findByCustomerAndContactPhoneAndAddressDetailAndWardAndDistrictAndProvince(
                        Customer customer,
                        String contactPhone,
                        String addressDetail,
                        String ward,
                        String district,
                        String province);
}
