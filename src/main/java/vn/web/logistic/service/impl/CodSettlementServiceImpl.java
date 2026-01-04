package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import vn.web.logistic.dto.request.CodSettlementRequest;
import vn.web.logistic.dto.response.manager.CodSettlementResultDTO;
import vn.web.logistic.dto.response.manager.ShipperCodSummaryDTO;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.repository.CodSettlementRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.service.CodSettlementService;

@Service
@RequiredArgsConstructor
@Slf4j
public class CodSettlementServiceImpl implements CodSettlementService {

    private final CodSettlementRepository codSettlementRepository;
    private final ServiceRequestRepository serviceRequestRepository;

    @Override
    public List<ShipperCodSummaryDTO> getShippersWithPendingCod(Long hubId) {
        log.info("Lấy danh sách shipper có COD chưa quyết toán trong Hub: {}", hubId);

        // Lấy danh sách shipper có COD pending trong Hub (shipper đang giữ tiền)
        List<Shipper> shippers = codSettlementRepository.findShippersWithPendingCodByHubId(hubId);

        List<ShipperCodSummaryDTO> result = new ArrayList<>();

        for (Shipper shipper : shippers) {
            BigDecimal totalAmount = codSettlementRepository.sumCollectedByShipperId(shipper.getShipperId());
            Long totalCount = codSettlementRepository.countCollectedByShipperId(shipper.getShipperId());

            ShipperCodSummaryDTO dto = ShipperCodSummaryDTO.builder()
                    .shipperId(shipper.getShipperId())
                    .shipperName(shipper.getUser() != null ? shipper.getUser().getFullName() : "N/A")
                    .shipperPhone(shipper.getUser() != null ? shipper.getUser().getPhone() : "N/A")
                    .shipperEmail(shipper.getUser() != null ? shipper.getUser().getEmail() : "N/A")
                    .totalCollectedAmount(totalAmount != null ? totalAmount : BigDecimal.ZERO)
                    .totalCollectedCount(totalCount != null ? totalCount : 0L)
                    .build();

            result.add(dto);
        }

        // Sắp xếp theo tổng tiền giảm dần
        result.sort((a, b) -> b.getTotalCollectedAmount().compareTo(a.getTotalCollectedAmount()));

        log.info("Tìm thấy {} shipper có COD chưa quyết toán", result.size());
        return result;
    }

