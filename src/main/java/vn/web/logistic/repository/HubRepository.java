package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.Hub;
import java.util.List;

@Repository
public interface HubRepository extends JpaRepository<Hub, Long> {

    // [MẶC ĐỊNH] findById(Long id): Lấy thông tin kho hiện tại.

    // Chỉ lấy các Hub đang hoạt động và sắp xếp theo tên
    @Query("SELECT h FROM Hub h WHERE h.status = 'active' ORDER BY h.hubName ASC")
    List<Hub> findAllActiveHubs();
}