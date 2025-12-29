package vn.web.logistic.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import vn.web.logistic.entity.UserStatus;

public class UserForm {

    @NotBlank
    @Size(max = 50)
    private String username;

    @Size(max = 100)
    private String fullName;

    @Email
    @Size(max = 100)
    private String email;

    @Size(max = 20)
    private String phone;

    // Optional for create/reset
    @Size(max = 100)
    private String password;

    @NotBlank
    private String roleName;

    private UserStatus status;

    // Staff profile (only when roleName == STAFF)
    private Long hubId;

    @Size(max = 50)
    private String staffPosition;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }

    public Long getHubId() {
        return hubId;
    }

    public void setHubId(Long hubId) {
        this.hubId = hubId;
    }

    public String getStaffPosition() {
        return staffPosition;
    }

    public void setStaffPosition(String staffPosition) {
        this.staffPosition = staffPosition;
    }
}
