<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Xếp Bao vào Xe - Loading</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .loading-header {
                    background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%);
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

                .panel-card-header.trip-header {
                    background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
                    color: #fff;
                }

                .panel-card-header.container-header {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    color: #fff;
                }

                .panel-card-body {
                    padding: 20px;
                    max-height: 500px;
                    overflow-y: auto;
                }

                .trip-item {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .trip-item:hover {
                    border-color: #4e73df;
                    background: #f8f9fc;
                }

                .trip-item.selected {
                    border-color: #1cc88a;
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                }

                .container-item {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 12px;
                    margin-bottom: 8px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .container-item:hover {
                    border-color: #36b9cc;
                    background: #f0f9fa;
                }

                .container-item.loaded {
                    border-color: #1cc88a;
                    background: #e8f5e9;
                    opacity: 0.7;
                }

                .capacity-bar {
                    height: 15px;
                    border-radius: 8px;
                    background: #e9ecef;
                    overflow: hidden;
                }

                .capacity-bar-fill {
                    height: 100%;
                    border-radius: 8px;
                    transition: width 0.3s;
                }

                .capacity-safe {
                    background: linear-gradient(90deg, #1cc88a, #17a673);
                }

                .capacity-warning {
                    background: linear-gradient(90deg, #f6c23e, #dda20a);
                }

                .capacity-danger {
                    background: linear-gradient(90deg, #e74a3b, #be2617);
                }

                .btn-load {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    border: none;
                    color: #fff;
                }

                .btn-load:hover {
                    background: linear-gradient(135deg, #17a673 0%, #0f6b4a 100%);
                    color: #fff;
                    transform: scale(1.1);
                }

                .btn-unload {
                    background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%);
                    border: none;
                    color: #fff;
                }

                .btn-unload:hover {
                    transform: scale(1.1);
                }

                .hub-filter-bar {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    border-radius: 10px;
                    padding: 15px 20px;
                    color: #fff;
                    margin-bottom: 20px;
                }

                .loaded-container-tag {
                    background: #e8f5e9;
                    border: 1px solid #1cc88a;
                    border-radius: 8px;
                    padding: 8px 12px;
                    margin-bottom: 8px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
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
                    color: #000;
                }

                .custom-toast.info {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    color: #fff;
                }

                .custom-toast .toast-icon {
                    font-size: 24px;
                    margin-right: 15px;
                }

                .custom-toast .toast-content {
                    flex: 1;
                }

                .custom-toast .toast-title {
                    font-weight: bold;
                    margin-bottom: 3px;
                }

                .custom-toast .toast-message {
                    font-size: 0.9rem;
                    opacity: 0.9;
                }

                .custom-toast .toast-close {
                    background: none;
                    border: none;
                    color: inherit;
                    font-size: 18px;
                    cursor: pointer;
                    opacity: 0.7;
                    margin-left: 10px;
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

                .stats-bar {
                    display: flex;
                    gap: 15px;
                }

                .stat-item {
                    background: rgba(255, 255, 255, 0.2);
                    padding: 10px 15px;
                    border-radius: 8px;
                    text-align: center;
                }

                .stat-item .stat-number {
                    font-size: 1.5rem;
                    font-weight: bold;
                }

                .stat-item .stat-label {
                    font-size: 0.75rem;
                    opacity: 0.9;
                }

                .vehicle-info {
                    background: #f8f9fc;
                    border-radius: 8px;
                    padding: 10px;
                    margin-top: 10px;
                }
            </style>
        </head>

        <body id="page-top">
            <div class="toast-container" id="toastContainer"></div>
            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <div class="loading-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-boxes mr-2"></i> Xếp Bao vào Xe (Loading)</h3>
                                        <p class="mb-0 opacity-75">Chọn chuyến xe và xếp các bao hàng đã niêm phong</p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="stats-bar justify-content-end">
                                            <div class="stat-item">
                                                <div class="stat-number" id="totalTripsCount">0</div>
                                                <div class="stat-label">Chuyến xe</div>
                                            </div>
                                            <div class="stat-item">
                                                <div class="stat-number" id="totalContainersCount">0</div>
                                                <div class="stat-label">Bao sẵn sàng</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="hub-filter-bar">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <label class="mb-1 font-weight-bold">Lọc theo Hub:</label>
                                        <select class="form-control" id="hubSelect">
                                            <option value="">-- Tất cả Hub --</option>
                                            <c:forEach var="hub" items="${hubs}">
                                                <option value="${hub.hubId}">${hub.hubName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="mb-1 font-weight-bold">Trạng thái:</label>
                                        <select class="form-control" id="statusFilter">
                                            <option value="">-- Tất cả --</option>
                                            <option value="loading">Đang xếp hàng</option>
                                            <option value="ready">Sẵn sàng xuất</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="panel-card">
                                        <div class="panel-card-header trip-header">
                                            <span><i class="fas fa-truck mr-2"></i> Chuyến xe</span>
                                            <span class="badge badge-light" id="tripsCountBadge">0</span>
                                        </div>
                                        <div class="panel-card-body">
                                            <div class="search-box">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="tripSearchInput"
                                                    placeholder="Tìm theo mã chuyến, biển số xe...">
                                            </div>
                                            <div id="tripsList"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="panel-card">
                                        <div class="panel-card-header container-header">
                                            <span><i class="fas fa-box mr-2"></i> Bao hàng sẵn sàng</span>
                                            <span class="badge badge-light" id="availableContainersBadge">0</span>
                                        </div>
                                        <div class="panel-card-body">
                                            <div class="search-box">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="containerSearchInput"
                                                    placeholder="Tìm theo mã bao...">
                                            </div>
                                            <div id="availableContainersList">
                                                <div class="text-center text-muted py-4">
                                                    <i class="fas fa-hand-pointer fa-3x mb-3" style="opacity:0.3"></i>
                                                    <p>Chọn một chuyến xe để xem bao hàng</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="panel-card">
                                        <div class="panel-card-header"
                                            style="background: linear-gradient(135deg, #858796 0%, #5a5c69 100%); color: #fff;">
                                            <span><i class="fas fa-truck-loading mr-2"></i> Bao đã xếp lên xe</span>
                                            <span class="badge badge-light" id="loadedContainersBadge">0</span>
                                        </div>
                                        <div class="panel-card-body" id="loadedContainersList">
                                            <div class="text-center text-muted py-4">
                                                <i class="fas fa-hand-pointer fa-3x mb-3" style="opacity:0.3"></i>
                                                <p>Chọn một chuyến xe để xem bao đã xếp</p>
                                            </div>
                                        </div>
                                        <div class="p-3 border-top" id="capacityInfo" style="display:none;">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Đã xếp:</span>
                                                <strong><span id="loadedWeight">0</span> kg</strong>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Sức chứa:</span>
                                                <strong><span id="vehicleCapacity">0</span> kg</strong>
                                            </div>
                                            <div class="capacity-bar">
                                                <div class="capacity-bar-fill capacity-safe" id="capacityBarFill"
                                                    style="width:0%"></div>
                                            </div>
                                            <small class="text-muted" id="capacityPercent">0%</small>
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
                var selectedTripFromHubId = null;
                var vehicleCapacity = 0;
                var allTrips = [];
                var allAvailableContainers = [];

                $(document).ready(function () {
                    loadTrips('');
                    $('#hubSelect').change(function () { loadTrips($(this).val()); });
                    $('#statusFilter').change(function () { filterTrips(); });
                    $('#tripSearchInput').on('input', function () { filterTrips(); });
                    $('#containerSearchInput').on('input', function () { filterContainers(); });
                });

                function showToast(type, title, message) {
                    var icons = { 'success': 'fa-check-circle', 'error': 'fa-times-circle', 'warning': 'fa-exclamation-triangle', 'info': 'fa-info-circle' };
                    var toastHtml = '<div class="custom-toast ' + type + '"><div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div><div class="toast-content"><div class="toast-title">' + title + '</div><div class="toast-message">' + message + '</div></div><button class="toast-close" onclick="closeToast(this)">&times;</button></div>';
                    var $toast = $(toastHtml);
                    $('#toastContainer').append($toast);
                    setTimeout(function () { $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }, 4000);
                }
                function closeToast(btn) { var $toast = $(btn).closest('.custom-toast'); $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }

                function loadTrips(hubId) {
                    var url = contextPath + '/api/manager/outbound/trips';
                    if (hubId) url += '?hubId=' + hubId;
                    $.get(url, function (response) {
                        if (response.success) {
                            allTrips = response.data;
                            $('#totalTripsCount').text(allTrips.length);
                            filterTrips();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách chuyến xe'); });
                }

                function filterTrips() {
                    var searchTerm = $('#tripSearchInput').val().toLowerCase();
                    var statusFilter = $('#statusFilter').val();
                    var filtered = allTrips.filter(function (trip) {
                        var matchSearch = true;
                        if (searchTerm) {
                            matchSearch = (trip.tripCode && trip.tripCode.toLowerCase().includes(searchTerm)) ||
                                (trip.vehiclePlate && trip.vehiclePlate.toLowerCase().includes(searchTerm)) ||
                                (trip.driverName && trip.driverName.toLowerCase().includes(searchTerm));
                        }
                        var matchStatus = true;
                        if (statusFilter) {
                            matchStatus = trip.status && trip.status.toLowerCase() === statusFilter.toLowerCase();
                        }
                        return matchSearch && matchStatus;
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
                        var capacityPercent = 0;
                        if (trip.vehicleCapacity && trip.vehicleCapacity > 0 && trip.totalWeight) {
                            capacityPercent = (trip.totalWeight / trip.vehicleCapacity) * 100;
                        }
                        var capacityClass = capacityPercent > 90 ? 'capacity-danger' : (capacityPercent > 70 ? 'capacity-warning' : 'capacity-safe');
                        var statusBadge = trip.status === 'loading' ? 'badge-warning' : (trip.status === 'ready' ? 'badge-success' : 'badge-info');
                        var html = '<div class="trip-item" data-trip-id="' + trip.tripId + '" data-from-hub="' + (trip.fromHubId || '') + '">' +
                            '<div class="d-flex justify-content-between align-items-center mb-2">' +
                            '<strong class="text-primary">' + trip.tripCode + '</strong>' +
                            '<span class="badge ' + statusBadge + '">' + trip.status + '</span>' +
                            '</div>' +
                            '<div class="vehicle-info">' +
                            '<small class="d-block"><i class="fas fa-truck mr-1 text-info"></i> <strong>' + (trip.vehiclePlate || 'N/A') + '</strong> (' + (trip.vehicleType || 'N/A') + ')</small>' +
                            '<small class="d-block"><i class="fas fa-user mr-1 text-success"></i> ' + (trip.driverName || 'Chưa có tài xế') + ' - ' + (trip.driverPhone || '') + '</small>' +
                            '<small class="d-block"><i class="fas fa-route mr-1 text-warning"></i> ' + (trip.fromHubName || 'N/A') + ' → ' + (trip.toHubName || 'N/A') + '</small>' +
                            '</div>' +
                            '<div class="mt-2">' +
                            '<small class="text-muted"><i class="fas fa-box mr-1"></i> ' + trip.containerCount + ' bao</small>' +
                            '<small class="text-muted ml-3"><i class="fas fa-weight mr-1"></i> ' + (trip.totalWeight || 0) + '/' + (trip.vehicleCapacity || 0) + ' kg</small>' +
                            '</div>' +
                            '<div class="capacity-bar mt-2"><div class="capacity-bar-fill ' + capacityClass + '" style="width:' + Math.min(capacityPercent, 100) + '%"></div></div>' +
                            '</div>';
                        container.append(html);
                    });
                    container.find('.trip-item').click(function () {
                        selectTrip($(this).data('trip-id'), $(this).data('from-hub'));
                    });
                    if (selectedTripId) {
                        $('.trip-item[data-trip-id="' + selectedTripId + '"]').addClass('selected');
                    }
                }

                function selectTrip(tripId, fromHubId) {
                    selectedTripId = tripId;
                    selectedTripFromHubId = fromHubId;
                    $('.trip-item').removeClass('selected');
                    $('.trip-item[data-trip-id="' + tripId + '"]').addClass('selected');
                    loadTripDetail(tripId);
                    loadAvailableContainers(fromHubId);
                }

                function loadTripDetail(tripId) {
                    $.get(contextPath + '/api/manager/outbound/trips/' + tripId, function (response) {
                        if (response.success) {
                            var trip = response.data;
                            vehicleCapacity = trip.vehicleCapacity || 0;
                            renderLoadedContainers(trip.containers || [], trip.totalLoadedWeight || 0, vehicleCapacity);
                            $('#capacityInfo').show();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải chi tiết chuyến xe'); });
                }

                function loadAvailableContainers(hubId) {
                    if (!hubId) {
                        $('#availableContainersList').html('<div class="text-center text-muted py-4"><p>Không xác định được Hub</p></div>');
                        return;
                    }
                    $.get(contextPath + '/api/manager/outbound/containers-for-loading?hubId=' + hubId, function (res) {
                        if (res.success) {
                            allAvailableContainers = res.data;
                            $('#totalContainersCount').text(allAvailableContainers.length);
                            filterContainers();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách bao hàng'); });
                }

                function filterContainers() {
                    var searchTerm = $('#containerSearchInput').val().toLowerCase();
                    var filtered = allAvailableContainers.filter(function (c) {
                        if (!searchTerm) return true;
                        return c.containerCode && c.containerCode.toLowerCase().includes(searchTerm);
                    });
                    renderAvailableContainers(filtered);
                }

                function renderAvailableContainers(containers) {
                    var panel = $('#availableContainersList');
                    panel.empty();
                    $('#availableContainersBadge').text(containers.length);
                    if (containers.length === 0) {
                        panel.html('<div class="text-center text-muted py-4"><i class="fas fa-box-open fa-3x mb-3" style="opacity:0.3"></i><p>Không có bao hàng sẵn sàng</p></div>');
                        return;
                    }
                    containers.forEach(function (c) {
                        var html = '<div class="container-item" data-container-id="' + c.containerId + '">' +
                            '<div class="d-flex justify-content-between align-items-center">' +
                            '<div>' +
                            '<strong>' + c.containerCode + '</strong><br>' +
                            '<small class="text-muted"><i class="fas fa-box mr-1"></i> ' + c.orderCount + ' đơn</small>' +
                            '<small class="text-muted ml-2"><i class="fas fa-weight mr-1"></i> ' + (c.weight || 0) + ' kg</small>' +
                            '<small class="text-muted d-block"><i class="fas fa-arrow-right mr-1"></i> ' + (c.destinationHubName || 'N/A') + '</small>' +
                            '</div>' +
                            '<button class="btn btn-sm btn-load" onclick="loadContainer(' + c.containerId + ', \'' + c.containerCode + '\')" title="Xếp lên xe">' +
                            '<i class="fas fa-arrow-right"></i>' +
                            '</button>' +
                            '</div>' +
                            '</div>';
                        panel.append(html);
                    });
                }

                function renderLoadedContainers(containers, totalWeight, capacity) {
                    var panel = $('#loadedContainersList');
                    panel.empty();
                    var loadedContainers = containers.filter(function (c) { return c.tripContainerStatus === 'loaded'; });
                    $('#loadedContainersBadge').text(loadedContainers.length);
                    if (loadedContainers.length === 0) {
                        panel.html('<div class="text-center text-muted py-4"><i class="fas fa-truck fa-3x mb-3" style="opacity:0.3"></i><p>Chưa xếp bao nào</p></div>');
                    } else {
                        loadedContainers.forEach(function (c) {
                            var html = '<div class="loaded-container-tag">' +
                                '<div>' +
                                '<strong>' + c.containerCode + '</strong><br>' +
                                '<small class="text-muted">' + c.orderCount + ' đơn | ' + (c.weight || 0) + ' kg</small>' +
                                '</div>' +
                                '<button class="btn btn-sm btn-unload" onclick="unloadContainer(' + c.containerId + ', \'' + c.containerCode + '\')" title="Dỡ khỏi xe">' +
                                '<i class="fas fa-times"></i>' +
                                '</button>' +
                                '</div>';
                            panel.append(html);
                        });
                    }
                    $('#loadedWeight').text(totalWeight);
                    $('#vehicleCapacity').text(capacity);
                    var percent = capacity > 0 ? (totalWeight / capacity) * 100 : 0;
                    $('#capacityPercent').text(percent.toFixed(1) + '%');
                    $('#capacityBarFill').css('width', Math.min(percent, 100) + '%');
                    var capacityClass = 'capacity-safe';
                    if (percent > 90) capacityClass = 'capacity-danger';
                    else if (percent > 70) capacityClass = 'capacity-warning';
                    $('#capacityBarFill').removeClass('capacity-safe capacity-warning capacity-danger').addClass(capacityClass);
                }

                function loadContainer(containerId, containerCode) {
                    if (!selectedTripId) {
                        showToast('warning', 'Chưa chọn chuyến', 'Vui lòng chọn chuyến xe trước');
                        return;
                    }
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/load-container?actorId=' + managerId,
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ tripId: selectedTripId, containerId: containerId }),
                        success: function (response) {
                            if (response.success) {
                                showToast('success', 'Xếp bao thành công!', 'Đã xếp bao ' + containerCode + ' lên xe');
                                if (response.message && response.message.indexOf('quá tải') > -1) {
                                    showToast('warning', 'Cảnh báo', response.message);
                                }
                                selectTrip(selectedTripId, selectedTripFromHubId);
                                loadTrips($('#hubSelect').val());
                            } else {
                                showToast('error', 'Không thể xếp bao', response.message || 'Đã xảy ra lỗi');
                            }
                        },
                        error: function (xhr) {
                            var error = xhr.responseJSON || {};
                            showToast('error', 'Lỗi xếp bao', error.message || 'Không thể xếp bao lên xe');
                        }
                    });
                }

                function unloadContainer(containerId, containerCode) {
                    if (!selectedTripId) return;
                    if (!confirm('Bạn có chắc muốn dỡ bao ' + containerCode + ' khỏi xe?')) return;
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/unload-container?actorId=' + managerId,
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ tripId: selectedTripId, containerId: containerId }),
                        success: function (response) {
                            if (response.success) {
                                showToast('success', 'Dỡ bao thành công!', 'Đã dỡ bao ' + containerCode + ' khỏi xe');
                                selectTrip(selectedTripId, selectedTripFromHubId);
                                loadTrips($('#hubSelect').val());
                            } else {
                                showToast('error', 'Không thể dỡ bao', response.message);
                            }
                        },
                        error: function (xhr) {
                            var error = xhr.responseJSON || {};
                            showToast('error', 'Lỗi dỡ bao', error.message || 'Không thể dỡ bao');
                        }
                    });
                }
            </script>
        </body>

        </html>