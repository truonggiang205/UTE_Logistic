package vn.web.logistic.service;

import vn.web.logistic.dto.request.lastmile.AssignTaskRequest;
import vn.web.logistic.dto.request.lastmile.ConfirmDeliveryRequest;
import vn.web.logistic.dto.request.lastmile.CounterPickupRequest;
import vn.web.logistic.dto.request.lastmile.DeliveryDelayRequest;
import vn.web.logistic.dto.response.lastmile.AssignTaskResponse;
import vn.web.logistic.dto.response.lastmile.ConfirmDeliveryResponse;
import vn.web.logistic.dto.response.lastmile.CounterPickupResponse;
import vn.web.logistic.dto.response.lastmile.DeliveryDelayResponse;

// Service interface cho phân hệ LAST MILE (Giao hàng)
public interface LastMileService {

    // Chức năng 1: Phân công Shipper
    // Input: shipperId, List<requestIds>
    // Logic: Validate shipper active, tạo ShipperTask với taskType=delivery,
    // taskStatus=assigned
    AssignTaskResponse assignTask(AssignTaskRequest request, Long actorUserId);

    // Chức năng 2: Xác nhận Giao Xong
    // Input: taskId, codCollected
    // Logic: Update task=completed, order=delivered, tạo CodTransaction(pending)
    // nếu COD > 0
    ConfirmDeliveryResponse confirmDelivery(ConfirmDeliveryRequest request, Long actorUserId);

    // Chức năng 3: Xác nhận Hẹn Lại
    // Input: taskId, reason
    // Logic: Update task=failed, giữ order=picked, insert
    // ParcelAction(DELIVERY_DELAY)
    DeliveryDelayResponse deliveryDelay(DeliveryDelayRequest request, Long actorUserId);

    // Chức năng 4: Khách nhận tại quầy
    // Input: requestId, customerIdCard, currentHubId
    // Logic: Update order=delivered, insert ParcelAction(COUNTER_RECEIVE),
    // CodTransaction(settled)
    CounterPickupResponse counterPickup(CounterPickupRequest request, Long actorUserId);
}
