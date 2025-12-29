package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "SHIPPERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Shipper {
    public enum ShipperType {
        fulltime, parttime
    }

    public enum ShipperStatus {
        active, inactive, busy
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shipper_id")
    private Long shipperId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hub_id")
    private Hub hub;

    @Enumerated(EnumType.STRING)
    private ShipperType shipperType;

    @Column(name = "vehicle_type", length = 50)
    private String vehicleType;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive','busy') DEFAULT 'active'")
    @Builder.Default
    private ShipperStatus status = ShipperStatus.active;

    private LocalDateTime joinedAt;

    @Builder.Default
    private BigDecimal rating = BigDecimal.valueOf(0.00);
}
