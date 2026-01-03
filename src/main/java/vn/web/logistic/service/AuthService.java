package vn.web.logistic.service;

import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.response.AuthResponse;

public interface AuthService {
    AuthResponse login(LoginRequest loginRequest);

    void logout(String token);
}
