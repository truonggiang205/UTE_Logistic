package vn.web.logistic.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.ActionType;

@Repository
public interface ActionTypeRepository extends JpaRepository<ActionType, Long> {

    /**
     * Tìm ActionType theo mã code
     * 
     * @param actionCode Mã action (VD: IMPORT_WAREHOUSE, COUNTER_SEND, ...)
     * @return Optional<ActionType>
     */
    Optional<ActionType> findByActionCode(String actionCode);

    /**
     * Kiểm tra mã code đã tồn tại (case insensitive)
     */
    Optional<ActionType> findByActionCodeIgnoreCase(String actionCode);

    /**
     * Lấy tất cả ActionType sắp xếp theo actionCode
     */
    List<ActionType> findAllByOrderByActionCodeAsc();

    /**
     * Tìm kiếm với filter và phân trang
     */
    @Query("SELECT a FROM ActionType a WHERE " +
            "(:keyword IS NULL OR :keyword = '' OR " +
            " LOWER(a.actionCode) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(a.actionName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            " LOWER(a.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<ActionType> findWithFilters(@Param("keyword") String keyword, Pageable pageable);
}
