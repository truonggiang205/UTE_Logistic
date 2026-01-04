package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import vn.web.logistic.enums.UserStatus;

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

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @Column(length = 20)
    private String phone;

    @Column(length = 100)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive','banned') DEFAULT 'active'")
    private UserStatus status = UserStatus.active;

    @Column(name = "avatar_url", length = 255)
    private String avatarUrl;

    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "USER_ROLES", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles = new HashSet<>();

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Customer customer;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Staff staff;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Shipper shipper;

    @OneToMany(mappedBy = "actor", fetch = FetchType.LAZY)
    private List<ParcelAction> actions = new ArrayList<>();

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<SystemLog> logs = new ArrayList<>();
}