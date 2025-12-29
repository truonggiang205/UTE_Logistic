package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "SHIPPER_TASKS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "shipper", "request" })
@EqualsAndHashCode(exclude = { "shipper", "request" })
public class ShipperTask {

    public enum TaskType {
        pickup, delivery
    }

    public enum TaskStatus {
        assigned, in_progress, completed, failed
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "task_id")
    private Long taskId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shipper_id", nullable = false)
    private Shipper shipper;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private ServiceRequest request;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TaskType taskType;

    private LocalDateTime assignedAt;

    private LocalDateTime completedAt;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('assigned','in_progress','completed','failed') DEFAULT 'assigned'")
    @Builder.Default
    private TaskStatus taskStatus = TaskStatus.assigned;

    private String resultNote;
}
