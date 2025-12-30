<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .trip-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .form-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    overflow: hidden;
                }

                .form-card-header {
                    background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
                    color: #fff;
                    padding: 15px 20px;
                }

                .form-card-body {
                    padding: 25px;
                }

                .vehicle-card {
                    border: 2px solid #e3e6f0;
                    border-radius: 12px;
                    padding: 15px;
                    cursor: pointer;
                    transition: all 0.3s;
                    margin-bottom: 15px;
                }

                .vehicle-card:hover {
                    border-color: #667eea;
                    transform: translateY(-2px);
                }

                .vehicle-card.selected {
                    border-color: #28a745;
                    background: #e8f5e9;
                }

                .vehicle-card.unavailable {
                    opacity: 0.5;
                    cursor: not-allowed;
                }

                .vehicle-icon {
                    width: 50px;
                    height: 50px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-size: 20px;
                }

                .vehicle-info h6 {
                    margin: 0;
                    font-weight: 600;
                }

                .vehicle-meta {
                    font-size: 12px;
                    color: #858796;
                }

                .vehicle-status {
                    padding: 4px 10px;
                    border-radius: 15px;
                    font-size: 11px;
                    font-weight: 600;
                }

                .status-available {
                    background: #d4edda;
                    color: #155724;
                }

                .status-in_transit {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-maintenance {
                    background: #f8d7da;
                    color: #721c24;
                }

                .driver-card {
                    border: 2px solid #e3e6f0;
                    border-radius: 12px;
                    padding: 15px;
                    cursor: pointer;
                    transition: all 0.3s;
                    margin-bottom: 15px;
                }

                .driver-card:hover {
                    border-color: #667eea;
                }

                .driver-card.selected {
                    border-color: #28a745;
                    background: #e8f5e9;
                }

                .driver-card.inactive {
                    opacity: 0.5;
                    cursor: not-allowed;
                }

                .driver-avatar {
                    width: 50px;
                    height: 50px;
                    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-size: 18px;
                    font-weight: 600;
                }

                .route-visual {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 15px;
                    padding: 30px;
                    color: #fff;
                    text-align: center;
                }

                .route-hub {
                    background: rgba(255, 255, 255, 0.2);
                    padding: 15px;
                    border-radius: 10px;
                }

                .route-arrow {
                    font-size: 30px;
                    margin: 20px 0;
                }

                .hub-name {
                    font-weight: 600;
                    font-size: 16px;
                }

                .btn-create-trip {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    border: none;
                    padding: 15px 40px;
                    font-size: 16px;
                    font-weight: 600;
                    border-radius: 10px;
                    color: #fff;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .btn-create-trip:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
                    color: #fff;
                }

                .btn-create-trip:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                    transform: none;
                }

                .trip-list {
                    max-height: 400px;
                    overflow-y: auto;
                }

                .trip-item {
                    background: #f8f9fc;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 10px;
                }

                .trip-code {
                    font-weight: 700;
                    color: #5a5c69;
                }

                .success-modal .modal-header {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    color: #fff;
                }

                .trip-info-box {
                    background: #f8f9fc;
                    border-radius: 10px;
                    padding: 20px;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 8px 0;
                    border-bottom: 1px solid #e3e6f0;
                }

                .info-row:last-child {
                    border-bottom: none;
                }
            </style>

            <!-- Header -->
            <div class="trip-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-route"></i> Tạo Chuyến Xe (Trip Planning)</h4>
                        <p class="mb-0 opacity-75">Lập kế hoạch vận chuyển container giữa các Hub</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/manager/outbound/gate-out" class="btn btn-light">
                            <i class="fas fa-arrow-right"></i> Xuất Bến
                        </a>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Left: Form tạo chuyến -->
                <div class="col-lg-8">
                    <div class="form-card mb-4">
                        <div class="form-card-header">
                            <i class="fas fa-plus-circle"></i> Thông tin chuyến mới
                        </div>
                        <div class="form-card-body">
                            <!-- Route Selection -->
                            <div class="row mb-4">
                                <div class="col-md-5">
                                    <label><i class="fas fa-warehouse text-primary"></i> Hub xuất phát</label>
                                    <select class="form-control" id="fromHubId" onchange="filterVehicles()">
                                        <option value="">-- Chọn Hub --</option>
                                        <c:forEach var="hub" items="${hubs}">
                                            <option value="${hub.hubId}" data-name="${hub.hubName}">
                                                ${hub.hubId} - ${hub.hubName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2 text-center d-flex align-items-end justify-content-center pb-2">
                                    <i class="fas fa-arrow-right fa-2x text-primary"></i>
                                </div>
                                <div class="col-md-5">
                                    <label><i class="fas fa-map-marker-alt text-danger"></i> Hub đích</label>
                                    <select class="form-control" id="toHubId" onchange="updateRouteVisual()">
                                        <option value="">-- Chọn Hub --</option>
                                        <c:forEach var="hub" items="${hubs}">
                                            <option value="${hub.hubId}" data-name="${hub.hubName}">
                                                ${hub.hubId} - ${hub.hubName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- Vehicle Selection -->
                            <h6 class="mb-3"><i class="fas fa-truck text-primary"></i> Chọn xe</h6>
                            <div class="row" id="vehicleList">
                                <c:forEach var="vehicle" items="${vehicles}">
                                    <c:set var="statusName" value="${vehicle.status.name()}" />
                                    <c:set var="isAvailable" value="${statusName eq 'available'}" />
                                    <div class="col-md-6">
                                        <div class="vehicle-card ${!isAvailable ? 'unavailable' : ''}"
                                            data-id="${vehicle.vehicleId}"
                                            data-hub="${vehicle.currentHub != null ? vehicle.currentHub.hubId : ''}"
                                            data-status="${statusName}" onclick="selectVehicle(this)">
                                            <div class="d-flex align-items-center">
                                                <div class="vehicle-icon mr-3">
                                                    <i class="fas fa-truck"></i>
                                                </div>
                                                <div class="vehicle-info flex-grow-1">
                                                    <h6 class="mb-1 font-weight-bold">${vehicle.plateNumber}</h6>
                                                    <div class="vehicle-meta text-muted small">
                                                        <span class="mr-2">
                                                            <i class="fas fa-weight"></i> ${vehicle.loadCapacity} kg
                                                        </span>
                                                        <span>
                                                            <i class="fas fa-warehouse"></i>
                                                            ${vehicle.currentHub != null ? vehicle.currentHub.hubName :
                                                            'N/A'}
                                                        </span>
                                                    </div>
                                                </div>
                                                <span class="badge vehicle-status status-${statusName}">
                                                    <c:choose>
                                                        <c:when test="${isAvailable}">Sẵn sàng</c:when>
                                                        <c:when test="${statusName eq 'in_transit'}">Đang chạy</c:when>
                                                        <c:otherwise>Bảo trì</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Driver Selection -->
                            <h6 class="mb-3 mt-4"><i class="fas fa-user text-success"></i> Chọn tài xế</h6>
                            <div class="row" id="driverList">
                                <c:forEach var="driver" items="${drivers}">
                                    <c:set var="driverStatusName" value="${driver.status.name()}" />
                                    <c:set var="isActive" value="${driverStatusName eq 'active'}" />
                                    <div class="col-md-6">
                                        <div class="driver-card ${!isActive ? 'inactive' : ''}"
                                            data-id="${driver.driverId}" data-status="${driverStatusName}"
                                            onclick="selectDriver(this)">
                                            <div class="d-flex align-items-center">
                                                <div class="driver-avatar mr-3">
                                                    ${driver.fullName.charAt(0)}
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-0">${driver.fullName}</h6>
                                                    <div class="vehicle-meta">
                                                        <i class="fas fa-phone"></i> ${driver.phoneNumber} |
                                                        <i class="fas fa-id-card"></i> ${driver.licenseNumber}
                                                    </div>
                                                </div>
                                                <span
                                                    class="vehicle-status ${isActive ? 'status-available' : 'status-maintenance'}">
                                                    <c:choose>
                                                        <c:when test="${isActive}">Hoạt động</c:when>
                                                        <c:otherwise>Nghỉ</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Submit -->
                            <div class="text-center mt-4">
                                <button type="button" class="btn btn-create-trip" id="btnCreateTrip"
                                    onclick="createTrip()" disabled>
                                    <i class="fas fa-plus-circle"></i> Tạo Chuyến Xe
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Preview & List -->
                <div class="col-lg-4">
                    <!-- Route Visual -->
                    <div class="route-visual mb-4" id="routeVisual">
                        <div class="route-hub">
                            <i class="fas fa-warehouse fa-2x mb-2"></i>
                            <div class="hub-name" id="fromHubName">Chọn Hub xuất phát</div>
                        </div>
                        <div class="route-arrow">
                            <i class="fas fa-arrow-down"></i>
                        </div>
                        <div class="route-hub">
                            <i class="fas fa-map-marker-alt fa-2x mb-2"></i>
                            <div class="hub-name" id="toHubName">Chọn Hub đích</div>
                        </div>
                    </div>

                    <!-- Recent Trips -->
                    <div class="form-card">
                        <div class="form-card-header">
                            <i class="fas fa-history"></i> Chuyến xe gần đây
                        </div>
                        <div class="form-card-body">
                            <div class="trip-list">
                                <c:choose>
                                    <c:when test="${not empty recentTrips}">
                                        <c:forEach var="trip" items="${recentTrips}">
                                            <c:set var="tripStatusName" value="${trip.status.name()}" />
                                            <div class="trip-item">
                                                <div class="d-flex justify-content-between">
                                                    <span class="trip-code">${trip.tripCode}</span>
                                                    <span
                                                        class="badge badge-${tripStatusName eq 'loading' ? 'warning' : 
                                                                   tripStatusName eq 'in_transit' ? 'info' : 
                                                                   tripStatusName eq 'completed' ? 'success' : 'secondary'}">
                                                        <c:choose>
                                                            <c:when test="${tripStatusName eq 'loading'}">Đang nạp
                                                            </c:when>
                                                            <c:when test="${tripStatusName eq 'in_transit'}">Đang chạy
                                                            </c:when>
                                                            <c:when test="${tripStatusName eq 'completed'}">Hoàn thành
                                                            </c:when>
                                                            <c:otherwise>${tripStatusName}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <div class="vehicle-meta mt-2">
                                                    <div><i class="fas fa-truck"></i> ${trip.vehicle.plateNumber}</div>
                                                    <div><i class="fas fa-user"></i> ${trip.driver.fullName}</div>
                                                    <div>
                                                        <i class="fas fa-route"></i>
                                                        ${trip.fromHub.hubName} → ${trip.toHub.hubName}
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted py-4">
                                            <i class="fas fa-inbox fa-3x mb-3"></i>
                                            <p>Chưa có chuyến xe nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Success Modal -->
            <div class="modal fade success-modal" id="successModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-check-circle"></i> Tạo chuyến thành công!</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center mb-4">
                                <i class="fas fa-truck fa-4x text-success mb-3"></i>
                                <h5 id="newTripCode">TRIP-20251230-0001</h5>
                            </div>
                            <div class="trip-info-box" id="tripInfoBox">
                                <!-- Trip info will be inserted here -->
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <a href="${pageContext.request.contextPath}/manager/outbound/gate-out"
                                class="btn btn-primary">
                                <i class="fas fa-arrow-right"></i> Đến Xuất Bến
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var contextPath = '${pageContext.request.contextPath}';
                var selectedVehicleId = null;
                var selectedDriverId = null;

                function selectVehicle(el) {
                    var status = el.getAttribute('data-status');
                    if (status !== 'available') return;

                    document.querySelectorAll('.vehicle-card').forEach(function (card) {
                        card.classList.remove('selected');
                    });
                    el.classList.add('selected');
                    selectedVehicleId = parseInt(el.getAttribute('data-id'));
                    validateForm();
                }

                function selectDriver(el) {
                    var status = el.getAttribute('data-status');
                    if (status !== 'active') return;

                    document.querySelectorAll('.driver-card').forEach(function (card) {
                        card.classList.remove('selected');
                    });
                    el.classList.add('selected');
                    selectedDriverId = parseInt(el.getAttribute('data-id'));
                    validateForm();
                }

                function filterVehicles() {
                    var fromHubId = document.getElementById('fromHubId').value;

                    document.querySelectorAll('.vehicle-card').forEach(function (card) {
                        var vehicleHub = card.getAttribute('data-hub');
                        if (fromHubId && vehicleHub !== fromHubId) {
                            card.classList.add('unavailable');
                        } else {
                            var origStatus = card.getAttribute('data-status');
                            if (origStatus === 'available') {
                                card.classList.remove('unavailable');
                            }
                        }
                    });

                    updateRouteVisual();
                    validateForm();
                }

                function updateRouteVisual() {
                    var fromHub = document.getElementById('fromHubId');
                    var toHub = document.getElementById('toHubId');

                    document.getElementById('fromHubName').textContent =
                        fromHub.selectedIndex > 0 ? fromHub.options[fromHub.selectedIndex].text : 'Chọn Hub xuất phát';
                    document.getElementById('toHubName').textContent =
                        toHub.selectedIndex > 0 ? toHub.options[toHub.selectedIndex].text : 'Chọn Hub đích';

                    validateForm();
                }

                function validateForm() {
                    var fromHubId = document.getElementById('fromHubId').value;
                    var toHubId = document.getElementById('toHubId').value;

                    var isValid = fromHubId && toHubId && selectedVehicleId && selectedDriverId && fromHubId !== toHubId;
                    document.getElementById('btnCreateTrip').disabled = !isValid;
                }

                function createTrip() {
                    var fromHubId = document.getElementById('fromHubId').value;
                    var toHubId = document.getElementById('toHubId').value;

                    if (!fromHubId || !toHubId || !selectedVehicleId || !selectedDriverId) {
                        alert('Vui lòng chọn đầy đủ thông tin!');
                        return;
                    }

                    var btn = document.getElementById('btnCreateTrip');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                    var requestData = {
                        vehicleId: selectedVehicleId,
                        driverId: selectedDriverId,
                        fromHubId: parseInt(fromHubId),
                        toHubId: parseInt(toHubId)
                    };

                    fetch(contextPath + '/api/manager/outbound/trip', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(requestData)
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            btn.disabled = false;
                            btn.innerHTML = '<i class="fas fa-plus-circle"></i> Tạo Chuyến Xe';

                            if (data.success) {
                                showSuccess(data.data);
                            } else {
                                alert(data.message || 'Có lỗi xảy ra!');
                            }
                        })
                        .catch(function (err) {
                            btn.disabled = false;
                            btn.innerHTML = '<i class="fas fa-plus-circle"></i> Tạo Chuyến Xe';
                            console.error(err);
                            alert('Lỗi kết nối server!');
                        });
                }

                function showSuccess(data) {
                    document.getElementById('newTripCode').textContent = data.trip.tripCode;

                    var html = '<div class="info-row">' +
                        '<span>Xe:</span><strong>' + data.vehicle.plateNumber + '</strong>' +
                        '</div>' +
                        '<div class="info-row">' +
                        '<span>Tài xế:</span><strong>' + data.driver.fullName + '</strong>' +
                        '</div>' +
                        '<div class="info-row">' +
                        '<span>Điện thoại:</span><strong>' + data.driver.phoneNumber + '</strong>' +
                        '</div>' +
                        '<div class="info-row">' +
                        '<span>Từ Hub:</span><strong>' + data.fromHub.hubName + '</strong>' +
                        '</div>' +
                        '<div class="info-row">' +
                        '<span>Đến Hub:</span><strong>' + data.toHub.hubName + '</strong>' +
                        '</div>' +
                        '<div class="info-row">' +
                        '<span>Trạng thái:</span><span class="badge badge-warning">Đang nạp hàng</span>' +
                        '</div>';

                    document.getElementById('tripInfoBox').innerHTML = html;
                    $('#successModal').modal('show');

                    // Reset form
                    selectedVehicleId = null;
                    selectedDriverId = null;
                    document.querySelectorAll('.vehicle-card, .driver-card').forEach(function (card) {
                        card.classList.remove('selected');
                    });
                    document.getElementById('fromHubId').value = '';
                    document.getElementById('toHubId').value = '';
                    updateRouteVisual();

                    // Refresh page after modal closed to update trip list
                    $('#successModal').on('hidden.bs.modal', function () {
                        location.reload();
                    });
                }
            </script>