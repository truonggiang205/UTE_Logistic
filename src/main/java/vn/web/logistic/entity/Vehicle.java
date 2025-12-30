package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "VEHICLES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = "currentHub")
@EqualsAndHashCode(exclude = "currentHub")
public class Vehicle {

    public enum VehicleStatus {
        available, in_transit, maintenance
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vehicle_id")
    private Long vehicleId;

    @Column(name = "plate_number", nullable = false, unique = true, length = 20)
    private String plateNumber;

    @Column(name = "vehicle_type", length = 50)
    private String vehicleType;

    @Column(name = "load_capacity", columnDefinition = "DECIMAL(10,2)")
    private BigDecimal loadCapacity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "current_hub_id")
    private Hub currentHub;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('available','in_transit','maintenance') DEFAULT 'available'")
    @Builder.Default
    private VehicleStatus status = VehicleStatus.available;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
