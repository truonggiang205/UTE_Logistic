package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import vn.web.logistic.enums.TrackingStatus;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter; 
import com.fasterxml.jackson.annotation.JsonIgnore;

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
    @JsonIgnore
    private ServiceRequest request;

    @Column(nullable = false, unique = true, length = 255)
    private String code;

    private LocalDateTime createdAt;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private TrackingStatus status = TrackingStatus.active;

    public String getFormattedCreatedAt() {
        if (this.createdAt == null) return "";
        return this.createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
} // Dấu đóng ngoặc cuối cùng