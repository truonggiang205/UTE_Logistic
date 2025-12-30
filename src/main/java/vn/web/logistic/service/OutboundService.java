package vn.web.logistic.service;

import vn.web.logistic.dto.request.outbound.ConsolidateRequest;
import vn.web.logistic.dto.request.outbound.GateOutRequest;
import vn.web.logistic.dto.request.outbound.TripPlanningRequest;
import vn.web.logistic.dto.response.outbound.ConsolidateResponse;
import vn.web.logistic.dto.response.outbound.GateOutResponse;
import vn.web.logistic.dto.response.outbound.TripPlanningResponse;

/**
 * Service cho PHÂN HỆ XUẤT KHO (MIDDLE MILE)
 * Xử lý các chức năng:
 * - Đóng bao (Consolidate)
 * - Tạo chuyến xe (Trip Planning)
 * - Xuất bến (Gate Out)
 */
public interface OutboundService {

    /**
     * CHỨC NĂNG 5: ĐÓNG BAO (Consolidate)
     * Gom nhiều đơn hàng lẻ vào một container để vận chuyển
     * 
     * Logic:
     * 1. Tạo container mới
     * 2. Gán các đơn lẻ vào container (INSERT ContainerDetails)
     * 3. Đơn phải có status='picked' hoặc 'failed' (hàng hoàn) mới được đóng
     * 
     * @param request ConsolidateRequest chứa danh sách requestIds, toHubId
     * @param actorId ID người thực hiện
     * @return ConsolidateResponse kết quả đóng bao
     */
    ConsolidateResponse consolidate(ConsolidateRequest request, Long actorId);

    /**
     * CHỨC NĂNG 6: TẠO CHUYẾN XE (Trip Planning)
     * Lên kế hoạch chuyến vận chuyển
     * 
     * Logic:
     * 1. Kiểm tra xe có đang available và đang ở Hub này không
     * 2. Tạo chuyến xe với status='loading'
     * 
     * @param request TripPlanningRequest chứa vehicleId, driverId, routeId
     * @param actorId ID người thực hiện
     * @return TripPlanningResponse thông tin chuyến xe vừa tạo
     */
    TripPlanningResponse createTrip(TripPlanningRequest request, Long actorId);

    /**
     * CHỨC NĂNG 7: XUẤT BẾN (Gate Out)
     * Xác nhận xe xuất bến và cập nhật trạng thái
     * 
     * Batch Process:
     * 1. Gán Container vào Trip (INSERT TripContainers)
     * 2. Update Xe -> status='in_transit', current_hub=NULL
     * 3. Update Trip -> status='on_way'
     * 4. Update TẤT CẢ đơn hàng trong các Container -> status='in_transit'
     * 5. INSERT Batch ParcelActions (type='EXPORT_WAREHOUSE')
     * 
     * @param request GateOutRequest chứa tripId, danh sách containerIds
     * @param actorId ID người thực hiện
     * @return GateOutResponse kết quả xuất bến
     */
    GateOutResponse gateOut(GateOutRequest request, Long actorId);
}
