package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "PARCEL_ROUTES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "request", "route" })
@EqualsAndHashCode(exclude = { "request", "route" })
public class ParcelRoute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long parcelRouteId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", nullable = false)
    private Route route;

    @Column(name = "route_order", nullable = false)
    private Integer routeOrder;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ParcelRouteStatus status = ParcelRouteStatus.planned;
}

enum ParcelRouteStatus {
    planned, in_progress, completed
}