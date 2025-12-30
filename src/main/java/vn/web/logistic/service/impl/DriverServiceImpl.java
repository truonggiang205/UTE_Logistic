package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.DriverRequest;
import vn.web.logistic.dto.response.DriverResponse;
import vn.web.logistic.dto.response.PageResponse;
import vn.web.logistic.entity.Driver;
import vn.web.logistic.entity.Driver.DriverStatus;
import vn.web.logistic.exception.BusinessException;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.DriverRepository;
import vn.web.logistic.service.DriverService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class DriverServiceImpl implements DriverService {

    private final DriverRepository driverRepository;

    @Override
    public DriverResponse create(DriverRequest request) {
        // Check duplicate identity card
        if (driverRepository.existsByIdentityCard(request.getIdentityCard())) {
            throw new BusinessException("DUPLICATE_IDENTITY_CARD",
                    "Số CCCD đã tồn tại trong hệ thống: " + request.getIdentityCard());
        }

        // Check duplicate license number
        if (driverRepository.existsByLicenseNumber(request.getLicenseNumber())) {
            throw new BusinessException("DUPLICATE_LICENSE_NUMBER",
                    "Số bằng lái đã tồn tại trong hệ thống: " + request.getLicenseNumber());
        }

        Driver driver = Driver.builder()
                .fullName(request.getFullName())
                .phoneNumber(request.getPhoneNumber())
                .licenseNumber(request.getLicenseNumber())
                .licenseClass(request.getLicenseClass())
                .identityCard(request.getIdentityCard())
                .status(DriverStatus.active)
                .build();

        driver = driverRepository.save(driver);
        log.info("Created new driver: {} - {}", driver.getFullName(), driver.getIdentityCard());

        return mapToResponse(driver);
    }

    @Override
    public DriverResponse update(Long id, DriverRequest request) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver", "driverId", id));

        // Check duplicate identity card (exclude current driver)
        if (driverRepository.existsByIdentityCardAndDriverIdNot(request.getIdentityCard(), id)) {
            throw new BusinessException("DUPLICATE_IDENTITY_CARD",
                    "Số CCCD đã tồn tại trong hệ thống: " + request.getIdentityCard());
        }

        // Check duplicate license number (exclude current driver)
        if (driverRepository.existsByLicenseNumberAndDriverIdNot(request.getLicenseNumber(), id)) {
            throw new BusinessException("DUPLICATE_LICENSE_NUMBER",
                    "Số bằng lái đã tồn tại trong hệ thống: " + request.getLicenseNumber());
        }

        driver.setFullName(request.getFullName());
        driver.setPhoneNumber(request.getPhoneNumber());
        driver.setLicenseNumber(request.getLicenseNumber());
        driver.setLicenseClass(request.getLicenseClass());
        driver.setIdentityCard(request.getIdentityCard());

        driver = driverRepository.save(driver);
        log.info("Updated driver: {}", driver.getFullName());

        return mapToResponse(driver);
    }

    @Override
    public DriverResponse updateStatus(Long id, String status) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver", "driverId", id));

        try {
            DriverStatus newStatus = DriverStatus.valueOf(status);
            driver.setStatus(newStatus);
        } catch (IllegalArgumentException e) {
            throw new BusinessException("INVALID_STATUS", "Trạng thái không hợp lệ: " + status);
        }

        driver = driverRepository.save(driver);
        log.info("Updated driver status: {} -> {}", driver.getFullName(), status);

        return mapToResponse(driver);
    }

    @Override
    @Transactional(readOnly = true)
    public DriverResponse getById(Long id) {
        Driver driver = driverRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Driver", "driverId", id));
        return mapToResponse(driver);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<DriverResponse> getAll(String status, String keyword, Pageable pageable) {
        DriverStatus driverStatus = null;
        if (status != null && !status.isEmpty()) {
            try {
                driverStatus = DriverStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                throw new BusinessException("INVALID_STATUS", "Trạng thái không hợp lệ: " + status);
            }
        }

        Page<Driver> page = driverRepository.findAllWithFilters(driverStatus, keyword, pageable);

        List<DriverResponse> content = page.getContent().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());

        return PageResponse.<DriverResponse>builder()
                .content(content)
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .first(page.isFirst())
                .last(page.isLast())
                .build();
    }

    private DriverResponse mapToResponse(Driver driver) {
        return DriverResponse.builder()
                .driverId(driver.getDriverId())
                .fullName(driver.getFullName())
                .phoneNumber(driver.getPhoneNumber())
                .licenseNumber(driver.getLicenseNumber())
                .licenseClass(driver.getLicenseClass())
                .identityCard(driver.getIdentityCard())
                .status(driver.getStatus().name())
                .createdAt(driver.getCreatedAt())
                .build();
    }
}
