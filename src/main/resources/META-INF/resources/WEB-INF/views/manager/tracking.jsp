<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tra cứu Vận đơn - Manager Portal</title>

                <!-- Custom fonts for this template-->
                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet"
                    type="text/css">
                <link
                    href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
                    rel="stylesheet">

                <!-- Custom styles for this template-->
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.min.css"
                    rel="stylesheet">

                <style>
                    /* Search Section */
                    .search-section {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 40px 20px;
                        border-radius: 15px;
                        margin-bottom: 30px;
                        box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
                    }

                    .search-section h2 {
                        color: #fff;
                        font-weight: 700;
                        margin-bottom: 10px;
                    }

                    .search-section p {
                        color: rgba(255, 255, 255, 0.8);
                        margin-bottom: 25px;
                    }

                    .search-box {
                        max-width: 700px;
                        margin: 0 auto;
                    }

                    .search-input-group {
                        display: flex;
                        gap: 10px;
                    }

                    .search-input-group input {
                        flex: 1;
                        padding: 15px 20px;
                        font-size: 16px;
                        border: none;
                        border-radius: 10px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
                    }

                    .search-input-group button {
                        padding: 15px 30px;
                        font-size: 16px;
                        font-weight: 600;
                        border: none;
                        border-radius: 10px;
                        background: #fff;
                        color: #667eea;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .search-input-group button:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                    }

                    /* Results Section */
                    .results-section {
                        display: none;
                    }

                    .results-section.show {
                        display: block;
                    }

                    .result-count {
                        font-size: 14px;
                        color: #6c757d;
                        margin-bottom: 20px;
                    }

                    .result-count strong {
                        color: #667eea;
                    }

                    /* Order Card */
                    .order-card {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                        overflow: hidden;
                        transition: all 0.3s;
                        cursor: pointer;
                    }

                    .order-card:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                    }

                    .order-card-header {
                        padding: 20px;
                        background: linear-gradient(135deg, #f8f9fc 0%, #eaecf4 100%);
                        border-bottom: 1px solid #e3e6f0;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .order-id {
                        font-size: 18px;
                        font-weight: 700;
                        color: #5a5c69;
                    }

                    .order-id i {
                        color: #667eea;
                        margin-right: 8px;
                    }

                    .order-status {
                        padding: 6px 15px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .status-pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-picked {
                        background: #cce5ff;
                        color: #004085;
                    }

                    .status-in_transit {
                        background: #d4edda;
                        color: #155724;
                    }

                    .status-delivered {
                        background: #28a745;
                        color: #fff;
                    }

                    .status-cancelled {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .status-failed {
                        background: #dc3545;
                        color: #fff;
                    }

                    .order-card-body {
                        padding: 20px;
                    }

                    .order-info-row {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 20px;
                    }

                    .order-info-col {
                        flex: 1;
                        min-width: 200px;
                    }

                    .info-label {
                        font-size: 12px;
                        color: #858796;
                        text-transform: uppercase;
                        margin-bottom: 5px;
                    }

                    .info-value {
                        font-size: 14px;
                        color: #5a5c69;
                        font-weight: 500;
                    }

                    .info-value i {
                        color: #667eea;
                        margin-right: 5px;
                        width: 16px;
                    }

                    /* Order Detail Modal */
                    .order-detail-modal .modal-dialog {
                        max-width: 900px;
                    }

                    .order-detail-modal .modal-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                        border: none;
                    }

                    .order-detail-modal .modal-header .close {
                        color: #fff;
                        opacity: 1;
                    }

                    .detail-section {
                        background: #f8f9fc;
                        border-radius: 10px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }

                    .detail-section-title {
                        font-size: 16px;
                        font-weight: 700;
                        color: #5a5c69;
                        margin-bottom: 15px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #667eea;
                    }

                    .detail-section-title i {
                        color: #667eea;
                        margin-right: 8px;
                    }

                    .detail-row {
                        display: flex;
                        margin-bottom: 10px;
                    }

                    .detail-label {
                        width: 140px;
                        color: #858796;
                        font-size: 13px;
                    }

                    .detail-value {
                        flex: 1;
                        color: #5a5c69;
                        font-weight: 500;
                        font-size: 14px;
                    }

                    /* Timeline */
                    .timeline {
                        position: relative;
                        padding-left: 30px;
                    }

                    .timeline::before {
                        content: '';
                        position: absolute;
                        left: 10px;
                        top: 0;
                        bottom: 0;
                        width: 3px;
                        background: linear-gradient(to bottom, #667eea, #764ba2);
                        border-radius: 3px;
                    }

                    .timeline-item {
                        position: relative;
                        padding-bottom: 25px;
                    }

                    .timeline-item:last-child {
                        padding-bottom: 0;
                    }

                    .timeline-dot {
                        position: absolute;
                        left: -25px;
                        top: 3px;
                        width: 14px;
                        height: 14px;
                        border-radius: 50%;
                        background: #667eea;
                        border: 3px solid #fff;
                        box-shadow: 0 2px 10px rgba(102, 126, 234, 0.4);
                    }

                    .timeline-item:first-child .timeline-dot {
                        background: #28a745;
                        box-shadow: 0 2px 10px rgba(40, 167, 69, 0.4);
                    }

                    .timeline-content {
                        background: #fff;
                        border-radius: 10px;
                        padding: 15px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    }

                    .timeline-title {
                        font-weight: 600;
                        color: #5a5c69;
                        margin-bottom: 5px;
                    }

                    .timeline-title .badge {
                        font-size: 10px;
                        margin-left: 8px;
                    }

                    .timeline-time {
                        font-size: 12px;
                        color: #858796;
                        margin-bottom: 8px;
                    }

                    .timeline-time i {
                        margin-right: 5px;
                    }

                    .timeline-meta {
                        font-size: 13px;
                        color: #6c757d;
                    }

                    .timeline-meta span {
                        display: inline-block;
                        margin-right: 15px;
                    }

                    .timeline-meta i {
                        color: #667eea;
                        margin-right: 5px;
                    }

                    .timeline-note {
                        margin-top: 8px;
                        padding: 8px 12px;
                        background: #f8f9fc;
                        border-radius: 5px;
                        font-size: 13px;
                        color: #5a5c69;
                        font-style: italic;
                    }

                    /* Loading */
                    .loading-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(255, 255, 255, 0.9);
                        z-index: 9999;
                        justify-content: center;
                        align-items: center;
                    }

                    .loading-overlay.show {
                        display: flex;
                    }

                    .loading-spinner {
                        text-align: center;
                    }

                    .loading-spinner i {
                        font-size: 48px;
                        color: #667eea;
                        animation: spin 1s linear infinite;
                    }

                    @keyframes spin {
                        0% {
                            transform: rotate(0deg);
                        }

                        100% {
                            transform: rotate(360deg);
                        }
                    }

                    /* No Results */
                    .no-results {
                        text-align: center;
                        padding: 60px 20px;
                    }

                    .no-results i {
                        font-size: 64px;
                        color: #d1d3e2;
                        margin-bottom: 20px;
                    }

                    .no-results h4 {
                        color: #5a5c69;
                        margin-bottom: 10px;
                    }

                    .no-results p {
                        color: #858796;
                    }

                    /* Quick search tags */
                    .quick-search {
                        margin-top: 15px;
                    }

                    .quick-search span {
                        color: rgba(255, 255, 255, 0.7);
                        font-size: 13px;
                        margin-right: 10px;
                    }

                    .quick-search .badge {
                        cursor: pointer;
                        padding: 8px 15px;
                        font-size: 12px;
                        margin: 3px;
                        transition: all 0.3s;
                    }

                    .quick-search .badge:hover {
                        transform: scale(1.05);
                    }
                </style>
            </head>

            <body id="page-top">

                <!-- Page Wrapper -->
                <div id="wrapper">

                    <!-- Content Wrapper -->
                    <div id="content-wrapper" class="d-flex flex-column">

                        <!-- Main Content -->
                        <div id="content">

                            <!-- Begin Page Content -->
                            <div class="container-fluid py-4">

                                <!-- Search Section -->
                                <div class="search-section text-center">
                                    <h2><i class="fas fa-search"></i> Tra cứu Vận đơn</h2>
                                    <p>Nhập mã đơn hàng hoặc số điện thoại người gửi để tra cứu thông tin</p>

                                    <div class="search-box">
                                        <div class="search-input-group">
                                            <input type="text" id="searchKeyword"
                                                placeholder="Nhập mã đơn (VD: 1, 2, 3...) hoặc SĐT người gửi..."
                                                onkeypress="handleKeyPress(event)">
                                            <button type="button" onclick="searchOrder()">
                                                <i class="fas fa-search"></i> Tra cứu
                                            </button>
                                        </div>
                                        <div class="quick-search">
                                            <span>Gợi ý:</span>
                                            <span class="badge badge-light" onclick="quickSearch('0901')">0901...</span>
                                            <span class="badge badge-light" onclick="quickSearch('0912')">0912...</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Results Section -->
                                <div class="results-section" id="resultsSection">
                                    <div class="result-count" id="resultCount"></div>
                                    <div id="orderList"></div>
                                </div>

                            </div>
                            <!-- /.container-fluid -->

                        </div>
                        <!-- End of Main Content -->

                    </div>
                    <!-- End of Content Wrapper -->

                </div>
                <!-- End of Page Wrapper -->

                <!-- Order Detail Modal -->
                <div class="modal fade order-detail-modal" id="orderDetailModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-box"></i> Chi tiết Vận đơn #<span id="modalOrderId"></span>
                                </h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body" id="orderDetailContent">
                                <!-- Content loaded via JS -->
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                <button type="button" class="btn btn-primary" onclick="printOrder()">
                                    <i class="fas fa-print"></i> In vận đơn
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Loading Overlay -->
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="loading-spinner">
                        <i class="fas fa-circle-notch fa-spin"></i>
                        <p class="mt-3">Đang tìm kiếm...</p>
                    </div>
                </div>

                <!-- Bootstrap core JavaScript-->
                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

                <!-- Core plugin JavaScript-->
                <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

                <!-- Custom scripts for all pages-->
                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

                <script>
                    var contextPath = '${pageContext.request.contextPath}';

                    // Handle Enter key
                    function handleKeyPress(event) {
                        if (event.key === 'Enter') {
                            searchOrder();
                        }
                    }

                    // Quick search
                    function quickSearch(keyword) {
                        document.getElementById('searchKeyword').value = keyword;
                        searchOrder();
                    }

                    // Search orders
                    function searchOrder() {
                        var keyword = document.getElementById('searchKeyword').value.trim();

                        if (!keyword) {
                            alert('Vui lòng nhập mã đơn hàng hoặc số điện thoại người gửi!');
                            return;
                        }

                        showLoading(true);

                        fetch(contextPath + '/api/manager/tracking?keyword=' + encodeURIComponent(keyword), {
                            method: 'GET',
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        })
                            .then(function (response) {
                                return response.json();
                            })
                            .then(function (data) {
                                showLoading(false);

                                if (data.success) {
                                    displayResults(data.data, data.keyword);
                                } else {
                                    showError(data.message || 'Có lỗi xảy ra');
                                }
                            })
                            .catch(function (error) {
                                showLoading(false);
                                console.error('Error:', error);
                                showError('Lỗi kết nối server');
                            });
                    }

                    // Display search results
                    function displayResults(orders, keyword) {
                        var resultsSection = document.getElementById('resultsSection');
                        var resultCount = document.getElementById('resultCount');
                        var orderList = document.getElementById('orderList');

                        if (!orders || orders.length === 0) {
                            resultCount.innerHTML = '';
                            orderList.innerHTML = '<div class="no-results">' +
                                '<i class="fas fa-inbox"></i>' +
                                '<h4>Không tìm thấy kết quả</h4>' +
                                '<p>Không có đơn hàng nào khớp với từ khóa "<strong>' + keyword + '</strong>"</p>' +
                                '</div>';
                            resultsSection.classList.add('show');
                            return;
                        }

                        resultCount.innerHTML = 'Tìm thấy <strong>' + orders.length + '</strong> đơn hàng với từ khóa "<strong>' + keyword + '</strong>"';

                        var html = '';
                        for (var i = 0; i < orders.length; i++) {
                            var order = orders[i];
                            html += renderOrderCard(order);
                        }

                        orderList.innerHTML = html;
                        resultsSection.classList.add('show');
                    }

                    // Render order card
                    function renderOrderCard(order) {
                        var statusClass = 'status-' + (order.status || 'pending').toLowerCase();
                        var statusText = order.statusDisplay || order.status || 'N/A';

                        return '<div class="order-card" onclick="viewOrderDetail(' + order.requestId + ')">' +
                            '<div class="order-card-header">' +
                            '<div class="order-id">' +
                            '<i class="fas fa-box"></i> Mã đơn: #' + order.requestId +
                            '</div>' +
                            '<span class="order-status ' + statusClass + '">' + statusText + '</span>' +
                            '</div>' +
                            '<div class="order-card-body">' +
                            '<div class="order-info-row">' +
                            '<div class="order-info-col">' +
                            '<div class="info-label">Người gửi</div>' +
                            '<div class="info-value"><i class="fas fa-user"></i> ' + (order.senderName || 'N/A') + '</div>' +
                            '<div class="info-value"><i class="fas fa-phone"></i> ' + (order.senderPhone || 'N/A') + '</div>' +
                            '</div>' +
                            '<div class="order-info-col">' +
                            '<div class="info-label">Người nhận</div>' +
                            '<div class="info-value"><i class="fas fa-user"></i> ' + (order.receiverName || 'N/A') + '</div>' +
                            '<div class="info-value"><i class="fas fa-phone"></i> ' + (order.receiverPhone || 'N/A') + '</div>' +
                            '</div>' +
                            '<div class="order-info-col">' +
                            '<div class="info-label">Tiền COD</div>' +
                            '<div class="info-value"><i class="fas fa-money-bill-wave"></i> ' + formatCurrency(order.codAmount) + '</div>' +
                            '</div>' +
                            '<div class="order-info-col">' +
                            '<div class="info-label">Vị trí hiện tại</div>' +
                            '<div class="info-value"><i class="fas fa-warehouse"></i> ' + (order.currentHubName || 'Chưa xác định') + '</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    }

                    // View order detail
                    function viewOrderDetail(requestId) {
                        showLoading(true);

                        fetch(contextPath + '/api/manager/tracking/' + requestId, {
                            method: 'GET',
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        })
                            .then(function (response) {
                                return response.json();
                            })
                            .then(function (data) {
                                showLoading(false);

                                if (data.success) {
                                    displayOrderDetail(data.data);
                                } else {
                                    alert(data.message || 'Không thể lấy thông tin đơn hàng');
                                }
                            })
                            .catch(function (error) {
                                showLoading(false);
                                console.error('Error:', error);
                                alert('Lỗi kết nối server');
                            });
                    }

                    // Display order detail in modal
                    function displayOrderDetail(order) {
                        document.getElementById('modalOrderId').textContent = order.requestId;

                        var statusClass = 'status-' + (order.status || 'pending').toLowerCase();

                        var html = '';

                        // Order Status
                        html += '<div class="text-center mb-4">' +
                            '<span class="order-status ' + statusClass + '" style="font-size: 14px; padding: 10px 25px;">' +
                            (order.statusDisplay || order.status) +
                            '</span>' +
                            '</div>';

                        // Order Info
                        html += '<div class="row">';

                        // Left Column - Sender & Receiver
                        html += '<div class="col-md-6">';

                        // Sender Info
                        html += '<div class="detail-section">' +
                            '<div class="detail-section-title"><i class="fas fa-user-tag"></i> Thông tin Người gửi</div>' +
                            '<div class="detail-row"><div class="detail-label">Họ tên:</div><div class="detail-value">' + (order.senderName || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Điện thoại:</div><div class="detail-value">' + (order.senderPhone || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Địa chỉ:</div><div class="detail-value">' + (order.pickupAddress || 'N/A') + '</div></div>' +
                            '</div>';

                        // Receiver Info
                        html += '<div class="detail-section">' +
                            '<div class="detail-section-title"><i class="fas fa-user-check"></i> Thông tin Người nhận</div>' +
                            '<div class="detail-row"><div class="detail-label">Họ tên:</div><div class="detail-value">' + (order.receiverName || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Điện thoại:</div><div class="detail-value">' + (order.receiverPhone || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Địa chỉ:</div><div class="detail-value">' + (order.deliveryAddress || 'N/A') + '</div></div>' +
                            '</div>';

                        html += '</div>';

                        // Right Column - Package & Fee
                        html += '<div class="col-md-6">';

                        // Package Info
                        html += '<div class="detail-section">' +
                            '<div class="detail-section-title"><i class="fas fa-box-open"></i> Thông tin Hàng hóa</div>' +
                            '<div class="detail-row"><div class="detail-label">Tên hàng:</div><div class="detail-value">' + (order.itemName || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Trọng lượng:</div><div class="detail-value">' + (order.weight || 0) + ' kg</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Kích thước:</div><div class="detail-value">' + (order.dimensions || 'N/A') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Loại dịch vụ:</div><div class="detail-value">' + (order.serviceTypeName || 'N/A') + '</div></div>' +
                            '</div>';

                        // Fee Info
                        html += '<div class="detail-section">' +
                            '<div class="detail-section-title"><i class="fas fa-dollar-sign"></i> Thông tin Phí</div>' +
                            '<div class="detail-row"><div class="detail-label">Phí vận chuyển:</div><div class="detail-value">' + formatCurrency(order.shippingFee) + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Tiền COD:</div><div class="detail-value text-primary font-weight-bold">' + formatCurrency(order.codAmount) + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Tổng tiền:</div><div class="detail-value text-success font-weight-bold">' + formatCurrency(order.totalPrice) + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Thanh toán:</div><div class="detail-value">' + (order.paymentStatus || 'N/A') + '</div></div>' +
                            '</div>';

                        html += '</div>';
                        html += '</div>';

                        // Current Location
                        html += '<div class="detail-section">' +
                            '<div class="detail-section-title"><i class="fas fa-map-marker-alt"></i> Vị trí Hiện tại</div>' +
                            '<div class="detail-row"><div class="detail-label">Kho/Hub:</div><div class="detail-value">' + (order.currentHubName || 'Chưa xác định') + '</div></div>' +
                            '<div class="detail-row"><div class="detail-label">Địa chỉ Hub:</div><div class="detail-value">' + (order.currentHubAddress || 'N/A') + '</div></div>' +
                            '</div>';

                        // Timeline
                        if (order.actionHistory && order.actionHistory.length > 0) {
                            html += '<div class="detail-section">' +
                                '<div class="detail-section-title"><i class="fas fa-history"></i> Lịch sử Hành trình</div>' +
                                '<div class="timeline">';

                            for (var i = 0; i < order.actionHistory.length; i++) {
                                var action = order.actionHistory[i];
                                html += '<div class="timeline-item">' +
                                    '<div class="timeline-dot"></div>' +
                                    '<div class="timeline-content">' +
                                    '<div class="timeline-title">' +
                                    action.actionName +
                                    '<span class="badge badge-info">' + action.actionCode + '</span>' +
                                    '</div>' +
                                    '<div class="timeline-time">' +
                                    '<i class="fas fa-clock"></i> ' + formatDateTime(action.actionTime) +
                                    '</div>' +
                                    '<div class="timeline-meta">';

                                if (action.fromHubName) {
                                    html += '<span><i class="fas fa-warehouse"></i> Từ: ' + action.fromHubName + '</span>';
                                }
                                if (action.toHubName) {
                                    html += '<span><i class="fas fa-warehouse"></i> Đến: ' + action.toHubName + '</span>';
                                }
                                if (action.actorName) {
                                    html += '<span><i class="fas fa-user"></i> NV: ' + action.actorName + '</span>';
                                }

                                html += '</div>';

                                if (action.note) {
                                    html += '<div class="timeline-note"><i class="fas fa-sticky-note"></i> ' + action.note + '</div>';
                                }

                                html += '</div></div>';
                            }

                            html += '</div></div>';
                        } else {
                            html += '<div class="detail-section">' +
                                '<div class="detail-section-title"><i class="fas fa-history"></i> Lịch sử Hành trình</div>' +
                                '<p class="text-muted text-center py-4"><i class="fas fa-info-circle"></i> Chưa có lịch sử hành trình</p>' +
                                '</div>';
                        }

                        document.getElementById('orderDetailContent').innerHTML = html;
                        $('#orderDetailModal').modal('show');
                    }

                    // Format currency
                    function formatCurrency(amount) {
                        if (!amount && amount !== 0) return '0 ₫';
                        return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
                    }

                    // Format date time
                    function formatDateTime(dateTimeStr) {
                        if (!dateTimeStr) return 'N/A';
                        try {
                            var date = new Date(dateTimeStr);
                            var day = String(date.getDate()).padStart(2, '0');
                            var month = String(date.getMonth() + 1).padStart(2, '0');
                            var year = date.getFullYear();
                            var hours = String(date.getHours()).padStart(2, '0');
                            var minutes = String(date.getMinutes()).padStart(2, '0');
                            return day + '/' + month + '/' + year + ' ' + hours + ':' + minutes;
                        } catch (e) {
                            return dateTimeStr;
                        }
                    }

                    // Show/hide loading
                    function showLoading(show) {
                        var overlay = document.getElementById('loadingOverlay');
                        if (show) {
                            overlay.classList.add('show');
                        } else {
                            overlay.classList.remove('show');
                        }
                    }

                    // Show error
                    function showError(message) {
                        var orderList = document.getElementById('orderList');
                        orderList.innerHTML = '<div class="alert alert-danger">' +
                            '<i class="fas fa-exclamation-triangle"></i> ' + message +
                            '</div>';
                        document.getElementById('resultsSection').classList.add('show');
                    }

                    // Print order
                    function printOrder() {
                        window.print();
                    }

                    // Focus search input on page load
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('searchKeyword').focus();
                    });
                </script>

            </body>

            </html>