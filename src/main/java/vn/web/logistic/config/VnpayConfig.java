package vn.web.logistic.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Component
public class VnpayConfig {
    @Value("${vnpay.pay-url}")
    private String vnpPayUrl;
    @Value("${vnpay.return-url}")
    private String vnpReturnUrl;
    @Value("${vnpay.tmn-code}")
    private String vnpTmnCode;
    @Value("${vnpay.secret-key}")
    private String secretKey;
    @Value("${vnpay.version:2.1.0}")
    private String vnpVersion;
    @Value("${vnpay.command:pay}")
    private String vnpCommand;
    @Value("${vnpay.order-type:other}")
    private String vnpOrderType;

    public String getVnpPayUrl() {
        return vnpPayUrl;
    }

    public String getVnpReturnUrl() {
        return vnpReturnUrl;
    }

    public String getVnpTmnCode() {
        return vnpTmnCode;
    }

    public String getVnpVersion() {
        return vnpVersion;
    }

    public String getVnpCommand() {
        return vnpCommand;
    }

    public String getVnpOrderType() {
        return vnpOrderType;
    }

    public String getSecretKey() {
        return secretKey;
    }

    /**
     * Tạo hash từ các fields - THEO ĐÚNG CODE MẪU VNPAY
     * Quan trọng: hashData PHẢI được URLEncode trước khi hash
     */
    public String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    // Build hash data - PHẢI ENCODE theo đúng code mẫu VNPAY
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        return hmacSHA512(secretKey, hashData.toString());
    }

    /**
     * Verify hash từ VNPAY callback - dùng cho IPN/Return URL
     * VNPAY trả về các giá trị đã được decode, nên ta cần encode lại khi verify
     */
    public String hashAllFieldsForVerify(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        return hmacSHA512(secretKey, hashData.toString());
    }

    public static String hmacSHA512(final String key, final String data) {
        try {
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            final SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(), "HmacSHA512");
            hmac512.init(secretKeySpec);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result)
                sb.append(String.format("%02x", b & 0xff));
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++)
            sb.append("0123456789".charAt(rnd.nextInt(10)));
        return sb.toString();
    }
}