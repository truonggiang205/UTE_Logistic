package vn.web.logistic.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import vn.web.logistic.dto.request.CodSettlementRequest;
import vn.web.logistic.dto.response.manager.CodSettlementResultDTO;
import vn.web.logistic.dto.response.manager.ShipperCodSummaryDTO;

public interface CodSettlementService {

    List<ShipperCodSummaryDTO> getShippersWithPendingCod(Long hubId);

    // Danh sách shipper đang giữ tiền COD (pending - chưa nộp về Hub)
    List<ShipperCodSummaryDTO> getShippersWithPendingHoldCod(Long hubId);

    // Chi tiết COD pending của một shipper
    ShipperCodSummaryDTO getShipperPendingCodDetail(Long shipperId);

    // Chi tiết COD của một shipper
    ShipperCodSummaryDTO getShipperCodDetail(Long shipperId);

    // Thực hiện quyết toán COD cho shipper
    CodSettlementResultDTO settleCod(CodSettlementRequest request, String managerName);

    // Lấy lịch sử quyết toán COD của một shipper
    ShipperCodSummaryDTO getSettlementHistory(Long shipperId);

    // Lấy các thống kê COD cho trang quyết toán
    Map<String, BigDecimal> getHubStatistics(Long hubId);
}
