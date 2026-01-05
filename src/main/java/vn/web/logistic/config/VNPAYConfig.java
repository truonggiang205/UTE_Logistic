package vn.web.logistic.config;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.net.URLEncoder;
import java.util.*;

public class VNPAYConfig {

    // ================= CONFIG =================
    public static final String vnp_TmnCode = "VELS5U0P";
    public static final String vnp_HashSecret = "U27A71PZD9L43SB5EJI5ODZRKHLNS4BH";

    public static final String vnp_PayUrl =
            "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    
    public static String vnp_ReturnUrl =
    	    "http://localhost:9090/customer/api/payment/vnpay-return";

//    public static final String vnp_IpnUrl =
//            "https://localhost:9090/customer/api/payment/vnpay-ipn";

    // ================= HMAC SHA512 =================
    public static String hmacSHA512(final String key, final String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey =
                    new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);

            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ================= HASH ALL FIELDS (CHỈ GHÉP CHUỖI) =================
    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder sb = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {
                sb.append(fieldName)
                  .append("=")
                  .append(fieldValue);
            }
            if (itr.hasNext()) {
                sb.append("&");
            }
        }
        return sb.toString(); // ❗ KHÔNG HASH Ở ĐÂY
    }

    // ================= BUILD QUERY STRING =================
    public static String buildQueryString(Map<String, String> params) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder query = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = params.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII))
                     .append("=")
                     .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII))
                     .append("&");
            }
        }
        if (query.length() > 0) query.deleteCharAt(query.length() - 1);
        return query.toString();
    }

    // ================= CLIENT IP =================
    public static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if ("0:0:0:0:0:0:0:1".equals(ip)) {
            ip = "127.0.0.1";
        }
        return ip;
    }
}
