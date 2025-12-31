package vn.web.logistic.service;

import java.util.List;

import vn.web.logistic.dto.request.CodSettlementRequest;
import vn.web.logistic.dto.response.manager.CodSettlementResultDTO;
import vn.web.logistic.dto.response.manager.ShipperCodSummaryDTO;

/**
 * Service interface cho nghiệp vụ Quyết toán COD của Manager
 * 
 * Flow nghiệp vụ:
 * 1. Manager xem danh sách shipper có COD chưa quyết toán
 * 2. Manager chọn shipper để xem chi tiết các khoản COD
 * 3. Manager thực hiện quyết toán (update status = settled)
 */
public interface CodSettlementService {

    /**
     * Lấy danh sách shipper có COD chưa quyết toán trong Hub
     * 
     * @param hubId ID của Hub mà Manager quản lý
     * @return Danh sách shipper với tổng tiền COD đang giữ
     */
    List<ShipperCodSummaryDTO> getShippersWithPendingCod(Long hubId);

    /**
     * Lấy chi tiết COD của một shipper
     * 
     * @param shipperId ID của shipper
     * @return Chi tiết các khoản COD đang chờ quyết toán
     */
    ShipperCodSummaryDTO getShipperCodDetail(Long shipperId);

    /**
     * Thực hiện quyết toán COD cho shipper
     * 
     * Bước 1: Validate shipper và số tiền
     * Bước 2: Lấy danh sách COD transactions cần quyết toán
     * Bước 3: Update status thành 'settled', set settledAt = NOW()
     * Bước 4: Ghi log và trả về kết quả
     * 
     * @param request     Thông tin quyết toán
     * @param managerName Tên Manager thực hiện quyết toán
     * @return Kết quả quyết toán
     */
    CodSettlementResultDTO settleCod(CodSettlementRequest request, String managerName);

    /**
     * Lấy lịch sử quyết toán COD của một shipper
     * 
     * @param shipperId ID của shipper
     * @return Danh sách các khoản COD đã quyết toán
     */
    ShipperCodSummaryDTO getSettlementHistory(Long shipperId);
}
