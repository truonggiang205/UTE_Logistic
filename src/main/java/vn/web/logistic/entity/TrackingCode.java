package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "TRACKING_CODES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TrackingCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long trackingId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @Column(nullable = false, unique = true, length = 30)
    private String code;

    private LocalDateTime createdAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TrackingStatus status = TrackingStatus.active;
}

enum TrackingStatus {
    active, inactive
}