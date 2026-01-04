package vn.web.logistic.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.entity.ActionType;
import vn.web.logistic.entity.CodTransaction;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Hub;
import vn.web.logistic.entity.ParcelAction;
import vn.web.logistic.entity.ParcelRoute;
import vn.web.logistic.entity.Route;
import vn.web.logistic.entity.ServiceRequest;
import vn.web.logistic.entity.ServiceType;
import vn.web.logistic.entity.TrackingCode;
import vn.web.logistic.entity.TrackingCode.TrackingStatus;
import vn.web.logistic.entity.User;
import vn.web.logistic.repository.ActionTypeRepository;
import vn.web.logistic.repository.CodTransactionRepository;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.HubRepository;
import vn.web.logistic.repository.ParcelActionRepository;
import vn.web.logistic.repository.ParcelRouteRepository;
import vn.web.logistic.repository.RouteRepository;
import vn.web.logistic.repository.ServiceRequestRepository;
import vn.web.logistic.repository.ServiceTypeRepository;
import vn.web.logistic.repository.TrackingCodeRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.InboundService;

@Service
@RequiredArgsConstructor
public class InboundServiceImpl implements InboundService {

        // --- TIÊM CÁC REPOSITORY CẦN THIẾT ---
        private final CustomerRepository customerRepo;
        private final CustomerAddressRepository addressRepo;
        private final ServiceRequestRepository requestRepo;
        private final ServiceTypeRepository serviceTypeRepo;
        private final ActionTypeRepository actionTypeRepo;
        private final ParcelActionRepository actionRepo;
        private final CodTransactionRepository codRepo;
        private final UserRepository userRepo;
        private final TrackingCodeRepository trackingRepo;
        private final HubRepository hubRepo;
        private final RouteRepository routeRepo;
        private final ParcelRouteRepository parcelRouteRepo;