    @Override
    public ShipperCodSummaryDTO getShipperCodDetail(Long shipperId) {
        log.info("Lấy chi tiết COD của shipper: {}", shipperId);

        // Lấy danh sách COD pending của shipper (shipper đang giữ tiền)
        List<CodTransaction> transactions = codSettlementRepository.findCollectedByShipperId(shipperId);

        if (transactions.isEmpty()) {
            return ShipperCodSummaryDTO.builder()
                    .shipperId(shipperId)
                    .totalCollectedAmount(BigDecimal.ZERO)
                    .totalCollectedCount(0L)
                    .transactions(new ArrayList<>())
                    .build();
        }

        // Lấy thông tin shipper từ transaction đầu tiên
        Shipper shipper = transactions.get(0).getShipper();

        // Map các transaction
        List<ShipperCodSummaryDTO.CodTransactionDTO> transactionDTOs = transactions.stream()
                .map(tx -> ShipperCodSummaryDTO.CodTransactionDTO.builder()
                        .codTxId(tx.getCodTxId())
                        .requestId(tx.getRequest().getRequestId())
                        .trackingCode("VN" + String.format("%08d", tx.getRequest().getRequestId()))
                        .customerName(getCustomerName(tx))
                        .amount(tx.getAmount())
                        .collectedAt(tx.getCollectedAt())
                        .paymentMethod(tx.getPaymentMethod())
                        .build())
                .collect(Collectors.toList());

        // Tính tổng
        BigDecimal totalAmount = transactions.stream()
                .map(CodTransaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return ShipperCodSummaryDTO.builder()
                .shipperId(shipperId)
                .shipperName(shipper.getUser() != null ? shipper.getUser().getFullName() : "N/A")
                .shipperPhone(shipper.getUser() != null ? shipper.getUser().getPhone() : "N/A")
                .shipperEmail(shipper.getUser() != null ? shipper.getUser().getEmail() : "N/A")
                .totalCollectedAmount(totalAmount)
                .totalCollectedCount((long) transactions.size())
                .transactions(transactionDTOs)
                .build();
    }

    @Override
    @Transactional
    public CodSettlementResultDTO settleCod(CodSettlementRequest request, String managerName) {
        log.info("Thực hiện quyết toán COD cho shipper: {} bởi Manager: {}", request.getShipperId(), managerName);

        try {
            // Bước 1: Validate
            if (request.getShipperId() == null) {
                return CodSettlementResultDTO.builder()
                        .success(false)
                        .message("Shipper ID không được để trống")
                        .build();
            }

            // Bước 2: Lấy danh sách COD cần quyết toán
            List<CodTransaction> transactions;

            if (request.getCodTxIds() != null && !request.getCodTxIds().isEmpty()) {
                // Quyết toán các transaction cụ thể
                transactions = codSettlementRepository.findAllById(request.getCodTxIds());
                // Validate: chỉ lấy những transaction thuộc shipper và có status = collected
                // (đã nộp, chờ duyệt)
                transactions = transactions.stream()
                        .filter(tx -> tx.getShipper().getShipperId().equals(request.getShipperId()))
                        .filter(tx -> tx.getStatus() == CodTransaction.CodStatus.collected)
                        .collect(Collectors.toList());
            } else {
                // Quyết toán tất cả COD pending của shipper
                transactions = codSettlementRepository.findCollectedByShipperId(request.getShipperId());
            }

            if (transactions.isEmpty()) {
                return CodSettlementResultDTO.builder()
                        .success(false)
                        .message("Không tìm thấy khoản COD nào cần quyết toán")
                        .shipperId(request.getShipperId())
                        .build();
            }

            // Bước 3: Tính tổng tiền
            BigDecimal totalAmount = transactions.stream()
                    .map(CodTransaction::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Validate số tiền nếu có
            if (request.getAmount() != null && request.getAmount().compareTo(BigDecimal.ZERO) > 0) {
                if (totalAmount.compareTo(request.getAmount()) != 0) {
                    log.warn("Số tiền quyết toán không khớp. Expected: {}, Actual: {}",
                            request.getAmount(), totalAmount);
                    // Cho phép quyết toán nhưng ghi log cảnh báo
                }
            }

            // Bước 4: Update status thành settled
            LocalDateTime settledAt = LocalDateTime.now();
            String shipperName = null;

            for (CodTransaction tx : transactions) {
                tx.setStatus(CodTransaction.CodStatus.settled);
                tx.setSettledAt(settledAt);

                if (shipperName == null && tx.getShipper().getUser() != null) {
                    shipperName = tx.getShipper().getUser().getFullName();
                }

                // Cập nhật paymentStatus của ServiceRequest thành paid
                ServiceRequest serviceRequest = tx.getRequest();
                if (serviceRequest != null) {
                    serviceRequest.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
                    serviceRequestRepository.save(serviceRequest);
                    log.info("Đã cập nhật paymentStatus=paid cho request #{}", serviceRequest.getRequestId());
                }
            }

            // Lưu COD Transactions vào database
            codSettlementRepository.saveAll(transactions);

            log.info("Quyết toán thành công {} đơn COD với tổng tiền {} cho shipper {}",
                    transactions.size(), totalAmount, request.getShipperId());

            return CodSettlementResultDTO.builder()
                    .success(true)
                    .message("Quyết toán COD thành công")
                    .shipperId(request.getShipperId())
                    .shipperName(shipperName)
                    .settledAmount(totalAmount)
                    .settledCount(transactions.size())
                    .settledAt(settledAt)
                    .settledBy(managerName)
                    .build();

        } catch (Exception e) {
            log.error("Lỗi khi quyết toán COD cho shipper {}: {}", request.getShipperId(), e.getMessage(), e);
            return CodSettlementResultDTO.builder()
                    .success(false)
                    .message("Lỗi hệ thống: " + e.getMessage())
                    .shipperId(request.getShipperId())
                    .build();
        }
    }

    @Override
    public ShipperCodSummaryDTO getSettlementHistory(Long shipperId) {
        log.info("Lấy lịch sử quyết toán COD của shipper: {}", shipperId);

        // Lấy danh sách COD settled của shipper
        List<CodTransaction> transactions = codSettlementRepository.findSettledByShipperId(shipperId);

        if (transactions.isEmpty()) {
            return ShipperCodSummaryDTO.builder()
                    .shipperId(shipperId)
                    .totalCollectedAmount(BigDecimal.ZERO)
                    .totalCollectedCount(0L)
                    .transactions(new ArrayList<>())
                    .build();
        }

        // Lấy thông tin shipper
        Shipper shipper = transactions.get(0).getShipper();

        // Map các transaction
        List<ShipperCodSummaryDTO.CodTransactionDTO> transactionDTOs = transactions.stream()
                .map(tx -> ShipperCodSummaryDTO.CodTransactionDTO.builder()
                        .codTxId(tx.getCodTxId())
                        .requestId(tx.getRequest().getRequestId())
                        .trackingCode("VN" + String.format("%08d", tx.getRequest().getRequestId()))
                        .customerName(getCustomerName(tx))
                        .amount(tx.getAmount())
                        .collectedAt(tx.getSettledAt()) // Dùng settledAt cho lịch sử
                        .paymentMethod(tx.getPaymentMethod())
                        .build())
                .collect(Collectors.toList());

        // Tính tổng
        BigDecimal totalAmount = transactions.stream()
                .map(CodTransaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return ShipperCodSummaryDTO.builder()
                .shipperId(shipperId)
                .shipperName(shipper.getUser() != null ? shipper.getUser().getFullName() : "N/A")
                .shipperPhone(shipper.getUser() != null ? shipper.getUser().getPhone() : "N/A")
                .shipperEmail(shipper.getUser() != null ? shipper.getUser().getEmail() : "N/A")
                .totalCollectedAmount(totalAmount)
                .totalCollectedCount((long) transactions.size())
                .transactions(transactionDTOs)
                .build();
    }

    /**
     * Lấy tên khách hàng từ transaction
     */
    private String getCustomerName(CodTransaction tx) {
        if (tx.getRequest() != null && tx.getRequest().getDeliveryAddress() != null) {
            return tx.getRequest().getDeliveryAddress().getContactName();
        }
        return "N/A";
    }

    @Override
    public Map<String, BigDecimal> getHubStatistics(Long hubId) {
        log.info("Lấy thống kê COD cho Hub: {}", hubId);

        Map<String, BigDecimal> stats = new HashMap<>();

        // Tổng tiền đã quyết toán hôm nay
        BigDecimal settledToday = codSettlementRepository.sumSettledTodayByHubId(hubId);
        stats.put("settledToday", settledToday != null ? settledToday : BigDecimal.ZERO);

        // Tổng tiền pending (shipper đang giữ, chưa nộp)
        BigDecimal pendingTotal = codSettlementRepository.sumPendingCodByHubId(hubId);
        stats.put("pendingTotal", pendingTotal != null ? pendingTotal : BigDecimal.ZERO);

        // Tổng doanh thu đã settled (tất cả thời gian)
        BigDecimal totalSettled = codSettlementRepository.sumTotalSettledByHubId(hubId);
        stats.put("totalSettled", totalSettled != null ? totalSettled : BigDecimal.ZERO);

        return stats;
    }
}
