package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "DRIVERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Driver {

    public enum DriverStatus {
        active, inactive
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "driver_id")
    private Long driverId;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(name = "license_number", nullable = false, unique = true, length = 50)
    private String licenseNumber;

    @Column(name = "license_class", length = 10)
    private String licenseClass;

    @Column(name = "identity_card", nullable = false, unique = true, length = 20)
    private String identityCard;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive') DEFAULT 'active'")
    @Builder.Default
    private DriverStatus status = DriverStatus.active;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
