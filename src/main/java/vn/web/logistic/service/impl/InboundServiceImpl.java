package vn.web.logistic.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.dto.request.inbound.DropOffRequest;
import vn.web.logistic.dto.request.inbound.ScanInRequest;
import vn.web.logistic.dto.response.inbound.DropOffResponse;
import vn.web.logistic.dto.response.inbound.ScanInResponse;
import vn.web.logistic.entity.*;
import vn.web.logistic.exception.ResourceNotFoundException;
import vn.web.logistic.repository.*;
import vn.web.logistic.service.InboundService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Implementation cho phân hệ NHẬP KHO (INBOUND)
 * Xử lý các nghiệp vụ: Quét Nhập (Scan In) và Tạo đơn tại quầy (Drop-off)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class InboundServiceImpl implements InboundService {

    // ========================= CONSTANTS =========================
    private static final String ACTION_CODE_IMPORT_WAREHOUSE = "IMPORT_WAREHOUSE";
    private static final String ACTION_CODE_COUNTER_SEND = "COUNTER_SEND";
    private static final BigDecimal DIMENSIONAL_WEIGHT_FACTOR = new BigDecimal("6000"); // Hệ số quy đổi thể tích

    // ========================= REPOSITORIES =========================
    private final ServiceRequestRepository serviceRequestRepository;
    private final HubRepository hubRepository;
    private final TripRepository tripRepository;
    private final TripContainerRepository tripContainerRepository;
    private final ParcelActionRepository parcelActionRepository;
    private final ActionTypeRepository actionTypeRepository;
    private final UserRepository userRepository;
    private final CustomerRepository customerRepository;
    private final CustomerAddressRepository customerAddressRepository;
    private final ServiceTypeRepository serviceTypeRepository;
    private final CodTransactionRepository codTransactionRepository;

    // ===================================================================
    // CHỨC NĂNG 1: QUÉT NHẬP (SCAN IN)
    // ===================================================================

    /**
     * Quét nhập kho - Nhân viên kho quét mã đơn hàng để xác nhận hàng đã về kho
     *
     * Business Logic:
     * 1. Validate: Kiểm tra các requestId có tồn tại
     * 2. Update: Cập nhật ServiceRequest: status='picked',
     * current_hub_id=currentHubId
     * 3. Log: Thêm vào ParcelActions với type='IMPORT_WAREHOUSE'
     * 4. Trip Logic: Nếu có tripId, kiểm tra và cập nhật trạng thái chuyến xe
     */
    @Override
    @Transactional
    public ScanInResponse scanIn(ScanInRequest request, Long actorId) {
        log.info("=== BẮT ĐẦU QUÉT NHẬP KHO ===");
        log.info("Hub hiện tại: {}, Số đơn: {}, Trip ID: {}",
                request.getCurrentHubId(), request.getRequestIds().size(), request.getTripId());

        // === STEP 1: Validate Hub và Actor ===
        Hub currentHub = hubRepository.findById(request.getCurrentHubId())
                .orElseThrow(
                        () -> new ResourceNotFoundException("Hub", "hubId", request.getCurrentHubId()));

        User actor = userRepository.findById(actorId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "userId", actorId));

        ActionType importAction = actionTypeRepository.findByActionCode(ACTION_CODE_IMPORT_WAREHOUSE)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "ActionType", "actionCode", ACTION_CODE_IMPORT_WAREHOUSE));

        // === STEP 2: Xử lý từng đơn hàng ===
        List<ScanInResponse.ScanResult> results = new ArrayList<>();
        int successCount = 0;
        int failedCount = 0;

        for (Long requestId : request.getRequestIds()) {
            ScanInResponse.ScanResult result = processSingleScanIn(
                    requestId, currentHub, actor, importAction, request.getNote());
            results.add(result);

            if (result.isSuccess()) {
                successCount++;
            } else {
                failedCount++;
            }
        }

        // === STEP 3: Xử lý Trip Logic (nếu có tripId) ===
        ScanInResponse.TripStatusInfo tripStatusInfo = null;
        if (request.getTripId() != null) {
            tripStatusInfo = processTripCompletion(request.getTripId());
        }

        log.info("=== KẾT THÚC QUÉT NHẬP KHO: Thành công {}/{} đơn ===", successCount, results.size());

        return ScanInResponse.builder()
                .totalScanned(results.size())
                .successCount(successCount)
                .failedCount(failedCount)
                .results(results)
                .tripStatus(tripStatusInfo)
                .build();
    }

    /**
     * Xử lý quét nhập cho một đơn hàng đơn lẻ
     */
    private ScanInResponse.ScanResult processSingleScanIn(
            Long requestId, Hub currentHub, User actor, ActionType importAction, String note) {

        try {
            // Tìm đơn hàng
            Optional<ServiceRequest> optRequest = serviceRequestRepository.findById(requestId);

            if (optRequest.isEmpty()) {
                return ScanInResponse.ScanResult.builder()
                        .requestId(requestId)
                        .success(false)
                        .message("Không tìm thấy đơn hàng với mã: " + requestId)
                        .build();
            }

            ServiceRequest serviceRequest = optRequest.get();
            String previousStatus = serviceRequest.getStatus().name();

            // Lấy Hub cũ để log
            Hub fromHub = serviceRequest.getCurrentHub();

            // Cập nhật trạng thái đơn hàng
            serviceRequest.setStatus(ServiceRequest.RequestStatus.picked);
            serviceRequest.setCurrentHub(currentHub);
            serviceRequestRepository.save(serviceRequest);

            // Tạo log ParcelAction
            ParcelAction action = ParcelAction.builder()
                    .request(serviceRequest)
                    .actionType(importAction)
                    .fromHub(fromHub)
                    .toHub(currentHub)
                    .actor(actor)
                    .actionTime(LocalDateTime.now())
                    .note(note != null ? note : "Nhập kho - Quét mã đơn hàng")
                    .build();
            parcelActionRepository.save(action);

            log.debug("Quét nhập thành công đơn hàng: {} -> Hub: {}", requestId, currentHub.getHubName());

            return ScanInResponse.ScanResult.builder()
                    .requestId(requestId)
                    .success(true)
                    .message("Nhập kho thành công")
                    .previousStatus(previousStatus)
                    .newStatus(ServiceRequest.RequestStatus.picked.name())
                    .build();

        } catch (Exception e) {
            log.error("Lỗi khi xử lý đơn hàng {}: {}", requestId, e.getMessage());
            return ScanInResponse.ScanResult.builder()
                    .requestId(requestId)
                    .success(false)
                    .message("Lỗi xử lý: " + e.getMessage())
                    .build();
        }
    }

    /**
     * Kiểm tra và cập nhật trạng thái chuyến xe khi nhập từ xe tải
     * Nếu tất cả container đã dỡ hàng -> chuyển trạng thái Trip thành 'completed'
     */
    private ScanInResponse.TripStatusInfo processTripCompletion(Long tripId) {
        log.info("Kiểm tra hoàn thành chuyến xe: {}", tripId);

        Trip trip = tripRepository.findById(tripId)
                .orElseThrow(() -> new ResourceNotFoundException("Trip", "tripId", tripId));

        String previousStatus = trip.getStatus().name();

        // Lấy danh sách TripContainer
        List<TripContainer> tripContainers = tripContainerRepository.findByTripIdWithContainerDetails(tripId);
        int totalContainers = tripContainers.size();

        // Đếm số container đã dỡ
        long unloadedCount = tripContainers.stream()
                .filter(tc -> tc.getStatus() == TripContainer.TripContainerStatus.unloaded)
                .count();

        boolean isCompleted = (unloadedCount == totalContainers && totalContainers > 0);

        // Nếu tất cả đã dỡ -> cập nhật trạng thái trip
        if (isCompleted && trip.getStatus() != Trip.TripStatus.completed) {
            trip.setStatus(Trip.TripStatus.completed);
            trip.setArrivedAt(LocalDateTime.now());
            tripRepository.save(trip);
            log.info("Chuyến xe {} đã hoàn thành - Tất cả {} container đã dỡ hàng", tripId, totalContainers);
        }

        return ScanInResponse.TripStatusInfo.builder()
                .tripId(tripId)
                .tripCode(trip.getTripCode())
                .previousStatus(previousStatus)
                .newStatus(trip.getStatus().name())
                .totalContainers(totalContainers)
                .unloadedContainers((int) unloadedCount)
                .isCompleted(isCompleted)
                .build();
    }

    // ===================================================================
    // CHỨC NĂNG 2: TẠO ĐƠN TẠI QUẦY (DROP-OFF)
    // ===================================================================

    /**
     * Tạo đơn tại quầy - Khách mang hàng ra bưu cục gửi trực tiếp
     *
     * Business Logic:
     * 1. Calculate Fee: Tính cước phí dựa trên weight và loại dịch vụ
     * 2. Create Order: Tạo ServiceRequest với status='picked',
     * payment_status='paid'
     * 3. Log: Thêm vào ParcelActions với type='COUNTER_SEND'
     * 4. Transaction: Thêm vào CodTransactions để ghi nhận việc thu tiền cước
     */
    @Override
    @Transactional
    public DropOffResponse createDropOffOrder(DropOffRequest request, Long actorId) {
        log.info("=== BẮT ĐẦU TẠO ĐƠN TẠI QUẦY ===");
        log.info("Hub: {}, Service Type: {}, Weight: {} kg",
                request.getCurrentHubId(), request.getServiceTypeId(), request.getWeight());

        try {
            // === STEP 1: Validate và lấy các entity cần thiết ===
            Hub currentHub = hubRepository.findById(request.getCurrentHubId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Hub", "hubId", request.getCurrentHubId()));

            User actor = userRepository.findById(actorId)
                    .orElseThrow(() -> new ResourceNotFoundException("User", "userId", actorId));

            ServiceType serviceType = serviceTypeRepository.findById(request.getServiceTypeId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "ServiceType", "serviceTypeId", request.getServiceTypeId()));

            ActionType counterSendAction = actionTypeRepository.findByActionCode(ACTION_CODE_COUNTER_SEND)
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "ActionType", "actionCode", ACTION_CODE_COUNTER_SEND));

            // === STEP 2: Tạo hoặc tìm Customer (khách vãng lai) ===
            Customer customer = findOrCreateCustomer(request.getSenderInfo());

            // === STEP 3: Tạo địa chỉ gửi và nhận ===
            CustomerAddress pickupAddress = createAddress(customer, request.getSenderInfo());
            CustomerAddress deliveryAddress = createAddress(customer, request.getReceiverInfo());

            // === STEP 4: Tính phí vận chuyển ===
            DropOffResponse.FeeDetails feeDetails = calculateShippingFee(
                    request.getWeight(),
                    request.getLength(),
                    request.getWidth(),
                    request.getHeight(),
                    request.getCodAmount(),
                    serviceType);

            // === STEP 5: Tạo ServiceRequest ===
            ServiceRequest serviceRequest = ServiceRequest.builder()
                    .customer(customer)
                    .pickupAddress(pickupAddress)
                    .deliveryAddress(deliveryAddress)
                    .serviceType(serviceType)
                    .weight(request.getWeight())
                    .length(request.getLength())
                    .width(request.getWidth())
                    .height(request.getHeight())
                    .chargeableWeight(feeDetails.getChargeableWeight())
                    .shippingFee(feeDetails.getShippingFee())
                    .codFee(feeDetails.getCodFee())
                    .insuranceFee(feeDetails.getInsuranceFee())
                    .totalPrice(feeDetails.getTotalPrice())
                    .codAmount(request.getCodAmount() != null ? request.getCodAmount() : BigDecimal.ZERO)
                    .receiverPayAmount(request.getCodAmount()) // Người nhận trả tiền COD
                    .status(ServiceRequest.RequestStatus.picked) // Đã lấy hàng tại quầy
                    .paymentStatus(ServiceRequest.PaymentStatus.paid) // Khách trả tiền ngay
                    .currentHub(currentHub)
                    .itemName(request.getItemName())
                    .note(request.getNote())
                    .createdAt(LocalDateTime.now())
                    .build();

            serviceRequest = serviceRequestRepository.save(serviceRequest);
            log.info("Đã tạo đơn hàng: {}", serviceRequest.getRequestId());

            // === STEP 6: Tạo ParcelAction log ===
            ParcelAction action = ParcelAction.builder()
                    .request(serviceRequest)
                    .actionType(counterSendAction)
                    .toHub(currentHub) // Gửi tại quầy -> toHub là Hub hiện tại
                    .actor(actor)
                    .actionTime(LocalDateTime.now())
                    .note("Khách gửi hàng trực tiếp tại quầy - " + currentHub.getHubName())
                    .build();
            parcelActionRepository.save(action);

            // === STEP 7: Tạo CodTransaction (ghi nhận thu tiền cước) ===
            CodTransaction codTransaction = CodTransaction.builder()
                    .request(serviceRequest)
                    .shipper(null) // Thu tại quầy, không có shipper
                    .amount(feeDetails.getTotalPrice())
                    .collectedAt(LocalDateTime.now())
                    .settledAt(LocalDateTime.now()) // Thu tiền ngay -> đã quyết toán
                    .status(CodTransaction.CodStatus.settled)
                    .paymentMethod(request.getPaymentMethod())
                    .build();
            codTransaction = codTransactionRepository.save(codTransaction);
            log.info("Đã ghi nhận giao dịch thu tiền: {} - Số tiền: {}",
                    codTransaction.getCodTxId(), feeDetails.getTotalPrice());

            log.info("=== HOÀN THÀNH TẠO ĐƠN TẠI QUẦY: {} ===", serviceRequest.getRequestId());

            // === STEP 8: Build Response ===
            return buildDropOffResponse(serviceRequest, feeDetails, codTransaction, request);

        } catch (Exception e) {
            log.error("Lỗi khi tạo đơn tại quầy: {}", e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tạo đơn tại quầy: " + e.getMessage(), e);
        }
    }

    /**
     * Tìm hoặc tạo mới Customer dựa trên số điện thoại
     * Nếu không tìm thấy -> tạo khách vãng lai
     */
    private Customer findOrCreateCustomer(DropOffRequest.AddressInfo senderInfo) {
        // Tìm customer theo số điện thoại
        Optional<Customer> existingCustomer = customerRepository.findByPhone(senderInfo.getContactPhone());

        if (existingCustomer.isPresent()) {
            log.debug("Tìm thấy khách hàng với SĐT: {}", senderInfo.getContactPhone());
            return existingCustomer.get();
        }

        // Tạo khách vãng lai
        Customer newCustomer = Customer.builder()
                .fullName(senderInfo.getContactName())
                .phone(senderInfo.getContactPhone())
                .email(senderInfo.getEmail())
                .createdAt(LocalDateTime.now())
                .build();

        newCustomer = customerRepository.save(newCustomer);
        log.info("Đã tạo khách hàng mới (vãng lai): {} - {}", newCustomer.getCustomerId(),
                senderInfo.getContactPhone());

        return newCustomer;
    }

    /**
     * Tạo CustomerAddress từ AddressInfo
     */
    private CustomerAddress createAddress(Customer customer, DropOffRequest.AddressInfo addressInfo) {
        CustomerAddress address = CustomerAddress.builder()
                .customer(customer)
                .contactName(addressInfo.getContactName())
                .contactPhone(addressInfo.getContactPhone())
                .addressDetail(addressInfo.getAddressDetail())
                .ward(addressInfo.getWard())
                .district(addressInfo.getDistrict())
                .province(addressInfo.getProvince())
                .isDefault(false)
                .build();

        return customerAddressRepository.save(address);
    }

    /**
     * Tính phí vận chuyển dựa trên trọng lượng, kích thước và loại dịch vụ
     *
     * Công thức:
     * 1. Trọng lượng quy đổi = (Dài x Rộng x Cao) / 6000
     * 2. Trọng lượng tính cước = MAX(Trọng lượng thực, Trọng lượng quy đổi)
     * 3. Phí vận chuyển = Phí cơ bản + (Trọng lượng tính cước * Giá/kg)
     * 4. Phí COD = MAX(COD * COD_Rate, COD_Min_Fee)
     * 5. Tổng = Phí vận chuyển + Phí COD + Phí bảo hiểm
     */
    private DropOffResponse.FeeDetails calculateShippingFee(
            BigDecimal weight,
            BigDecimal length,
            BigDecimal width,
            BigDecimal height,
            BigDecimal codAmount,
            ServiceType serviceType) {

        log.debug("Bắt đầu tính phí - Weight: {}, L x W x H: {} x {} x {}",
                weight, length, width, height);

        // 1. Tính trọng lượng quy đổi từ kích thước
        BigDecimal dimensionalWeight = BigDecimal.ZERO;
        if (length != null && width != null && height != null) {
            dimensionalWeight = length.multiply(width).multiply(height)
                    .divide(DIMENSIONAL_WEIGHT_FACTOR, 2, RoundingMode.CEILING);
        }

        // 2. Trọng lượng tính cước = MAX(thực, quy đổi)
        BigDecimal chargeableWeight = weight.max(dimensionalWeight);

        // 3. Phí vận chuyển = baseFee + (chargeableWeight * extraPricePerKg)
        BigDecimal shippingFee = serviceType.getBaseFee()
                .add(chargeableWeight.multiply(serviceType.getExtraPricePerKg()))
                .setScale(0, RoundingMode.CEILING); // Làm tròn lên

        // 4. Phí COD (nếu có)
        BigDecimal codFee = BigDecimal.ZERO;
        if (codAmount != null && codAmount.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal calculatedCodFee = codAmount.multiply(serviceType.getCodRate());
            codFee = calculatedCodFee.max(serviceType.getCodMinFee())
                    .setScale(0, RoundingMode.CEILING);
        }

        // 5. Phí bảo hiểm (tạm tính = 0, có thể mở rộng sau)
        BigDecimal insuranceFee = BigDecimal.ZERO;

        // 6. Tổng tiền
        BigDecimal totalPrice = shippingFee.add(codFee).add(insuranceFee);

        log.debug("Kết quả tính phí - Chargeable: {} kg, Shipping: {}, COD Fee: {}, Total: {}",
                chargeableWeight, shippingFee, codFee, totalPrice);

        return DropOffResponse.FeeDetails.builder()
                .actualWeight(weight)
                .dimensionalWeight(dimensionalWeight)
                .chargeableWeight(chargeableWeight)
                .shippingFee(shippingFee)
                .codFee(codFee)
                .insuranceFee(insuranceFee)
                .totalPrice(totalPrice)
                .build();
    }

    /**
     * Build DropOffResponse từ các entity đã tạo
     */
    private DropOffResponse buildDropOffResponse(
            ServiceRequest serviceRequest,
            DropOffResponse.FeeDetails feeDetails,
            CodTransaction codTransaction,
            DropOffRequest request) {

        // Build sender info
        DropOffResponse.AddressInfo senderInfo = DropOffResponse.AddressInfo.builder()
                .contactName(request.getSenderInfo().getContactName())
                .contactPhone(request.getSenderInfo().getContactPhone())
                .fullAddress(buildFullAddress(request.getSenderInfo()))
                .build();

        // Build receiver info
        DropOffResponse.AddressInfo receiverInfo = DropOffResponse.AddressInfo.builder()
                .contactName(request.getReceiverInfo().getContactName())
                .contactPhone(request.getReceiverInfo().getContactPhone())
                .fullAddress(buildFullAddress(request.getReceiverInfo()))
                .build();

        // Build COD transaction info
        DropOffResponse.CodTransactionInfo codTransactionInfo = DropOffResponse.CodTransactionInfo.builder()
                .transactionId(codTransaction.getCodTxId())
                .amount(codTransaction.getAmount())
                .paymentMethod(codTransaction.getPaymentMethod())
                .status(codTransaction.getStatus().name())
                .collectedAt(codTransaction.getCollectedAt())
                .build();

        return DropOffResponse.builder()
                .requestId(serviceRequest.getRequestId())
                .feeDetails(feeDetails)
                .codTransaction(codTransactionInfo)
                .createdAt(serviceRequest.getCreatedAt())
                .status(serviceRequest.getStatus().name())
                .paymentStatus(serviceRequest.getPaymentStatus().name())
                .senderInfo(senderInfo)
                .receiverInfo(receiverInfo)
                .message("Tạo đơn hàng thành công!")
                .build();
    }

    /**
     * Ghép địa chỉ đầy đủ
     */
    private String buildFullAddress(DropOffRequest.AddressInfo addressInfo) {
        StringBuilder sb = new StringBuilder();
        sb.append(addressInfo.getAddressDetail());

        if (addressInfo.getWard() != null && !addressInfo.getWard().isEmpty()) {
            sb.append(", ").append(addressInfo.getWard());
        }
        if (addressInfo.getDistrict() != null && !addressInfo.getDistrict().isEmpty()) {
            sb.append(", ").append(addressInfo.getDistrict());
        }
        if (addressInfo.getProvince() != null && !addressInfo.getProvince().isEmpty()) {
            sb.append(", ").append(addressInfo.getProvince());
        }

        return sb.toString();
    }
}
