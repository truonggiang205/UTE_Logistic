<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <head>
            <title>Quét Nhập Kho - Logistics Manager</title>
            <style>
                .scan-input-container {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border-radius: 15px;
                    padding: 30px;
                    color: white;
                    margin-bottom: 20px;
                }

                .scan-input-container .form-control {
                    font-size: 1.5rem;
                    padding: 15px 20px;
                    border-radius: 10px;
                    border: none;
                }

                .scan-result-item {
                    border-left: 4px solid #e3e6f0;
                    padding: 15px;
                    margin-bottom: 10px;
                    background: #f8f9fc;
                    border-radius: 0 8px 8px 0;
                    transition: all 0.3s ease;
                }

                .scan-result-item.success {
                    border-left-color: #1cc88a;
                    background: #e8f8f2;
                }

                .scan-result-item.failed {
                    border-left-color: #e74a3b;
                    background: #fdf2f2;
                }

                .pending-list {
                    max-height: 300px;
                    overflow-y: auto;
                }

                .pending-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 10px 15px;
                    border-bottom: 1px solid #e3e6f0;
                }

                .pending-item:hover {
                    background: #f8f9fc;
                }

                .stats-card {
                    text-align: center;
                    padding: 20px;
                }

                .stats-card .number {
                    font-size: 2.5rem;
                    font-weight: bold;
                }

                .trip-info-card {
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    color: white;
                    border-radius: 10px;
                    padding: 20px;
                }

                .barcode-icon {
                    font-size: 3rem;
                    opacity: 0.8;
                }
            </style>
        </head>

        <body>
            <div class="container-fluid">
                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">
                        <i class="fas fa-barcode"></i> Quét Nhập Kho
                    </h1>
                    <div>
                        <a href="${pageContext.request.contextPath}/manager/inbound/drop-off"
                            class="btn btn-info btn-sm shadow-sm">
                            <i class="fas fa-plus-circle"></i> Tạo đơn tại quầy
                        </a>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column - Scan Input -->
                    <div class="col-lg-8">
                        <!-- Scan Input Card -->
                        <div class="scan-input-container">
                            <div class="row align-items-center">
                                <div class="col-auto">
                                    <i class="fas fa-qrcode barcode-icon"></i>
                                </div>
                                <div class="col">
                                    <h4 class="mb-2">Quét mã đơn hàng</h4>
                                    <p class="mb-3 opacity-75">Nhập mã đơn hoặc quét barcode để nhập kho</p>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="scanInput"
                                            placeholder="Nhập mã đơn hàng và nhấn Enter..." autofocus
                                            autocomplete="off">
                                        <div class="input-group-append">
                                            <button class="btn btn-light" type="button" onclick="addToPendingList()">
                                                <i class="fas fa-plus"></i> Thêm
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Hub & Trip Selection -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-cog"></i> Cấu hình nhập kho
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="currentHubId"><i class="fas fa-warehouse"></i> Kho nhận hàng
                                                <span class="text-danger">*</span></label>
                                            <select class="form-control" id="currentHubId" required>
                                                <option value="">-- Chọn kho --</option>
                                                <c:forEach var="hub" items="${hubs}">
                                                    <option value="${hub.hubId}">${hub.hubId} - ${hub.hubName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="tripId"><i class="fas fa-truck"></i> Chuyến xe (nếu có)</label>
                                            <input type="text" class="form-control" id="tripId"
                                                placeholder="Nhập mã chuyến xe hoặc để trống">
                                            <small class="text-muted">Để trống nếu không nhập từ chuyến xe</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="scanNote"><i class="fas fa-sticky-note"></i> Ghi chú</label>
                                    <textarea class="form-control" id="scanNote" rows="2"
                                        placeholder="Ghi chú khi nhập kho (tuỳ chọn)"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Pending List -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-list"></i> Danh sách chờ quét (<span id="pendingCount">0</span>
                                    đơn)
                                </h6>
                                <div>
                                    <button class="btn btn-danger btn-sm" onclick="clearPendingList()">
                                        <i class="fas fa-trash"></i> Xoá tất cả
                                    </button>
                                    <button class="btn btn-success btn-sm ml-2" onclick="processScanIn()"
                                        id="btnProcessScan">
                                        <i class="fas fa-check-circle"></i> Xác nhận nhập kho
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="pending-list" id="pendingList">
                                    <div class="text-center text-muted py-4" id="emptyPendingMsg">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>Chưa có đơn hàng nào. Quét mã để thêm vào danh sách.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Scan Results -->
                        <div class="card shadow mb-4" id="resultsCard" style="display: none;">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-clipboard-check"></i> Kết quả quét nhập
                                </h6>
                            </div>
                            <div class="card-body" id="scanResults">
                                <!-- Results will be inserted here -->
                            </div>
                        </div>
                    </div>

                    <!-- Right Column - Stats & Trip Info -->
                    <div class="col-lg-4">
                        <!-- Quick Stats -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-chart-pie"></i> Thống kê phiên làm việc
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-6">
                                        <div class="stats-card border-right">
                                            <div class="number text-success" id="sessionSuccess">0</div>
                                            <div class="text-muted">Thành công</div>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="stats-card">
                                            <div class="number text-danger" id="sessionFailed">0</div>
                                            <div class="text-muted">Thất bại</div>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="text-center">
                                    <div class="h4 font-weight-bold text-primary" id="sessionTotal">0</div>
                                    <div class="text-muted">Tổng đã quét</div>
                                </div>
                            </div>
                        </div>

                        <!-- Trip Status Card -->
                        <div class="card shadow mb-4" id="tripStatusCard" style="display: none;">
                            <div class="card-body trip-info-card">
                                <h5 class="mb-3"><i class="fas fa-truck"></i> Thông tin chuyến xe</h5>
                                <div class="mb-2">
                                    <strong>Mã chuyến:</strong> <span id="tripCode">-</span>
                                </div>
                                <div class="mb-2">
                                    <strong>Trạng thái:</strong> <span id="tripStatus"
                                        class="badge badge-light">-</span>
                                </div>
                                <div class="mb-2">
                                    <strong>Container:</strong> <span id="tripContainers">0/0</span> đã dỡ
                                </div>
                                <div class="progress mt-3" style="height: 10px;">
                                    <div class="progress-bar bg-light" role="progressbar" id="tripProgress"
                                        style="width: 0%"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Scans -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-history"></i> Quét gần đây
                                </h6>
                            </div>
                            <div class="card-body" style="max-height: 300px; overflow-y: auto;">
                                <div id="recentScans">
                                    <p class="text-muted text-center">Chưa có lịch sử quét</p>
                                </div>
                            </div>
                        </div>

                        <!-- Keyboard Shortcuts -->
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-secondary">
                                    <i class="fas fa-keyboard"></i> Phím tắt
                                </h6>
                            </div>
                            <div class="card-body">
                                <small>
                                    <div class="mb-1"><kbd>Enter</kbd> - Thêm đơn vào danh sách</div>
                                    <div class="mb-1"><kbd>Ctrl</kbd> + <kbd>Enter</kbd> - Xác nhận nhập kho</div>
                                    <div class="mb-1"><kbd>Esc</kbd> - Xoá ô nhập</div>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Audio for scan feedback -->
            <audio id="successSound" src="${pageContext.request.contextPath}/static/sounds/beep-success.mp3"
                preload="auto"></audio>
            <audio id="errorSound" src="${pageContext.request.contextPath}/static/sounds/beep-error.mp3"
                preload="auto"></audio>

            <script>
                // ==================== STATE ====================
                var pendingRequestIds = [];
                var sessionStats = { success: 0, failed: 0, total: 0 };
                var recentScans = [];

                // ==================== INITIALIZATION ====================
                document.addEventListener('DOMContentLoaded', function () {
                    // Focus on scan input
                    document.getElementById('scanInput').focus();

                    // Keyboard shortcuts
                    document.addEventListener('keydown', function (e) {
                        // Ctrl + Enter to process
                        if (e.ctrlKey && e.key === 'Enter') {
                            processScanIn();
                        }
                        // Escape to clear input
                        if (e.key === 'Escape') {
                            document.getElementById('scanInput').value = '';
                            document.getElementById('scanInput').focus();
                        }
                    });

                    // Enter key on scan input
                    document.getElementById('scanInput').addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            addToPendingList();
                        }
                    });
                });

                // ==================== PENDING LIST FUNCTIONS ====================
                function addToPendingList() {
                    var input = document.getElementById('scanInput');
                    var value = input.value.trim();

                    if (!value) {
                        return;
                    }

                    // Check if numeric (request ID)
                    var requestId = parseInt(value);
                    if (isNaN(requestId)) {
                        showToast('Mã đơn hàng không hợp lệ', 'error');
                        return;
                    }

                    // Check duplicate
                    if (pendingRequestIds.indexOf(requestId) !== -1) {
                        showToast('Đơn hàng #' + requestId + ' đã có trong danh sách', 'warning');
                        input.value = '';
                        input.focus();
                        return;
                    }

                    // Add to list
                    pendingRequestIds.push(requestId);
                    renderPendingList();

                    // Clear input and refocus
                    input.value = '';
                    input.focus();

                    // Play success beep (optional)
                    // playSound('success');
                }

                function removeFromPending(requestId) {
                    var index = pendingRequestIds.indexOf(requestId);
                    if (index > -1) {
                        pendingRequestIds.splice(index, 1);
                        renderPendingList();
                    }
                }

                function clearPendingList() {
                    if (pendingRequestIds.length === 0) return;

                    if (confirm('Xác nhận xoá tất cả ' + pendingRequestIds.length + ' đơn trong danh sách?')) {
                        pendingRequestIds = [];
                        renderPendingList();
                    }
                }

                function renderPendingList() {
                    var container = document.getElementById('pendingList');
                    var countSpan = document.getElementById('pendingCount');
                    var emptyMsg = document.getElementById('emptyPendingMsg');

                    countSpan.textContent = pendingRequestIds.length;

                    if (pendingRequestIds.length === 0) {
                        container.innerHTML = '';
                        container.appendChild(emptyMsg.cloneNode(true));
                        return;
                    }

                    var html = '';
                    for (var i = 0; i < pendingRequestIds.length; i++) {
                        var id = pendingRequestIds[i];
                        html += '<div class="pending-item">' +
                            '<div>' +
                            '<i class="fas fa-box text-primary mr-2"></i>' +
                            '<strong>#' + id + '</strong>' +
                            '</div>' +
                            '<button class="btn btn-sm btn-outline-danger" onclick="removeFromPending(' + id + ')">' +
                            '<i class="fas fa-times"></i>' +
                            '</button>' +
                            '</div>';
                    }
                    container.innerHTML = html;
                }

                // ==================== SCAN PROCESSING ====================
                function processScanIn() {
                    // Validate
                    var hubId = document.getElementById('currentHubId').value;
                    if (!hubId) {
                        showToast('Vui lòng chọn kho nhận hàng', 'error');
                        return;
                    }

                    if (pendingRequestIds.length === 0) {
                        showToast('Chưa có đơn hàng nào để quét', 'warning');
                        return;
                    }

                    var tripIdInput = document.getElementById('tripId').value.trim();
                    var note = document.getElementById('scanNote').value.trim();

                    // Prepare request data
                    var requestData = {
                        requestIds: pendingRequestIds,
                        currentHubId: parseInt(hubId),
                        tripId: tripIdInput ? parseInt(tripIdInput) : null,
                        note: note || null
                    };

                    // Disable button
                    var btn = document.getElementById('btnProcessScan');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                    // Call API
                    fetch('${pageContext.request.contextPath}/api/manager/inbound/scan-in', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(requestData)
                    })
                        .then(function (response) {
                            return response.json();
                        })
                        .then(function (data) {
                            handleScanResult(data);
                        })
                        .catch(function (error) {
                            console.error('Error:', error);
                            showToast('Lỗi kết nối server', 'error');
                        })
                        .finally(function () {
                            btn.disabled = false;
                            btn.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận nhập kho';
                        });
                }

                function handleScanResult(data) {
                    // Update session stats
                    sessionStats.success += data.successCount;
                    sessionStats.failed += data.failedCount;
                    sessionStats.total += data.totalScanned;
                    updateSessionStats();

                    // Show results
                    renderScanResults(data);

                    // Update trip status if present
                    if (data.tripStatus) {
                        updateTripStatus(data.tripStatus);
                    }

                    // Add to recent scans
                    for (var i = 0; i < data.results.length; i++) {
                        var result = data.results[i];
                        recentScans.unshift(result);
                    }
                    renderRecentScans();

                    // Clear pending list
                    pendingRequestIds = [];
                    renderPendingList();

                    // Show toast
                    if (data.successCount > 0) {
                        showToast('Nhập kho thành công ' + data.successCount + '/' + data.totalScanned + ' đơn', 'success');
                    } else {
                        showToast('Không có đơn nào được nhập kho', 'error');
                    }

                    // Focus back to input
                    document.getElementById('scanInput').focus();
                }

                function renderScanResults(data) {
                    var container = document.getElementById('scanResults');
                    var card = document.getElementById('resultsCard');
                    card.style.display = 'block';

                    var html = '<div class="mb-3">' +
                        '<span class="badge badge-success mr-2">Thành công: ' + data.successCount + '</span>' +
                        '<span class="badge badge-danger">Thất bại: ' + data.failedCount + '</span>' +
                        '</div>';

                    for (var i = 0; i < data.results.length; i++) {
                        var result = data.results[i];
                        var statusClass = result.success ? 'success' : 'failed';
                        var icon = result.success ? 'check-circle text-success' : 'times-circle text-danger';

                        html += '<div class="scan-result-item ' + statusClass + '">' +
                            '<div class="d-flex justify-content-between align-items-center">' +
                            '<div>' +
                            '<i class="fas fa-' + icon + ' mr-2"></i>' +
                            '<strong>#' + result.requestId + '</strong>' +
                            '</div>' +
                            '<span class="badge badge-' + (result.success ? 'success' : 'danger') + '">' +
                            result.message + '</span>' +
                            '</div>';

                        if (result.success && result.previousStatus) {
                            html += '<small class="text-muted mt-1 d-block">' +
                                'Trạng thái: ' + result.previousStatus + ' → ' + result.newStatus +
                                '</small>';
                        }

                        html += '</div>';
                    }

                    container.innerHTML = html;
                }

                function updateTripStatus(tripStatus) {
                    var card = document.getElementById('tripStatusCard');
                    card.style.display = 'block';

                    document.getElementById('tripCode').textContent = tripStatus.tripCode;
                    document.getElementById('tripStatus').textContent = tripStatus.newStatus;
                    document.getElementById('tripContainers').textContent = tripStatus.unloadedContainers + '/' + tripStatus.totalContainers;

                    var progress = tripStatus.totalContainers > 0
                        ? (tripStatus.unloadedContainers / tripStatus.totalContainers * 100)
                        : 0;
                    document.getElementById('tripProgress').style.width = progress + '%';

                    if (tripStatus.isCompleted) {
                        document.getElementById('tripStatus').className = 'badge badge-success';
                    }
                }

                function updateSessionStats() {
                    document.getElementById('sessionSuccess').textContent = sessionStats.success;
                    document.getElementById('sessionFailed').textContent = sessionStats.failed;
                    document.getElementById('sessionTotal').textContent = sessionStats.total;
                }

                function renderRecentScans() {
                    var container = document.getElementById('recentScans');
                    var limit = 10; // Show only last 10
                    var scans = recentScans.slice(0, limit);

                    if (scans.length === 0) {
                        container.innerHTML = '<p class="text-muted text-center">Chưa có lịch sử quét</p>';
                        return;
                    }

                    var html = '';
                    for (var i = 0; i < scans.length; i++) {
                        var scan = scans[i];
                        var icon = scan.success ? 'check text-success' : 'times text-danger';
                        html += '<div class="d-flex justify-content-between align-items-center py-1 border-bottom">' +
                            '<span><i class="fas fa-' + icon + ' mr-2"></i>#' + scan.requestId + '</span>' +
                            '<small class="text-muted">' + (scan.success ? 'OK' : 'Lỗi') + '</small>' +
                            '</div>';
                    }
                    container.innerHTML = html;
                }

                // ==================== UTILITY FUNCTIONS ====================
                function showToast(message, type) {
                    // Simple toast using alert for now
                    // Can be replaced with a proper toast library
                    var bgColor = type === 'success' ? '#1cc88a' : (type === 'error' ? '#e74a3b' : '#f6c23e');

                    var toast = document.createElement('div');
                    toast.style.cssText = 'position:fixed;top:20px;right:20px;padding:15px 25px;background:' + bgColor +
                        ';color:white;border-radius:8px;z-index:9999;box-shadow:0 4px 15px rgba(0,0,0,0.2);';
                    toast.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : (type === 'error' ? 'times' : 'exclamation')) +
                        '-circle mr-2"></i>' + message;

                    document.body.appendChild(toast);

                    setTimeout(function () {
                        toast.remove();
                    }, 3000);
                }

                function playSound(type) {
                    try {
                        var sound = document.getElementById(type + 'Sound');
                        if (sound) {
                            sound.currentTime = 0;
                            sound.play();
                        }
                    } catch (e) {
                        console.log('Sound not available');
                    }
                }
            </script>
        </body>