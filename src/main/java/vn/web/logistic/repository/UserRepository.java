package vn.web.logistic.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.web.logistic.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // [MẶC ĐỊNH] findById(Long id): Xác định Manager (Actor) đang thao tác.

    // [TÙY CHỈNH] Dùng cho Login/Security
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
}
