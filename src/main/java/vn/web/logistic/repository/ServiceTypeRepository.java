package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.ServiceType;
import java.util.List;
import java.util.Optional;

@Repository
public interface ServiceTypeRepository extends JpaRepository<ServiceType, Long> {

    // Kiểm tra xem mã dịch vụ này có bản ghi nào đang hoạt động không
    boolean existsByServiceCodeAndIsActiveTrue(String serviceCode);

    // Tìm tất cả các dịch vụ đang có hiệu lực (để khách hàng chọn khi tạo đơn)
    List<ServiceType> findAllByIsActiveTrue();

    // Tìm bản ghi đang Active của một ID cụ thể (dùng cho update)
    Optional<ServiceType> findByServiceTypeIdAndIsActiveTrue(Long id);

    // Tìm bản ghi mới nhất dựa trên mã code, sắp xếp theo version giảm dần
    Optional<ServiceType> findFirstByServiceCodeOrderByVersionDesc(String serviceCode);
}