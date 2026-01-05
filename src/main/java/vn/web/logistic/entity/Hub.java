package vn.web.logistic.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "HUBS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Hub {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "hub_id")
    private Long hubId;

    @Column(name = "hub_name", nullable = false, length = 100)
    private String hubName;

    @Column(length = 255)
    private String address;

    @Column(length = 50)
    private String ward;

    @Column(length = 50)
    private String district;

    @Column(length = 50)
    private String province;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('central','regional','local') DEFAULT 'local'")
    @Builder.Default
    private HubLevel hubLevel = HubLevel.local;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('active','inactive') DEFAULT 'active'")
    @Builder.Default
    private HubStatus status = HubStatus.active;

    private LocalDateTime createdAt;

    @Column(name = "contact_phone", length = 20)
    private String contactPhone;

    @Column(length = 100)
    private String email;

    // Nested public enums để có thể truy cập từ bên ngoài
    public enum HubLevel {
        central, regional, local
    }

    public enum HubStatus {
        active, inactive
    }
}