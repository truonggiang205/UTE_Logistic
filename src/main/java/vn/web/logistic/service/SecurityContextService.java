package vn.web.logistic.service;

import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.User;

// Service xử lý SecurityContext
// Cung cấp thông tin user hiện tại cho các controller
public interface SecurityContextService {

    // Lấy User hiện tại từ SecurityContext
    User getCurrentUser();

    // Lấy userId của user hiện tại
    Long getCurrentUserId();

    // Lấy hubId của user hiện tại (từ Staff hoặc Shipper)
    Long getCurrentHubId();

    // Lấy Hub entity của user hiện tại
    Hub getCurrentHub();

    // Kiểm tra user có thuộc hub không
    boolean belongsToHub(Long hubId);
}
