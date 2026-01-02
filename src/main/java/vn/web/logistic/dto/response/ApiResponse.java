package vn.web.logistic.dto.response;

import java.util.HashMap;
import java.util.Map;

public class ApiResponse {
    public static Map<String, Object> message(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }

}
