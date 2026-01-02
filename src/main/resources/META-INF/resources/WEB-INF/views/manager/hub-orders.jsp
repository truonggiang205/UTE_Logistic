<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Đơn hàng Hub - Manager Portal</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.min.css"
                    rel="stylesheet">

                <style>
                    .orders-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 25px;
                        border-radius: 15px;
                        color: #fff;
                        margin-bottom: 25px;
                    }

                    .status-badge {
                        padding: 5px 12px;
                        border-radius: 20px;
                        font-size: 0.8rem;
                        font-weight: 600;
                    }

                    .status-pending {
                        background: #ffc107;
                        color: #000;
                    }

                    .status-picked {
                        background: #17a2b8;
                        color: #fff;
                    }

                    .status-in_transit {
                        background: #6f42c1;
                        color: #fff;
                    }

                    .status-delivered {
                        background: #28a745;
                        color: #fff;
                    }

                    .status-cancelled {
                        background: #dc3545;
                        color: #fff;
                    }

                    .status-failed {
                        background: #6c757d;
                        color: #fff;
                    }

                    .payment-paid {
                        color: #28a745;
                        font-weight: bold;
                    }

                    .payment-unpaid {
                        color: #dc3545;
                        font-weight: bold;
                    }

                    .action-btn {
                        padding: 5px 10px;
                        margin: 2px;
                        border-radius: 5px;
                        font-size: 0.85rem;
                    }

                    .order-image {
                        width: 50px;
                        height: 50px;
                        object-fit: cover;
                        border-radius: 5px;
                        cursor: pointer;
                    }

                    .filter-card {
                        background: #fff;
                        border-radius: 10px;
                        padding: 20px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    /* Edit Modal Styles */
                    .edit-modal .modal-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                    }

                    .edit-modal .modal-header .close {
                        color: #fff;
                    }

                    /* Image Preview Modal */
                    .image-modal-backdrop {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.8);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s ease;
                    }

                    .image-modal-backdrop.show {
                        opacity: 1;
                        visibility: visible;
                    }

                    .image-modal-content {
                        max-width: 90%;
                        max-height: 90%;
                    }

                    .image-modal-content img {
                        max-width: 100%;
                        max-height: 80vh;
                        border-radius: 10px;
                    }

                    .image-modal-close {
                        position: absolute;
                        top: 20px;
                        right: 30px;
                        color: #fff;
                        font-size: 30px;
                        cursor: pointer;
                    }

                    /* Notification Modal Styles */
                    .notification-modal-backdrop {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.5);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s ease;
                    }

                    .notification-modal-backdrop.show {
                        opacity: 1;
                        visibility: visible;
                    }

                    .notification-modal {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                        max-width: 450px;
                        width: 90%;
                        transform: scale(0.8);
                        transition: all 0.3s ease;
                        overflow: hidden;
                    }

                    .notification-modal-backdrop.show .notification-modal {
                        transform: scale(1);
                    }

                    .notification-modal-header {
                        padding: 25px;
                        text-align: center;
                    }

                    .notification-modal-header.success {
                        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    }

                    .notification-modal-header.error {
                        background: linear-gradient(135deg, #dc3545 0%, #ff6b6b 100%);
                    }

                    .notification-modal-header.warning {
                        background: linear-gradient(135deg, #ffc107 0%, #ffb347 100%);
                    }

                    .notification-modal-header.info {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    }

                    .notification-modal-icon {
                        font-size: 48px;
                        color: #fff;
                        margin-bottom: 10px;
                    }

                    .notification-modal-title {
                        color: #fff;
                        font-size: 1.3rem;
                        font-weight: 600;
                        margin: 0;
                    }

                    .notification-modal-body {
                        padding: 25px;
                        text-align: center;
                    }

                    .notification-modal-message {
                        color: #333;
                        font-size: 1rem;
                        margin-bottom: 20px;
                    }

                    .notification-modal-footer {
                        padding: 0 25px 25px;
                        display: flex;
                        gap: 10px;
                        justify-content: center;
                    }

                    .notification-modal-btn {
                        padding: 12px 30px;
                        border: none;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .notification-modal-btn.primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                    }

                    .notification-modal-btn.secondary {
                        background: #e9ecef;
                        color: #495057;
                    }
                </style>
            </head>

            <body id="page-top">
                <div id="wrapper">
                    <div id="content-wrapper" class="d-flex flex-column">
                        <div id="content">
                            <div class="container-fluid py-4">

                                <!-- Header -->
                                <div class="orders-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h4 class="mb-1"><i class="fas fa-boxes"></i> Quản lý Đơn hàng tại Hub</h4>
                                            <p class="mb-0 opacity-75">Xem, chỉnh sửa và quản lý tất cả đơn hàng</p>
                                        </div>
                                        <div>
                                            <span class="badge badge-light p-2" id="currentHubInfo">
                                                <i class="fas fa-building"></i> Đang tải...
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Filter Card -->
                                <div class="filter-card">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><i class="fas fa-filter"></i> Lọc theo trạng thái</label>
                                                <select class="form-control" id="statusFilter" onchange="loadOrders()">
                                                    <option value="">-- Tất cả --</option>
                                                    <option value="pending">Chờ xử lý</option>
                                                    <option value="picked">Đã lấy hàng</option>
                                                    <option value="in_transit">Đang vận chuyển</option>
                                                    <option value="delivered">Đã giao</option>
                                                    <option value="cancelled">Đã hủy</option>
                                                    <option value="failed">Giao thất bại</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label><i class="fas fa-search"></i> Tìm kiếm</label>
                                                <input type="text" class="form-control" id="searchKeyword"
                                                    placeholder="Mã đơn hoặc SĐT..." onkeyup="debounceSearch()">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>&nbsp;</label>
                                                <button class="btn btn-primary btn-block" onclick="loadOrders()">
                                                    <i class="fas fa-sync"></i> Làm mới
                                                </button>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label>&nbsp;</label>
                                                <button class="btn btn-success btn-block" onclick="exportToExcel()">
                                                    <i class="fas fa-file-excel"></i> Xuất Excel
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Orders Table -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                        <h6 class="m-0 font-weight-bold text-primary">
                                            <i class="fas fa-list"></i> Danh sách đơn hàng
                                            <span class="badge badge-info ml-2" id="orderCount">0</span>
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover" id="ordersTable"
                                                width="100%">
                                                <thead class="thead-light">
                                                    <tr>
                                                        <th>Mã đơn</th>
                                                        <th>Ảnh</th>
                                                        <th>Người gửi</th>
                                                        <th>Người nhận</th>
                                                        <th>Trạng thái</th>
                                                        <th>Thanh toán</th>
                                                        <th>Tổng tiền</th>
                                                        <th>Ngày tạo</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="ordersTableBody">
                                                    <!-- Data loaded via AJAX -->
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Order Modal -->
                <div class="modal fade edit-modal" id="editOrderModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-edit"></i> Chỉnh sửa Đơn hàng</h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form id="editOrderForm">
                                    <input type="hidden" id="editRequestId">

                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-primary mb-3"><i class="fas fa-user"></i> Người gửi</h6>
                                            <div class="form-group">
                                                <label>Tên người gửi</label>
                                                <input type="text" class="form-control" id="editSenderName">
                                            </div>
                                            <div class="form-group">
                                                <label>SĐT người gửi</label>
                                                <input type="text" class="form-control" id="editSenderPhone">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-danger mb-3"><i class="fas fa-user-check"></i> Người nhận
                                            </h6>
                                            <div class="form-group">
                                                <label>Tên người nhận</label>
                                                <input type="text" class="form-control" id="editReceiverName">
                                            </div>
                                            <div class="form-group">
                                                <label>SĐT người nhận</label>
                                                <input type="text" class="form-control" id="editReceiverPhone">
                                            </div>
                                        </div>
                                    </div>

                                    <hr>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Trạng thái đơn hàng</label>
                                                <select class="form-control" id="editStatus">
                                                    <option value="pending">Chờ xử lý</option>
                                                    <option value="picked">Đã lấy hàng</option>
                                                    <option value="in_transit">Đang vận chuyển</option>
                                                    <option value="delivered">Đã giao</option>
                                                    <option value="cancelled">Đã hủy</option>
                                                    <option value="failed">Giao thất bại</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Trạng thái thanh toán</label>
                                                <select class="form-control" id="editPaymentStatus">
                                                    <option value="unpaid">Chưa thanh toán</option>
                                                    <option value="paid">Đã thanh toán</option>
                                                    <option value="refunded">Đã hoàn tiền</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Tên hàng hóa</label>
                                                <input type="text" class="form-control" id="editItemName">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Ghi chú</label>
                                                <input type="text" class="form-control" id="editNote">
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="saveOrderChanges()">
                                    <i class="fas fa-save"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Image Preview Modal -->
                <div class="image-modal-backdrop" id="imageModal" onclick="closeImageModal()">
                    <span class="image-modal-close">&times;</span>
                    <div class="image-modal-content">
                        <img id="imageModalImg" src="" alt="Ảnh hàng hóa">
                    </div>
                </div>

                <!-- Notification Modal -->
                <div class="notification-modal-backdrop" id="notificationModal">
                    <div class="notification-modal">
                        <div class="notification-modal-header" id="notificationHeader">
                            <div class="notification-modal-icon" id="notificationIcon"></div>
                            <h5 class="notification-modal-title" id="notificationTitle"></h5>
                        </div>
                        <div class="notification-modal-body">
                            <p class="notification-modal-message" id="notificationMessage"></p>
                        </div>
                        <div class="notification-modal-footer">
                            <button class="notification-modal-btn primary" onclick="closeNotification()">Đóng</button>
                        </div>
                    </div>
                </div>

                <!-- Confirm Modal -->
                <div class="notification-modal-backdrop" id="confirmModal">
                    <div class="notification-modal">
                        <div class="notification-modal-header info">
                            <div class="notification-modal-icon"><i class="fas fa-question-circle"></i></div>
                            <h5 class="notification-modal-title">Xác nhận</h5>
                        </div>
                        <div class="notification-modal-body">
                            <p class="notification-modal-message" id="confirmMessage"></p>
                        </div>
                        <div class="notification-modal-footer">
                            <button class="notification-modal-btn secondary" onclick="closeConfirm(false)">Hủy</button>
                            <button class="notification-modal-btn primary" onclick="closeConfirm(true)">Xác
                                nhận</button>
                        </div>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/datatables/jquery.dataTables.min.js"></script>
                <script
                    src="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.min.js"></script>
                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

                <script>
                    let currentHubId = null;
                    let ordersData = [];
                    let searchTimeout = null;

                    $(document).ready(function () {
                        loadManagerInfo();
                    });

                    // ============ NOTIFICATION MODAL FUNCTIONS ============
                    function showNotification(type, title, message, callback) {
                        const modal = $('#notificationModal');
                        const header = $('#notificationHeader');
                        const icon = $('#notificationIcon');

                        header.removeClass('success error warning info').addClass(type);

                        const icons = {
                            success: '<i class="fas fa-check-circle"></i>',
                            error: '<i class="fas fa-times-circle"></i>',
                            warning: '<i class="fas fa-exclamation-triangle"></i>',
                            info: '<i class="fas fa-info-circle"></i>'
                        };
                        icon.html(icons[type] || icons.info);

                        $('#notificationTitle').text(title);
                        $('#notificationMessage').html(message);
                        window.notificationCallback = callback;
                        modal.addClass('show');
                    }

                    function closeNotification() {
                        $('#notificationModal').removeClass('show');
                        if (window.notificationCallback) {
                            window.notificationCallback();
                            window.notificationCallback = null;
                        }
                    }

                    let confirmCallback = null;

                    function showConfirm(message, callback) {
                        $('#confirmMessage').html(message);
                        confirmCallback = callback;
                        $('#confirmModal').addClass('show');
                    }

                    function closeConfirm(result) {
                        $('#confirmModal').removeClass('show');
                        if (confirmCallback) {
                            confirmCallback(result);
                            confirmCallback = null;
                        }
                    }

                    // ============ IMAGE MODAL ============
                    function showImageModal(imagePath) {
                        const fullPath = '${pageContext.request.contextPath}/uploads/' + imagePath;
                        $('#imageModalImg').attr('src', fullPath);
                        $('#imageModal').addClass('show');
                    }

                    function closeImageModal() {
                        $('#imageModal').removeClass('show');
                    }

                    // ============ LOAD DATA ============
                    function loadManagerInfo() {
                        $.get('${pageContext.request.contextPath}/api/manager/dashboard/stats', function (response) {
                            if (response.success) {
                                currentHubId = response.hubId;
                                $('#currentHubInfo').html('<i class="fas fa-building"></i> Hub ID: ' + currentHubId);
                                loadOrders();
                            }
                        }).fail(function () {
                            showNotification('error', 'Lỗi', 'Không thể lấy thông tin Hub. Vui lòng đăng nhập lại.');
                        });
                    }

                    function debounceSearch() {
                        clearTimeout(searchTimeout);
                        searchTimeout = setTimeout(loadOrders, 500);
                    }

                    function loadOrders() {
                        if (!currentHubId) return;

                        const status = $('#statusFilter').val();
                        const keyword = $('#searchKeyword').val();

                        let url = '${pageContext.request.contextPath}/api/manager/hub-orders/' + currentHubId + '/orders';
                        const params = [];
                        if (status) params.push('status=' + status);
                        if (keyword) params.push('keyword=' + encodeURIComponent(keyword));
                        if (params.length > 0) url += '?' + params.join('&');

                        $.ajax({
                            url: url,
                            type: 'GET',
                            beforeSend: function () {
                                $('#ordersTableBody').html('<tr><td colspan="9" class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</td></tr>');
                            },
                            success: function (response) {
                                if (response.success) {
                                    ordersData = response.data;
                                    renderOrdersTable(ordersData);
                                    $('#orderCount').text(ordersData.length);
                                } else {
                                    showNotification('error', 'Lỗi', response.message);
                                }
                            },
                            error: function (xhr) {
                                const resp = xhr.responseJSON;
                                showNotification('error', 'Lỗi', resp ? resp.message : 'Không thể tải danh sách đơn hàng');
                            }
                        });
                    }

                    function renderOrdersTable(orders) {
                        if (orders.length === 0) {
                            $('#ordersTableBody').html('<tr><td colspan="9" class="text-center text-muted">Không có đơn hàng nào</td></tr>');
                            return;
                        }

                        let html = '';
                        orders.forEach(function (order) {
                            const statusClass = 'status-' + order.status;
                            const statusText = getStatusText(order.status);
                            const paymentClass = order.paymentStatus === 'paid' ? 'payment-paid' : 'payment-unpaid';
                            const paymentText = order.paymentStatus === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán';

                            let imageHtml = '<span class="text-muted">Không có</span>';
                            if (order.imageOrder) {
                                imageHtml = '<img src="${pageContext.request.contextPath}/uploads/' + order.imageOrder + '" ' +
                                    'class="order-image" onclick="showImageModal(\'' + order.imageOrder + '\')" alt="Ảnh">';
                            }

                            html += '<tr>';
                            html += '<td><strong>#' + order.requestId + '</strong></td>';
                            html += '<td>' + imageHtml + '</td>';
                            html += '<td>' + (order.senderName || 'N/A') + '<br><small class="text-muted">' + (order.senderPhone || '') + '</small></td>';
                            html += '<td>' + (order.receiverName || 'N/A') + '<br><small class="text-muted">' + (order.receiverPhone || '') + '</small></td>';
                            html += '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>';
                            html += '<td><span class="' + paymentClass + '">' + paymentText + '</span></td>';
                            html += '<td>' + formatCurrency(order.totalPrice) + '</td>';
                            html += '<td>' + formatDate(order.createdAt) + '</td>';
                            html += '<td>';
                            html += '<button class="btn btn-sm btn-info action-btn" onclick="editOrder(' + order.requestId + ')" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>';
                            html += '<button class="btn btn-sm btn-danger action-btn" onclick="deleteOrder(' + order.requestId + ')" title="Xóa"><i class="fas fa-trash"></i></button>';
                            html += '</td>';
                            html += '</tr>';
                        });

                        $('#ordersTableBody').html(html);
                    }

                    function getStatusText(status) {
                        const statusMap = {
                            'pending': 'Chờ xử lý',
                            'picked': 'Đã lấy hàng',
                            'in_transit': 'Đang vận chuyển',
                            'delivered': 'Đã giao',
                            'cancelled': 'Đã hủy',
                            'failed': 'Giao thất bại'
                        };
                        return statusMap[status] || status;
                    }

                    function formatCurrency(amount) {
                        if (!amount) return '0 ₫';
                        return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
                    }

                    function formatDate(dateStr) {
                        if (!dateStr) return 'N/A';
                        const date = new Date(dateStr);
                        return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
                    }

                    // ============ EDIT ORDER ============
                    function editOrder(requestId) {
                        const order = ordersData.find(o => o.requestId === requestId);
                        if (!order) {
                            showNotification('error', 'Lỗi', 'Không tìm thấy đơn hàng');
                            return;
                        }

                        $('#editRequestId').val(order.requestId);
                        $('#editSenderName').val(order.senderName || '');
                        $('#editSenderPhone').val(order.senderPhone || '');
                        $('#editReceiverName').val(order.receiverName || '');
                        $('#editReceiverPhone').val(order.receiverPhone || '');
                        $('#editStatus').val(order.status);
                        $('#editPaymentStatus').val(order.paymentStatus);
                        $('#editItemName').val(order.itemName || '');
                        $('#editNote').val(order.note || '');

                        $('#editOrderModal').modal('show');
                    }

                    function saveOrderChanges() {
                        const requestId = $('#editRequestId').val();
                        const updateData = {
                            status: $('#editStatus').val(),
                            paymentStatus: $('#editPaymentStatus').val(),
                            itemName: $('#editItemName').val(),
                            note: $('#editNote').val()
                        };

                        $.ajax({
                            url: '${pageContext.request.contextPath}/api/manager/hub-orders/' + requestId,
                            type: 'PUT',
                            contentType: 'application/json',
                            data: JSON.stringify(updateData),
                            success: function (response) {
                                if (response.success) {
                                    $('#editOrderModal').modal('hide');
                                    showNotification('success', 'Thành công', 'Đã cập nhật đơn hàng!');
                                    loadOrders();
                                } else {
                                    showNotification('error', 'Lỗi', response.message);
                                }
                            },
                            error: function (xhr) {
                                const resp = xhr.responseJSON;
                                showNotification('error', 'Lỗi', resp ? resp.message : 'Không thể cập nhật đơn hàng');
                            }
                        });
                    }

                    // ============ DELETE ORDER ============
                    function deleteOrder(requestId) {
                        showConfirm('Bạn có chắc muốn xóa đơn hàng <strong>#' + requestId + '</strong>?<br><br>' +
                            '<span class="text-danger">Lưu ý: Thao tác này sẽ xóa tất cả dữ liệu liên quan (tracking, lịch sử...)</span>',
                            function (confirmed) {
                                if (confirmed) {
                                    $.ajax({
                                        url: '${pageContext.request.contextPath}/api/manager/hub-orders/' + requestId,
                                        type: 'DELETE',
                                        success: function (response) {
                                            if (response.success) {
                                                showNotification('success', 'Thành công', 'Đã xóa đơn hàng!');
                                                loadOrders();
                                            } else {
                                                showNotification('error', 'Lỗi', response.message);
                                            }
                                        },
                                        error: function (xhr) {
                                            const resp = xhr.responseJSON;
                                            showNotification('error', 'Lỗi', resp ? resp.message : 'Không thể xóa đơn hàng');
                                        }
                                    });
                                }
                            }
                        );
                    }

                    // ============ EXPORT ============
                    function exportToExcel() {
                        showNotification('info', 'Thông báo', 'Tính năng xuất Excel đang được phát triển');
                    }
                </script>
            </body>

            </html>