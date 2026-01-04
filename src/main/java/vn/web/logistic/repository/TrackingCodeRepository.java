package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.enums.TrackingStatus;
import java.util.List;
import java.util.Optional;

@Repository
public interface TrackingCodeRepository extends JpaRepository<TrackingCode, Long> {

    /**
     * Lấy danh sách lộ trình của một đơn hàng cụ thể.
     * Spring Data JPA sẽ tự hiểu 'Request_RequestId' là lấy ID từ đối tượng ServiceRequest liên kết.
     * Sắp xếp theo thời gian tạo tăng dần để vẽ Timeline.
     */
    List<TrackingCode> findByRequest_RequestIdOrderByCreatedAtAsc(Long requestId);

    /**
     * Tìm kiếm thông tin bằng mã code duy nhất.
     */
    Optional<TrackingCode> findByCode(String code);

    /**
     * Kiểm tra sự tồn tại của mã code.
     */
    boolean existsByCode(String code);
    
    /**
     * Tìm tất cả tracking theo trạng thái (active/inactive).
     */
    List<TrackingCode> findByStatus(TrackingStatus status);
}