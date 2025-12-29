package vn.web.logistic.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "HUBS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Hub {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
    @Column(nullable = false, length = 20)
    private HubLevel hubLevel = HubLevel.local;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private HubStatus status = HubStatus.active;

    private LocalDateTime createdAt;

    @Column(name = "contact_phone", length = 20)
    private String contactPhone;

    @Column(length = 100)
    private String email;

    // Explicit getters/setters to support IDEs/environments
    // where Lombok annotation processing is not enabled.
    public String getHubName() {
        return hubName;
    }

    public void setHubName(String hubName) {
        this.hubName = hubName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public HubLevel getHubLevel() {
        return hubLevel;
    }

    public void setHubLevel(HubLevel hubLevel) {
        this.hubLevel = hubLevel;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
