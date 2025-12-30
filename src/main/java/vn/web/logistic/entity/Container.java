package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "CONTAINERS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = { "createdAtHub", "destinationHub", "createdBy" })
@EqualsAndHashCode(exclude = { "createdAtHub", "destinationHub", "createdBy" })
public class Container {

    public enum ContainerType {
        standard, fragile, frozen, express
    }

    public enum ContainerStatus {
        created, closed, loaded, received, unpacked
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "container_id")
    private Long containerId;

    @Column(name = "container_code", nullable = false, unique = true, length = 50)
    private String containerCode;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('standard','fragile','frozen','express') DEFAULT 'standard'")
    @Builder.Default
    private ContainerType type = ContainerType.standard;

    @Column(columnDefinition = "DECIMAL(10,2)")
    private BigDecimal weight;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_at_hub_id", nullable = false)
    private Hub createdAtHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "destination_hub_id", nullable = false)
    private Hub destinationHub;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('created','closed','loaded','received','unpacked') DEFAULT 'created'")
    @Builder.Default
    private ContainerStatus status = ContainerStatus.created;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
