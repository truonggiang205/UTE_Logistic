package vn.web.logistic.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import vn.web.logistic.dto.request.CreateShipperRequest;
import vn.web.logistic.dto.response.manager.ShipperInfoDTO;
import vn.web.logistic.dto.response.manager.UpdateStatusResult;

// Service cho quản lý Shipper trong Hub
public interface ShipperManagementService {

    // Filter Shipper
    Page<ShipperInfoDTO> getShippers(Long hubId, String status, String keyword, int page, int size);

    // Get shipper detail
    ShipperInfoDTO getShipperDetail(Long shipperId);

    // Update shipper status (với kiểm tra ràng buộc khi khóa tài khoản)
    UpdateStatusResult updateShipperStatus(Long shipperId, String status);

    // Get statistics
    Map<String, Object> getHubShipperStatistics(Long hubId);

    // Get unassigned shippers
    List<ShipperInfoDTO> getUnassignedShippers();

    // Assign shipper to Hub
    boolean assignShipperToHub(Long shipperId, Long hubId);

    // Remove shipper from Hub
    boolean removeShipperFromHub(Long shipperId);

    // Create shipper
    ShipperInfoDTO createShipper(CreateShipperRequest request, Long hubId);

    // Check username exists
    boolean isUsernameExists(String username);

    // Check email exists
    boolean isEmailExists(String email);

    // Check phone exists
    boolean isPhoneExists(String phone);
}
