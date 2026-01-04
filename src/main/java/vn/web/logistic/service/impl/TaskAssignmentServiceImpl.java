package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.dto.request.AssignTaskRequest;
import vn.web.logistic.dto.response.manager.OrderForAssignDTO;
import vn.web.logistic.dto.response.manager.UpdateStatusResult;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.Shipper;
import vn.web.logistic.entity.ShipperTask;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ShipperRepository;
import vn.web.logistic.repository.ShipperTaskRepository;
import vn.web.logistic.service.TaskAssignmentService;

@Service
@RequiredArgsConstructor
public class TaskAssignmentServiceImpl implements TaskAssignmentService {

        private final ServiceRequestRepository serviceRequestRepository;
        private final ShipperRepository shipperRepository;
        private final ShipperTaskRepository shipperTaskRepository;

        @Override
        public List<OrderForAssignDTO> getPendingPickupOrders(String district) {
                List<ServiceRequest> requests = serviceRequestRepository.findPendingPickupByDistrict(district);
                return requests.stream()
                                .map(r -> mapToDTO(r, "pickup"))
                                .collect(Collectors.toList());
        }

        @Override
        public List<OrderForAssignDTO> getPendingDeliveryOrders(Long hubId) {
                List<ServiceRequest> requests = serviceRequestRepository.findPendingDeliveryByHubId(hubId);
                return requests.stream()
                                .map(r -> mapToDTO(r, "delivery"))
                                .collect(Collectors.toList());
        }

        @Override
        public Page<OrderForAssignDTO> getPendingPickupOrdersPaged(String district, int page, int size) {
                Pageable pageable = PageRequest.of(page, size);
                Page<ServiceRequest> requestPage = serviceRequestRepository.findPendingPickupByDistrictPaged(district,
                                pageable);
                return requestPage.map(r -> mapToDTO(r, "pickup"));
        }

        @Override
        public Page<OrderForAssignDTO> getPendingDeliveryOrdersPaged(Long hubId, int page, int size) {
                Pageable pageable = PageRequest.of(page, size);
                Page<ServiceRequest> requestPage = serviceRequestRepository.findPendingDeliveryByHubIdPaged(hubId,
                                pageable);
                return requestPage.map(r -> mapToDTO(r, "delivery"));
        }

        @Override
        public long countPendingPickupOrders(String district) {
                return serviceRequestRepository.countPendingPickupByDistrict(district);
        }

        @Override
        public long countPendingDeliveryOrders(Long hubId) {
                return serviceRequestRepository.countPendingDeliveryByHubId(hubId);
        }

        @Override
        @Transactional
        public UpdateStatusResult assignShipper(AssignTaskRequest request, Long hubId) {
                // 1. Validate request
                if (request.getRequestId() == null || request.getShipperId() == null || request.getTaskType() == null) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Thiếu thông tin phân công")
                                        .errorCode("INVALID_REQUEST")
                                        .build();
                }

