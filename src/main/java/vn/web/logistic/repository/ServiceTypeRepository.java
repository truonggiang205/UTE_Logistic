package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.ServiceType;

@Repository
public interface ServiceTypeRepository extends JpaRepository<ServiceType, Long> {
    // Kiểm tra trùng mã Service Code khi thêm mới
    boolean existsByServiceCode(String serviceCode);
}