package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.ServiceTypeRequest;
import vn.web.logistic.dto.response.ServiceTypeResponse;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.service.ServiceTypeService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ServiceTypeServiceImpl implements ServiceTypeService {

    private final ServiceTypeRepository repo;

    @Override
    @Transactional(readOnly = true)
    public List<ServiceTypeResponse> getAll() {
        return repo.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ServiceTypeResponse getById(Long id) {
        ServiceType entity = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ ID: " + id));
        return mapToResponse(entity);
    }

    @Override
    @Transactional
    public ServiceTypeResponse create(ServiceTypeRequest request) {
        // 1. Tìm bản ghi có cùng ServiceCode và đang Active (hoặc bản ghi có version
        // cao nhất)
        // Chúng ta tìm bản ghi mới nhất của mã này để lấy Version
        Optional<ServiceType> latestVersionOpt = repo
                .findFirstByServiceCodeOrderByVersionDesc(request.getServiceCode());

        ServiceType serviceType = new ServiceType();
        mapRequestToEntity(request, serviceType);

        if (latestVersionOpt.isPresent()) {
            // TRƯỜNG HỢP: Đã có mã này trong hệ thống
            ServiceType oldEntity = latestVersionOpt.get();

            // Tắt bản ghi cũ nếu nó đang Active
            if (oldEntity.getIsActive() != null && oldEntity.getIsActive()) {
                oldEntity.setIsActive(false);
                repo.save(oldEntity);
            }

            // Thiết lập bản ghi mới với Version tiếp theo
            int currentVersion = (oldEntity.getVersion() == null) ? 1 : oldEntity.getVersion();
            serviceType.setVersion(currentVersion + 1);
            serviceType.setParentId(
                    oldEntity.getParentId() == null ? oldEntity.getServiceTypeId() : oldEntity.getParentId());
        } else {
            // TRƯỜNG HỢP: Mã mới hoàn toàn
            serviceType.setVersion(1);
            serviceType.setParentId(null);
        }

        // Thiết lập các thông số chung
        serviceType.setIsActive(true);
        serviceType.setEffectiveFrom(java.time.LocalDateTime.now());
        serviceType.setServiceCode(request.getServiceCode()); // Đảm bảo dùng đúng mã từ request

        ServiceType savedObj = repo.save(serviceType);
        return mapToResponse(savedObj);
    }

    @Override
    @Transactional
    public ServiceTypeResponse update(Long id, ServiceTypeRequest request) {
        // 1. Tìm bản ghi hiện tại
        ServiceType oldEntity = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));

        // 2. KIỂM TRA THAY ĐỔI (Thêm đoạn này)
        if (!hasChanges(oldEntity, request)) {
            // Nếu không có gì thay đổi, trả về dữ liệu cũ luôn, không làm gì cả
            return mapToResponse(oldEntity);
        }

        if (oldEntity.getIsActive() == null || !oldEntity.getIsActive()) {
            throw new RuntimeException("Không thể cập nhật bản ghi đã hết hiệu lực!");
        }

        // 3. Nếu có thay đổi, mới thực hiện logic đóng cũ - tạo mới
        oldEntity.setIsActive(false);
        repo.save(oldEntity);

        ServiceType newVersion = new ServiceType();
        mapRequestToEntity(request, newVersion);

        newVersion.setServiceTypeId(null);
        newVersion.setServiceCode(oldEntity.getServiceCode());
        // Nếu oldEntity.getVersion() bị null thì mặc định là 1, không thì cộng 1
        int currentVersion = (oldEntity.getVersion() == null) ? 1 : oldEntity.getVersion();
        newVersion.setVersion(currentVersion + 1);

        newVersion.setIsActive(true);
        newVersion.setEffectiveFrom(java.time.LocalDateTime.now());
        newVersion
                .setParentId(oldEntity.getParentId() == null ? oldEntity.getServiceTypeId() : oldEntity.getParentId());

        return mapToResponse(repo.save(newVersion));
    }

    // Hàm bổ trợ để so sánh dữ liệu
    private boolean hasChanges(ServiceType entity, ServiceTypeRequest req) {
        return !entity.getServiceName().equals(req.getServiceName()) ||
                entity.getBaseFee().compareTo(req.getBaseFee()) != 0 ||
                entity.getExtraPricePerKg().compareTo(req.getExtraPricePerKg()) != 0 ||
                !entity.getDescription().equals(req.getDescription());
        // Bạn có thể thêm các trường khác vào đây để so sánh
    }

    @Override
    @Transactional
    public void delete(Long id) {
        ServiceType entity = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ"));

        entity.setIsActive(false);
        repo.save(entity);
    }

    private ServiceTypeResponse mapToResponse(ServiceType entity) {
        return ServiceTypeResponse.builder()
                .serviceTypeId(entity.getServiceTypeId())
                .serviceCode(entity.getServiceCode())
                .serviceName(entity.getServiceName())
                .baseFee(entity.getBaseFee())
                .extraPricePerKg(entity.getExtraPricePerKg())
                .codRate(entity.getCodRate())
                .codMinFee(entity.getCodMinFee())
                .insuranceRate(entity.getInsuranceRate())
                .description(entity.getDescription())
                // Ép kiểu an toàn (null -> false)
                .isActive(entity.getIsActive() != null && entity.getIsActive())
                .version(entity.getVersion())
                .effectiveFrom(entity.getEffectiveFrom())
                .build();
    }

    private void mapRequestToEntity(ServiceTypeRequest request, ServiceType entity) {
        entity.setServiceCode(request.getServiceCode());
        entity.setServiceName(request.getServiceName());
        entity.setBaseFee(request.getBaseFee());
        entity.setExtraPricePerKg(request.getExtraPricePerKg());
        entity.setCodRate(request.getCodRate());
        entity.setCodMinFee(request.getCodMinFee());
        entity.setInsuranceRate(request.getInsuranceRate());
        entity.setDescription(request.getDescription());
    }
}