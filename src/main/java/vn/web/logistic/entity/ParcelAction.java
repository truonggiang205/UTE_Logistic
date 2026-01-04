package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "PARCEL_ACTIONS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "request", "actionType", "fromHub", "toHub", "actor" })
@EqualsAndHashCode(exclude = { "request", "actionType", "fromHub", "toHub", "actor" })
public class ParcelAction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long actionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "action_type_id", nullable = false)
    private ActionType actionType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_hub_id")
    private Hub fromHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_hub_id")
    private Hub toHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "actor_id", nullable = false)
    private User actor;

    private LocalDateTime actionTime;

    private String note;
}