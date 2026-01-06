package vn.web.logistic.service;

import vn.web.logistic.dto.request.RegisterRequest;

public interface OtpService {
    String generateAndSaveOtp(RegisterRequest request);

    boolean validateOtp(String phone, String otp);

    RegisterRequest getPendingRegistration(String phone);

    void clearOtp(String phone);
}