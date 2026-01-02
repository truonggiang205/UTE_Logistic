package vn.web.logistic.controller.manager;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.web.logistic.dto.request.outbound.*;
import vn.web.logistic.dto.response.outbound.*;
import vn.web.logistic.service.OutboundService;

import java.util.List;
import java.util.Map;

/**
 * OutboundController - API cho phân hệ Xuất Kho (Middle Mile)
 * 
 * NHÓM 1: Quản lý Đóng gói (Consolidation)
 * NHÓM 2: Điều phối xe (Trip Planning)
 * NHÓM 3: Xếp hàng lên xe (Loading)
 * NHÓM 4: Xuất bến (Gate Out)
 */
@RestController
@RequestMapping("/api/manager/outbound")
@RequiredArgsConstructor
@Slf4j
public class OutboundController {

    private final OutboundService outboundService;

    // ===================================================================
    // NHÓM 1: QUẢN LÝ ĐÓNG GÓI (CONSOLIDATION)
    // ===================================================================

    /**
     * 1.1. Lấy danh sách đơn hàng chờ đóng gói tại Hub
     * GET /api/manager/outbound/pending-orders?hubId=1
     */
    @GetMapping("/pending-orders")
    public ResponseEntity<?> getPendingOrdersForConsolidation(@RequestParam Long hubId) {
        try {
            List<PendingOrderResponse> orders = outboundService.getPendingOrdersForConsolidation(hubId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", orders,
                    "count", orders.size()));
        } catch (Exception e) {
            log.error("Error getting pending orders: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.2. Tạo bao mới (Container)
     * POST /api/manager/outbound/containers
     */
    @PostMapping("/containers")
    public ResponseEntity<?> createContainer(
            @Valid @RequestBody CreateContainerRequest request,
            @RequestParam Long hubId,
            @RequestParam Long actorId) {
        try {
            ContainerDetailResponse container = outboundService.createContainer(request, hubId, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Tạo bao thành công!",
                    "data", container));
        } catch (Exception e) {
            log.error("Error creating container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.3. Xem danh sách các bao tại Hub
     * GET /api/manager/outbound/containers?hubId=1
     */
    @GetMapping("/containers")
    public ResponseEntity<?> getContainersAtHub(@RequestParam Long hubId) {
        try {
            List<ContainerListResponse> containers = outboundService.getContainersAtHub(hubId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", containers,
                    "count", containers.size()));
        } catch (Exception e) {
            log.error("Error getting containers: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.4. Xem chi tiết bao
     * GET /api/manager/outbound/containers/{containerId}
     */
    @GetMapping("/containers/{containerId}")
    public ResponseEntity<?> getContainerDetail(@PathVariable Long containerId) {
        try {
            ContainerDetailResponse container = outboundService.getContainerDetail(containerId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", container));
        } catch (Exception e) {
            log.error("Error getting container detail: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.5. Thêm đơn hàng vào bao
     * POST /api/manager/outbound/containers/add-order
     */
    @PostMapping("/containers/add-order")
    public ResponseEntity<?> addOrderToContainer(
            @Valid @RequestBody AddOrderToContainerRequest request,
            @RequestParam Long actorId) {
        try {
            outboundService.addOrderToContainer(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã thêm đơn hàng vào bao thành công!"));
        } catch (Exception e) {
            log.error("Error adding order to container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.6. Gỡ đơn hàng khỏi bao
     * POST /api/manager/outbound/containers/remove-order
     */
    @PostMapping("/containers/remove-order")
    public ResponseEntity<?> removeOrderFromContainer(
            @Valid @RequestBody RemoveOrderFromContainerRequest request,
            @RequestParam Long actorId) {
        try {
            outboundService.removeOrderFromContainer(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã gỡ đơn hàng khỏi bao thành công!"));
        } catch (Exception e) {
            log.error("Error removing order from container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.7. Chốt bao (Seal Container)
     * POST /api/manager/outbound/containers/{containerId}/seal
     */
    @PostMapping("/containers/{containerId}/seal")
    public ResponseEntity<?> sealContainer(
            @PathVariable Long containerId,
            @RequestParam Long actorId) {
        try {
            outboundService.sealContainer(containerId, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã chốt bao thành công!"));
        } catch (Exception e) {
            log.error("Error sealing container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.7b. Mở lại bao (Reopen Container)
     * POST /api/manager/outbound/containers/{containerId}/reopen
     */
    @PostMapping("/containers/{containerId}/reopen")
    public ResponseEntity<?> reopenContainer(
            @PathVariable Long containerId,
            @RequestParam Long actorId) {
        try {
            outboundService.reopenContainer(containerId, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã mở lại bao thành công! Bạn có thể thêm/bớt đơn hàng."));
        } catch (Exception e) {
            log.error("Error reopening container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 1.8. Đóng hàng loạt đơn vào bao
     * POST /api/manager/outbound/consolidate
     */
    @PostMapping("/consolidate")
    public ResponseEntity<?> consolidate(
            @Valid @RequestBody ConsolidateRequest request,
            @RequestParam Long actorId) {
        try {
            ConsolidateResponse response = outboundService.consolidate(request, request.getCurrentHubId(), actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đóng bao thành công!",
                    "data", response));
        } catch (Exception e) {
            log.error("Error consolidating: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    // ===================================================================
    // NHÓM 2: ĐIỀU PHỐI XE (TRIP PLANNING)
    // ===================================================================

    /**
     * 2.1. Lấy danh sách tất cả Xe trong hệ thống
     * GET /api/manager/outbound/vehicles
     */
    @GetMapping("/vehicles")
    public ResponseEntity<?> getAllVehicles() {
        try {
            List<VehicleSelectResponse> vehicles = outboundService.getAllVehicles();
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", vehicles,
                    "count", vehicles.size()));
        } catch (Exception e) {
            log.error("Error getting vehicles: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 2.2. Lấy danh sách tất cả Tài xế trong hệ thống
     * GET /api/manager/outbound/drivers
     */
    @GetMapping("/drivers")
    public ResponseEntity<?> getAllDrivers() {
        try {
            List<DriverSelectResponse> drivers = outboundService.getAllDrivers();
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", drivers,
                    "count", drivers.size()));
        } catch (Exception e) {
            log.error("Error getting drivers: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 2.3. Tạo chuyến xe mới
     * POST /api/manager/outbound/trips
     */
    @PostMapping("/trips")
    public ResponseEntity<?> createTrip(
            @Valid @RequestBody TripPlanningRequest request,
            @RequestParam Long actorId) {
        try {
            TripPlanningResponse response = outboundService.createTrip(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Tạo chuyến xe thành công!",
                    "data", response));
        } catch (Exception e) {
            log.error("Error creating trip: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 2.4. Xem danh sách các chuyến xe đang xử lý tại Hub
     * GET /api/manager/outbound/trips?hubId=1
     */
    @GetMapping("/trips")
    public ResponseEntity<?> getTripsAtHub(@RequestParam Long hubId) {
        try {
            List<TripListResponse> trips = outboundService.getTripsAtHub(hubId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", trips,
                    "count", trips.size()));
        } catch (Exception e) {
            log.error("Error getting trips: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 2.5. Xem chi tiết chuyến xe
     * GET /api/manager/outbound/trips/{tripId}
     */
    @GetMapping("/trips/{tripId}")
    public ResponseEntity<?> getTripDetail(@PathVariable Long tripId) {
        try {
            TripDetailResponse trip = outboundService.getTripDetail(tripId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", trip));
        } catch (Exception e) {
            log.error("Error getting trip detail: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    // ===================================================================
    // NHÓM 3: XẾP HÀNG LÊN XE (LOADING)
    // ===================================================================

    /**
     * 3.1. Lấy danh sách Bao chờ xếp lên xe
     * GET /api/manager/outbound/containers-for-loading?hubId=1
     */
    @GetMapping("/containers-for-loading")
    public ResponseEntity<?> getContainersReadyForLoading(@RequestParam Long hubId) {
        try {
            List<ContainerForLoadingResponse> containers = outboundService.getContainersReadyForLoading(hubId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "data", containers,
                    "count", containers.size()));
        } catch (Exception e) {
            log.error("Error getting containers for loading: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 3.2. Xếp bao lên chuyến xe
     * POST /api/manager/outbound/load-container
     */
    @PostMapping("/load-container")
    public ResponseEntity<?> loadContainerToTrip(
            @Valid @RequestBody LoadContainerRequest request,
            @RequestParam Long actorId) {
        try {
            outboundService.loadContainerToTrip(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã xếp bao lên xe thành công!"));
        } catch (Exception e) {
            log.error("Error loading container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 3.3. Gỡ bao khỏi chuyến xe
     * POST /api/manager/outbound/unload-container
     */
    @PostMapping("/unload-container")
    public ResponseEntity<?> unloadContainerFromTrip(
            @Valid @RequestBody UnloadContainerRequest request,
            @RequestParam Long actorId) {
        try {
            outboundService.unloadContainerFromTrip(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đã gỡ bao khỏi xe thành công!"));
        } catch (Exception e) {
            log.error("Error unloading container: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    // ===================================================================
    // NHÓM 4: XUẤT BẾN (GATE OUT)
    // ===================================================================

    /**
     * 4.1. Xác nhận Xuất bến
     * POST /api/manager/outbound/gate-out
     */
    @PostMapping("/gate-out")
    public ResponseEntity<?> gateOut(
            @Valid @RequestBody GateOutRequest request,
            @RequestParam Long actorId) {
        try {
            GateOutResponse response = outboundService.gateOut(request, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Xuất bến thành công!",
                    "data", response));
        } catch (Exception e) {
            log.error("Error gate out: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /**
     * 4.2. Xuất bến cho Trip đã xếp hàng (không cần truyền containerIds)
     * POST /api/manager/outbound/trips/{tripId}/gate-out
     */
    @PostMapping("/trips/{tripId}/gate-out")
    public ResponseEntity<?> gateOutTrip(
            @PathVariable Long tripId,
            @RequestParam Long actorId) {
        try {
            GateOutResponse response = outboundService.gateOutTrip(tripId, actorId);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Xuất bến thành công!",
                    "data", response));
        } catch (Exception e) {
            log.error("Error gate out trip: ", e);
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }
}
