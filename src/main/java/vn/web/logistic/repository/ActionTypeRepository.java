package vn.web.logistic.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.web.logistic.entity.ActionType;

import java.util.Optional;

@Repository
public interface ActionTypeRepository extends JpaRepository<ActionType, Long> {

    /**
     * Tìm ActionType theo mã code
     * 
     * @param actionCode Mã action (VD: IMPORT_WAREHOUSE, COUNTER_SEND, ...)
     * @return Optional<ActionType>
     */
    Optional<ActionType> findByActionCode(String actionCode);
}
