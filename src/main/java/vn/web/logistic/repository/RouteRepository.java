package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Route;

import java.util.List;
import java.util.Optional;

@Repository
public interface RouteRepository extends JpaRepository<Route, Long> {

    // Tìm tuyến đường dựa trên Tỉnh/Thành phố gửi và nhận
    // Query theo province của Hub nguồn và Hub đích
    Optional<Route> findTopByFromHub_ProvinceAndToHub_Province(String sourceProvince, String destProvince);

    // Lấy danh sách tuyến đường xuất phát từ Hub (dùng cho Manager chọn tuyến)
    List<Route> findByFromHub_HubId(Long hubId);

    // Query Native SQL để đảm bảo lấy đúng dữ liệu nếu JPA derived query không hoạt
    // động
    @Query(value = "SELECT r.* FROM route r WHERE r.from_hub_id = :hubId", nativeQuery = true)
    List<Route> findRoutesByFromHubIdNative(@Param("hubId") Long hubId);

    // Query JPQL để fetch eager cả fromHub và toHub tránh N+1
    @Query("SELECT r FROM Route r LEFT JOIN FETCH r.fromHub LEFT JOIN FETCH r.toHub WHERE r.fromHub.hubId = :hubId")
    List<Route> findRoutesWithHubsByFromHubId(@Param("hubId") Long hubId);

    // Fetch eager một Route theo ID để tránh lỗi lazy proxy serialization
    @Query("SELECT r FROM Route r LEFT JOIN FETCH r.fromHub LEFT JOIN FETCH r.toHub WHERE r.routeId = :routeId")
    Optional<Route> findByIdWithHubs(@Param("routeId") Long routeId);

    // Fetch eager toàn bộ tuyến + 2 hub để phục vụ trang admin tuyến vận chuyển
    @Query("SELECT r FROM Route r LEFT JOIN FETCH r.fromHub LEFT JOIN FETCH r.toHub")
    List<Route> findAllWithHubs();
}