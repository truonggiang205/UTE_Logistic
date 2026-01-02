package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "USERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "roles", "customer", "staff", "shipper", "actions", "logs" })
@EqualsAndHashCode(exclude = { "roles", "customer", "staff", "shipper", "actions", "logs" })
public class User {

    public enum UserStatus {
        active,
        inactive,
        banned
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    // --- SỬA QUAN TRỌNG 1: Ánh xạ đúng vào cột password_hash ---
    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @Column(length = 20)
    private String phone;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive','banned') DEFAULT 'active'")
    @Builder.Default
    private UserStatus status = UserStatus.active;

    @Column(name = "avatar_url", length = 255)
    private String avatarUrl;

    // --- SỬA QUAN TRỌNG 2: Ánh xạ cột & Tự động cập nhật thời gian ---

    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;

    @CreationTimestamp // Tự động lấy giờ hiện tại khi INSERT
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp // Tự động cập nhật giờ hiện tại khi UPDATE
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // ----------------------------------------------------------------

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "USER_ROLES", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    @Builder.Default
    private Set<Role> roles = new HashSet<>();

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Customer customer;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Staff staff;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Shipper shipper;

    @OneToMany(mappedBy = "actor", fetch = FetchType.LAZY)
    @Builder.Default
    private List<ParcelAction> actions = new ArrayList<>();

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    @Builder.Default
    private List<SystemLog> logs = new ArrayList<>();
}