package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "TRIP_CONTAINERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "trip", "container" })
@EqualsAndHashCode(exclude = { "trip", "container" })
public class TripContainer {

    public enum TripContainerStatus {
        loaded, unloaded
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "container_id", nullable = false)
    private Container container;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('loaded','unloaded') DEFAULT 'loaded'")
    @Builder.Default
    private TripContainerStatus status = TripContainerStatus.loaded;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
