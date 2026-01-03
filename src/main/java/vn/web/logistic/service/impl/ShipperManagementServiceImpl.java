package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.CreateShipperRequest;
import vn.web.logistic.dto.response.manager.ShipperInfoDTO;
import vn.web.logistic.dto.response.manager.UpdateStatusResult;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.ShipperRepository;
import vn.web.logistic.repository.ShipperTaskRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.ShipperManagementService;

@Service
@RequiredArgsConstructor
public class ShipperManagementServiceImpl implements ShipperManagementService {

    private final ShipperRepository shipperRepository;
    private final HubRepository hubRepository;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final CodTransactionRepository codTransactionRepository;
    private final ShipperTaskRepository shipperTaskRepository;

    @Override
    public Page<ShipperInfoDTO> getShippers(Long hubId, String status, String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("user.fullName").ascending());
        Page<Shipper> shipperPage;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm theo keyword
            shipperPage = shipperRepository.searchByHubIdAndKeywordPaged(hubId, keyword.trim(), pageable);
        } else if (status != null && !status.isEmpty()) {
            // Filter theo status
            try {
                Shipper.ShipperStatus shipperStatus = Shipper.ShipperStatus.valueOf(status);
                shipperPage = shipperRepository.findByHubIdAndStatusPaged(hubId, shipperStatus, pageable);
            } catch (IllegalArgumentException e) {
                shipperPage = Page.empty(pageable);
            }
        } else {
            // Lấy tất cả
            shipperPage = shipperRepository.findByHubIdWithUserPaged(hubId, pageable);
        }

        return shipperPage.map(this::mapToDTO);
    }

    @Override
    public ShipperInfoDTO getShipperDetail(Long shipperId) {
        return shipperRepository.findById(shipperId)
                .map(this::mapToDTO)
                .orElse(null);
    }

    @Override
    @Transactional
    public UpdateStatusResult updateShipperStatus(Long shipperId, String status) {
        try {
            Shipper.ShipperStatus newStatus = Shipper.ShipperStatus.valueOf(status);
            Optional<Shipper> optShipper = shipperRepository.findById(shipperId);

            if (!optShipper.isPresent()) {
                return UpdateStatusResult.builder()
                        .success(false)
                        .message("Không tìm thấy shipper")
                        .errorCode("NOT_FOUND")
                        .build();
            }

            Shipper shipper = optShipper.get();

            // Kiểm tra ràng buộc KHI KHÓA TÀI KHOẢN (status = inactive)
            if (newStatus == Shipper.ShipperStatus.inactive) {
                // Check 1: Còn COD pending không?
                long pendingCodCount = codTransactionRepository.countPendingByShipperId(shipperId);
                if (pendingCodCount > 0) {
                    BigDecimal pendingAmount = codTransactionRepository.sumPendingByShipperId(shipperId);
                    return UpdateStatusResult.builder()
                            .success(false)
                            .message("Phải thu hết tiền nợ trước! Còn " + pendingCodCount
                                    + " khoản COD chưa thu (tổng: " + pendingAmount + "đ)")
                            .errorCode("PENDING_COD")
                            .build();
                }

                // Check 2: Còn task đang xử lý không?
                long activeTaskCount = shipperTaskRepository.countActiveTasksByShipperId(shipperId);
                if (activeTaskCount > 0) {
                    return UpdateStatusResult.builder()
                            .success(false)
                            .message("Phải thu hồi hết hàng về kho trước! Còn " + activeTaskCount + " đơn đang giao")
                            .errorCode("ACTIVE_TASKS")
                            .build();
                }
            }

            // Update status
            shipper.setStatus(newStatus);
            shipperRepository.save(shipper);

            return UpdateStatusResult.builder()
                    .success(true)
                    .message("Cập nhật trạng thái thành công")
                    .build();

        } catch (IllegalArgumentException e) {
            return UpdateStatusResult.builder()
                    .success(false)
                    .message("Trạng thái không hợp lệ: " + status)
                    .errorCode("INVALID_STATUS")
                    .build();
        }
    }

    @Override
    public Map<String, Object> getHubShipperStatistics(Long hubId) {
        Map<String, Object> stats = new HashMap<>();

        long total = shipperRepository.countByHubHubId(hubId);
        long active = shipperRepository.countByHubIdAndStatus(hubId, Shipper.ShipperStatus.active);
        long busy = shipperRepository.countByHubIdAndStatus(hubId, Shipper.ShipperStatus.busy);
        long inactive = shipperRepository.countByHubIdAndStatus(hubId, Shipper.ShipperStatus.inactive);

        stats.put("total", total);
        stats.put("active", active);
        stats.put("busy", busy);
        stats.put("inactive", inactive);
        stats.put("available", active);

        return stats;
    }

    @Override
    public List<ShipperInfoDTO> getUnassignedShippers() {
        List<Shipper> shippers = shipperRepository.findByHubIsNull();
        return shippers.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public boolean assignShipperToHub(Long shipperId, Long hubId) {
        Optional<Shipper> optShipper = shipperRepository.findById(shipperId);
        Optional<Hub> optHub = hubRepository.findById(hubId);

        if (optShipper.isPresent() && optHub.isPresent()) {
            Shipper shipper = optShipper.get();
            shipper.setHub(optHub.get());
            shipperRepository.save(shipper);
            return true;
        }
        return false;
    }

    @Override
    @Transactional
    public boolean removeShipperFromHub(Long shipperId) {
        Optional<Shipper> optShipper = shipperRepository.findById(shipperId);
        if (optShipper.isPresent()) {
            Shipper shipper = optShipper.get();
            shipper.setHub(null);
            shipperRepository.save(shipper);
            return true;
        }
        return false;
    }

    // Map Shipper entity sang DTO
    private ShipperInfoDTO mapToDTO(Shipper shipper) {
        User user = shipper.getUser();
        return ShipperInfoDTO.builder()
                .shipperId(shipper.getShipperId())
                .userId(user != null ? user.getUserId() : null)
                .fullName(user != null ? user.getFullName() : "N/A")
                .phone(user != null ? user.getPhone() : "N/A")
                .email(user != null ? user.getEmail() : "N/A")
                .avatarUrl(user != null ? user.getAvatarUrl() : null)
                .shipperType(shipper.getShipperType() != null ? shipper.getShipperType().name() : "N/A")
                .vehicleType(shipper.getVehicleType())
                .status(shipper.getStatus() != null ? shipper.getStatus().name() : "N/A")
                .joinedAt(shipper.getJoinedAt())
                .rating(shipper.getRating() != null ? shipper.getRating() : BigDecimal.ZERO)
                .totalTasksToday(0L)
                .completedTasksToday(0L)
                .totalCodToday(BigDecimal.ZERO)
                .pendingCodCount(0L)
                .build();
    }

    @Override
    @Transactional
    public ShipperInfoDTO createShipper(CreateShipperRequest request, Long hubId) {
        if (userRepository.existsByUsername(request.getUsername())) {
            return null;
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            return null;
        }

        try {
            // 1. Tạo User
            User user = User.builder()
                    .username(request.getUsername())
                    .passwordHash(passwordEncoder.encode(request.getPassword()))
                    .email(request.getEmail())
                    .phone(request.getPhone())
                    .fullName(request.getFullName())
                    .status(User.UserStatus.active)
                    .createdAt(LocalDateTime.now())
                    .build();

            // 2. Gán role SHIPPER
            Role shipperRole = roleRepository.findByRoleName("SHIPPER")
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy role SHIPPER"));
            Set<Role> roles = new HashSet<>();
            roles.add(shipperRole);
            user.setRoles(roles);

            user = userRepository.save(user);

            // 3. Lấy Hub
            Hub hub = null;
            if (hubId != null) {
                hub = hubRepository.findById(hubId).orElse(null);
            }

            // 4. Tạo Shipper
            Shipper.ShipperType type = Shipper.ShipperType.fulltime;
            if ("parttime".equalsIgnoreCase(request.getShipperType())) {
                type = Shipper.ShipperType.parttime;
            }

            Shipper shipper = Shipper.builder()
                    .user(user)
                    .hub(hub)
                    .shipperType(type)
                    .vehicleType(request.getVehicleType())
                    .status(Shipper.ShipperStatus.active)
                    .joinedAt(LocalDateTime.now())
                    .rating(BigDecimal.ZERO)
                    .build();

            shipper = shipperRepository.save(shipper);

            return mapToDTO(shipper);

        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public boolean isPhoneExists(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        return userRepository.existsByPhone(phone);
    }
}
