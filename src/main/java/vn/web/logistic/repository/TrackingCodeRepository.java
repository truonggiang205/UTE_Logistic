package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.TrackingCode.TrackingStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrackingCodeRepository extends JpaRepository<TrackingCode, Long> {

    /**
     * Tìm TrackingCode theo mã code
     */
    Optional<TrackingCode> findByCode(String code);

    /**
     * Tìm TrackingCode theo requestId
     */
    @Query("SELECT tc FROM TrackingCode tc WHERE tc.request.requestId = :requestId")
    Optional<TrackingCode> findByRequestId(@Param("requestId") Long requestId);

    /**
     * Tìm TrackingCode theo requestId (derived query)
     */
    Optional<TrackingCode> findByRequest_RequestId(Long requestId);

    /**
     * Xóa TrackingCode theo requestId
     */
    void deleteByRequest_RequestId(Long requestId);

    /**
     * Tìm TrackingCode theo mã code (tìm kiếm LIKE)
     */
    @Query("SELECT tc FROM TrackingCode tc WHERE tc.code LIKE %:keyword%")
    java.util.List<TrackingCode> findByCodeContaining(@Param("keyword") String keyword);

    /**
     * Lấy danh sách lộ trình của một đơn hàng cụ thể.
     * Spring Data JPA sẽ tự hiểu 'Request_RequestId' là lấy ID từ đối tượng
     * ServiceRequest liên kết.
     * Sắp xếp theo thời gian tạo tăng dần để vẽ Timeline.
     */
    List<TrackingCode> findByRequest_RequestIdOrderByCreatedAtAsc(Long requestId);

    /**
     * Kiểm tra sự tồn tại của mã code.
     */
    boolean existsByCode(String code);

    /**
     * Tìm tất cả tracking theo trạng thái (active/inactive).
     */
    List<TrackingCode> findByStatus(TrackingStatus status);
}