                // 2. Validate taskType
                ShipperTask.TaskType taskType;
                try {
                        taskType = ShipperTask.TaskType.valueOf(request.getTaskType());
                } catch (IllegalArgumentException e) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Loại task không hợp lệ: " + request.getTaskType())
                                        .errorCode("INVALID_TASK_TYPE")
                                        .build();
                }

                // 3. Kiểm tra đơn hàng tồn tại
                ServiceRequest serviceRequest = serviceRequestRepository.findByIdWithDetails(request.getRequestId())
                                .orElse(null);
                if (serviceRequest == null) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Không tìm thấy đơn hàng #" + request.getRequestId())
                                        .errorCode("ORDER_NOT_FOUND")
                                        .build();
                }

                // 4. Kiểm tra shipper tồn tại và thuộc Hub
                Shipper shipper = shipperRepository.findById(request.getShipperId()).orElse(null);
                if (shipper == null) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Không tìm thấy shipper")
                                        .errorCode("SHIPPER_NOT_FOUND")
                                        .build();
                }

                if (shipper.getHub() == null || !shipper.getHub().getHubId().equals(hubId)) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Shipper không thuộc Hub của bạn")
                                        .errorCode("SHIPPER_WRONG_HUB")
                                        .build();
                }

                // 5. Kiểm tra shipper có đang active không
                if (shipper.getStatus() != Shipper.ShipperStatus.active &&
                                shipper.getStatus() != Shipper.ShipperStatus.busy) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Shipper đang không hoạt động")
                                        .errorCode("SHIPPER_INACTIVE")
                                        .build();
                }

                // 6. Kiểm tra đơn đã có task ACTIVE (assigned/in_progress) chưa
                // Cho phép phân công lại nếu task trước đã failed
                boolean hasActiveTask = shipperTaskRepository.existsActiveTaskByRequestAndType(
                                serviceRequest, taskType);
                if (hasActiveTask) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Đơn hàng đang có task " + taskType + " chưa hoàn thành")
                                        .errorCode("ALREADY_ASSIGNED")
                                        .build();
                }

                // 7. Tạo ShipperTask
                ShipperTask task = ShipperTask.builder()
                                .shipper(shipper)
                                .request(serviceRequest)
                                .taskType(taskType)
                                .taskStatus(ShipperTask.TaskStatus.assigned)
                                .assignedAt(LocalDateTime.now())
                                .build();
                shipperTaskRepository.save(task);

                // 8. Cập nhật status shipper nếu cần
                // if (shipper.getStatus() == Shipper.ShipperStatus.active) {
                //         shipper.setStatus(Shipper.ShipperStatus.busy);
                //         shipperRepository.save(shipper);
                // }

                return UpdateStatusResult.builder()
                                .success(true)
                                .message("Phân công thành công! Đơn #" + request.getRequestId() + " → "
                                                + shipper.getUser().getFullName())
                                .build();
        }

        @Override
        @Transactional
        public UpdateStatusResult unassignShipper(Long taskId) {
                ShipperTask task = shipperTaskRepository.findById(taskId).orElse(null);
                if (task == null) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Không tìm thấy task")
                                        .errorCode("TASK_NOT_FOUND")
                                        .build();
                }

                if (task.getTaskStatus() != ShipperTask.TaskStatus.assigned) {
                        return UpdateStatusResult.builder()
                                        .success(false)
                                        .message("Chỉ có thể hủy task chưa thực hiện")
                                        .errorCode("TASK_IN_PROGRESS")
                                        .build();
                }

                shipperTaskRepository.delete(task);

                return UpdateStatusResult.builder()
                                .success(true)
                                .message("Đã hủy phân công")
                                .build();
        }

        // Map ServiceRequest to DTO
        private OrderForAssignDTO mapToDTO(ServiceRequest r, String taskType) {
                return OrderForAssignDTO.builder()
                                .requestId(r.getRequestId())
                                .taskType(taskType)
                                .senderName(r.getPickupAddress() != null ? r.getPickupAddress().getContactName() : null)
                                .senderPhone(r.getPickupAddress() != null ? r.getPickupAddress().getContactPhone()
                                                : null)
                                .pickupAddress(r.getPickupAddress() != null ? r.getPickupAddress().getAddressDetail()
                                                : null)
                                .pickupDistrict(r.getPickupAddress() != null ? r.getPickupAddress().getDistrict()
                                                : null)
                                .receiverName(r.getDeliveryAddress() != null ? r.getDeliveryAddress().getContactName()
                                                : null)
                                .receiverPhone(r.getDeliveryAddress() != null ? r.getDeliveryAddress().getContactPhone()
                                                : null)
                                .deliveryAddress(r.getDeliveryAddress() != null
                                                ? r.getDeliveryAddress().getAddressDetail()
                                                : null)
                                .deliveryDistrict(r.getDeliveryAddress() != null ? r.getDeliveryAddress().getDistrict()
                                                : null)
                                .itemName(r.getItemName())
                                .codAmount(r.getCodAmount())
                                .shippingFee(r.getShippingFee())
                                .receiverPayAmount(r.getReceiverPayAmount())
                                .status(r.getStatus() != null ? r.getStatus().name() : null)
                                .createdAt(r.getCreatedAt())
                                .currentHubId(r.getCurrentHub() != null ? r.getCurrentHub().getHubId() : null)
                                .currentHubName(r.getCurrentHub() != null ? r.getCurrentHub().getHubName() : null)
                                .build();
        }
}
