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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ServiceTypeServiceImpl implements ServiceTypeService {

    private final ServiceTypeRepository repo;

    // 1. Lấy tất cả và convert sang Response DTO
    @Override
    @Transactional(readOnly = true)
    public List<ServiceTypeResponse> getAll() {
        return repo.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    // 2. Lấy chi tiết
    @Override
    @Transactional(readOnly = true)
    public ServiceTypeResponse getById(Long id) {
        ServiceType entity = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ ID: " + id));
        return mapToResponse(entity);
    }

    // 3. Tạo mới (Nhận Request -> Lưu Entity -> Trả về Response)
    @Override
    @Transactional
    public ServiceTypeResponse create(ServiceTypeRequest request) {
        if (repo.existsByServiceCode(request.getServiceCode())) {
            throw new RuntimeException("Mã dịch vụ " + request.getServiceCode() + " đã tồn tại!");
        }

        // Map Request -> Entity
        ServiceType serviceType = new ServiceType();
        mapRequestToEntity(request, serviceType);

        ServiceType savedObj = repo.save(serviceType);
        return mapToResponse(savedObj);
    }

    // 4. Cập nhật
    @Override
    @Transactional
    public ServiceTypeResponse update(Long id, ServiceTypeRequest request) {
        ServiceType existingService = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ để update"));

        // Map data mới vào entity cũ
        mapRequestToEntity(request, existingService);
        // Lưu ý: Không set lại ServiceCode nếu nghiệp vụ không cho phép sửa mã

        ServiceType savedObj = repo.save(existingService);
        return mapToResponse(savedObj);
    }

    // 5. Xóa
    @Override
    @Transactional
    public void delete(Long id) {
        if (!repo.existsById(id)) {
            throw new RuntimeException("Không tìm thấy dịch vụ để xóa");
        }
        repo.deleteById(id);
    }

    // --- Helper functions (Private) ---

    // Helper: Convert Entity -> Response
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
                .build();
    }

    // Helper: Convert Request -> Entity
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