<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đóng Bao - Consolidate</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .consolidate-header {
                    background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
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
                    font-weight: 600;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .panel-card-body {
                    padding: 20px;
                    max-height: 600px;
                    overflow-y: auto;
                }

                .order-item {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 12px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                    position: relative;
                }

                .order-item:hover {
                    border-color: #4e73df;
                    background: #f8f9fc;
                    transform: translateX(5px);
                }

                .order-item.selected {
                    border-color: #1cc88a;
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                }

                .order-item .priority-badge {
                    position: absolute;
                    top: -8px;
                    right: 10px;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-size: 0.7rem;
                    font-weight: bold;
                }

                .priority-HIGH {
                    background: #e74a3b;
                    color: #fff;
                }

                .priority-MEDIUM {
                    background: #f6c23e;
                    color: #000;
                }

                .priority-NORMAL {
                    background: #858796;
                    color: #fff;
                }

                .order-details {
                    font-size: 0.85rem;
                    margin-top: 8px;
                }

                .order-details .detail-row {
                    display: flex;
                    margin-bottom: 4px;
                }

                .order-details .detail-label {
                    color: #858796;
                    width: 80px;
                    flex-shrink: 0;
                }

                .order-details .detail-value {
                    color: #5a5c69;
                    flex: 1;
                }

                .container-item {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .container-item:hover {
                    border-color: #4e73df;
                    background: #f8f9fc;
                }

                .container-item.selected {
                    border-color: #1cc88a;
                    background: #e8f5e9;
                }

                .btn-consolidate {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    border: none;
                    padding: 12px 25px;
                    font-weight: 600;
                    border-radius: 8px;
                }

                .btn-consolidate:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(28, 200, 138, 0.4);
                }

                .hub-select-card {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    border-radius: 10px;
                    padding: 20px;
                    color: #fff;
                    margin-bottom: 20px;
                }

                .order-badge {
                    background: #e9ecef;
                    padding: 3px 10px;
                    border-radius: 15px;
                    font-size: 0.75rem;
                    margin-right: 5px;
                    display: inline-block;
                    margin-bottom: 3px;
                }

                .badge-cod {
                    background: #f6c23e;
                    color: #000;
                }

                .badge-fragile {
                    background: #e74a3b;
                    color: #fff;
                }

                .badge-express {
                    background: #4e73df;
                    color: #fff;
                }

                .badge-weight {
                    background: #1cc88a;
                    color: #fff;
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

                .time-in-warehouse {
                    font-size: 0.75rem;
                    color: #858796;
                }

                .time-in-warehouse.urgent {
                    color: #e74a3b;
                    font-weight: bold;
                }

                .filter-tabs {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 15px;
                    flex-wrap: wrap;
                }

                .filter-tab {
                    padding: 6px 15px;
                    border-radius: 20px;
                    border: 1px solid #d1d3e2;
                    background: #fff;
                    cursor: pointer;
                    font-size: 0.85rem;
                    transition: all 0.3s;
                }

                .filter-tab:hover,
                .filter-tab.active {
                    background: #4e73df;
                    color: #fff;
                    border-color: #4e73df;
                }

                .stats-bar {
                    display: flex;
                    gap: 15px;
                    margin-bottom: 15px;
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
            </style>
        </head>

        <body id="page-top">
            <div class="toast-container" id="toastContainer"></div>
            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <div class="consolidate-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-box mr-2"></i> Đóng Bao (Consolidate)</h3>
                                        <p class="mb-0 opacity-75">Tạo bao mới, thêm đơn hàng vào bao và niêm phong</p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="stats-bar justify-content-end">
                                            <div class="stat-item">
                                                <div class="stat-number" id="totalOrdersCount">0</div>
                                                <div class="stat-label">Đơn chờ</div>
                                            </div>
                                            <div class="stat-item">
                                                <div class="stat-number" id="totalContainersCount">0</div>
                                                <div class="stat-label">Bao hàng</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="hub-select-card">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <label class="font-weight-bold mb-2">Chọn Hub:</label>
                                        <select class="form-control" id="hubSelect">
                                            <option value="">-- Chọn Hub --</option>
                                            <c:forEach var="hub" items="${hubs}">
                                                <option value="${hub.hubId}">${hub.hubName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="font-weight-bold mb-2">Hub đích đến:</label>
                                        <select class="form-control" id="destHubSelect">
                                            <option value="">-- Chọn Hub đích --</option>
                                            <c:forEach var="hub" items="${hubs}">
                                                <option value="${hub.hubId}">${hub.hubName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <button class="btn btn-light mt-4" id="btnCreateContainer" disabled><i
                                                class="fas fa-plus mr-1"></i> Tạo bao mới</button>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-5">
                                    <div class="panel-card">
                                        <div class="panel-card-header bg-primary text-white"><span><i
                                                    class="fas fa-list mr-2"></i> Đơn hàng chờ đóng bao</span><span
                                                class="badge badge-light" id="ordersCountBadge">0</span></div>
                                        <div class="panel-card-body">
                                            <div class="search-box"><i class="fas fa-search"></i><input type="text"
                                                    class="form-control" id="orderSearchInput"
                                                    placeholder="Tìm theo mã vận đơn, tên, SĐT..."></div>
                                            <div class="filter-tabs">
                                                <span class="filter-tab active" data-filter="all">Tất cả</span>
                                                <span class="filter-tab" data-filter="HIGH">Ưu tiên cao</span>
                                                <span class="filter-tab" data-filter="cod">Có COD</span>
                                                <span class="filter-tab" data-filter="express">Express</span>
                                            </div>
                                            <div id="ordersList">
                                                <div class="text-center text-muted py-4"><i
                                                        class="fas fa-hand-pointer fa-3x mb-3" style="opacity:0.3"></i>
                                                    <p>Chọn Hub để xem đơn hàng</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="panel-card">
                                        <div class="panel-card-header bg-info text-white"><span><i
                                                    class="fas fa-box-open mr-2"></i> Bao hàng tại Hub</span><span
                                                class="badge badge-light" id="containersCountBadge">0</span></div>
                                        <div class="panel-card-body">
                                            <div class="search-box"><i class="fas fa-search"></i><input type="text"
                                                    class="form-control" id="containerSearchInput"
                                                    placeholder="Tìm theo mã bao..."></div>
                                            <div id="containersList">
                                                <div class="text-center text-muted py-4"><i
                                                        class="fas fa-hand-pointer fa-3x mb-3" style="opacity:0.3"></i>
                                                    <p>Chọn Hub để xem bao hàng</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="panel-card">
                                        <div class="panel-card-header bg-success text-white"><span><i
                                                    class="fas fa-info-circle mr-2"></i> Chi tiết bao hàng</span><button
                                                class="btn btn-sm btn-light" id="btnRefreshDetail"
                                                style="display:none;"><i class="fas fa-sync-alt"></i></button></div>
                                        <div class="panel-card-body" id="containerDetail">
                                            <div class="text-center text-muted py-4"><i class="fas fa-box fa-3x mb-3"
                                                    style="opacity:0.3"></i>
                                                <p>Chọn một bao để xem chi tiết</p>
                                            </div>
                                        </div>
                                        <div class="p-3 border-top" id="containerActions" style="display:none;">
                                            <button class="btn btn-consolidate btn-block mb-2" id="btnSealContainer"><i
                                                    class="fas fa-lock mr-1"></i> Niêm phong bao</button>
                                            <button class="btn btn-warning btn-block" id="btnReopenContainer"
                                                style="display:none;"><i class="fas fa-unlock mr-1"></i> Mở lại
                                                bao</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="createContainerModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-plus-circle mr-2"></i> Tạo bao mới</h5><button
                                type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group"><label>Mã bao:</label><input type="text" class="form-control"
                                    id="containerCode" placeholder="VD: BAG-001"></div>
                            <div class="form-group"><label>Loại bao:</label><select class="form-control"
                                    id="containerType">
                                    <option value="standard">Standard</option>
                                    <option value="fragile">Fragile (Dễ vỡ)</option>
                                    <option value="frozen">Frozen (Đông lạnh)</option>
                                    <option value="express">Express (Hỏa tốc)</option>
                                </select></div>
                        </div>
                        <div class="modal-footer"><button type="button" class="btn btn-secondary"
                                data-dismiss="modal">Hủy</button><button type="button" class="btn btn-primary"
                                id="btnConfirmCreateContainer"><i class="fas fa-check mr-1"></i> Tạo bao</button></div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="orderDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title"><i class="fas fa-file-alt mr-2"></i> Chi tiết đơn hàng</h5><button
                                type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body" id="orderDetailContent"></div>
                        <div class="modal-footer"><button type="button" class="btn btn-secondary"
                                data-dismiss="modal">Đóng</button></div>
                    </div>
                </div>
            </div>
            <!-- Modal Xác nhận Niêm phong bao -->
            <div class="modal fade" id="sealConfirmModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header"
                            style="background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); color: #fff;">
                            <h5 class="modal-title"><i class="fas fa-lock mr-2"></i> Xác nhận niêm phong bao</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body text-center py-4">
                            <i class="fas fa-box fa-4x text-success mb-3"></i>
                            <h5 class="font-weight-bold">Niêm phong bao hàng?</h5>
                            <p class="text-muted">Sau khi niêm phong, bạn sẽ <strong class="text-danger">không
                                    thể</strong> thêm hoặc xóa đơn hàng khỏi bao.</p>
                            <p class="text-info"><i class="fas fa-info-circle mr-1"></i> Bao sẽ sẵn sàng để xếp lên xe
                                vận chuyển.</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-secondary px-4" data-dismiss="modal"><i
                                    class="fas fa-times mr-1"></i> Hủy</button>
                            <button type="button" class="btn btn-success px-4" id="confirmSealBtn"><i
                                    class="fas fa-lock mr-1"></i> Niêm phong</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal Xác nhận Mở lại bao -->
            <div class="modal fade" id="reopenConfirmModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header"
                            style="background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%); color: #fff;">
                            <h5 class="modal-title"><i class="fas fa-unlock mr-2"></i> Xác nhận mở lại bao</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body text-center py-4">
                            <i class="fas fa-box-open fa-4x text-warning mb-3"></i>
                            <h5 class="font-weight-bold">Mở lại bao hàng?</h5>
                            <p class="text-muted">Sau khi mở lại, bạn có thể thêm hoặc bớt đơn hàng trong bao.</p>
                            <p class="text-warning"><i class="fas fa-exclamation-triangle mr-1"></i> Lưu ý: Chỉ có thể
                                mở lại bao chưa được xếp lên xe.</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-secondary px-4" data-dismiss="modal"><i
                                    class="fas fa-times mr-1"></i> Hủy</button>
                            <button type="button" class="btn btn-warning px-4" id="confirmReopenBtn"><i
                                    class="fas fa-unlock mr-1"></i> Mở lại</button>
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
                var selectedContainerId = null;
                var selectedHubId = null;
                var allOrders = [];
                var allContainers = [];
                var currentFilter = 'all';

                $(document).ready(function () {
                    $('#hubSelect').change(function () { selectedHubId = $(this).val(); if (selectedHubId) { loadOrders(selectedHubId); loadContainers(selectedHubId); updateCreateButton(); } });
                    $('#destHubSelect').change(function () { updateCreateButton(); });
                    $('#btnCreateContainer').click(function () { $('#containerCode').val('BAG-' + Date.now()); $('#createContainerModal').modal('show'); });
                    $('#btnConfirmCreateContainer').click(function () { createContainer(); });
                    $('#btnSealContainer').click(function () { sealContainer(); });
                    $('#btnReopenContainer').click(function () { reopenContainer(); });
                    $('#btnRefreshDetail').click(function () { if (selectedContainerId) loadContainerDetail(selectedContainerId); });
                    $('#orderSearchInput').on('input', function () { filterOrders(); });
                    $('#containerSearchInput').on('input', function () { filterContainers(); });
                    $('.filter-tab').click(function () { $('.filter-tab').removeClass('active'); $(this).addClass('active'); currentFilter = $(this).data('filter'); filterOrders(); });
                });

                function showToast(type, title, message) {
                    var icons = { 'success': 'fa-check-circle', 'error': 'fa-times-circle', 'warning': 'fa-exclamation-triangle', 'info': 'fa-info-circle' };
                    var toastHtml = '<div class="custom-toast ' + type + '"><div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div><div class="toast-content"><div class="toast-title">' + title + '</div><div class="toast-message">' + message + '</div></div><button class="toast-close" onclick="closeToast(this)">&times;</button></div>';
                    var $toast = $(toastHtml);
                    $('#toastContainer').append($toast);
                    setTimeout(function () { $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }, 4000);
                }
                function closeToast(btn) { var $toast = $(btn).closest('.custom-toast'); $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }
                function updateCreateButton() { var hubId = $('#hubSelect').val(); var destHubId = $('#destHubSelect').val(); $('#btnCreateContainer').prop('disabled', !hubId || !destHubId); }
                function formatCurrency(amount) { if (!amount) return '0 ₫'; return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫'; }
                function formatDateTime(dateStr) { if (!dateStr) return 'N/A'; var date = new Date(dateStr); return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }); }

                function loadOrders(hubId) {
                    $.get(contextPath + '/api/manager/outbound/pending-orders?hubId=' + hubId, function (response) {
                        if (response.success) { allOrders = response.data; $('#totalOrdersCount').text(allOrders.length); $('#ordersCountBadge').text(allOrders.length); filterOrders(); }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách đơn hàng'); });
                }
                function loadContainers(hubId) {
                    $.get(contextPath + '/api/manager/outbound/containers?hubId=' + hubId, function (response) {
                        if (response.success) { allContainers = response.data; $('#totalContainersCount').text(allContainers.length); $('#containersCountBadge').text(allContainers.length); filterContainers(); }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách bao hàng'); });
                }
                function filterOrders() {
                    var searchTerm = $('#orderSearchInput').val().toLowerCase();
                    var filtered = allOrders.filter(function (order) {
                        var matchSearch = true;
                        if (searchTerm) { matchSearch = (order.trackingCode && order.trackingCode.toLowerCase().includes(searchTerm)) || (order.senderName && order.senderName.toLowerCase().includes(searchTerm)) || (order.receiverName && order.receiverName.toLowerCase().includes(searchTerm)) || (order.senderPhone && order.senderPhone.includes(searchTerm)) || (order.receiverPhone && order.receiverPhone.includes(searchTerm)) || (order.requestId && order.requestId.toString().includes(searchTerm)); }
                        var matchFilter = true;
                        if (currentFilter === 'HIGH') { matchFilter = order.priorityLevel === 'HIGH'; }
                        else if (currentFilter === 'cod') { matchFilter = order.codAmount && order.codAmount > 0; }
                        else if (currentFilter === 'express') { matchFilter = order.serviceTypeName && order.serviceTypeName.toLowerCase().includes('express'); }
                        return matchSearch && matchFilter;
                    });
                    renderOrders(filtered);
                }
                function filterContainers() {
                    var searchTerm = $('#containerSearchInput').val().toLowerCase();
                    var filtered = allContainers.filter(function (c) { if (!searchTerm) return true; return c.containerCode && c.containerCode.toLowerCase().includes(searchTerm); });
                    renderContainers(filtered);
                }
                function renderOrders(orders) {
                    var panel = $('#ordersList'); panel.empty();
                    if (orders.length === 0) { panel.html('<div class="text-center text-muted py-4"><i class="fas fa-inbox fa-3x mb-3" style="opacity:0.3"></i><p>Không có đơn hàng nào</p></div>'); return; }
                    orders.forEach(function (order) {
                        var priorityClass = 'priority-' + (order.priorityLevel || 'NORMAL');
                        var badges = '';
                        if (order.codAmount && order.codAmount > 0) badges += '<span class="order-badge badge-cod">COD: ' + formatCurrency(order.codAmount) + '</span>';
                        if (order.serviceTypeName) { var badgeClass = order.serviceTypeName.toLowerCase().includes('express') ? 'badge-express' : ''; badges += '<span class="order-badge ' + badgeClass + '">' + order.serviceTypeName + '</span>'; }
                        if (order.weight) badges += '<span class="order-badge badge-weight">' + order.weight + ' kg</span>';
                        if (order.isFragile) badges += '<span class="order-badge badge-fragile"><i class="fas fa-glass-whiskey"></i> Dễ vỡ</span>';
                        var timeClass = order.hoursInWarehouse > 48 ? 'urgent' : '';
                        var timeText = order.hoursInWarehouse ? order.hoursInWarehouse + ' giờ tồn kho' : '';
                        var html = '<div class="order-item" data-order-id="' + order.requestId + '"><span class="priority-badge ' + priorityClass + '">' + (order.priorityLevel || 'NORMAL') + '</span>' +
                            '<div class="d-flex justify-content-between align-items-start"><div><strong class="text-primary">#' + order.requestId + '</strong>' + (order.trackingCode ? '<span class="ml-2 text-muted small">' + order.trackingCode + '</span>' : '') + '</div><button class="btn btn-sm btn-outline-info" onclick="showOrderDetail(event, ' + order.requestId + ')"><i class="fas fa-eye"></i></button></div>' +
                            '<div class="order-details"><div class="detail-row"><span class="detail-label"><i class="fas fa-user text-success"></i> Gửi:</span><span class="detail-value">' + (order.senderName || 'N/A') + ' - ' + (order.senderPhone || '') + '</span></div>' +
                            '<div class="detail-row"><span class="detail-label"></span><span class="detail-value small text-muted">' + (order.senderAddress || '') + ', ' + (order.senderProvince || '') + '</span></div>' +
                            '<div class="detail-row"><span class="detail-label"><i class="fas fa-map-marker-alt text-danger"></i> Nhận:</span><span class="detail-value">' + (order.receiverName || 'N/A') + ' - ' + (order.receiverPhone || '') + '</span></div>' +
                            '<div class="detail-row"><span class="detail-label"></span><span class="detail-value small text-muted">' + (order.receiverAddress || '') + ', ' + (order.receiverProvince || '') + '</span></div>' +
                            '<div class="detail-row"><span class="detail-label"><i class="fas fa-box text-info"></i> Hàng:</span><span class="detail-value">' + (order.itemName || 'N/A') + '</span></div></div>' +
                            '<div class="mt-2">' + badges + '</div><div class="time-in-warehouse ' + timeClass + '"><i class="fas fa-clock"></i> ' + timeText + '</div></div>';
                        panel.append(html);
                    });
                    panel.find('.order-item').click(function (e) { if (!$(e.target).closest('button').length) $(this).toggleClass('selected'); });
                }
                function renderContainers(containers) {
                    var panel = $('#containersList'); panel.empty();
                    if (containers.length === 0) { panel.html('<div class="text-center text-muted py-4"><i class="fas fa-box-open fa-3x mb-3" style="opacity:0.3"></i><p>Chưa có bao hàng nào</p></div>'); return; }
                    containers.forEach(function (c) {
                        var statusBadge = c.status === 'created' ? 'badge-warning' : (c.status === 'closed' ? 'badge-success' : 'badge-info');
                        var statusText = c.status === 'created' ? 'Đang mở' : (c.status === 'closed' ? 'Đã niêm phong' : c.status);
                        var html = '<div class="container-item" data-container-id="' + c.containerId + '"><div class="d-flex justify-content-between align-items-center"><strong>' + c.containerCode + '</strong><span class="badge ' + statusBadge + '">' + statusText + '</span></div><div class="mt-2"><small class="text-muted"><i class="fas fa-box mr-1"></i> ' + c.orderCount + ' đơn</small><small class="text-muted ml-3"><i class="fas fa-weight mr-1"></i> ' + (c.weight || 0) + ' kg</small></div><small class="text-muted d-block mt-1"><i class="fas fa-arrow-right mr-1"></i> ' + (c.destinationHubName || 'N/A') + '</small></div>';
                        panel.append(html);
                    });
                    panel.find('.container-item').click(function () { selectContainer($(this).data('container-id')); });
                }
                function showOrderDetail(event, orderId) {
                    event.stopPropagation();
                    var order = allOrders.find(function (o) { return o.requestId === orderId; });
                    if (!order) return;
                    var html = '<div class="row"><div class="col-md-6"><h6 class="font-weight-bold text-primary mb-3"><i class="fas fa-user-circle mr-2"></i>Thông tin người gửi</h6><table class="table table-sm"><tr><td class="text-muted">Họ tên:</td><td>' + (order.senderName || 'N/A') + '</td></tr><tr><td class="text-muted">SĐT:</td><td>' + (order.senderPhone || 'N/A') + '</td></tr><tr><td class="text-muted">Địa chỉ:</td><td>' + (order.senderAddress || '') + '</td></tr><tr><td class="text-muted">Phường/Xã:</td><td>' + (order.senderWard || 'N/A') + '</td></tr><tr><td class="text-muted">Quận/Huyện:</td><td>' + (order.senderDistrict || 'N/A') + '</td></tr><tr><td class="text-muted">Tỉnh/TP:</td><td>' + (order.senderProvince || 'N/A') + '</td></tr></table></div>' +
                        '<div class="col-md-6"><h6 class="font-weight-bold text-danger mb-3"><i class="fas fa-map-marker-alt mr-2"></i>Thông tin người nhận</h6><table class="table table-sm"><tr><td class="text-muted">Họ tên:</td><td>' + (order.receiverName || 'N/A') + '</td></tr><tr><td class="text-muted">SĐT:</td><td>' + (order.receiverPhone || 'N/A') + '</td></tr><tr><td class="text-muted">Địa chỉ:</td><td>' + (order.receiverAddress || '') + '</td></tr><tr><td class="text-muted">Phường/Xã:</td><td>' + (order.receiverWard || 'N/A') + '</td></tr><tr><td class="text-muted">Quận/Huyện:</td><td>' + (order.receiverDistrict || 'N/A') + '</td></tr><tr><td class="text-muted">Tỉnh/TP:</td><td>' + (order.receiverProvince || 'N/A') + '</td></tr></table></div></div><hr>' +
                        '<div class="row"><div class="col-md-6"><h6 class="font-weight-bold text-info mb-3"><i class="fas fa-box mr-2"></i>Thông tin hàng hóa</h6><table class="table table-sm"><tr><td class="text-muted">Mã vận đơn:</td><td><strong>' + (order.trackingCode || 'N/A') + '</strong></td></tr><tr><td class="text-muted">Tên hàng:</td><td>' + (order.itemName || 'N/A') + '</td></tr><tr><td class="text-muted">Trọng lượng:</td><td>' + (order.weight || 0) + ' kg</td></tr><tr><td class="text-muted">Kích thước:</td><td>' + (order.length || 0) + ' x ' + (order.width || 0) + ' x ' + (order.height || 0) + ' cm</td></tr><tr><td class="text-muted">TL quy đổi:</td><td>' + (order.volumetricWeight || 0) + ' kg</td></tr><tr><td class="text-muted">Loại dịch vụ:</td><td><span class="badge badge-info">' + (order.serviceTypeName || 'N/A') + '</span></td></tr></table></div>' +
                        '<div class="col-md-6"><h6 class="font-weight-bold text-success mb-3"><i class="fas fa-money-bill-wave mr-2"></i>Thông tin phí</h6><table class="table table-sm"><tr><td class="text-muted">Tiền thu hộ (COD):</td><td class="text-warning font-weight-bold">' + formatCurrency(order.codAmount) + '</td></tr><tr><td class="text-muted">Phí vận chuyển:</td><td>' + formatCurrency(order.shippingFee) + '</td></tr><tr><td class="text-muted">Tổng cộng:</td><td class="font-weight-bold text-success">' + formatCurrency(order.totalPrice) + '</td></tr></table><h6 class="font-weight-bold text-warning mb-3 mt-4"><i class="fas fa-clock mr-2"></i>Thời gian</h6><table class="table table-sm"><tr><td class="text-muted">Tạo đơn:</td><td>' + formatDateTime(order.createdAt) + '</td></tr><tr><td class="text-muted">Tồn kho:</td><td><span class="' + (order.hoursInWarehouse > 48 ? 'text-danger font-weight-bold' : '') + '">' + (order.hoursInWarehouse || 0) + ' giờ</span></td></tr><tr><td class="text-muted">Ưu tiên:</td><td><span class="badge priority-' + (order.priorityLevel || 'NORMAL') + '">' + (order.priorityLevel || 'NORMAL') + '</span></td></tr></table></div></div>';
                    $('#orderDetailContent').html(html);
                    $('#orderDetailModal').modal('show');
                }
                function selectContainer(containerId) { selectedContainerId = containerId; $('.container-item').removeClass('selected'); $('.container-item[data-container-id="' + containerId + '"]').addClass('selected'); loadContainerDetail(containerId); $('#btnRefreshDetail').show(); }
                function loadContainerDetail(containerId) {
                    $.get(contextPath + '/api/manager/outbound/containers/' + containerId, function (response) {
                        if (response.success) {
                            var c = response.data;
                            var ordersHtml = '';
                            if (c.orders && c.orders.length > 0) { ordersHtml = '<div class="list-group">'; c.orders.forEach(function (o) { ordersHtml += '<div class="list-group-item d-flex justify-content-between align-items-center py-2"><div><strong>#' + o.requestId + '</strong><br><small class="text-muted">' + (o.itemName || 'N/A') + '</small></div><button class="btn btn-sm btn-outline-danger" onclick="removeOrder(' + o.requestId + ')"><i class="fas fa-times"></i></button></div>'; }); ordersHtml += '</div>'; }
                            else { ordersHtml = '<div class="alert alert-info"><i class="fas fa-info-circle mr-2"></i>Chưa có đơn hàng trong bao</div>'; }
                            var statusBadge = c.status === 'created' ? 'badge-warning' : 'badge-success';
                            var statusText = c.status === 'created' ? 'Đang mở' : 'Đã niêm phong';
                            var html = '<div class="text-center mb-3"><h4 class="font-weight-bold text-primary">' + c.containerCode + '</h4><span class="badge ' + statusBadge + ' px-3 py-2">' + statusText + '</span></div>' +
                                '<div class="row text-center mb-3"><div class="col-4"><div class="border rounded p-2"><div class="font-weight-bold text-info">' + (c.type || 'standard') + '</div><small class="text-muted">Loại bao</small></div></div><div class="col-4"><div class="border rounded p-2"><div class="font-weight-bold text-success">' + c.orderCount + '</div><small class="text-muted">Số đơn</small></div></div><div class="col-4"><div class="border rounded p-2"><div class="font-weight-bold text-warning">' + (c.weight || 0) + ' kg</div><small class="text-muted">Trọng lượng</small></div></div></div>' +
                                '<p class="text-muted small"><i class="fas fa-arrow-right mr-1"></i> Đích: <strong>' + (c.destinationHubName || 'N/A') + '</strong></p><hr><h6 class="font-weight-bold"><i class="fas fa-list mr-2"></i>Đơn hàng trong bao:</h6>' + ordersHtml;
                            if (c.status === 'created') { html += '<hr><button class="btn btn-primary btn-block" onclick="addSelectedOrders()"><i class="fas fa-plus mr-1"></i> Thêm đơn đã chọn vào bao</button>'; }
                            $('#containerDetail').html(html);
                            $('#containerActions').show();
                            if (c.status === 'created') {
                                $('#btnSealContainer').show();
                                $('#btnReopenContainer').hide();
                            } else if (c.status === 'closed') {
                                $('#btnSealContainer').hide();
                                $('#btnReopenContainer').show();
                            } else {
                                $('#btnSealContainer').hide();
                                $('#btnReopenContainer').hide();
                            }
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải chi tiết bao hàng'); });
                }
                function createContainer() {
                    var hubId = $('#hubSelect').val(); var destHubId = $('#destHubSelect').val(); var containerCode = $('#containerCode').val(); var containerType = $('#containerType').val();
                    if (!containerCode) { showToast('warning', 'Thiếu thông tin', 'Vui lòng nhập mã bao'); return; }
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/containers?hubId=' + hubId + '&actorId=' + managerId, method: 'POST', contentType: 'application/json', data: JSON.stringify({ containerCode: containerCode, containerType: containerType, currentHubId: parseInt(hubId), destinationHubId: parseInt(destHubId) }),
                        success: function (response) { if (response.success) { $('#createContainerModal').modal('hide'); showToast('success', 'Thành công!', 'Đã tạo bao hàng mới: ' + containerCode); loadContainers(hubId); } else { showToast('error', 'Lỗi', response.message); } },
                        error: function (xhr) { var error = xhr.responseJSON || {}; showToast('error', 'Lỗi', error.message || 'Không thể tạo bao'); }
                    });
                }
                function addSelectedOrders() {
                    if (!selectedContainerId) { showToast('warning', 'Chưa chọn bao', 'Vui lòng chọn bao hàng trước'); return; }
                    var selectedOrders = []; $('.order-item.selected').each(function () { selectedOrders.push($(this).data('order-id')); });
                    if (selectedOrders.length === 0) { showToast('warning', 'Chưa chọn đơn', 'Vui lòng chọn ít nhất một đơn hàng'); return; }
                    var successCount = 0; var failCount = 0;
                    var promises = selectedOrders.map(function (orderId) { return $.ajax({ url: contextPath + '/api/manager/outbound/containers/add-order?actorId=' + managerId, method: 'POST', contentType: 'application/json', data: JSON.stringify({ containerId: selectedContainerId, requestId: orderId }) }).done(function () { successCount++; }).fail(function () { failCount++; }); });
                    Promise.all(promises.map(function (p) { return p.catch(function (e) { return e; }); })).then(function () {
                        if (successCount > 0) showToast('success', 'Thành công!', 'Đã thêm ' + successCount + ' đơn vào bao');
                        if (failCount > 0) showToast('warning', 'Cảnh báo', failCount + ' đơn không thể thêm (có thể đã trong bao khác)');
                        loadOrders(selectedHubId); loadContainerDetail(selectedContainerId); loadContainers(selectedHubId);
                    });
                }
                function removeOrder(orderId) {
                    if (!selectedContainerId) return;
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/containers/remove-order?actorId=' + managerId, method: 'POST', contentType: 'application/json', data: JSON.stringify({ containerId: selectedContainerId, requestId: orderId }),
                        success: function (response) { if (response.success) { showToast('success', 'Đã xóa', 'Đã gỡ đơn #' + orderId + ' khỏi bao'); loadOrders(selectedHubId); loadContainerDetail(selectedContainerId); loadContainers(selectedHubId); } else { showToast('error', 'Lỗi', response.message); } },
                        error: function (xhr) { var error = xhr.responseJSON || {}; showToast('error', 'Lỗi', error.message || 'Không thể xóa đơn'); }
                    });
                }
                function sealContainer() {
                    if (!selectedContainerId) return;
                    if (!confirm('Bạn có chắc muốn niêm phong bao này?\n\nSau khi niêm phong sẽ không thể thêm/xóa đơn hàng.')) return;
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/containers/' + selectedContainerId + '/seal?actorId=' + managerId, method: 'POST',
                        success: function (response) { if (response.success) { showToast('success', 'Đã niêm phong!', 'Bao hàng đã được niêm phong và sẵn sàng xếp xe'); loadContainers(selectedHubId); loadContainerDetail(selectedContainerId); } else { showToast('error', 'Lỗi', response.message); } },
                        error: function (xhr) { var error = xhr.responseJSON || {}; showToast('error', 'Lỗi', error.message || 'Không thể niêm phong bao'); }
                    });
                }
                function reopenContainer() {
                    if (!selectedContainerId) return;
                    if (!confirm('Bạn có chắc muốn mở lại bao này?\n\nSau khi mở lại bạn có thể thêm/bớt đơn hàng.')) return;
                    $.ajax({
                        url: contextPath + '/api/manager/outbound/containers/' + selectedContainerId + '/reopen?actorId=' + managerId, method: 'POST',
                        success: function (response) { if (response.success) { showToast('success', 'Đã mở lại bao!', 'Bạn có thể thêm/bớt đơn hàng'); loadContainers(selectedHubId); loadContainerDetail(selectedContainerId); } else { showToast('error', 'Lỗi', response.message); } },
                        error: function (xhr) { var error = xhr.responseJSON || {}; showToast('error', 'Lỗi', error.message || 'Không thể mở lại bao'); }
                    });
                }
            </script>
        </body>

        </html>