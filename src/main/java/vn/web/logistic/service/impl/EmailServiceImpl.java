package vn.web.logistic.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import vn.web.logistic.service.EmailService;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender; // Đối tượng gửi mail của Spring

    @Override
    public void sendOtpEmail(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("NGHV Logistics <your-email@gmail.com>");
        message.setTo(to);
        message.setSubject("MÃ XÁC THỰC EMAIL - NGHV LOGISTICS");
        message.setText("Chào bạn,\n\n" +
                        "Mã xác thực (OTP) để cập nhật email của bạn là: " + otp + "\n" +
                        "Mã này có hiệu lực trong vòng 5 phút.\n\n" +
                        "Trân trọng,\nĐội ngũ NGHV Logistics.");
        
        mailSender.send(message);
    }
}