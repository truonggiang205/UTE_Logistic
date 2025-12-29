package vn.web.logistic.repository;

import java.util.Optional;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import vn.web.logistic.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

        @Query("""
            select distinct u
            from User u
            left join fetch u.roles
            left join fetch u.staff st
            left join fetch st.hub
            left join fetch u.shipper sp
            left join fetch sp.hub
            order by u.userId desc
            """)
    List<User> findAllWithRoles();

        @Query("""
            select u
            from User u
            left join fetch u.roles
            left join fetch u.staff st
            left join fetch st.hub
            left join fetch u.shipper sp
            left join fetch sp.hub
            where u.userId = ?1
            """)
    Optional<User> findByIdWithRoles(Long userId);
}
