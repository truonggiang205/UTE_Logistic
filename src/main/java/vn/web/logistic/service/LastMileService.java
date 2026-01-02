package vn.web.logistic.service;

import java.util.List;
import java.util.Map;

import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmPickupRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.request.lastmile.PickupDelayRequest;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmPickupResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;
import vn.web.logistic.dto.response.lastmile.PickupDelayResponse;

// Service interface cho phân hệ LAST MILE (Giao hàng)
public interface LastMileService {

    // DATA FETCHING

    // Lấy danh sách Shipper (có filter theo hubId và status)
    List<Map<String, Object>> getShippers(Long hubId, String status);

    // Lấy danh sách đơn hàng chờ giao (có filter theo hubId, status, trackingCode)
    List<Map<String, Object>> getOrdersForDelivery(Long hubId, String status, String trackingCode);

    // Lấy danh sách task của shipper (có filter theo hubId, shipperId và status)
    List<Map<String, Object>> getShipperTasks(Long hubId, Long shipperId, String status);

    // CHỨC NĂNG GIAO HÀNG

    // Chức năng 1: Phân công Shipper
    AssignTaskResponse assignTask(AssignTaskRequest request, Long actorUserId);

    // Chức năng 2: Xác nhận Giao Xong
    ConfirmDeliveryResponse confirmDelivery(ConfirmDeliveryRequest request, Long actorUserId);

    // Chức năng 3: Xác nhận Hẹn Lại (Giao thất bại)
    DeliveryDelayResponse deliveryDelay(DeliveryDelayRequest request, Long actorUserId);

    // Chức năng 4: Khách nhận tại quầy
    CounterPickupResponse counterPickup(CounterPickupRequest request, Long actorUserId);

    // CHỨC NĂNG LẤY HÀNG (PICKUP)

    // Chức năng 5: Xác nhận Lấy Hàng Thành Công
    ConfirmPickupResponse confirmPickup(ConfirmPickupRequest request, Long actorUserId);

    // Chức năng 6: Xác nhận Lấy Hàng Thất Bại (Hẹn lại)
    PickupDelayResponse pickupDelay(PickupDelayRequest request, Long actorUserId);

    // CHỨC NĂNG HOÀN HÀNG

    // Lấy danh sách đơn cần hoàn hàng (3+ lần giao thất bại), filter theo hubId
    List<Map<String, Object>> getOrdersPendingReturnGoods(Long hubId);

    // Lấy danh sách đơn chờ trả shop (đã về Hub gốc, status=failed), filter theo
    // hubId
    List<Map<String, Object>> getOrdersPendingReturnShop(Long hubId);

    // Kích hoạt hoàn hàng thủ công
    Map<String, Object> activateReturnGoods(Long requestId);

    // Hoàn tất trả hàng cho Shop
    Map<String, Object> completeReturnGoods(Long requestId, Long actorUserId);
}
