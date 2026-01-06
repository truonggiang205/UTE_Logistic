package vn.web.logistic.service.impl;

import org.springframework.stereotype.Service;
import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.service.OtpService;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpServiceImpl implements OtpService {

    // Lưu trữ tạm thời: Phone -> {OTP, RegisterRequest}
    private final Map<String, PendingData> otpCache = new ConcurrentHashMap<>();

    private static class PendingData {
        RegisterRequest request;
        String otp;
    }

    @Override
    public String generateAndSaveOtp(RegisterRequest request) {
        String otp = String.format("%06d", new Random().nextInt(1000000));

        PendingData data = new PendingData();
        data.request = request;
        data.otp = otp;

        otpCache.put(request.getPhone(), data);

        // Giả lập gửi SMS (Bạn sẽ thấy mã in ra ở Console Spring Boot)
        System.out.println("NGHV LOGISTICS - OTP cho " + request.getPhone() + " là: " + otp);
        return otp;
    }

    @Override
    public boolean validateOtp(String phone, String otp) {
        PendingData data = otpCache.get(phone);
        return data != null && data.otp.equals(otp);
    }

    @Override
    public RegisterRequest getPendingRegistration(String phone) {
        PendingData data = otpCache.get(phone);
        return (data != null) ? data.request : null;
    }

    @Override
    public void clearOtp(String phone) {
        otpCache.remove(phone);
    }
}