package vn.web.logistic.service;

import vn.web.logistic.dto.request.outbound.*;
import vn.web.logistic.dto.response.outbound.*;

import java.util.List;

/**
 * OutboundService - Phân hệ Xuất Kho (Middle Mile)
 * 
 * NHÓM 1: Quản lý Đóng gói (Consolidation)
 * NHÓM 2: Điều phối xe (Trip Planning)
 * NHÓM 3: Xếp hàng lên xe (Loading)
 * NHÓM 4: Xuất bến (Gate Out)
 */
public interface OutboundService {

    // ===================================================================
    // NHÓM 1: QUẢN LÝ ĐÓNG GÓI (CONSOLIDATION)
    // ===================================================================

    /**
     * 1.1. Lấy danh sách đơn hàng chờ đóng gói tại Hub
     * - Đơn đang nằm ở Hub hiện tại (currentHub = hubId)
     * - Trạng thái: picked (đã lấy), hoặc hàng từ kho khác chuyển tới
     * - Chưa nằm trong bao nào
     */
    List<PendingOrderResponse> getPendingOrdersForConsolidation(Long hubId);

    /**
     * 1.2. Tạo bao mới (Container)
     * 
     * @param request Thông tin bao: mã bao, loại bao, đích đến
     * @param hubId   Hub hiện tại (nơi tạo bao)
     * @param actorId User thực hiện
     * @return Container đã tạo
     */
    ContainerDetailResponse createContainer(CreateContainerRequest request, Long hubId, Long actorId);

    /**
     * 1.3. Xem danh sách các bao tại Hub
     * - Bao đang mở (created)
     * - Bao đã đóng (closed)
     */
    List<ContainerListResponse> getContainersAtHub(Long hubId);

    /**
     * 1.4. Xem chi tiết bao (các đơn hàng trong bao)
     */
    ContainerDetailResponse getContainerDetail(Long containerId);

    /**
     * 1.5. Thêm đơn hàng vào bao
     * - Cập nhật trọng lượng bao
     * - Tạo ContainerDetail
     */
    void addOrderToContainer(AddOrderToContainerRequest request, Long actorId);

    /**
     * 1.6. Gỡ đơn hàng khỏi bao
     * - Trừ trọng lượng bao
     * - Xóa ContainerDetail
     */
    void removeOrderFromContainer(RemoveOrderFromContainerRequest request, Long actorId);

    /**
     * 1.7. Chốt bao (Seal Container)
     * - Chuyển trạng thái bao sang "closed" (đã đóng)
     * - Bao sẵn sàng để xếp lên xe
     */
    void sealContainer(Long containerId, Long actorId);

    /**
     * 1.7b. Mở lại bao (Reopen Container)
     * - Chuyển trạng thái bao từ "closed" về "created"
     * - Cho phép thêm/bớt đơn hàng
     * - Chỉ áp dụng cho bao chưa xếp lên xe
     */
    void reopenContainer(Long containerId, Long actorId);

    /**
     * 1.8. Đóng hàng loạt đơn vào bao
     * - Thêm nhiều đơn vào container
     * - Trả về kết quả từng đơn
     */
    ConsolidateResponse consolidate(ConsolidateRequest request, Long hubId, Long actorId);

    // ===================================================================
    // NHÓM 2: ĐIỀU PHỐI XE (TRIP PLANNING)
    // ===================================================================

    /**
     * 2.1. Lấy danh sách tất cả Xe trong hệ thống
     * - Không lọc theo vị trí
     * - Để người quản lý tự chọn theo thực tế
     */
    List<VehicleSelectResponse> getAllVehicles();

    /**
     * 2.2. Lấy danh sách tất cả Tài xế trong hệ thống
     */
    List<DriverSelectResponse> getAllDrivers();

    /**
     * 2.3. Tạo chuyến xe mới (Trip)
     * - Gắn Xe, Tài xế, Tuyến đường
     * - Logic tự sửa lỗi: Nếu Xe/Tài xế đang bị ghi nhận sai vị trí,
     * tự động cập nhật vị trí về Hub hiện tại
     */
    TripPlanningResponse createTrip(TripPlanningRequest request, Long actorId);

    /**
     * 2.4. Xem danh sách các chuyến xe đang xử lý tại Hub
     * - Trạng thái: loading (đang xếp hàng)
     */
    List<TripListResponse> getTripsAtHub(Long hubId);

    /**
     * 2.5. Xem chi tiết chuyến xe
     * - Thông tin xe, tài xế
     * - Danh sách các bao trên xe
     */
    TripDetailResponse getTripDetail(Long tripId);

    // ===================================================================
    // NHÓM 3: XẾP HÀNG LÊN XE (LOADING)
    // ===================================================================

    /**
     * 3.1. Lấy danh sách Bao chờ xếp lên xe
     * - Bao đang nằm ở Hub này
     * - Trạng thái: closed (đã đóng gói)
     * - Chưa được xếp lên xe nào
     */
    List<ContainerForLoadingResponse> getContainersReadyForLoading(Long hubId);

    /**
     * 3.2. Xếp bao lên chuyến xe
     * - Gán bao vào chuyến (TripContainer)
     * - Cộng tải trọng
     * - Cảnh báo nếu quá tải (log warning)
     */
    void loadContainerToTrip(LoadContainerRequest request, Long actorId);

    /**
     * 3.3. Gỡ bao khỏi chuyến xe
     * - Xóa TripContainer
     * - Trừ tải trọng
     */
    void unloadContainerFromTrip(UnloadContainerRequest request, Long actorId);

    // ===================================================================
    // NHÓM 4: XUẤT BẾN (GATE OUT)
    // ===================================================================

    /**
     * 4.1. Xác nhận Xuất bến
     * Thực hiện Batch Update:
     * - Trip -> status = on_way, departedAt = now
     * - Vehicle -> status = in_transit, currentHub = null
     * - Container -> status = loaded (đang vận chuyển)
     * - ServiceRequest -> status = in_transit, currentHub = null
     * - Insert ParcelAction (EXPORT_WAREHOUSE)
     */
    GateOutResponse gateOut(GateOutRequest request, Long actorId);

    /**
     * 4.2. Xác nhận Xuất bến cho Trip đã xếp hàng
     * - Không cần truyền containerIds
     * - Lấy tất cả container đã load trên trip
     */
    GateOutResponse gateOutTrip(Long tripId, Long actorId);
}
