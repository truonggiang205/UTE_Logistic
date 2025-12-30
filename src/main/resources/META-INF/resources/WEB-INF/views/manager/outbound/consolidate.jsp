<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đóng Bao - Manager Portal</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.min.css"
                    rel="stylesheet">

                <style>
                    .consolidate-header {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        padding: 25px;
                        border-radius: 15px;
                        color: #fff;
                        margin-bottom: 25px;
                    }

                    .step-card {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                        overflow: hidden;
                    }

                    .step-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                        padding: 15px 20px;
                        display: flex;
                        align-items: center;
                    }

                    .step-number {
                        width: 35px;
                        height: 35px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        margin-right: 15px;
                    }

                    .step-body {
                        padding: 20px;
                    }

                    .order-list {
                        max-height: 400px;
                        overflow-y: auto;
                    }

                    .order-item {
                        display: flex;
                        align-items: center;
                        padding: 12px 15px;
                        border: 1px solid #e3e6f0;
                        border-radius: 8px;
                        margin-bottom: 10px;
                        transition: all 0.3s;
                    }

                    .order-item:hover {
                        border-color: #667eea;
                        background: #f8f9fc;
                    }

                    .order-item.selected {
                        border-color: #28a745;
                        background: #e8f5e9;
                    }

                    .order-checkbox {
                        margin-right: 15px;
                        width: 20px;
                        height: 20px;
                    }

                    .order-info {
                        flex: 1;
                    }

                    .order-id {
                        font-weight: 600;
                        color: #5a5c69;
                    }

                    .order-meta {
                        font-size: 12px;
                        color: #858796;
                    }

                    .order-status {
                        padding: 4px 10px;
                        border-radius: 15px;
                        font-size: 11px;
                        font-weight: 600;
                    }

                    .status-picked {
                        background: #cce5ff;
                        color: #004085;
                    }

                    .status-failed {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .search-box {
                        position: relative;
                        margin-bottom: 15px;
                    }

                    .search-box input {
                        padding-left: 40px;
                        border-radius: 25px;
                    }

                    .search-box i {
                        position: absolute;
                        left: 15px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #858796;
                    }

                    .container-preview {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 15px;
                        padding: 25px;
                        color: #fff;
                    }

                    .preview-item {
                        display: flex;
                        justify-content: space-between;
                        padding: 10px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .preview-item:last-child {
                        border-bottom: none;
                    }

                    .preview-label {
                        opacity: 0.8;
                    }

                    .preview-value {
                        font-weight: 600;
                    }

                    .btn-consolidate {
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

                    .btn-consolidate:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
                        color: #fff;
                    }

                    .btn-consolidate:disabled {
                        opacity: 0.6;
                        cursor: not-allowed;
                        transform: none;
                    }

                    .result-modal .modal-header {
                        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                        color: #fff;
                    }

                    .result-item {
                        display: flex;
                        align-items: center;
                        padding: 10px;
                        border-radius: 8px;
                        margin-bottom: 8px;
                    }

                    .result-item.success {
                        background: #d4edda;
                    }

                    .result-item.failed {
                        background: #f8d7da;
                    }

                    .select-all-box {
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
                                <div class="consolidate-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h4 class="mb-1"><i class="fas fa-box"></i> Đóng Bao (Consolidate)</h4>
                                            <p class="mb-0 opacity-75">Gom nhiều đơn hàng lẻ vào một container để vận
                                                chuyển</p>
                                        </div>
                                        <div class="text-right">
                                            <div class="h5 mb-0">
                                                <span id="selectedCount">0</span> đơn đã chọn
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Left: Chọn đơn hàng -->
                                    <div class="col-lg-8">
                                        <!-- Step 1: Chọn Hub -->
                                        <div class="step-card">
                                            <div class="step-header">
                                                <div class="step-number">1</div>
                                                <div>Chọn Hub xuất phát và Hub đích</div>
                                            </div>
                                            <div class="step-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label><i class="fas fa-warehouse text-primary"></i> Hub
                                                                hiện tại</label>
                                                            <select class="form-control" id="currentHubId"
                                                                onchange="loadOrders()">
                                                                <option value="">-- Chọn Hub --</option>
                                                                <c:forEach var="hub" items="${hubs}">
                                                                    <option value="${hub.hubId}">${hub.hubId} -
                                                                        ${hub.hubName}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label><i class="fas fa-map-marker-alt text-danger"></i> Hub
                                                                đích</label>
                                                            <select class="form-control" id="toHubId">
                                                                <option value="">-- Chọn Hub đích --</option>
                                                                <c:forEach var="hub" items="${hubs}">
                                                                    <option value="${hub.hubId}">${hub.hubId} -
                                                                        ${hub.hubName}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Step 2: Chọn đơn hàng -->
                                        <div class="step-card">
                                            <div class="step-header">
                                                <div class="step-number">2</div>
                                                <div>Chọn đơn hàng cần đóng bao</div>
                                            </div>
                                            <div class="step-body">
                                                <!-- Search -->
                                                <div class="search-box">
                                                    <i class="fas fa-search"></i>
                                                    <input type="text" class="form-control" id="searchOrder"
                                                        placeholder="Tìm theo mã đơn hoặc SĐT..."
                                                        onkeyup="filterOrders()">
                                                </div>

                                                <!-- Select All -->
                                                <div class="select-all-box">
                                                    <div class="custom-control custom-checkbox">
                                                        <input type="checkbox" class="custom-control-input"
                                                            id="selectAll" onchange="toggleSelectAll()">
                                                        <label class="custom-control-label" for="selectAll">
                                                            <strong>Chọn tất cả</strong> (<span
                                                                id="totalOrders">0</span> đơn hợp lệ)
                                                        </label>
                                                    </div>
                                                </div>

                                                <!-- Order List -->
                                                <div class="order-list" id="orderList">
                                                    <div class="text-center text-muted py-5">
                                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                                        <p>Chọn Hub để xem danh sách đơn hàng</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right: Preview & Submit -->
                                    <div class="col-lg-4">
                                        <!-- Step 3: Loại container -->
                                        <div class="step-card">
                                            <div class="step-header">
                                                <div class="step-number">3</div>
                                                <div>Loại Container</div>
                                            </div>
                                            <div class="step-body">
                                                <div class="form-group mb-0">
                                                    <select class="form-control" id="containerType">
                                                        <option value="standard">Standard - Hàng thường</option>
                                                        <option value="fragile">Fragile - Hàng dễ vỡ</option>
                                                        <option value="frozen">Frozen - Hàng đông lạnh</option>
                                                        <option value="express">Express - Hàng nhanh</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Preview -->
                                        <div class="step-card">
                                            <div class="step-header">
                                                <div class="step-number">4</div>
                                                <div>Xem trước Container</div>
                                            </div>
                                            <div class="step-body p-0">
                                                <div class="container-preview">
                                                    <div class="preview-item">
                                                        <span class="preview-label">Số đơn hàng:</span>
                                                        <span class="preview-value" id="previewOrderCount">0</span>
                                                    </div>
                                                    <div class="preview-item">
                                                        <span class="preview-label">Tổng trọng lượng:</span>
                                                        <span class="preview-value"><span id="previewWeight">0</span>
                                                            kg</span>
                                                    </div>
                                                    <div class="preview-item">
                                                        <span class="preview-label">Hub xuất phát:</span>
                                                        <span class="preview-value" id="previewFromHub">-</span>
                                                    </div>
                                                    <div class="preview-item">
                                                        <span class="preview-label">Hub đích:</span>
                                                        <span class="preview-value" id="previewToHub">-</span>
                                                    </div>
                                                    <div class="preview-item">
                                                        <span class="preview-label">Loại container:</span>
                                                        <span class="preview-value" id="previewType">Standard</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Submit Button -->
                                        <button type="button" class="btn btn-consolidate btn-block" id="btnConsolidate"
                                            onclick="consolidate()" disabled>
                                            <i class="fas fa-box"></i> Đóng Bao
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- Result Modal -->
                <div class="modal fade result-modal" id="resultModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-check-circle"></i> Kết quả Đóng Bao</h5>
                                <button type="button" class="close text-white" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body" id="resultContent">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                <button type="button" class="btn btn-primary" onclick="printLabel()">
                                    <i class="fas fa-print"></i> In nhãn Container
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
                    var ordersData = [];
                    var selectedOrders = [];

                    // Load orders when hub is selected
                    function loadOrders() {
                        var hubId = document.getElementById('currentHubId').value;
                        if (!hubId) {
                            document.getElementById('orderList').innerHTML =
                                '<div class="text-center text-muted py-5">' +
                                '<i class="fas fa-inbox fa-3x mb-3"></i>' +
                                '<p>Chọn Hub để xem danh sách đơn hàng</p></div>';
                            return;
                        }

                        document.getElementById('orderList').innerHTML =
                            '<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x"></i></div>';

                        // Fetch orders with status picked or failed at this hub
                        fetch(contextPath + '/api/manager/tracking?keyword=' + hubId)
                            .then(function (response) { return response.json(); })
                            .then(function (data) {
                                if (data.success && data.data) {
                                    // Filter only picked or failed
                                    ordersData = data.data.filter(function (o) {
                                        return o.status === 'picked' || o.status === 'failed';
                                    });
                                    renderOrders(ordersData);
                                } else {
                                    ordersData = [];
                                    renderOrders([]);
                                }
                            })
                            .catch(function (err) {
                                console.error(err);
                                // Mock data for demo
                                ordersData = [
                                    { requestId: 1, status: 'picked', senderName: 'Nguyễn Văn A', senderPhone: '0901234567', weight: 2.5 },
                                    { requestId: 2, status: 'picked', senderName: 'Trần Văn B', senderPhone: '0912345678', weight: 1.8 },
                                    { requestId: 3, status: 'failed', senderName: 'Lê Thị C', senderPhone: '0923456789', weight: 3.2 }
                                ];
                                renderOrders(ordersData);
                            });

                        updatePreview();
                    }

                    function renderOrders(orders) {
                        var html = '';
                        if (orders.length === 0) {
                            html = '<div class="text-center text-muted py-5">' +
                                '<i class="fas fa-box-open fa-3x mb-3"></i>' +
                                '<p>Không có đơn hàng hợp lệ (picked/failed)</p></div>';
                        } else {
                            for (var i = 0; i < orders.length; i++) {
                                var o = orders[i];
                                var statusClass = o.status === 'picked' ? 'status-picked' : 'status-failed';
                                var statusText = o.status === 'picked' ? 'Đã lấy' : 'Hoàn hàng';
                                var isSelected = selectedOrders.indexOf(o.requestId) > -1;

                                html += '<div class="order-item ' + (isSelected ? 'selected' : '') + '" data-id="' + o.requestId + '">' +
                                    '<input type="checkbox" class="order-checkbox" ' + (isSelected ? 'checked' : '') +
                                    ' onchange="toggleOrder(' + o.requestId + ', ' + (o.weight || 0) + ')">' +
                                    '<div class="order-info">' +
                                    '<div class="order-id">#' + o.requestId + '</div>' +
                                    '<div class="order-meta">' +
                                    '<i class="fas fa-user"></i> ' + (o.senderName || 'N/A') + ' | ' +
                                    '<i class="fas fa-phone"></i> ' + (o.senderPhone || 'N/A') + ' | ' +
                                    '<i class="fas fa-weight"></i> ' + (o.weight || 0) + ' kg' +
                                    '</div></div>' +
                                    '<span class="order-status ' + statusClass + '">' + statusText + '</span>' +
                                    '</div>';
                            }
                        }
                        document.getElementById('orderList').innerHTML = html;
                        document.getElementById('totalOrders').textContent = orders.length;
                    }

                    function toggleOrder(requestId, weight) {
                        var idx = selectedOrders.indexOf(requestId);
                        if (idx > -1) {
                            selectedOrders.splice(idx, 1);
                        } else {
                            selectedOrders.push(requestId);
                        }
                        updateSelectedUI();
                        updatePreview();
                    }

                    function toggleSelectAll() {
                        var selectAll = document.getElementById('selectAll').checked;
                        selectedOrders = [];
                        if (selectAll) {
                            for (var i = 0; i < ordersData.length; i++) {
                                selectedOrders.push(ordersData[i].requestId);
                            }
                        }
                        renderOrders(ordersData);
                        updateSelectedUI();
                        updatePreview();
                    }

                    function updateSelectedUI() {
                        document.getElementById('selectedCount').textContent = selectedOrders.length;
                        document.getElementById('btnConsolidate').disabled = selectedOrders.length === 0 ||
                            !document.getElementById('toHubId').value;

                        var items = document.querySelectorAll('.order-item');
                        for (var i = 0; i < items.length; i++) {
                            var id = parseInt(items[i].getAttribute('data-id'));
                            var cb = items[i].querySelector('.order-checkbox');
                            if (selectedOrders.indexOf(id) > -1) {
                                items[i].classList.add('selected');
                                if (cb) cb.checked = true;
                            } else {
                                items[i].classList.remove('selected');
                                if (cb) cb.checked = false;
                            }
                        }
                    }

                    function updatePreview() {
                        var currentHub = document.getElementById('currentHubId');
                        var toHub = document.getElementById('toHubId');
                        var containerType = document.getElementById('containerType');

                        document.getElementById('previewOrderCount').textContent = selectedOrders.length;
                        document.getElementById('previewFromHub').textContent =
                            currentHub.options[currentHub.selectedIndex] ?
                                currentHub.options[currentHub.selectedIndex].text : '-';
                        document.getElementById('previewToHub').textContent =
                            toHub.options[toHub.selectedIndex] ?
                                toHub.options[toHub.selectedIndex].text : '-';
                        document.getElementById('previewType').textContent =
                            containerType.options[containerType.selectedIndex].text;

                        // Calculate weight
                        var totalWeight = 0;
                        for (var i = 0; i < ordersData.length; i++) {
                            if (selectedOrders.indexOf(ordersData[i].requestId) > -1) {
                                totalWeight += parseFloat(ordersData[i].weight || 0);
                            }
                        }
                        document.getElementById('previewWeight').textContent = totalWeight.toFixed(2);

                        document.getElementById('btnConsolidate').disabled = selectedOrders.length === 0 || !toHub.value;
                    }

                    function filterOrders() {
                        var keyword = document.getElementById('searchOrder').value.toLowerCase();
                        var filtered = ordersData.filter(function (o) {
                            return (o.requestId + '').indexOf(keyword) > -1 ||
                                (o.senderName || '').toLowerCase().indexOf(keyword) > -1 ||
                                (o.senderPhone || '').indexOf(keyword) > -1;
                        });
                        renderOrders(filtered);
                    }

                    function consolidate() {
                        var currentHubId = document.getElementById('currentHubId').value;
                        var toHubId = document.getElementById('toHubId').value;
                        var containerType = document.getElementById('containerType').value;

                        if (!currentHubId || !toHubId || selectedOrders.length === 0) {
                            alert('Vui lòng chọn đầy đủ thông tin!');
                            return;
                        }

                        var btn = document.getElementById('btnConsolidate');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                        var requestData = {
                            requestIds: selectedOrders,
                            currentHubId: parseInt(currentHubId),
                            toHubId: parseInt(toHubId),
                            containerType: containerType
                        };

                        fetch(contextPath + '/api/manager/outbound/consolidate', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(requestData)
                        })
                            .then(function (response) { return response.json(); })
                            .then(function (data) {
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fas fa-box"></i> Đóng Bao';

                                if (data.success) {
                                    showResult(data.data);
                                    // Reset
                                    selectedOrders = [];
                                    loadOrders();
                                } else {
                                    alert(data.message || 'Có lỗi xảy ra!');
                                }
                            })
                            .catch(function (err) {
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fas fa-box"></i> Đóng Bao';
                                console.error(err);
                                alert('Lỗi kết nối server!');
                            });
                    }

                    function showResult(data) {
                        var html = '<div class="alert alert-success">' +
                            '<h5><i class="fas fa-check-circle"></i> Đóng bao thành công!</h5>' +
                            '<p class="mb-0">Container: <strong>' + data.container.containerCode + '</strong></p>' +
                            '</div>';

                        html += '<div class="row mb-3">' +
                            '<div class="col-4 text-center"><div class="h4 text-success">' + data.successCount + '</div><small>Thành công</small></div>' +
                            '<div class="col-4 text-center"><div class="h4 text-danger">' + data.failedCount + '</div><small>Thất bại</small></div>' +
                            '<div class="col-4 text-center"><div class="h4 text-info">' + data.container.totalWeight + ' kg</div><small>Trọng lượng</small></div>' +
                            '</div>';

                        html += '<h6>Chi tiết kết quả:</h6>';
                        for (var i = 0; i < data.results.length; i++) {
                            var r = data.results[i];
                            var cls = r.success ? 'success' : 'failed';
                            var icon = r.success ? 'check-circle text-success' : 'times-circle text-danger';
                            html += '<div class="result-item ' + cls + '">' +
                                '<i class="fas fa-' + icon + ' mr-2"></i>' +
                                '<strong>#' + r.requestId + '</strong> - ' + r.message +
                                '</div>';
                        }

                        document.getElementById('resultContent').innerHTML = html;
                        $('#resultModal').modal('show');
                    }

                    function printLabel() {
                        window.print();
                    }

                    // Event listeners
                    document.getElementById('toHubId').addEventListener('change', updatePreview);
                    document.getElementById('containerType').addEventListener('change', updatePreview);
                </script>

            </body>

            </html>