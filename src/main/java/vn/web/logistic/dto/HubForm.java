package vn.web.logistic.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import vn.web.logistic.entity.HubLevel;

public class HubForm {

    @NotBlank
    @Size(max = 100)
    private String hubName;

    @Size(max = 255)
    private String address;

    @Size(max = 50)
    private String ward;

    @Size(max = 50)
    private String district;

    @Size(max = 50)
    private String province;

    @NotNull
    private HubLevel hubLevel;

    @Size(max = 20)
    private String contactPhone;

    @Email
    @Size(max = 100)
    private String email;

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
