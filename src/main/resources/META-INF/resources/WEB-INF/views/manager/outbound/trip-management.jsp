<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Chuyến xe - Trip Management</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .page-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .panel-card {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                    margin-bottom: 20px;
                }

                .panel-card-header {
                    padding: 15px 20px;
                    border-bottom: 1px solid #eee;
                    border-radius: 12px 12px 0 0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .panel-card-body {
                    padding: 20px;
                    max-height: 600px;
                    overflow-y: auto;
                }

                .trip-card {
                    border: 2px solid #e3e6f0;
                    border-radius: 12px;
                    padding: 15px;
                    margin-bottom: 15px;
                    transition: all 0.3s;
                    cursor: pointer;
                }

                .trip-card:hover {
                    border-color: #667eea;
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                }

                .trip-card.selected {
                    border-color: #1cc88a;
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                }

                .status-badge {
                    padding: 5px 12px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .status-loading {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-on_way {
                    background: #cce5ff;
                    color: #004085;
                }

                .status-completed {
                    background: #d4edda;
                    color: #155724;
                }

                .container-card {
                    background: #f8f9fc;
                    border: 1px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 12px;
                    margin-bottom: 10px;
                }

                .order-item {
                    background: #fff;
                    border: 1px solid #e3e6f0;
                    border-radius: 8px;
                    padding: 10px;
                    margin-bottom: 8px;
                    font-size: 0.85rem;
                }

                .info-row {
                    display: flex;
                    margin-bottom: 8px;
                }

                .info-label {
                    width: 120px;
                    color: #858796;
                    font-weight: 500;
                }

                .info-value {
                    flex: 1;
                    color: #3a3b45;
                }

                .search-box {
                    position: relative;
                    margin-bottom: 15px;
                }

                .search-box input {
                    padding-left: 35px;
                    border-radius: 20px;
                    border: 1px solid #d1d3e2;
                }

                .search-box i {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #858796;
                }

                .filter-bar {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    border-radius: 10px;
                    padding: 15px 20px;
                    color: #fff;
                    margin-bottom: 20px;
                }

                .toast-container {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                }

                .custom-toast {
                    min-width: 350px;
                    padding: 15px 20px;
                    border-radius: 10px;
                    margin-bottom: 10px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                    animation: slideIn 0.3s ease;
                    display: flex;
                    align-items: center;
                }

                .custom-toast.success {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    color: #fff;
                }

                .custom-toast.error {
                    background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%);
                    color: #fff;
                }

                .custom-toast.warning {
                    background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%);
                    color: #fff;
                }

                .custom-toast .toast-icon {
                    font-size: 1.5rem;
                    margin-right: 15px;
                }

                .custom-toast .toast-content {
                    flex: 1;
                }

                .custom-toast .toast-title {
                    font-weight: bold;
                    margin-bottom: 3px;
                }

                .custom-toast .toast-close {
                    background: none;
                    border: none;
                    color: #fff;
                    font-size: 1.2rem;
                    cursor: pointer;
                    opacity: 0.7;
                }

                .custom-toast .toast-close:hover {
                    opacity: 1;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }

                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                @keyframes slideOut {
                    from {
                        transform: translateX(0);
                        opacity: 1;
                    }

                    to {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                }

                .detail-section {
                    margin-bottom: 20px;
                }

                .detail-section-title {
                    font-weight: 600;
                    color: #4e73df;
                    margin-bottom: 10px;
                    border-bottom: 2px solid #4e73df;
                    padding-bottom: 5px;
                }

                .timeline-item {
                    position: relative;
                    padding-left: 30px;
                    margin-bottom: 15px;
                }

                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: 8px;
                    top: 25px;
                    bottom: -15px;
                    width: 2px;
                    background: #e3e6f0;
                }

                .timeline-item:last-child::before {
                    display: none;
                }

                .timeline-dot {
                    position: absolute;
                    left: 0;
                    top: 5px;
                    width: 18px;
                    height: 18px;
                    border-radius: 50%;
                    background: #4e73df;
                    border: 3px solid #fff;
                    box-shadow: 0 0 0 2px #4e73df;
                }

                .order-status-badge {
                    font-size: 0.7rem;
                    padding: 2px 8px;
                    border-radius: 10px;
                }
            </style>
        </head>

        <body id="page-top">
            <div class="toast-container" id="toastContainer"></div>

            <!-- Modal xem chi tiết đơn hàng -->
            <div class="modal fade" id="orderDetailModal" tabindex="-1">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title"><i class="fas fa-file-alt mr-2"></i> Chi tiết đơn hàng</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body" id="orderDetailContent"></div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal xác nhận xe đến bến -->
            <div class="modal fade" id="arriveConfirmModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header"
                            style="background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); color: #fff;">
                            <h5 class="modal-title"><i class="fas fa-flag-checkered mr-2"></i> Xác nhận xe đến bến</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body text-center py-4">
                            <i class="fas fa-truck fa-4x text-success mb-3"></i>
                            <h5 class="font-weight-bold">Xác nhận chuyến xe đã đến bến?</h5>
                            <p class="text-muted">Chuyến xe <strong id="arriveTripCode" class="text-primary"></strong>
                                sẽ được đánh dấu hoàn thành.</p>
                            <p class="text-info"><i class="fas fa-info-circle mr-1"></i> Các bao hàng sẽ được chuyển
                                sang trạng thái đã nhận tại Hub đích.</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-secondary px-4" data-dismiss="modal"><i
                                    class="fas fa-times mr-1"></i> Hủy</button>
                            <button type="button" class="btn btn-success px-4" id="confirmArriveBtn"><i
                                    class="fas fa-check mr-1"></i> Xác nhận đến</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <div class="page-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-truck mr-2"></i> Quản lý Chuyến xe</h3>
                                        <p class="mb-0 opacity-75">Xem tất cả chuyến xe, chi tiết bao hàng và đơn hàng
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="d-flex justify-content-end">
                                            <div class="text-center mr-3">
                                                <div class="h4 mb-0" id="totalTripsCount">0</div>
                                                <small class="opacity-75">Tổng chuyến</small>
                                            </div>
                                            <div class="text-center mr-3">
                                                <div class="h4 mb-0" id="onWayCount">0</div>
                                                <small class="opacity-75">Đang chạy</small>
                                            </div>
                                            <div class="text-center">
                                                <div class="h4 mb-0" id="completedCount">0</div>
                                                <small class="opacity-75">Hoàn thành</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="filter-bar">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <label class="mb-1 font-weight-bold">Hub xuất phát:</label>
                                        <select class="form-control" id="hubSelect">
                                            <option value="">-- Tất cả Hub --</option>
                                            <c:forEach var="hub" items="${hubs}">
                                                <option value="${hub.hubId}">${hub.hubName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="mb-1 font-weight-bold">Trạng thái:</label>
                                        <select class="form-control" id="statusFilter">
                                            <option value="">-- Tất cả --</option>
                                            <option value="loading">Đang xếp hàng</option>
                                            <option value="on_way">Đang vận chuyển</option>
                                            <option value="completed">Đã hoàn thành</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="mb-1 font-weight-bold">Từ ngày:</label>
                                        <input type="date" class="form-control" id="fromDate">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="mb-1 font-weight-bold">Đến ngày:</label>
                                        <input type="date" class="form-control" id="toDate">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Danh sách chuyến xe -->
                                <div class="col-md-5">
                                    <div class="panel-card">
                                        <div class="panel-card-header"
                                            style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff;">
                                            <span><i class="fas fa-list mr-2"></i> Danh sách chuyến xe</span>
                                            <span class="badge badge-light" id="tripsCountBadge">0</span>
                                        </div>
                                        <div class="panel-card-body">
                                            <div class="search-box">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="tripSearchInput"
                                                    placeholder="Tìm theo mã chuyến, biển số, tài xế...">
                                            </div>
                                            <div id="tripsList"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Chi tiết chuyến xe -->
                                <div class="col-md-7">
                                    <div class="panel-card">
                                        <div class="panel-card-header"
                                            style="background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); color: #fff;">
                                            <span><i class="fas fa-info-circle mr-2"></i> Chi tiết chuyến xe</span>
                                            <div id="tripActions" style="display:none;">
                                                <button class="btn btn-sm btn-light" id="btnArriveTrip"><i
                                                        class="fas fa-flag-checkered mr-1"></i> Xe đến bến</button>
                                            </div>
                                        </div>
                                        <div class="panel-card-body" id="tripDetailContent">
                                            <div class="text-center text-muted py-5">
                                                <i class="fas fa-hand-pointer fa-4x mb-3" style="opacity:0.3"></i>
                                                <p class="h5">Chọn một chuyến xe để xem chi tiết</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
            <script>
                var contextPath = '${pageContext.request.contextPath}';
                var managerId = 1;
                var selectedTripId = null;
                var allTrips = [];

                $(document).ready(function () {
                    loadAllTrips();
                    $('#hubSelect, #statusFilter').change(function () { filterTrips(); });
                    $('#fromDate, #toDate').change(function () { filterTrips(); });
                    $('#tripSearchInput').on('input', function () { filterTrips(); });
                    $('#btnArriveTrip').click(function () { showArriveConfirm(); });
                    $('#confirmArriveBtn').click(function () { confirmTripArrival(); });
                });

                function showToast(type, title, message) {
                    var icons = { 'success': 'fa-check-circle', 'error': 'fa-times-circle', 'warning': 'fa-exclamation-triangle', 'info': 'fa-info-circle' };
                    var toastHtml = '<div class="custom-toast ' + type + '"><div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div><div class="toast-content"><div class="toast-title">' + title + '</div><div class="toast-message">' + message + '</div></div><button class="toast-close" onclick="closeToast(this)">&times;</button></div>';
                    var $toast = $(toastHtml);
                    $('#toastContainer').append($toast);
                    setTimeout(function () { $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }, 4000);
                }
                function closeToast(btn) { $(btn).closest('.custom-toast').remove(); }

                function formatDateTime(dateStr) {
                    if (!dateStr) return 'N/A';
                    var d = new Date(dateStr);
                    return d.toLocaleString('vi-VN');
                }

                function formatCurrency(amount) {
                    if (!amount) return '0 đ';
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
                }

                function loadAllTrips() {
                    $.get(contextPath + '/api/manager/resource/all-trips', function (response) {
                        if (response.success) {
                            allTrips = response.data;
                            updateStats();
                            filterTrips();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách chuyến xe'); });
                }

                function updateStats() {
                    $('#totalTripsCount').text(allTrips.length);
                    var onWay = allTrips.filter(function (t) { return t.status === 'on_way'; }).length;
                    var completed = allTrips.filter(function (t) { return t.status === 'completed'; }).length;
                    $('#onWayCount').text(onWay);
                    $('#completedCount').text(completed);
                }

                function filterTrips() {
                    var hubId = $('#hubSelect').val();
                    var status = $('#statusFilter').val();
                    var search = $('#tripSearchInput').val().toLowerCase();
                    var fromDate = $('#fromDate').val();
                    var toDate = $('#toDate').val();

                    var filtered = allTrips.filter(function (trip) {
                        // Lấy hubId từ object fromHub
                        var tripFromHubId = trip.fromHub ? trip.fromHub.hubId : null;
                        if (hubId && tripFromHubId != hubId) return false;
                        if (status && trip.status !== status) return false;
                        if (search) {
                            var vehiclePlate = trip.vehicle ? trip.vehicle.plateNumber : '';
                            var driverName = trip.driver ? trip.driver.fullName : '';
                            var matchSearch = (trip.tripCode && trip.tripCode.toLowerCase().includes(search)) ||
                                (vehiclePlate && vehiclePlate.toLowerCase().includes(search)) ||
                                (driverName && driverName.toLowerCase().includes(search));
                            if (!matchSearch) return false;
                        }
                        if (fromDate && trip.createdAt && new Date(trip.createdAt) < new Date(fromDate)) return false;
                        if (toDate && trip.createdAt && new Date(trip.createdAt) > new Date(toDate + 'T23:59:59')) return false;
                        return true;
                    });

                    renderTrips(filtered);
                }

                function renderTrips(trips) {
                    var container = $('#tripsList');
                    container.empty();
                    $('#tripsCountBadge').text(trips.length);

                    if (trips.length === 0) {
                        container.html('<div class="text-center text-muted py-4"><i class="fas fa-inbox fa-3x mb-3" style="opacity:0.3"></i><p>Không có chuyến xe nào</p></div>');
                        return;
                    }

                    trips.forEach(function (trip) {
                        var statusClass = 'status-' + trip.status;
                        var statusText = trip.status === 'loading' ? 'Đang xếp hàng' : (trip.status === 'on_way' ? 'Đang vận chuyển' : 'Hoàn thành');
                        var vehiclePlate = trip.vehicle ? trip.vehicle.plateNumber : 'N/A';
                        var vehicleType = trip.vehicle ? trip.vehicle.vehicleType : '';
                        var driverName = trip.driver ? trip.driver.fullName : 'N/A';
                        var driverPhone = trip.driver ? trip.driver.phoneNumber : '';
                        var fromHubName = trip.fromHub ? trip.fromHub.hubName : 'N/A';
                        var toHubName = trip.toHub ? trip.toHub.hubName : 'N/A';
                        var html = '<div class="trip-card" data-trip-id="' + trip.tripId + '">' +
                            '<div class="d-flex justify-content-between align-items-start mb-2">' +
                            '<h5 class="font-weight-bold text-primary mb-0">' + trip.tripCode + '</h5>' +
                            '<span class="status-badge ' + statusClass + '">' + statusText + '</span></div>' +
                            '<div class="info-row"><span class="info-label"><i class="fas fa-truck text-info"></i> Xe:</span><span class="info-value">' + vehiclePlate + ' (' + vehicleType + ')</span></div>' +
                            '<div class="info-row"><span class="info-label"><i class="fas fa-user text-success"></i> Tài xế:</span><span class="info-value">' + driverName + ' - ' + driverPhone + '</span></div>' +
                            '<div class="info-row"><span class="info-label"><i class="fas fa-route text-warning"></i> Tuyến:</span><span class="info-value">' + fromHubName + ' → ' + toHubName + '</span></div>' +
                            '<div class="d-flex justify-content-between mt-2">' +
                            '<small class="text-muted"><i class="fas fa-box mr-1"></i> ' + trip.containerCount + ' bao</small>' +
                            '<small class="text-muted"><i class="fas fa-clock mr-1"></i> ' + formatDateTime(trip.createdAt) + '</small></div></div>';
                        container.append(html);
                    });

                    container.find('.trip-card').click(function () {
                        selectTrip($(this).data('trip-id'));
                    });

                    if (selectedTripId) {
                        $('.trip-card[data-trip-id="' + selectedTripId + '"]').addClass('selected');
                    }
                }

                function selectTrip(tripId) {
                    selectedTripId = tripId;
                    $('.trip-card').removeClass('selected');
                    $('.trip-card[data-trip-id="' + tripId + '"]').addClass('selected');
                    loadTripDetail(tripId);
                }

                function loadTripDetail(tripId) {
                    $.get(contextPath + '/api/manager/resource/trips/' + tripId + '/full-detail', function (response) {
                        if (response.success) {
                            renderTripDetail(response.data);
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải chi tiết chuyến xe'); });
                }

                function renderTripDetail(trip) {
                    var statusClass = 'status-' + trip.status;
                    var statusText = trip.status === 'loading' ? 'Đang xếp hàng' : (trip.status === 'on_way' ? 'Đang vận chuyển' : 'Hoàn thành');

                    var html = '<div class="detail-section">' +
                        '<div class="d-flex justify-content-between align-items-center mb-3">' +
                        '<h4 class="font-weight-bold text-primary mb-0">' + trip.tripCode + '</h4>' +
                        '<span class="status-badge ' + statusClass + ' px-3 py-2">' + statusText + '</span></div>';

                    // Thông tin xe và tài xế
                    html += '<div class="row mb-3">' +
                        '<div class="col-md-6"><div class="detail-section-title"><i class="fas fa-truck mr-2"></i>Thông tin xe</div>' +
                        '<div class="info-row"><span class="info-label">Biển số:</span><span class="info-value font-weight-bold">' + (trip.vehicle ? trip.vehicle.plateNumber : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">Loại xe:</span><span class="info-value">' + (trip.vehicle ? trip.vehicle.vehicleType : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">Tải trọng:</span><span class="info-value">' + (trip.vehicle ? trip.vehicle.loadCapacity : 0) + ' kg</span></div>' +
                        '<div class="info-row"><span class="info-label">Trạng thái:</span><span class="info-value"><span class="badge badge-info">' + (trip.vehicle ? trip.vehicle.status : 'N/A') + '</span></span></div></div>' +
                        '<div class="col-md-6"><div class="detail-section-title"><i class="fas fa-user mr-2"></i>Thông tin tài xế</div>' +
                        '<div class="info-row"><span class="info-label">Họ tên:</span><span class="info-value font-weight-bold">' + (trip.driver ? trip.driver.fullName : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">SĐT:</span><span class="info-value">' + (trip.driver ? trip.driver.phoneNumber : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">GPLX:</span><span class="info-value">' + (trip.driver ? trip.driver.licenseNumber : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">Hạng:</span><span class="info-value">' + (trip.driver ? trip.driver.licenseClass : 'N/A') + '</span></div></div></div>';

                    // Timeline
                    html += '<div class="detail-section-title"><i class="fas fa-history mr-2"></i>Lịch trình</div>' +
                        '<div class="row mb-3"><div class="col-md-6">' +
                        '<div class="timeline-item"><div class="timeline-dot" style="background:#4e73df;"></div><div><strong>Tạo chuyến</strong><br><small class="text-muted">' + formatDateTime(trip.createdAt) + '</small></div></div>' +
                        '<div class="timeline-item"><div class="timeline-dot" style="background:' + (trip.departedAt ? '#1cc88a' : '#858796') + ';"></div><div><strong>Xuất bến</strong><br><small class="text-muted">' + (trip.departedAt ? formatDateTime(trip.departedAt) : 'Chưa xuất') + '</small></div></div>' +
                        '<div class="timeline-item"><div class="timeline-dot" style="background:' + (trip.arrivedAt ? '#1cc88a' : '#858796') + ';"></div><div><strong>Đến bến</strong><br><small class="text-muted">' + (trip.arrivedAt ? formatDateTime(trip.arrivedAt) : 'Chưa đến') + '</small></div></div></div>' +
                        '<div class="col-md-6"><div class="detail-section-title"><i class="fas fa-route mr-2"></i>Tuyến đường</div>' +
                        '<div class="info-row"><span class="info-label">Xuất phát:</span><span class="info-value font-weight-bold text-primary">' + (trip.fromHub ? trip.fromHub.hubName : 'N/A') + '</span></div>' +
                        '<div class="info-row"><span class="info-label">Đến:</span><span class="info-value font-weight-bold text-success">' + (trip.toHub ? trip.toHub.hubName : 'N/A') + '</span></div>' +
                        '<hr><div class="info-row"><span class="info-label">Tổng bao:</span><span class="info-value font-weight-bold">' + trip.containerCount + '</span></div>' +
                        '<div class="info-row"><span class="info-label">Tổng đơn:</span><span class="info-value font-weight-bold">' + trip.totalOrders + '</span></div></div></div>';

                    // Danh sách bao hàng
                    html += '<div class="detail-section-title"><i class="fas fa-boxes mr-2"></i>Bao hàng trên xe (' + (trip.containers ? trip.containers.length : 0) + ')</div>';
                    if (trip.containers && trip.containers.length > 0) {
                        trip.containers.forEach(function (container) {
                            html += '<div class="container-card">' +
                                '<div class="d-flex justify-content-between align-items-center mb-2">' +
                                '<h6 class="font-weight-bold text-info mb-0"><i class="fas fa-box mr-1"></i> ' + container.containerCode + '</h6>' +
                                '<div><span class="badge badge-' + (container.status === 'closed' ? 'success' : 'warning') + ' mr-1">' + container.status + '</span>' +
                                '<span class="badge badge-info">' + container.orderCount + ' đơn</span></div></div>' +
                                '<div class="d-flex justify-content-between text-muted small mb-2">' +
                                '<span><i class="fas fa-weight mr-1"></i> ' + (container.currentWeight || 0) + ' kg</span>' +
                                '<span><i class="fas fa-clock mr-1"></i> Xếp lúc: ' + formatDateTime(container.loadedAt) + '</span></div>';

                            // Hiển thị các đơn hàng trong bao
                            if (container.orders && container.orders.length > 0) {
                                html += '<div class="mt-2"><small class="text-muted font-weight-bold">Đơn hàng trong bao:</small>';
                                container.orders.forEach(function (order) {
                                    var orderStatusClass = order.status === 'in_transit' ? 'badge-primary' : (order.status === 'delivered' ? 'badge-success' : 'badge-secondary');
                                    html += '<div class="order-item">' +
                                        '<div class="d-flex justify-content-between align-items-center">' +
                                        '<div><strong class="text-primary">#' + order.requestId + '</strong>' +
                                        (order.trackingNumber ? '<span class="ml-2 text-muted small">' + order.trackingNumber + '</span>' : '') + '</div>' +
                                        '<div><span class="order-status-badge badge ' + orderStatusClass + '">' + order.status + '</span>' +
                                        '<button class="btn btn-sm btn-outline-info ml-2" onclick="showOrderDetail(' + order.requestId + ')"><i class="fas fa-eye"></i></button></div></div>' +
                                        '<div class="row mt-1">' +
                                        '<div class="col-6"><small class="text-muted"><i class="fas fa-user text-success"></i> ' + (order.senderName || 'N/A') + '</small></div>' +
                                        '<div class="col-6"><small class="text-muted"><i class="fas fa-map-marker-alt text-danger"></i> ' + (order.receiverName || 'N/A') + '</small></div></div>' +
                                        '<div class="d-flex justify-content-between mt-1">' +
                                        '<small><i class="fas fa-box text-info"></i> ' + (order.itemName || 'N/A') + '</small>' +
                                        '<small class="text-warning font-weight-bold">' + formatCurrency(order.codAmount) + '</small></div></div>';
                                });
                                html += '</div>';
                            }
                            html += '</div>';
                        });
                    } else {
                        html += '<div class="alert alert-info"><i class="fas fa-info-circle mr-2"></i>Chưa có bao hàng nào trên xe</div>';
                    }

                    html += '</div>';

                    $('#tripDetailContent').html(html);

                    // Hiển thị nút "Xe đến bến" nếu chuyến đang on_way
                    if (trip.status === 'on_way') {
                        $('#tripActions').show();
                    } else {
                        $('#tripActions').hide();
                    }
                }

                function showOrderDetail(orderId) {
                    $.get(contextPath + '/api/manager/resource/orders/' + orderId, function (response) {
                        if (response.success) {
                            var order = response.data;
                            var html = '<div class="row"><div class="col-md-6"><h6 class="font-weight-bold text-primary mb-3"><i class="fas fa-user-circle mr-2"></i>Thông tin người gửi</h6>' +
                                '<table class="table table-sm"><tr><td class="text-muted">Họ tên:</td><td>' + (order.senderName || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">SĐT:</td><td>' + (order.senderPhone || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Địa chỉ:</td><td>' + (order.senderAddress || '') + '</td></tr>' +
                                '<tr><td class="text-muted">Phường/Xã:</td><td>' + (order.senderWard || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Quận/Huyện:</td><td>' + (order.senderDistrict || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Tỉnh/TP:</td><td>' + (order.senderProvince || 'N/A') + '</td></tr></table></div>' +
                                '<div class="col-md-6"><h6 class="font-weight-bold text-danger mb-3"><i class="fas fa-map-marker-alt mr-2"></i>Thông tin người nhận</h6>' +
                                '<table class="table table-sm"><tr><td class="text-muted">Họ tên:</td><td>' + (order.receiverName || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">SĐT:</td><td>' + (order.receiverPhone || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Địa chỉ:</td><td>' + (order.receiverAddress || '') + '</td></tr>' +
                                '<tr><td class="text-muted">Phường/Xã:</td><td>' + (order.receiverWard || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Quận/Huyện:</td><td>' + (order.receiverDistrict || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Tỉnh/TP:</td><td>' + (order.receiverProvince || 'N/A') + '</td></tr></table></div></div><hr>' +
                                '<div class="row"><div class="col-md-6"><h6 class="font-weight-bold text-info mb-3"><i class="fas fa-box mr-2"></i>Thông tin hàng hóa</h6>' +
                                '<table class="table table-sm"><tr><td class="text-muted">Mã vận đơn:</td><td><strong>' + (order.trackingCode || 'N/A') + '</strong></td></tr>' +
                                '<tr><td class="text-muted">Tên hàng:</td><td>' + (order.itemName || 'N/A') + '</td></tr>' +
                                '<tr><td class="text-muted">Trọng lượng:</td><td>' + (order.weight || 0) + ' kg</td></tr>' +
                                '<tr><td class="text-muted">Kích thước:</td><td>' + (order.length || 0) + ' x ' + (order.width || 0) + ' x ' + (order.height || 0) + ' cm</td></tr>' +
                                '<tr><td class="text-muted">Loại dịch vụ:</td><td><span class="badge badge-info">' + (order.serviceTypeName || 'N/A') + '</span></td></tr></table></div>' +
                                '<div class="col-md-6"><h6 class="font-weight-bold text-success mb-3"><i class="fas fa-money-bill-wave mr-2"></i>Thông tin phí</h6>' +
                                '<table class="table table-sm"><tr><td class="text-muted">Tiền thu hộ (COD):</td><td class="text-warning font-weight-bold">' + formatCurrency(order.codAmount) + '</td></tr>' +
                                '<tr><td class="text-muted">Phí vận chuyển:</td><td>' + formatCurrency(order.shippingFee) + '</td></tr>' +
                                '<tr><td class="text-muted">Tổng cộng:</td><td class="font-weight-bold text-success">' + formatCurrency(order.totalPrice) + '</td></tr></table>' +
                                '<h6 class="font-weight-bold text-warning mb-3 mt-3"><i class="fas fa-info-circle mr-2"></i>Trạng thái</h6>' +
                                '<table class="table table-sm"><tr><td class="text-muted">Trạng thái:</td><td><span class="badge badge-primary">' + (order.status || 'N/A') + '</span></td></tr>' +
                                '<tr><td class="text-muted">Tạo đơn:</td><td>' + formatDateTime(order.createdAt) + '</td></tr></table></div></div>';
                            $('#orderDetailContent').html(html);
                            $('#orderDetailModal').modal('show');
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải chi tiết đơn hàng'); });
                }

                function showArriveConfirm() {
                    var trip = allTrips.find(function (t) { return t.tripId == selectedTripId; });
                    if (trip) {
                        $('#arriveTripCode').text(trip.tripCode);
                        $('#arriveConfirmModal').modal('show');
                    }
                }

                function confirmTripArrival() {
                    $('#arriveConfirmModal').modal('hide');
                    $.ajax({
                        url: contextPath + '/api/manager/resource/trips/' + selectedTripId + '/arrive?actorId=' + managerId,
                        method: 'POST',
                        success: function (response) {
                            if (response.success) {
                                showToast('success', 'Thành công!', 'Đã xác nhận chuyến xe đến bến');
                                loadAllTrips();
                                loadTripDetail(selectedTripId);
                            } else {
                                showToast('error', 'Lỗi', response.message);
                            }
                        },
                        error: function (xhr) {
                            var error = xhr.responseJSON || {};
                            showToast('error', 'Lỗi', error.message || 'Không thể xác nhận xe đến bến');
                        }
                    });
                }
            </script>
        </body>

        </html>