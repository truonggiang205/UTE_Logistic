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
     * Logic: FieldName=FieldValue (đã encode) nối với nhau bằng dấu & (không dư ở
     * cuối)
     * Dùng cho việc tạo URL thanh toán - fields chưa được encode
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
                    // Build hash data - PHẢI ENCODE giá trị theo đúng code mẫu VNPAY
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                } catch (Exception e) {
                    throw new IllegalStateException("Không thể encode dữ liệu VNPAY cho field: " + fieldName, e);
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
     * VNPAY trả về các giá trị ĐÃ ĐƯỢC DECODE bởi framework (Spring tự decode query
     * params)
     * Nên ta cần ENCODE LẠI khi verify để khớp với cách VNPAY tạo hash
     */
    public boolean verifySecureHash(Map<String, String> params, String receivedHash) {
        // Loại bỏ vnp_SecureHash và vnp_SecureHashType khỏi params trước khi hash
        Map<String, String> fieldsToHash = new LinkedHashMap<>();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            String key = entry.getKey();
            if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType")) {
                fieldsToHash.put(key, entry.getValue());
            }
        }

        // Tính hash - sử dụng cùng logic với hashAllFields
        String calculatedHash = hashAllFields(fieldsToHash);

        // So sánh case-insensitive
        return receivedHash != null && receivedHash.equalsIgnoreCase(calculatedHash);
    }

    /**
     * HMAC-SHA512 hash function theo chuẩn VNPAY
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            final SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
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