        /**
         * TẠO ĐƠN HÀNG TẠI QUẦY (DROP-OFF)
         * Đây là luồng quan trọng nhất khi khách mang hàng trực tiếp đến bưu cục.
         * 
         * LOGIC THANH TOÁN:
         * - payment_status trong ServiceRequest: Quản lý trạng thái thanh toán CƯỚC VẬN
         * CHUYỂN
         * - COD_TRANSACTIONS: Chỉ lưu khoản TIỀN THU HỘ (tiền hàng) khi codAmount > 0
         * - receiver_pay_amount: Tổng tiền người nhận phải trả (= codAmount + phí ship
         * nếu chưa thanh toán)
         */
        @Override
        @Transactional
        public ServiceRequest createDropOffOrder(ServiceRequest order, String senderPhone, String receiverPhone,
                        Long managerId, Long routeId) {

                // --- BƯỚC 0: XÁC THỰC NHÂN VIÊN & HUB TẠI QUẦY ---
                User manager = userRepo.findById(managerId)
                                .orElseThrow(() -> new RuntimeException("Manager không tồn tại với ID: " + managerId));

                Hub hubTaiQuay = (manager.getStaff() != null) ? manager.getStaff().getHub() : null;
                if (hubTaiQuay == null) {
                        throw new RuntimeException("Nhân viên này chưa được gán vào bưu cục (Hub) nào!");
                }

                // --- BƯỚC 1: QUẢN LÝ THÔNG TIN KHÁCH HÀNG & ĐỊA CHỈ ---
                String senderName = (order.getCustomer() != null && order.getCustomer().getFullName() != null)
                                ? order.getCustomer().getFullName()
                                : "Khách gửi";
                String receiverName = (order.getDeliveryAddress() != null
                                && order.getDeliveryAddress().getContactName() != null)
                                                ? order.getDeliveryAddress().getContactName()
                                                : "Người nhận";

                Customer sender = findOrCreateCustomer(senderPhone, senderName);
                Customer receiver = findOrCreateCustomer(receiverPhone, receiverName);

                CustomerAddress pickupAddr = validateAndSaveAddress(sender, order.getPickupAddress());
                CustomerAddress deliveryAddr = validateAndSaveAddress(receiver, order.getDeliveryAddress());

                // --- BƯỚC 2: TÍNH TOÁN KỸ THUẬT VÀ TÀI CHÍNH ---
                ServiceType st = serviceTypeRepo.findById(order.getServiceType().getServiceTypeId())
                                .orElseThrow(() -> new RuntimeException("Loại dịch vụ không hợp lệ"));

                // Xử lý giá trị mặc định để tránh lỗi Null
                BigDecimal length = order.getLength() != null ? order.getLength() : BigDecimal.ONE;
                BigDecimal width = order.getWidth() != null ? order.getWidth() : BigDecimal.ONE;
                BigDecimal height = order.getHeight() != null ? order.getHeight() : BigDecimal.ONE;
                BigDecimal weight = order.getWeight() != null ? order.getWeight() : BigDecimal.ONE;
                BigDecimal codAmount = order.getCodAmount() != null ? order.getCodAmount() : BigDecimal.ZERO;
                String itemName = order.getItemName() != null ? order.getItemName() : "Hàng hóa";
                String note = order.getNote() != null ? order.getNote() : "";
                String imageOrder = order.getImageOrder(); // Có thể null

                // Công thức tính trọng lượng quy đổi (Volumetric Weight)
                BigDecimal dimWeight = length.multiply(width).multiply(height)
                                .divide(new BigDecimal("6000"), 2, RoundingMode.HALF_UP);
                BigDecimal chargeableWeight = weight.max(dimWeight);

                // Tính toán các loại phí dựa trên cấu hình ServiceType
                BigDecimal shippingFee = calculateShippingFee(st, chargeableWeight);
                BigDecimal codFee = calculateCodFee(st, codAmount);
                BigDecimal insFee = calculateInsuranceFee(st, codAmount);
                BigDecimal totalPrice = shippingFee.add(codFee).add(insFee); // Tổng phí logistics

                // --- BƯỚC 3: XÁC ĐỊNH TUYẾN ĐƯỜNG ĐI (ROUTING) ---
                Route selectedRoute = routeRepo.findByIdWithHubs(routeId)
                                .orElseThrow(() -> new RuntimeException("Tuyến đường không tồn tại: " + routeId));

                // --- BƯỚC 4: XÁC ĐỊNH TRẠNG THÁI THANH TOÁN VÀ SỐ TIỀN NGƯỜI NHẬN TRẢ ---
                // paymentStatus đã được set từ Controller (paid/unpaid tùy người gửi trả hay
                // người nhận trả)
                ServiceRequest.PaymentStatus paymentStatus = order.getPaymentStatus() != null
                                ? order.getPaymentStatus()
                                : ServiceRequest.PaymentStatus.unpaid;

                // Tính receiver_pay_amount: Số tiền shipper cần thu của người nhận
                // = codAmount (tiền hàng) + phí ship (nếu người nhận trả sau)
                BigDecimal receiverPayAmount;
                if (paymentStatus == ServiceRequest.PaymentStatus.paid) {
                        // Người gửi đã trả phí ship -> Người nhận chỉ trả tiền hàng COD
                        receiverPayAmount = codAmount;
                } else {
                        // Người nhận trả sau -> Người nhận trả cả phí ship + tiền hàng COD
                        receiverPayAmount = codAmount.add(totalPrice);
                }

                // --- BƯỚC 5: LẤP ĐẦY ĐẦY ĐỦ DỮ LIỆU ĐƠN HÀNG (SERVICE_REQUEST) ---
                order.setCustomer(sender);
                order.setPickupAddress(pickupAddr);
                order.setDeliveryAddress(deliveryAddr);
                order.setServiceType(st);
                order.setCurrentHub(hubTaiQuay);
                order.setStatus(ServiceRequest.RequestStatus.picked); // Drop-off = Đã nhận hàng
                order.setPaymentStatus(paymentStatus);
                order.setCreatedAt(LocalDateTime.now());
                // Thông tin hàng hóa
                order.setItemName(itemName);
                order.setWeight(weight);
                order.setLength(length);
                order.setWidth(width);
                order.setHeight(height);
                order.setChargeableWeight(chargeableWeight);
                order.setCodAmount(codAmount);
                order.setNote(note);
                order.setImageOrder(imageOrder);
                // Thông tin tài chính
                order.setShippingFee(shippingFee);
                order.setCodFee(codFee);
                order.setInsuranceFee(insFee);
                order.setTotalPrice(totalPrice);
                order.setReceiverPayAmount(receiverPayAmount);
                // expectedPickupTime không cần vì drop-off là khách mang đến

                ServiceRequest savedOrder = requestRepo.save(order);

                // --- BƯỚC 6: KHỞI TẠO LỘ TRÌNH CHI TIẾT (PARCEL_ROUTES) ---
                ParcelRoute pr = ParcelRoute.builder()
                                .request(savedOrder)
                                .route(selectedRoute)
                                .routeOrder(1)
                                .status(ParcelRoute.ParcelRouteStatus.planned)
                                .build();
                parcelRouteRepo.save(pr);

                // --- BƯỚC 7: TẠO MÃ VẬN ĐƠN (TRACKING CODE) ---
                // Sử dụng UUID để đảm bảo tính duy nhất
                String trackingCodeStr = generateTrackingCode(savedOrder.getRequestId());
                TrackingCode trackingCode = TrackingCode.builder()
                                .request(savedOrder)
                                .code(trackingCodeStr)
                                .createdAt(LocalDateTime.now())
                                .status(TrackingStatus.active)
                                .build();
                trackingRepo.save(trackingCode);

                // --- BƯỚC 8: GHI LỊCH SỬ HÀNH TRÌNH (PARCEL_ACTION) ---
                ActionType dropOffAction = actionTypeRepo.findByActionCode("DROP_OFF")
                                .orElseThrow(() -> new RuntimeException(
                                                "Không tìm thấy ActionType 'DROP_OFF'. Vui lòng chạy seed_logistic.sql."));

                ParcelAction action = ParcelAction.builder()
                                .request(savedOrder)
                                .actionType(dropOffAction)
                                .actor(manager)
                                .fromHub(hubTaiQuay)
                                .toHub(selectedRoute.getToHub())
                                .actionTime(LocalDateTime.now())
                                .note("Khách gửi tại quầy Hub " + hubTaiQuay.getHubName() +
                                                ". Lộ trình: " + selectedRoute.getDescription() +
                                                ". Mã vận đơn: " + trackingCodeStr)
                                .build();
                actionRepo.save(action);

                // --- BƯỚC 9: TẠO COD_TRANSACTION (KHI CÓ TIỀN CẦN THU) ---
                // Tạo COD Transaction khi receiverPayAmount > 0 (bao gồm COD và/hoặc phí ship
                // nếu chưa thanh toán)
                if (receiverPayAmount.compareTo(BigDecimal.ZERO) > 0) {
                        CodTransaction codTx = CodTransaction.builder()
                                        .request(savedOrder)
                                        .amount(receiverPayAmount) // = codAmount + phí ship (nếu chưa thanh toán)
                                        .status(CodTransaction.CodStatus.pending) // Luôn là PENDING khi tạo mới
                                        .paymentMethod(null) // NULL vì chưa giao, chưa biết khách trả bằng gì
                                        .shipper(null) // NULL vì chưa phân công shipper
                                        .codType(CodTransaction.CodType.delivery_cod)
                                        .collectedAt(null) // Chưa thu
                                        .settledAt(null) // Chưa quyết toán
                                        .build();
                        codRepo.save(codTx);
                }
                return savedOrder;
        }

