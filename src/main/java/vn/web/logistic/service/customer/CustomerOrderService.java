package vn.web.logistic.service.customer;

import java.util.List;

import vn.web.logistic.dto.request.customer.CustomerPickupOrderForm;
import vn.web.logistic.entity.ServiceRequest;

public interface CustomerOrderService {

    ServiceRequest createPickupOrder(CustomerPickupOrderForm form);

    List<ServiceRequest> getMyOrders();

    ServiceRequest getMyOrderOrThrow(Long requestId);

    void cancelMyOrder(Long requestId);
}
