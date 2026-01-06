package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

        // Phiên bản "chịu được" dữ liệu NULL/blank, tránh tạo địa chỉ trùng do khác biệt NULL vs ""
        @Query("""
            SELECT a
            FROM CustomerAddress a
            WHERE a.customer = :customer
              AND COALESCE(TRIM(a.addressDetail), '') = COALESCE(TRIM(:addressDetail), '')
              AND COALESCE(TRIM(a.ward), '') = COALESCE(TRIM(:ward), '')
              AND COALESCE(TRIM(a.district), '') = COALESCE(TRIM(:district), '')
              AND COALESCE(TRIM(a.province), '') = COALESCE(TRIM(:province), '')
            """)
        Optional<CustomerAddress> findDuplicateAddress(
            @Param("customer") Customer customer,
            @Param("addressDetail") String addressDetail,
            @Param("ward") String ward,
            @Param("district") String district,
            @Param("province") String province);

        @Modifying
        @Query("UPDATE CustomerAddress a SET a.isDefault = false WHERE a.customer.customerId = :customerId AND a.isDefault = true")
        int clearDefaultForCustomer(@Param("customerId") Long customerId);

    /**
     * Lấy danh sách địa chỉ của một khách hàng
     */
    List<CustomerAddress> findByCustomerCustomerId(Long customerId);

    /**
     * Lấy địa chỉ mặc định của khách hàng
     */
    Optional<CustomerAddress> findByCustomerCustomerIdAndIsDefaultTrue(Long customerId);
}
