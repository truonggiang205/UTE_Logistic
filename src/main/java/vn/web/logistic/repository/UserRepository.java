package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    // Tìm user bằng email hoặc username để hỗ trợ đăng nhập linh hoạt
    Optional<User> findByEmailOrUsername(String email, String username);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
    
    boolean existsByPhone(String phone);
    
    @Query("SELECT u FROM User u WHERE u.username = :id OR u.email = :id OR u.phone = :id")
    Optional<User> findByIdentifier(@Param("id") String identifier);
}