package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.Hub;

@Repository
public interface HubRepository extends JpaRepository<Hub, Long> {

    // [MẶC ĐỊNH] findById(Long id): Lấy thông tin kho hiện tại.

    // Chỉ lấy các Hub đang hoạt động và sắp xếp theo tên
    @Query("SELECT h FROM Hub h WHERE h.status = 'active' ORDER BY h.hubName ASC")
    List<Hub> findAllActiveHubs();

    // Tìm Hub theo tên (kiểm tra trùng)
    Optional<Hub> findByHubNameIgnoreCase(String hubName);

    // Tìm kiếm với filter và phân trang
    @Query("SELECT h FROM Hub h WHERE " +
            "(:status IS NULL OR h.status = :status) AND " +
            "(:hubLevel IS NULL OR h.hubLevel = :hubLevel) AND " +
            "(:keyword IS NULL OR :keyword = '' OR " +
            " LOWER(h.hubName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(h.address) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(h.province) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Hub> findWithFilters(
            @Param("status") Hub.HubStatus status,
            @Param("hubLevel") Hub.HubLevel hubLevel,
            @Param("keyword") String keyword,
            Pageable pageable);

    // Đếm tổng số Hub theo status
    long countByStatus(Hub.HubStatus status);
}