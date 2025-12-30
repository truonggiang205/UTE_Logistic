<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .counter-header {
                    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .pickup-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    overflow: hidden;
                }

                .pickup-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: #fff;
                    padding: 20px;
                }

                .pickup-body {
                    padding: 25px;
                }

                .search-box {
                    position: relative;
                }

                .search-box input {
                    padding-left: 45px;
                    font-size: 18px;
                    height: 55px;
                    border-radius: 10px;
                }

                .search-box i {
                    position: absolute;
                    left: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #858796;
                    font-size: 18px;
                }

                .order-detail {
                    background: #f8f9fc;
                    border-radius: 12px;
                    padding: 25px;
                    margin-top: 20px;
                    display: none;
                }

                .order-detail.show {
                    display: block;
                }

                .detail-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 12px 0;
                    border-bottom: 1px solid #e3e6f0;
                }

                .detail-row:last-child {
                    border-bottom: none;
                }

                .detail-label {
                    color: #858796;
                }

                .detail-value {
                    font-weight: 600;
                    text-align: right;
                }

                .cod-highlight {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    color: #fff;
                    padding: 20px;
                    border-radius: 12px;
                    text-align: center;
                    margin: 20px 0;
                }

                .cod-highlight .amount {
                    font-size: 32px;
                    font-weight: 700;
                }

                .btn-pickup {
                    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
                    border: none;
                    color: #fff;
                    padding: 15px 40px;
                    border-radius: 30px;
                    font-size: 18px;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .btn-pickup:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 25px rgba(245, 175, 25, 0.4);
                    color: #fff;
                }

                .btn-pickup:disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                    transform: none;
                }

                .history-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    overflow: hidden;
                }

                .history-header {
                    background: linear-gradient(135deg, #606c88 0%, #3f4c6b 100%);
                    color: #fff;
                    padding: 15px 20px;
                }

                .history-body {
                    padding: 20px;
                    max-height: 400px;
                    overflow-y: auto;
                }

                .history-item {
                    padding: 12px 0;
                    border-bottom: 1px solid #e3e6f0;
                }

                .history-item:last-child {
                    border-bottom: none;
                }

                .history-time {
                    font-size: 11px;
                    color: #858796;
                }

                .not-found {
                    text-align: center;
                    padding: 40px;
                    color: #858796;
                }

                .not-found i {
                    font-size: 50px;
                    margin-bottom: 15px;
                }
            </style>

            <!-- Header -->
            <div class="counter-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-store mr-2"></i>Khách Nhận Tại Quầy</h4>
                        <p class="mb-0 opacity-75">Xác nhận khi khách hàng đến nhận hàng trực tiếp</p>
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
                <!-- Main: Tìm và xác nhận -->
                <div class="col-lg-8">
                    <div class="pickup-card">
                        <div class="pickup-header">
                            <h5 class="mb-0"><i class="fas fa-search mr-2"></i>Tìm kiếm đơn hàng</h5>
                        </div>
                        <div class="pickup-body">
                            <div class="search-box">
                                <i class="fas fa-barcode"></i>
                                <input type="text" class="form-control form-control-lg" id="searchTracking"
                                    placeholder="Nhập mã vận đơn hoặc quét barcode..." autofocus>
                            </div>
                            <p class="text-muted small mt-2">
                                <i class="fas fa-info-circle mr-1"></i>
                                Nhập mã vận đơn và nhấn Enter hoặc dùng máy quét barcode
                            </p>

                            <!-- Order Detail -->
                            <div class="order-detail" id="orderDetail">
                                <h5 class="mb-3"><i class="fas fa-box text-primary mr-2"></i>Thông tin đơn hàng</h5>
                                <div class="detail-row">
                                    <span class="detail-label">Mã vận đơn:</span>
                                    <span class="detail-value text-primary" id="detailTrackingCode"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Người gửi:</span>
                                    <span class="detail-value" id="detailSender"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Người nhận:</span>
                                    <span class="detail-value" id="detailReceiver"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">SĐT Người nhận:</span>
                                    <span class="detail-value" id="detailReceiverPhone"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Trạng thái:</span>
                                    <span class="detail-value" id="detailStatus"></span>
                                </div>

                                <div class="cod-highlight">
                                    <div class="small mb-1">Số tiền COD cần thu</div>
                                    <div class="amount" id="detailCodAmount">0 ₫</div>
                                </div>

                                <div class="mb-3">
                                    <label class="font-weight-bold">Số tiền thực thu:</label>
                                    <input type="number" class="form-control form-control-lg" id="inputCodCollected"
                                        min="0" step="1000">
                                </div>

                                <div class="mb-3">
                                    <label>Số CMND/CCCD người nhận (tùy chọn):</label>
                                    <input type="text" class="form-control" id="inputIdCard"
                                        placeholder="Nhập số CMND/CCCD">
                                </div>

                                <div class="mb-3">
                                    <label>Ghi chú:</label>
                                    <textarea class="form-control" id="inputNote" rows="2"
                                        placeholder="Ghi chú khi giao"></textarea>
                                </div>

                                <input type="hidden" id="inputRequestId">

                                <div class="text-center">
                                    <button class="btn btn-pickup" id="btnConfirmPickup" disabled>
                                        <i class="fas fa-check-circle mr-2"></i>Xác nhận Đã Giao
                                    </button>
                                </div>
                            </div>

                            <!-- Not Found -->
                            <div class="not-found" id="notFoundMessage" style="display: none;">
                                <i class="fas fa-box-open"></i>
                                <h5>Không tìm thấy đơn hàng</h5>
                                <p>Vui lòng kiểm tra lại mã vận đơn</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sidebar: Lịch sử -->
                <div class="col-lg-4">
                    <div class="history-card">
                        <div class="history-header">
                            <h6 class="mb-0"><i class="fas fa-history mr-2"></i>Lịch sử giao tại quầy</h6>
                        </div>
                        <div class="history-body" id="historyList">
                            <p class="text-muted text-center">Chưa có giao dịch nào hôm nay</p>
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="pickup-card mt-4">
                        <div class="pickup-body text-center">
                            <h6 class="text-muted mb-3">Thống kê hôm nay</h6>
                            <div class="row">
                                <div class="col-6">
                                    <div class="h3 text-primary mb-0" id="statCount">0</div>
                                    <small class="text-muted">Đơn đã giao</small>
                                </div>
                                <div class="col-6">
                                    <div class="h3 text-success mb-0" id="statAmount">0₫</div>
                                    <small class="text-muted">Tổng COD</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var contextPath = '${pageContext.request.contextPath}';
                var todayStats = { count: 0, amount: 0 };

                // Wait for jQuery to be available
                function initPage() {
                    if (typeof jQuery === 'undefined') {
                        setTimeout(initPage, 50);
                        return;
                    }
                    $(document).ready(function () {
                        $('#searchTracking').on('keypress', function (e) {
                            if (e.which === 13) searchOrder();
                        });
                        $('#btnConfirmPickup').click(confirmPickup);
                        $('#inputCodCollected').on('input', function () {
                            $('#btnConfirmPickup').prop('disabled', !$(this).val());
                        });
                    });
                }

                function searchOrder() {
                    var tracking = $('#searchTracking').val().trim();
                    if (!tracking) return;

                    $('#orderDetail').removeClass('show');
                    $('#notFoundMessage').hide();

                    $.get(contextPath + '/api/manager/lastmile/orders?trackingCode=' + encodeURIComponent(tracking), function (response) {
                        if (response.success && response.data && response.data.length > 0) {
                            var order = response.data[0];
                            showOrderDetail(order);
                        } else {
                            $('#notFoundMessage').show();
                        }
                    }).fail(function () {
                        $('#notFoundMessage').show();
                    });
                }

                function showOrderDetail(order) {
                    $('#detailTrackingCode').text(order.trackingCode);
                    $('#detailSender').text(order.senderName || 'N/A');
                    $('#detailReceiver').text(order.receiverName || 'N/A');
                    $('#detailReceiverPhone').text(order.receiverPhone || 'N/A');
                    $('#detailStatus').html('<span class="badge badge-info">' + (order.status || 'N/A') + '</span>');
                    $('#detailCodAmount').text(formatCurrency(order.codAmount || 0));
                    $('#inputCodCollected').val(order.codAmount || 0);
                    $('#inputRequestId').val(order.requestId);
                    $('#inputIdCard').val('');
                    $('#inputNote').val('');
                    $('#btnConfirmPickup').prop('disabled', false);
                    $('#orderDetail').addClass('show');
                }

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
                }

                function confirmPickup() {
                    var requestId = $('#inputRequestId').val();
                    var codCollected = $('#inputCodCollected').val();
                    var idCard = $('#inputIdCard').val();
                    var note = $('#inputNote').val();

                    if (!requestId) { alert('Không tìm thấy thông tin đơn hàng'); return; }

                    $('#btnConfirmPickup').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...');

                    $.ajax({
                        url: contextPath + '/api/manager/lastmile/counter-pickup',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            requestId: parseInt(requestId),
                            codCollected: parseFloat(codCollected) || 0,
                            receiverIdCard: idCard,
                            note: note
                        }),
                        success: function (response) {
                            alert('Xác nhận giao hàng thành công!\nMã vận đơn: ' + response.trackingCode);
                            addToHistory(response);
                            updateStats(parseFloat(codCollected) || 0);
                            resetForm();
                        },
                        error: function (xhr) {
                            alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Có lỗi xảy ra'));
                        },
                        complete: function () {
                            $('#btnConfirmPickup').prop('disabled', false).html('<i class="fas fa-check-circle mr-2"></i>Xác nhận Đã Giao');
                        }
                    });
                }

                function addToHistory(response) {
                    var html = '<div class="history-item">' +
                        '<div class="d-flex justify-content-between">' +
                        '<strong class="text-primary">' + response.trackingCode + '</strong>' +
                        '<span class="history-time">' + new Date().toLocaleTimeString('vi-VN') + '</span>' +
                        '</div>' +
                        '<small class="text-muted">' + (response.receiverName || 'Khách hàng') + '</small><br>' +
                        '<span class="badge badge-success">COD: ' + formatCurrency(response.codCollected || 0) + '</span>' +
                        '</div>';

                    var $history = $('#historyList');
                    if ($history.find('.history-item').length === 0) {
                        $history.html(html);
                    } else {
                        $history.prepend(html);
                    }
                }

                function updateStats(amount) {
                    todayStats.count++;
                    todayStats.amount += amount;
                    $('#statCount').text(todayStats.count);
                    $('#statAmount').text(formatCurrency(todayStats.amount));
                }

                function resetForm() {
                    $('#searchTracking').val('').focus();
                    $('#orderDetail').removeClass('show');
                    $('#notFoundMessage').hide();
                }

                // Start initialization
                initPage();
            </script>