        /**
         * NHẬP KHO TRUNG CHUYỂN (INTER-HUB INBOUND)
         * Dùng khi xe tải chở hàng từ Hub khác tới và nhân viên quét mã nhập kho.
         * 
         * GUARD CLAUSE:
         * - Chỉ cho phép nhập nếu đơn đang ở trạng thái: in_transit
         * - Nếu đơn đã nằm tại Hub này rồi -> báo lỗi trùng lặp
         * 
         * SAU KHI NHẬP:
         * - Cập nhật currentHub cho đơn hàng
         * - Cập nhật trạng thái ParcelRoute thành COMPLETED (đã tới hub đích của chặng
         * đó)
         */
        @Override
        @Transactional
        public ServiceRequest processInterHubInbound(String trackingCode, Long currentHubId, Long managerId,
                        Long actionTypeId) {
                ServiceRequest sr = requestRepo.findByTrackingCode(trackingCode)
                                .orElseThrow(() -> new RuntimeException("Mã vận đơn không tồn tại: " + trackingCode));

                // === GUARD CLAUSE 1: Validate trạng thái ===
                if (sr.getStatus() != ServiceRequest.RequestStatus.in_transit) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng phải đang ở trạng thái 'Đang vận chuyển' (in_transit) mới được nhập kho. "
                                                        +
                                                        "Trạng thái hiện tại: " + sr.getStatus());
                }

                // === GUARD CLAUSE 2: Check trùng lặp ===
                if (sr.getCurrentHub() != null && sr.getCurrentHub().getHubId().equals(currentHubId)) {
                        throw new RuntimeException("ĐƠN HÀNG ĐÃ NẰM TẠI HUB NÀY! Mã " + trackingCode +
                                        " đã được quét nhập kho trước đó. Vui lòng kiểm tra lại.");
                }

                Hub currentHub = hubRepo.findById(currentHubId)
                                .orElseThrow(() -> new RuntimeException("Hub không tồn tại: " + currentHubId));
                User manager = userRepo.findById(managerId)
                                .orElseThrow(() -> new RuntimeException("Manager không tồn tại: " + managerId));

                // Lưu hub cũ để ghi log
                Hub previousHub = sr.getCurrentHub();

                // Cập nhật vị trí hiện tại của gói hàng
                sr.setCurrentHub(currentHub);

                // === CẬP NHẬT TRẠNG THÁI PARCEL_ROUTE ===
                // Tìm ParcelRoute có toHub = currentHub và cập nhật thành COMPLETED
                parcelRouteRepo.findByRequestIdAndRouteToHubId(sr.getRequestId(), currentHubId)
                                .ifPresent(parcelRoute -> {
                                        parcelRoute.setStatus(ParcelRoute.ParcelRouteStatus.completed);
                                        parcelRouteRepo.save(parcelRoute);
                                });

                // Lấy ActionType từ ID do Manager chọn trên giao diện
                ActionType at = actionTypeRepo.findById(actionTypeId)
                                .orElseThrow(() -> new RuntimeException(
                                                "Loại hành động không tồn tại: " + actionTypeId));

                // Ghi lịch sử hành trình
                ParcelAction action = ParcelAction.builder()
                                .request(sr)
                                .actionType(at)
                                .actor(manager)
                                .fromHub(previousHub)
                                .toHub(currentHub)
                                .actionTime(LocalDateTime.now())
                                .note("Đã nhập kho trung chuyển tại " + currentHub.getHubName())
                                .build();
                actionRepo.save(action);

                return requestRepo.save(sr);
        }

        /**
         * SHIPPER BÀN GIAO HÀNG VÀO BƯU CỤC (SHIPPER INBOUND)
         * Dùng khi Shipper đi lấy hàng từ nhà khách mang về bưu cục.
         * 
         * GUARD CLAUSE (ĐÃ SỬA - Logic 1):
         * - Cho phép nhập nếu đơn đang ở trạng thái: PENDING hoặc PICKING
         * - Nếu đã PICKED hoặc IN_TRANSIT thì báo lỗi (đã xử lý rồi)
         */
        @Override
        @Transactional
        public ServiceRequest processShipperInbound(String trackingCode, Long currentHubId, Long managerId,
                        Long actionTypeId) {
                ServiceRequest sr = requestRepo.findByTrackingCode(trackingCode)
                                .orElseThrow(() -> new RuntimeException("Mã vận đơn không tồn tại: " + trackingCode));

                // === GUARD CLAUSE: Validate trạng thái ===
                ServiceRequest.RequestStatus currentStatus = sr.getStatus();

                // Đã xử lý rồi -> Báo lỗi
                if (currentStatus == ServiceRequest.RequestStatus.picked) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng này đã được bàn giao trước đó (trạng thái: picked). " +
                                                        "Không thể bàn giao lại.");
                }
                if (currentStatus == ServiceRequest.RequestStatus.in_transit) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng này đã đang vận chuyển (trạng thái: in_transit). " +
                                                        "Không thể bàn giao lại.");
                }
                if (currentStatus == ServiceRequest.RequestStatus.delivered) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng này đã giao thành công (trạng thái: delivered). " +
                                                        "Không thể bàn giao lại.");
                }
                if (currentStatus == ServiceRequest.RequestStatus.cancelled) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng này đã bị hủy (trạng thái: cancelled). " +
                                                        "Không thể bàn giao.");
                }

                // CHỈ CHO PHÉP: pending hoặc picking (nếu có thêm enum picking trong tương lai)
                // Hiện tại chỉ có pending là hợp lệ theo enum hiện tại
                if (currentStatus != ServiceRequest.RequestStatus.pending) {
                        throw new RuntimeException(
                                        "SAI QUY TRÌNH! Đơn hàng phải ở trạng thái 'Chờ lấy hàng' (pending) mới được bàn giao. "
                                                        +
                                                        "Trạng thái hiện tại: " + currentStatus);
                }

                Hub currentHub = hubRepo.findById(currentHubId)
                                .orElseThrow(() -> new RuntimeException("Hub không tồn tại: " + currentHubId));
                User manager = userRepo.findById(managerId)
                                .orElseThrow(() -> new RuntimeException("Manager không tồn tại: " + managerId));

                // Chuyển trạng thái từ 'pending' sang 'picked'
                sr.setStatus(ServiceRequest.RequestStatus.picked);
                sr.setCurrentHub(currentHub);

                // Lấy ActionType từ ID do Manager chọn trên giao diện
                ActionType at = actionTypeRepo.findById(actionTypeId)
                                .orElseThrow(() -> new RuntimeException(
                                                "Loại hành động không tồn tại: " + actionTypeId));

                // Ghi lịch sử hành trình
                ParcelAction action = ParcelAction.builder()
                                .request(sr)
                                .actionType(at)
                                .actor(manager)
                                .fromHub(null) // Shipper lấy từ nhà khách, không có fromHub
                                .toHub(currentHub)
                                .actionTime(LocalDateTime.now())
                                .note("Shipper đã bàn giao hàng cho bưu cục " + currentHub.getHubName())
                                .build();
                actionRepo.save(action);

                return requestRepo.save(sr);
        }

        // ==================== HELPER METHODS ====================

        /**
         * Sinh mã vận đơn duy nhất
         * Format: LOG + năm(2 số) + tháng + ngày + UUID(8 ký tự) + requestId
         * Ví dụ: LOG260101-A1B2C3D4-123
         */
        private String generateTrackingCode(Long requestId) {
                LocalDateTime now = LocalDateTime.now();
                String datePart = String.format("%02d%02d%02d",
                                now.getYear() % 100, now.getMonthValue(), now.getDayOfMonth());
                String uuidPart = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                return "LOG" + datePart + "-" + uuidPart + "-" + requestId;
        }

        /**
         * Tự động tìm hoặc tạo mới khách hàng để tránh trùng số điện thoại
         */
        private Customer findOrCreateCustomer(String phone, String fullName) {
                return customerRepo.findByPhone(phone)
                                .orElseGet(() -> customerRepo.save(Customer.builder()
                                                .phone(phone)
                                                .fullName(fullName != null ? fullName : "Khách mới")
                                                .customerType(Customer.CustomerType.individual)
                                                .status(Customer.CustomerStatus.active)
                                                .createdAt(LocalDateTime.now())
                                                .build()));
        }

        /**
         * Kiểm tra địa chỉ, nếu khách đã dùng rồi thì lấy lại, nếu chưa thì lưu mới
         */
        private CustomerAddress validateAndSaveAddress(Customer customer, CustomerAddress address) {
                if (address == null) {
                        throw new RuntimeException("Địa chỉ không được để trống");
                }

                String addressDetail = address.getAddressDetail() != null ? address.getAddressDetail() : "";
                String ward = address.getWard() != null ? address.getWard() : "";
                String district = address.getDistrict() != null ? address.getDistrict() : "";
                String province = address.getProvince() != null ? address.getProvince() : "";

                return addressRepo.findByCustomerAndAddressDetailAndWardAndDistrictAndProvince(
                                customer, addressDetail, ward, district, province)
                                .orElseGet(() -> {
                                        address.setCustomer(customer);
                                        address.setIsDefault(false);
                                        address.setContactName(address.getContactName() != null
                                                        ? address.getContactName()
                                                        : customer.getFullName());
                                        address.setContactPhone(address.getContactPhone() != null
                                                        ? address.getContactPhone()
                                                        : customer.getPhone());
                                        address.setAddressDetail(addressDetail);
                                        address.setWard(ward);
                                        address.setDistrict(district);
                                        address.setProvince(province);
                                        return addressRepo.save(address);
                                });
        }

        /**
         * Tính cước vận chuyển (2kg đầu giá cố định, mỗi kg sau cộng thêm tiền)
         */
        private BigDecimal calculateShippingFee(ServiceType st, BigDecimal weight) {
                BigDecimal fee = st.getBaseFee() != null ? st.getBaseFee() : BigDecimal.ZERO;
                if (weight.compareTo(new BigDecimal("2.0")) > 0) {
                        BigDecimal extra = weight.subtract(new BigDecimal("2.0"));
                        BigDecimal extraPrice = st.getExtraPricePerKg() != null ? st.getExtraPricePerKg()
                                        : BigDecimal.ZERO;
                        fee = fee.add(extra.multiply(extraPrice));
                }
                return fee.setScale(2, RoundingMode.HALF_UP);
        }

        /**
         * Tính phí thu hộ (COD) dựa trên % giá trị hàng
         */
        private BigDecimal calculateCodFee(ServiceType st, BigDecimal codAmount) {
                if (codAmount == null || codAmount.compareTo(BigDecimal.ZERO) <= 0) {
                        return BigDecimal.ZERO;
                }
                BigDecimal codRate = st.getCodRate() != null ? st.getCodRate() : BigDecimal.ZERO;
                BigDecimal codMinFee = st.getCodMinFee() != null ? st.getCodMinFee() : BigDecimal.ZERO;
                return codAmount.multiply(codRate).max(codMinFee).setScale(2, RoundingMode.HALF_UP);
        }

        /**
         * Tính phí bảo hiểm hàng hóa (thường áp dụng cho hàng giá trị cao > 3tr)
         */
        private BigDecimal calculateInsuranceFee(ServiceType st, BigDecimal codAmount) {
                if (codAmount == null || codAmount.compareTo(new BigDecimal("3000000")) <= 0) {
                        return BigDecimal.ZERO;
                }
                BigDecimal insRate = st.getInsuranceRate() != null ? st.getInsuranceRate() : BigDecimal.ZERO;
                return codAmount.multiply(insRate).setScale(2, RoundingMode.HALF_UP);
        }

        // ==================== PUBLIC API METHODS ====================

        @Override
        public List<CustomerAddress> getCustomerAddresses(String phone) {
                return customerRepo.findByPhone(phone)
                                .map(c -> addressRepo.findByCustomer_CustomerId(c.getCustomerId()))
                                .orElse(List.of());
        }

        @Override
        public List<ServiceType> getActiveServices() {
                return serviceTypeRepo.findAllByIsActiveTrue();
        }

        @Override
        public List<Route> getAvailableRoutes(Long hubId) {
                List<Route> routes = routeRepo.findRoutesWithHubsByFromHubId(hubId);
                if (routes.isEmpty()) {
                        routes = routeRepo.findRoutesByFromHubIdNative(hubId);
                }
                return routes;
        }

        @Override
        public List<ActionType> getInboundActionTypes() {
                return actionTypeRepo.findAll();
        }
}