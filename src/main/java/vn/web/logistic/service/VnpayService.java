package vn.web.logistic.service;

import java.util.Map;
import vn.web.logistic.entity.VnpayTransaction;

public interface VnpayService {
    Map<String, String> createPaymentUrl(Long requestId, Long amount, String ipAddress);

    Map<String, String> processIpn(Map<String, String> params);

    VnpayTransaction processReturnUrl(Map<String, String> params);

    VnpayTransaction findByVnpTxnRef(String vnpTxnRef);

    VnpayTransaction findPendingByRequestId(Long requestId);
}