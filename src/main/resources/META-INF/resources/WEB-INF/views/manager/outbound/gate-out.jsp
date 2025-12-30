<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Xuất Bến - Manager Portal</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.min.css"
                    rel="stylesheet">

                <style>
                    .gateout-header {
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        padding: 25px;
                        border-radius: 15px;
                        color: #fff;
                        margin-bottom: 25px;
                    }

                    .section-card {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                        overflow: hidden;
                    }

                    .section-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                        padding: 15px 20px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .section-body {
                        padding: 20px;
                    }

                    .trip-select-card {
                        border: 2px solid #e3e6f0;
                        border-radius: 12px;
                        padding: 20px;
                        cursor: pointer;
                        transition: all 0.3s;
                        margin-bottom: 15px;
                    }

                    .trip-select-card:hover {
                        border-color: #667eea;
                        transform: translateY(-2px);
                    }

                    .trip-select-card.selected {
                        border-color: #28a745;
                        background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                    }

                    .trip-icon {
                        width: 60px;
                        height: 60px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 24px;
                    }

                    .trip-code {
                        font-size: 18px;
                        font-weight: 700;
                        color: #5a5c69;
                    }

                    .trip-meta {
                        font-size: 13px;
                        color: #858796;
                    }

                    .container-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                        gap: 15px;
                        max-height: 400px;
                        overflow-y: auto;
                        padding: 5px;
                    }

                    .container-item {
                        border: 2px solid #e3e6f0;
                        border-radius: 12px;
                        padding: 15px;
                        cursor: pointer;
                        transition: all 0.3s;
                        position: relative;
                    }

                    .container-item:hover {
                        border-color: #667eea;
                        transform: scale(1.02);
                    }

                    .container-item.selected {
                        border-color: #28a745;
                        background: #e8f5e9;
                    }

                    .container-item.loaded {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }

                    .container-checkbox {
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        width: 22px;
                        height: 22px;
                    }

                    .container-icon {
                        width: 45px;
                        height: 45px;
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 18px;
                        margin-bottom: 10px;
                    }

                    .container-code {
                        font-weight: 700;
                        color: #5a5c69;
                        font-size: 14px;
                    }

                    .container-meta {
                        font-size: 12px;
                        color: #858796;
                    }

                    .container-status {
                        padding: 3px 8px;
                        border-radius: 12px;
                        font-size: 10px;
                        font-weight: 600;
                    }

                    .status-closed {
                        background: #cce5ff;
                        color: #004085;
                    }

                    .status-loaded {
                        background: #d4edda;
                        color: #155724;
                    }

                    .summary-box {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 15px;
                        padding: 25px;
                        color: #fff;
                        position: sticky;
                        top: 20px;
                    }

                    .summary-title {
                        font-size: 18px;
                        font-weight: 700;
                        margin-bottom: 20px;
                        padding-bottom: 15px;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .summary-item {
                        display: flex;
                        justify-content: space-between;
                        padding: 12px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .summary-item:last-child {
                        border-bottom: none;
                    }

                    .summary-label {
                        opacity: 0.8;
                    }

                    .summary-value {
                        font-weight: 600;
                        font-size: 16px;
                    }

                    .btn-gateout {
                        background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                        border: none;
                        padding: 18px 40px;
                        font-size: 18px;
                        font-weight: 700;
                        border-radius: 12px;
                        color: #fff;
                        cursor: pointer;
                        transition: all 0.3s;
                        width: 100%;
                        margin-top: 20px;
                    }

                    .btn-gateout:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 8px 25px rgba(255, 65, 108, 0.4);
                        color: #fff;
                    }

                    .btn-gateout:disabled {
                        opacity: 0.6;
                        cursor: not-allowed;
                        transform: none;
                    }

                    .success-modal .modal-content {
                        border: none;
                        border-radius: 15px;
                        overflow: hidden;
                    }

                    .success-modal .modal-header {
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        color: #fff;
                        padding: 25px;
                    }

                    .success-animation {
                        text-align: center;
                        padding: 30px;
                    }

                    .success-icon {
                        width: 100px;
                        height: 100px;
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 20px;
                        animation: pulse 1.5s infinite;
                    }

                    @keyframes pulse {
                        0% {
                            transform: scale(1);
                        }

                        50% {
                            transform: scale(1.1);
                        }

                        100% {
                            transform: scale(1);
                        }
                    }

                    .result-list {
                        max-height: 300px;
                        overflow-y: auto;
                    }

                    .result-item {
                        display: flex;
                        align-items: center;
                        padding: 12px 15px;
                        background: #f8f9fc;
                        border-radius: 10px;
                        margin-bottom: 10px;
                    }

                    .result-item i {
                        font-size: 20px;
                        margin-right: 15px;
                    }

                    .no-trip-alert {
                        background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
                        border: 1px solid #feb2b2;
                        border-radius: 10px;
                        padding: 20px;
                        text-align: center;
                    }

                    .select-all-row {
                        background: #f8f9fc;
                        padding: 15px;
                        border-radius: 10px;
                        margin-bottom: 15px;
                    }
                </style>
            </head>

            <body id="page-top">
                <div id="wrapper">
                    <div id="content-wrapper" class="d-flex flex-column">
                        <div id="content">
                            <div class="container-fluid py-4">

                                <!-- Header -->
                                <div class="gateout-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h4 class="mb-1"><i class="fas fa-truck-loading"></i> Xuất Bến (Gate Out)
                                            </h4>
                                            <p class="mb-0 opacity-75">Nạp container lên xe và xuất bến vận chuyển</p>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/manager/outbound/consolidate"
                                                class="btn btn-light mr-2">
                                                <i class="fas fa-box"></i> Đóng Bao
                                            </a>
                                            <a href="${pageContext.request.contextPath}/manager/outbound/trip-planning"
                                                class="btn btn-light">
                                                <i class="fas fa-route"></i> Tạo Chuyến
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Left: Trip & Container Selection -->
                                    <div class="col-lg-8">
                                        <!-- Step 1: Chọn chuyến xe -->
                                        <div class="section-card">
                                            <div class="section-header">
                                                <div>
                                                    <i class="fas fa-truck mr-2"></i> Bước 1: Chọn chuyến xe đang chuẩn
                                                    bị
                                                </div>
                                                <span class="badge badge-light"><span
                                                        id="tripCount">${trips.size()}</span> chuyến</span>
                                            </div>
                                            <div class="section-body">
                                                <c:choose>
                                                    <c:when test="${not empty trips}">
                                                        <div class="row" id="tripList">
                                                            <c:forEach var="trip" items="${trips}">
                                                                <c:if test="${trip.status == 'loading'}">
                                                                    <div class="col-md-6">
                                                                        <div class="trip-select-card"
                                                                            data-id="${trip.tripId}"
                                                                            data-code="${trip.tripCode}"
                                                                            data-vehicle="${trip.vehicle.licensePlate}"
                                                                            data-driver="${trip.driver.fullName}"
                                                                            data-from="${trip.fromHub.hubId}"
                                                                            data-to="${trip.toHub.hubId}"
                                                                            data-to-name="${trip.toHub.hubName}"
                                                                            onclick="selectTrip(this)">
                                                                            <div class="d-flex align-items-center">
                                                                                <div class="trip-icon mr-3">
                                                                                    <i class="fas fa-truck"></i>
                                                                                </div>
                                                                                <div class="flex-grow-1">
                                                                                    <div class="trip-code">
                                                                                        ${trip.tripCode}</div>
                                                                                    <div class="trip-meta">
                                                                                        <i class="fas fa-car"></i>
                                                                                        ${trip.vehicle.licensePlate} |
                                                                                        <i class="fas fa-user"></i>
                                                                                        ${trip.driver.fullName}
                                                                                    </div>
                                                                                    <div class="trip-meta mt-1">
                                                                                        <i
                                                                                            class="fas fa-route text-primary"></i>
                                                                                        ${trip.fromHub.hubName} →
                                                                                        ${trip.toHub.hubName}
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-trip-alert">
                                                            <i
                                                                class="fas fa-exclamation-triangle fa-2x text-warning mb-3"></i>
                                                            <h5>Không có chuyến xe nào đang chuẩn bị</h5>
                                                            <p class="mb-0">Vui lòng tạo chuyến xe mới trước khi xuất
                                                                bến</p>
                                                            <a href="${pageContext.request.contextPath}/manager/outbound/trip-planning"
                                                                class="btn btn-primary mt-3">
                                                                <i class="fas fa-plus"></i> Tạo Chuyến Xe
                                                            </a>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Step 2: Chọn container -->
                                        <div class="section-card">
                                            <div class="section-header">
                                                <div>
                                                    <i class="fas fa-boxes mr-2"></i> Bước 2: Chọn container để nạp lên
                                                    xe
                                                </div>
                                                <span class="badge badge-light"><span id="containerCount">0</span>
                                                    container</span>
                                            </div>
                                            <div class="section-body">
                                                <div id="containerSection">
                                                    <div class="text-center text-muted py-5">
                                                        <i class="fas fa-hand-pointer fa-3x mb-3"></i>
                                                        <p>Chọn chuyến xe để xem danh sách container phù hợp</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right: Summary & Action -->
                                    <div class="col-lg-4">
                                        <div class="summary-box">
                                            <div class="summary-title">
                                                <i class="fas fa-clipboard-list"></i> Thông tin xuất bến
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Chuyến xe:</span>
                                                <span class="summary-value" id="summaryTrip">-</span>
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Xe:</span>
                                                <span class="summary-value" id="summaryVehicle">-</span>
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Tài xế:</span>
                                                <span class="summary-value" id="summaryDriver">-</span>
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Hub đích:</span>
                                                <span class="summary-value" id="summaryDestination">-</span>
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Số container:</span>
                                                <span class="summary-value">
                                                    <span id="summaryContainerCount">0</span> bao
                                                </span>
                                            </div>

                                            <div class="summary-item">
                                                <span class="summary-label">Tổng đơn hàng:</span>
                                                <span class="summary-value">
                                                    <span id="summaryOrderCount">0</span> đơn
                                                </span>
                                            </div>

                                            <button type="button" class="btn btn-gateout" id="btnGateOut"
                                                onclick="gateOut()" disabled>
                                                <i class="fas fa-truck-loading"></i> XUẤT BẾN
                                            </button>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- Success Modal -->
                <div class="modal fade success-modal" id="successModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-check-circle"></i> Xuất bến thành công!</h5>
                                <button type="button" class="close text-white" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="success-animation">
                                    <div class="success-icon">
                                        <i class="fas fa-truck fa-3x text-white"></i>
                                    </div>
                                    <h4 id="successTripCode">TRIP-20251230-0001</h4>
                                    <p class="text-muted">Chuyến xe đã xuất bến và đang trên đường đến Hub đích</p>
                                </div>

                                <h6><i class="fas fa-boxes"></i> Danh sách container đã nạp:</h6>
                                <div class="result-list" id="resultList">
                                    <!-- Results will be inserted here -->
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                <button type="button" class="btn btn-info" onclick="printManifest()">
                                    <i class="fas fa-print"></i> In Phiếu Giao Nhận
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

                <script>
                    var contextPath = '${pageContext.request.contextPath}';
                    var selectedTripId = null;
                    var selectedTripData = null;
                    var containersData = [];
                    var selectedContainers = [];

                    function selectTrip(el) {
                        document.querySelectorAll('.trip-select-card').forEach(function (card) {
                            card.classList.remove('selected');
                        });
                        el.classList.add('selected');

                        selectedTripId = parseInt(el.getAttribute('data-id'));
                        selectedTripData = {
                            tripId: selectedTripId,
                            tripCode: el.getAttribute('data-code'),
                            vehicle: el.getAttribute('data-vehicle'),
                            driver: el.getAttribute('data-driver'),
                            fromHubId: el.getAttribute('data-from'),
                            toHubId: el.getAttribute('data-to'),
                            toHubName: el.getAttribute('data-to-name')
                        };

                        // Update summary
                        document.getElementById('summaryTrip').textContent = selectedTripData.tripCode;
                        document.getElementById('summaryVehicle').textContent = selectedTripData.vehicle;
                        document.getElementById('summaryDriver').textContent = selectedTripData.driver;
                        document.getElementById('summaryDestination').textContent = selectedTripData.toHubName;

                        // Load containers for this trip's destination
                        loadContainers(selectedTripData.toHubId);
                    }

                    function loadContainers(toHubId) {
                        var section = document.getElementById('containerSection');
                        section.innerHTML = '<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i></div>';

                        // Fetch containers with status=closed and matching destination hub
                        fetch(contextPath + '/api/manager/outbound/containers?status=closed&toHubId=' + toHubId)
                            .then(function (response) { return response.json(); })
                            .then(function (data) {
                                if (data.success && data.data) {
                                    containersData = data.data;
                                    renderContainers(containersData);
                                } else {
                                    containersData = [];
                                    renderContainers([]);
                                }
                            })
                            .catch(function (err) {
                                console.error(err);
                                // Mock data for demo
                                containersData = [
                                    { containerId: 1, containerCode: 'CNT-20251230-0001', containerType: 'standard', totalWeight: 25.5, itemCount: 10 },
                                    { containerId: 2, containerCode: 'CNT-20251230-0002', containerType: 'fragile', totalWeight: 18.2, itemCount: 5 },
                                    { containerId: 3, containerCode: 'CNT-20251230-0003', containerType: 'express', totalWeight: 12.8, itemCount: 8 }
                                ];
                                renderContainers(containersData);
                            });
                    }

                    function renderContainers(containers) {
                        var section = document.getElementById('containerSection');

                        if (containers.length === 0) {
                            section.innerHTML = '<div class="text-center text-muted py-5">' +
                                '<i class="fas fa-box-open fa-3x mb-3"></i>' +
                                '<p>Không có container nào sẵn sàng cho Hub đích này</p>' +
                                '<a href="' + contextPath + '/manager/outbound/consolidate" class="btn btn-primary">' +
                                '<i class="fas fa-plus"></i> Đóng Bao Mới</a></div>';
                            document.getElementById('containerCount').textContent = '0';
                            return;
                        }

                        var html = '<div class="select-all-row">' +
                            '<div class="custom-control custom-checkbox">' +
                            '<input type="checkbox" class="custom-control-input" id="selectAllContainers" onchange="toggleSelectAll()">' +
                            '<label class="custom-control-label" for="selectAllContainers">' +
                            '<strong>Chọn tất cả container</strong> (' + containers.length + ' container sẵn sàng)' +
                            '</label></div></div>';

                        html += '<div class="container-grid">';
                        for (var i = 0; i < containers.length; i++) {
                            var c = containers[i];
                            var typeIcon = c.containerType === 'fragile' ? 'fa-wine-glass' :
                                c.containerType === 'frozen' ? 'fa-snowflake' :
                                    c.containerType === 'express' ? 'fa-bolt' : 'fa-box';
                            var isSelected = selectedContainers.indexOf(c.containerId) > -1;

                            html += '<div class="container-item ' + (isSelected ? 'selected' : '') + '" ' +
                                'data-id="' + c.containerId + '" ' +
                                'data-weight="' + (c.totalWeight || 0) + '" ' +
                                'data-count="' + (c.itemCount || 0) + '" ' +
                                'onclick="toggleContainer(' + c.containerId + ')">' +
                                '<input type="checkbox" class="container-checkbox" ' + (isSelected ? 'checked' : '') + '>' +
                                '<div class="container-icon"><i class="fas ' + typeIcon + '"></i></div>' +
                                '<div class="container-code">' + c.containerCode + '</div>' +
                                '<div class="container-meta">' +
                                '<i class="fas fa-weight"></i> ' + (c.totalWeight || 0) + ' kg | ' +
                                '<i class="fas fa-box"></i> ' + (c.itemCount || 0) + ' đơn' +
                                '</div>' +
                                '<span class="container-status status-closed mt-2 d-inline-block">' +
                                (c.containerType || 'standard').toUpperCase() + '</span>' +
                                '</div>';
                        }
                        html += '</div>';

                        section.innerHTML = html;
                        document.getElementById('containerCount').textContent = containers.length;
                    }

                    function toggleContainer(containerId) {
                        var idx = selectedContainers.indexOf(containerId);
                        if (idx > -1) {
                            selectedContainers.splice(idx, 1);
                        } else {
                            selectedContainers.push(containerId);
                        }
                        updateContainerUI();
                        updateSummary();
                    }

                    function toggleSelectAll() {
                        var selectAll = document.getElementById('selectAllContainers').checked;
                        selectedContainers = [];
                        if (selectAll) {
                            for (var i = 0; i < containersData.length; i++) {
                                selectedContainers.push(containersData[i].containerId);
                            }
                        }
                        updateContainerUI();
                        updateSummary();
                    }

                    function updateContainerUI() {
                        var items = document.querySelectorAll('.container-item');
                        items.forEach(function (item) {
                            var id = parseInt(item.getAttribute('data-id'));
                            var cb = item.querySelector('.container-checkbox');
                            if (selectedContainers.indexOf(id) > -1) {
                                item.classList.add('selected');
                                if (cb) cb.checked = true;
                            } else {
                                item.classList.remove('selected');
                                if (cb) cb.checked = false;
                            }
                        });
                    }

                    function updateSummary() {
                        var totalOrders = 0;
                        var items = document.querySelectorAll('.container-item');
                        items.forEach(function (item) {
                            var id = parseInt(item.getAttribute('data-id'));
                            if (selectedContainers.indexOf(id) > -1) {
                                totalOrders += parseInt(item.getAttribute('data-count') || 0);
                            }
                        });

                        document.getElementById('summaryContainerCount').textContent = selectedContainers.length;
                        document.getElementById('summaryOrderCount').textContent = totalOrders;
                        document.getElementById('btnGateOut').disabled = selectedContainers.length === 0 || !selectedTripId;
                    }

                    function gateOut() {
                        if (!selectedTripId || selectedContainers.length === 0) {
                            alert('Vui lòng chọn chuyến xe và ít nhất 1 container!');
                            return;
                        }

                        var btn = document.getElementById('btnGateOut');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                        var requestData = {
                            tripId: selectedTripId,
                            containerIds: selectedContainers
                        };

                        fetch(contextPath + '/api/manager/outbound/gate-out', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(requestData)
                        })
                            .then(function (response) { return response.json(); })
                            .then(function (data) {
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fas fa-truck-loading"></i> XUẤT BẾN';

                                if (data.success) {
                                    showSuccess(data.data);
                                } else {
                                    alert(data.message || 'Có lỗi xảy ra!');
                                }
                            })
                            .catch(function (err) {
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fas fa-truck-loading"></i> XUẤT BẾN';
                                console.error(err);
                                alert('Lỗi kết nối server!');
                            });
                    }

                    function showSuccess(data) {
                        document.getElementById('successTripCode').textContent = data.trip.tripCode;

                        var html = '';
                        for (var i = 0; i < data.containers.length; i++) {
                            var c = data.containers[i];
                            html += '<div class="result-item">' +
                                '<i class="fas fa-check-circle text-success"></i>' +
                                '<div>' +
                                '<strong>' + c.containerCode + '</strong>' +
                                '<div class="text-muted small">' + c.containerType + ' | ' + c.totalWeight + ' kg</div>' +
                                '</div></div>';
                        }

                        document.getElementById('resultList').innerHTML = html;
                        $('#successModal').modal('show');

                        // Refresh page after modal closed
                        $('#successModal').on('hidden.bs.modal', function () {
                            location.reload();
                        });
                    }

                    function printManifest() {
                        window.print();
                    }
                </script>

            </body>

            </html>