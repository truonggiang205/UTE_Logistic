package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "TRIPS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "vehicle", "driver", "fromHub", "toHub" })
@EqualsAndHashCode(exclude = { "vehicle", "driver", "fromHub", "toHub" })
public class Trip {

    public enum TripStatus {
        loading, on_way, completed
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "trip_id")
    private Long tripId;

    @Column(name = "trip_code", nullable = false, unique = true, length = 50)
    private String tripCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "driver_id", nullable = false)
    private Driver driver;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_hub_id", nullable = false)
    private Hub fromHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_hub_id", nullable = false)
    private Hub toHub;

    @Column(name = "departed_at")
    private LocalDateTime departedAt;

    @Column(name = "arrived_at")
    private LocalDateTime arrivedAt;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('loading','on_way','completed') DEFAULT 'loading'")
    @Builder.Default
    private TripStatus status = TripStatus.loading;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
