<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .assign-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
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

                .shipper-card {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .shipper-card:hover {
                    border-color: #667eea;
                    background: #f8f9fc;
                }

                .shipper-card.selected {
                    border-color: #28a745;
                    background: #e8f5e9;
                }

                .shipper-avatar {
                    width: 50px;
                    height: 50px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #fff;
                    font-weight: 700;
                    margin-right: 15px;
                }

                .shipper-status {
                    padding: 4px 10px;
                    border-radius: 15px;
                    font-size: 11px;
                    font-weight: 600;
                }

                .status-active {
                    background: #d4edda;
                    color: #155724;
                }

                .status-busy {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-inactive {
                    background: #f8d7da;
                    color: #721c24;
                }

                .btn-assign {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    padding: 12px 30px;
                    border-radius: 25px;
                    color: #fff;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .btn-assign:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
                    color: #fff;
                }

                .counter-badge {
                    background: #667eea;
                    color: #fff;
                    padding: 5px 12px;
                    border-radius: 15px;
                    font-weight: 600;
                }
            </style>

            <!-- Header -->
            <div class="assign-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-user-tag mr-2"></i>Phân công Shipper</h4>
                        <p class="mb-0 opacity-75">Chọn đơn hàng và gán cho Shipper giao hàng</p>
                    </div>
                    <div>
                        <span class="badge badge-light p-2">
                            <i class="fas fa-calendar-day mr-1"></i>
                            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm" />
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Step 1: Chọn Shipper -->
                <div class="col-lg-4">
                    <div class="step-card">
                        <div class="step-header">
                            <div class="step-number">1</div>
                            <div>
                                <h6 class="mb-0">Chọn Shipper</h6>
                                <small class="opacity-75">Shipper sẵn sàng nhận đơn</small>
                            </div>
                        </div>
                        <div class="step-body">
                            <div class="mb-3">
                                <select class="form-control" id="filterShipperStatus">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" selected>Đang rảnh (Active)</option>
                                    <option value="busy">Đang bận (Busy)</option>
                                </select>
                            </div>
                            <div id="shipperList">
                                <div class="text-center py-4">
                                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                                    <p class="mt-2 text-muted">Đang tải danh sách...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Chọn đơn hàng -->
                <div class="col-lg-5">
                    <div class="step-card">
                        <div class="step-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <div class="step-number">2</div>
                            <div class="flex-grow-1">
                                <h6 class="mb-0">Chọn đơn hàng</h6>
                                <small class="opacity-75">Đơn sẵn sàng giao</small>
                            </div>
                            <span class="counter-badge" id="selectedOrderCount">0 đơn</span>
                        </div>
                        <div class="step-body">
                            <div class="d-flex mb-3">
                                <input type="text" class="form-control mr-2" id="searchOrder"
                                    placeholder="Tìm mã vận đơn...">
                                <button class="btn btn-outline-primary" id="selectAllOrders">
                                    <i class="fas fa-check-double"></i>
                                </button>
                            </div>
                            <div class="order-list" id="orderList">
                                <div class="text-center py-4">
                                    <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                                    <p class="mt-2 text-muted">Đang tải danh sách...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Xác nhận -->
                <div class="col-lg-3">
                    <div class="step-card">
                        <div class="step-header" style="background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);">
                            <div class="step-number">3</div>
                            <div>
                                <h6 class="mb-0">Xác nhận</h6>
                                <small class="opacity-75">Phân công giao hàng</small>
                            </div>
                        </div>
                        <div class="step-body">
                            <div class="mb-3">
                                <label class="text-muted small">Shipper được chọn:</label>
                                <div id="selectedShipperInfo" class="font-weight-bold text-primary">Chưa chọn shipper
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="text-muted small">Số đơn được chọn:</label>
                                <div id="selectedOrderInfo" class="font-weight-bold text-success">0 đơn hàng</div>
                            </div>
                            <hr>
                            <button class="btn btn-assign btn-block" id="btnAssign" disabled>
                                <i class="fas fa-paper-plane mr-2"></i>Phân công
                            </button>
                        </div>
                    </div>

                    <div class="step-card">
                        <div class="step-header" style="background: linear-gradient(135deg, #606c88 0%, #3f4c6b 100%);">
                            <div class="step-number"><i class="fas fa-history"></i></div>
                            <div>
                                <h6 class="mb-0">Phân công gần đây</h6>
                            </div>
                        </div>
                        <div class="step-body" id="recentAssignments">
                            <p class="text-muted text-center">Chưa có phân công nào</p>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var selectedShipperId = null;
                var selectedShipperName = '';
                var selectedOrderIds = [];
                var contextPath = '${pageContext.request.contextPath}';

                // Wait for jQuery to be available
                function initPage() {
                    if (typeof jQuery === 'undefined') {
                        setTimeout(initPage, 50);
                        return;
                    }
                    $(document).ready(function () {
                        loadShippers();
                        loadOrders();

                        $('#filterShipperStatus').change(function () {
                            loadShippers($(this).val());
                        });

                        $('#searchOrder').on('input', function () {
                            var keyword = $(this).val().toLowerCase();
                            $('.order-item').each(function () {
                                $(this).toggle($(this).text().toLowerCase().indexOf(keyword) !== -1);
                            });
                        });

                        $('#selectAllOrders').click(function () {
                            $('.order-checkbox').prop('checked', true).trigger('change');
                        });

                        $('#btnAssign').click(assignTask);
                    });
                }

                function loadShippers(status) {
                    var url = contextPath + '/api/manager/lastmile/shippers' + (status ? '?status=' + status : '');
                    $.get(url, function (response) {
                        if (response.success && response.data) renderShippers(response.data);
                    }).fail(function () {
                        $('#shipperList').html('<p class="text-danger text-center">Lỗi tải danh sách</p>');
                    });
                }

                function renderShippers(shippers) {
                    if (shippers.length === 0) {
                        $('#shipperList').html('<p class="text-muted text-center">Không có shipper nào</p>');
                        return;
                    }
                    var html = '';
                    shippers.forEach(function (s) {
                        var initials = s.shipperName ? s.shipperName.charAt(0).toUpperCase() : '?';
                        var statusText = s.status === 'active' ? 'Rảnh' : s.status === 'busy' ? 'Bận' : 'Nghỉ';
                        html += '<div class="shipper-card d-flex align-items-center" data-shipper-id="' + s.shipperId + '" data-shipper-name="' + s.shipperName + '">' +
                            '<div class="shipper-avatar">' + initials + '</div>' +
                            '<div class="flex-grow-1"><div class="font-weight-bold">' + s.shipperName + '</div>' +
                            '<small class="text-muted"><i class="fas fa-phone mr-1"></i>' + s.phone + '</small></div>' +
                            '<span class="shipper-status status-' + s.status + '">' + statusText + '</span></div>';
                    });
                    $('#shipperList').html(html);
                    $('.shipper-card').click(function () {
                        $('.shipper-card').removeClass('selected');
                        $(this).addClass('selected');
                        selectedShipperId = $(this).data('shipper-id');
                        selectedShipperName = $(this).data('shipper-name');
                        $('#selectedShipperInfo').text(selectedShipperName);
                        updateAssignButton();
                    });
                }

                function loadOrders() {
                    $.get(contextPath + '/api/manager/lastmile/orders?status=picked', function (response) {
                        if (response.success && response.data) renderOrders(response.data);
                    }).fail(function () {
                        $('#orderList').html('<p class="text-danger text-center">Lỗi tải danh sách</p>');
                    });
                }

                function renderOrders(orders) {
                    if (orders.length === 0) {
                        $('#orderList').html('<p class="text-muted text-center">Không có đơn hàng nào</p>');
                        return;
                    }
                    var html = '';
                    orders.forEach(function (o) {
                        html += '<div class="order-item"><input type="checkbox" class="order-checkbox" data-request-id="' + o.requestId + '">' +
                            '<div class="order-info"><div class="order-id">' + o.trackingCode + '</div>' +
                            '<div class="order-meta"><i class="fas fa-user mr-1"></i>' + (o.receiverName || 'N/A') + '<br>' +
                            '<i class="fas fa-map-marker-alt mr-1"></i>' + (o.receiverAddress || 'N/A') + '</div></div>' +
                            '<div class="text-right"><small class="text-muted">COD</small><br>' +
                            '<span class="font-weight-bold text-success">' + formatCurrency(o.codAmount || 0) + '</span></div></div>';
                    });
                    $('#orderList').html(html);
                    $('.order-checkbox').change(function () {
                        var id = $(this).data('request-id');
                        var $item = $(this).closest('.order-item');
                        if ($(this).is(':checked')) {
                            $item.addClass('selected');
                            if (selectedOrderIds.indexOf(id) === -1) selectedOrderIds.push(id);
                        } else {
                            $item.removeClass('selected');
                            selectedOrderIds = selectedOrderIds.filter(function (x) { return x !== id; });
                        }
                        updateOrderCount();
                        updateAssignButton();
                    });
                }

                function updateOrderCount() {
                    $('#selectedOrderCount').text(selectedOrderIds.length + ' đơn');
                    $('#selectedOrderInfo').text(selectedOrderIds.length + ' đơn hàng');
                }

                function updateAssignButton() {
                    $('#btnAssign').prop('disabled', !(selectedShipperId && selectedOrderIds.length > 0));
                }

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
                }

                function assignTask() {
                    if (!selectedShipperId || selectedOrderIds.length === 0) {
                        alert('Vui lòng chọn shipper và ít nhất 1 đơn hàng');
                        return;
                    }
                    $('#btnAssign').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...');
                    $.ajax({
                        url: contextPath + '/api/manager/lastmile/assign-task',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ shipperId: selectedShipperId, requestIds: selectedOrderIds }),
                        success: function (response) {
                            alert('Phân công thành công ' + response.assignedCount + ' đơn cho ' + response.shipperName);
                            addRecentAssignment(response);
                            selectedOrderIds = [];
                            selectedShipperId = null;
                            $('.shipper-card').removeClass('selected');
                            $('#selectedShipperInfo').text('Chưa chọn shipper');
                            loadShippers($('#filterShipperStatus').val());
                            loadOrders();
                            updateOrderCount();
                        },
                        error: function (xhr) {
                            alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Có lỗi xảy ra'));
                        },
                        complete: function () {
                            $('#btnAssign').prop('disabled', false).html('<i class="fas fa-paper-plane mr-2"></i>Phân công');
                        }
                    });
                }

                function addRecentAssignment(response) {
                    var html = '<div class="border-bottom pb-2 mb-2"><small class="text-muted">' + new Date().toLocaleTimeString('vi-VN') + '</small><br>' +
                        '<strong>' + response.shipperName + '</strong><br><span class="badge badge-success">' + response.assignedCount + ' đơn</span></div>';
                    $('#recentAssignments').prepend(html);
                }

                // Start initialization
                initPage();
            </script>