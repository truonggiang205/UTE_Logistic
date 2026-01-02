package vn.web.logistic.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.web.logistic.config.VnpayConfig;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.VnpayTransaction;
import vn.web.logistic.entity.VnpayTransaction.VnpayPaymentStatus;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.VnpayTransactionRepository;
import vn.web.logistic.service.VnpayService;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class VnpayServiceImpl implements VnpayService {
    private static final Logger logger = LoggerFactory.getLogger(VnpayServiceImpl.class);

    @Autowired
    private VnpayConfig vnpayConfig;
    @Autowired
    private VnpayTransactionRepository vnpayTransactionRepository;
    @Autowired
    private ServiceRequestRepository serviceRequestRepository;

    @Override
    @Transactional
    public Map<String, String> createPaymentUrl(Long requestId, Long amount, String ipAddress) {
        try {
            ServiceRequest request = serviceRequestRepository.findById(requestId).orElseThrow();
            String vnpTxnRef = VnpayConfig.getRandomNumber(8);

            // Lưu Transaction
            VnpayTransaction transaction = VnpayTransaction.builder()
                    .request(request).amount(BigDecimal.valueOf(amount))
                    .vnpTxnRef(vnpTxnRef).paymentStatus(VnpayPaymentStatus.pending)
                    .createdAt(LocalDateTime.now()).build();
            vnpayTransactionRepository.save(transaction);

            Map<String, String> vnpParams = new LinkedHashMap<>();
            vnpParams.put("vnp_Version", vnpayConfig.getVnpVersion());
            vnpParams.put("vnp_Command", vnpayConfig.getVnpCommand());
            vnpParams.put("vnp_TmnCode", vnpayConfig.getVnpTmnCode());
            vnpParams.put("vnp_Amount", String.valueOf(amount * 100));
            vnpParams.put("vnp_CurrCode", "VND");
            vnpParams.put("vnp_TxnRef", vnpTxnRef);
            vnpParams.put("vnp_OrderInfo", "Thanh toan don hang:" + vnpTxnRef);
            vnpParams.put("vnp_OrderType", vnpayConfig.getVnpOrderType());
            vnpParams.put("vnp_Locale", "vn");
            vnpParams.put("vnp_ReturnUrl", vnpayConfig.getVnpReturnUrl());
            // Luôn sử dụng 127.0.0.1 cho môi trường Sandbox
            vnpParams.put("vnp_IpAddr", "127.0.0.1");

            // Timezone theo VNPAY - dùng Etc/GMT+7 như code mẫu
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnpCreateDate = formatter.format(cld.getTime());
            vnpParams.put("vnp_CreateDate", vnpCreateDate);

            cld.add(Calendar.MINUTE, 15);
            String vnpExpireDate = formatter.format(cld.getTime());
            vnpParams.put("vnp_ExpireDate", vnpExpireDate);

            // Build hashData và query ĐỒNG THỜI như code mẫu VNPAY
            // QUAN TRỌNG: Sort theo alphabetical order
            List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnpParams.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    try {
                        // Build hash data - encode theo US_ASCII như code mẫu VNPAY
                        hashData.append(fieldName);
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        // Build query - cả fieldName và fieldValue đều phải encode
                        query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                        query.append('=');
                        query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        if (itr.hasNext()) {
                            query.append('&');
                            hashData.append('&');
                        }
                    } catch (Exception e) {
                        logger.error("Error encoding parameter: {}", fieldName, e);
                    }
                }
            }

            String queryUrl = query.toString();
            String vnpSecureHash = VnpayConfig.hmacSHA512(vnpayConfig.getSecretKey(), hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnpSecureHash;
            String paymentUrl = vnpayConfig.getVnpPayUrl() + "?" + queryUrl;

            logger.info("=== VNPAY PAYMENT URL CREATED ===");
            logger.info("TxnRef: {}", vnpTxnRef);
            logger.info("HashData: {}", hashData.toString());
            logger.info("SecureHash: {}", vnpSecureHash);

            Map<String, String> result = new HashMap<>();
            result.put("paymentUrl", paymentUrl);
            result.put("vnpTxnRef", vnpTxnRef);
            return result;
        } catch (Exception e) {
            logger.error("Error creating payment URL", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public VnpayTransaction findByVnpTxnRef(String vnpTxnRef) {
        return vnpayTransactionRepository.findByVnpTxnRef(vnpTxnRef).orElse(null);
    }

    @Override
    public VnpayTransaction findPendingByRequestId(Long requestId) {
        return vnpayTransactionRepository
                .findTopByRequest_RequestIdAndPaymentStatusOrderByCreatedAtDesc(requestId, VnpayPaymentStatus.pending)
                .orElse(null);
    }

    /**
     * Verify chữ ký từ VNPAY callback
     * QUAN TRỌNG: Phải loại bỏ vnp_SecureHash và vnp_SecureHashType trước khi
     * verify
     */
    private boolean verifySignature(Map<String, String> params) {
        String vnpSecureHash = params.get("vnp_SecureHash");
        if (vnpSecureHash == null || vnpSecureHash.isEmpty()) {
            logger.error("Missing vnp_SecureHash in callback");
            return false;
        }

        // Sử dụng method verifySecureHash từ VnpayConfig - đã loại bỏ vnp_SecureHash và
        // vnp_SecureHashType bên trong
        boolean isValid = vnpayConfig.verifySecureHash(params, vnpSecureHash);

        if (!isValid) {
            logger.error("Signature verification failed!");
            logger.error("Received hash: {}", vnpSecureHash);

            // Debug: Log các fields được hash
            Map<String, String> fieldsToHash = new LinkedHashMap<>();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                String key = entry.getKey();
                if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType")) {
                    fieldsToHash.put(key, entry.getValue());
                }
            }
            logger.error("Fields to hash: {}", fieldsToHash);
        }
        return isValid;
    }

    /**
     * Xử lý IPN (Instant Payment Notification) từ VNPAY
     * VNPAY gọi API này để thông báo kết quả thanh toán
     */
    @Override
    @Transactional
    public Map<String, String> processIpn(Map<String, String> params) {
        Map<String, String> result = new HashMap<>();
        logger.info("=== PROCESSING VNPAY IPN ===");
        logger.info("IPN Params: {}", params);

        try {
            // 1. Verify signature - đã loại bỏ vnp_SecureHash và vnp_SecureHashType bên
            // trong
            if (!verifySignature(params)) {
                result.put("RspCode", "97");
                result.put("Message", "Invalid signature");
                return result;
            }

            String vnpTxnRef = params.get("vnp_TxnRef");
            String vnpResponseCode = params.get("vnp_ResponseCode");
            String vnpTransactionNo = params.get("vnp_TransactionNo");
            String vnpBankCode = params.get("vnp_BankCode");
            String vnpPayDate = params.get("vnp_PayDate");

            // 2. Tìm transaction
            VnpayTransaction transaction = vnpayTransactionRepository.findByVnpTxnRef(vnpTxnRef).orElse(null);
            if (transaction == null) {
                logger.error("Transaction not found: {}", vnpTxnRef);
                result.put("RspCode", "01");
                result.put("Message", "Order not found");
                return result;
            }

            // 3. Kiểm tra đã xử lý chưa (idempotent)
            if (transaction.getPaymentStatus() != VnpayPaymentStatus.pending) {
                logger.info("Transaction already processed: {} - Status: {}", vnpTxnRef,
                        transaction.getPaymentStatus());
                result.put("RspCode", "02");
                result.put("Message", "Order already confirmed");
                return result;
            }

            // 4. Cập nhật transaction
            transaction.setVnpTransactionNo(vnpTransactionNo);
            transaction.setVnpBankCode(vnpBankCode);
            transaction.setVnpPayDate(vnpPayDate);
            transaction.setVnpResponseCode(vnpResponseCode);
            transaction.setUpdatedAt(LocalDateTime.now());

            // 5. Xử lý theo response code
            if ("00".equals(vnpResponseCode)) {
                // Thanh toán thành công
                transaction.setPaymentStatus(VnpayPaymentStatus.paid);

                // Cập nhật ServiceRequest
                ServiceRequest request = transaction.getRequest();
                if (request != null) {
                    request.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
                    serviceRequestRepository.save(request);
                    logger.info("Updated ServiceRequest {} payment status to PAID", request.getRequestId());
                }

                logger.info("Payment SUCCESS for transaction: {}", vnpTxnRef);
            } else {
                // Thanh toán thất bại
                transaction.setPaymentStatus(VnpayPaymentStatus.failed);
                logger.warn("Payment FAILED for transaction: {} - ResponseCode: {}", vnpTxnRef, vnpResponseCode);
            }

            vnpayTransactionRepository.save(transaction);

            result.put("RspCode", "00");
            result.put("Message", "Confirm Success");
            return result;

        } catch (Exception e) {
            logger.error("Error processing IPN: {}", e.getMessage(), e);
            result.put("RspCode", "99");
            result.put("Message", "Unknown error");
            return result;
        }
    }

    /**
     * Xử lý Return URL - Khi user được redirect về từ VNPAY
     */
    @Override
    @Transactional
    public VnpayTransaction processReturnUrl(Map<String, String> params) {
        logger.info("=== PROCESSING VNPAY RETURN URL ===");
        logger.info("Return Params: {}", params);

        try {
            // 1. Verify signature - đã loại bỏ vnp_SecureHash và vnp_SecureHashType bên
            // trong
            if (!verifySignature(params)) {
                logger.error("Return URL signature verification failed");
                return null;
            }

            String vnpTxnRef = params.get("vnp_TxnRef");
            String vnpResponseCode = params.get("vnp_ResponseCode");
            String vnpTransactionNo = params.get("vnp_TransactionNo");
            String vnpBankCode = params.get("vnp_BankCode");
            String vnpPayDate = params.get("vnp_PayDate");

            // 2. Tìm transaction
            VnpayTransaction transaction = vnpayTransactionRepository.findByVnpTxnRef(vnpTxnRef).orElse(null);
            if (transaction == null) {
                logger.error("Transaction not found for return URL: {}", vnpTxnRef);
                return null;
            }

            // 3. Cập nhật thông tin (nếu chưa được IPN cập nhật)
            if (transaction.getPaymentStatus() == VnpayPaymentStatus.pending) {
                transaction.setVnpTransactionNo(vnpTransactionNo);
                transaction.setVnpBankCode(vnpBankCode);
                transaction.setVnpPayDate(vnpPayDate);
                transaction.setVnpResponseCode(vnpResponseCode);
                transaction.setUpdatedAt(LocalDateTime.now());

                if ("00".equals(vnpResponseCode)) {
                    transaction.setPaymentStatus(VnpayPaymentStatus.paid);

                    // Cập nhật ServiceRequest
                    ServiceRequest request = transaction.getRequest();
                    if (request != null) {
                        request.setPaymentStatus(ServiceRequest.PaymentStatus.paid);
                        serviceRequestRepository.save(request);
                    }
                } else {
                    transaction.setPaymentStatus(VnpayPaymentStatus.failed);
                }

                vnpayTransactionRepository.save(transaction);
            }

            return transaction;

        } catch (Exception e) {
            logger.error("Error processing return URL: {}", e.getMessage(), e);
            return null;
        }
    }
}