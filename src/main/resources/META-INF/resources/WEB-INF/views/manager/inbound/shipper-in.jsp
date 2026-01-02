<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Shipper Bàn Giao - Manager Portal</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

                <style>
                    .scan-header {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        padding: 30px;
                        border-radius: 15px;
                        color: #fff;
                        margin-bottom: 25px;
                    }

                    .scan-card {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        overflow: hidden;
                    }

                    .scan-card-header {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        color: #fff;
                        padding: 20px;
                        display: flex;
                        align-items: center;
                    }

                    .card-icon {
                        width: 50px;
                        height: 50px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 15px;
                        font-size: 1.5rem;
                    }

                    .scan-card-body {
                        padding: 30px;
                    }

                    .scan-input-group {
                        position: relative;
                    }

                    .scan-input-group input {
                        padding-left: 50px;
                        height: 60px;
                        font-size: 1.3rem;
                        font-weight: 600;
                        border-radius: 10px;
                        border: 2px solid #e3e6f0;
                        text-transform: uppercase;
                    }

                    .scan-input-group input:focus {
                        border-color: #f5576c;
                        box-shadow: 0 0 0 3px rgba(245, 87, 108, 0.2);
                    }

                    .scan-icon {
                        position: absolute;
                        left: 18px;
                        top: 50%;
                        transform: translateY(-50%);
                        font-size: 1.3rem;
                        color: #858796;
                    }

                    .result-panel {
                        margin-top: 15px;
                        padding: 12px 16px;
                        border-radius: 8px;
                        display: none;
                        font-size: 0.95rem;
                        border: 1px solid transparent;
                    }

                    .result-panel.success {
                        background-color: #d4edda;
                        border-color: #c3e6cb;
                        color: #155724;
                    }

                    .result-panel.error {
                        background-color: #f8d7da;
                        border-color: #f5c6cb;
                        color: #721c24;
                        color: #fff;
                    }

                    .recent-scans {
                        max-height: 450px;
                        overflow-y: auto;
                    }

                    .scan-item {
                        display: flex;
                        align-items: center;
                        padding: 15px;
                        border: 1px solid #e3e6f0;
                        border-radius: 10px;
                        margin-bottom: 10px;
                        transition: all 0.3s;
                        font-size: 14px;
                    }

                    .scan-item strong {
                        font-size: 14px;
                    }

                    .scan-item small {
                        font-size: 12px;
                    }

                    .scan-item:hover {
                        border-color: #f5576c;
                        background: #f8f9fc;
                    }

                    .scan-item.success {
                        border-left: 4px solid #28a745;
                    }

                    .scan-item.error {
                        border-left: 4px solid #dc3545;
                    }

                    .scan-time {
                        font-size: 11px;
                        color: #858796;
                    }

                    .stats-box {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        border-radius: 15px;
                        padding: 25px;
                        color: #fff;
                        text-align: center;
                    }

                    .stats-number {
                        font-size: 3rem;
                        font-weight: 700;
                    }

                    .order-detail {
                        background: #f8f9fc;
                        border-radius: 10px;
                        padding: 15px;
                        margin-top: 15px;
                    }

                    .order-detail-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 8px 0;
                        border-bottom: 1px solid #e3e6f0;
                    }

                    .order-detail-row:last-child {
                        border-bottom: none;
                    }

                    .shipper-info {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 10px;
                        padding: 15px;
                        color: #fff;
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body id="page-top">
                <div id="wrapper">


                    <div id="content-wrapper" class="d-flex flex-column">
                        <div id="content">

                            <div class="container-fluid py-4">

                                <!-- Header -->
                                <div class="scan-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h4 class="mb-1"><i class="fas fa-motorcycle"></i> Shipper Bàn Giao
                                                Hàng</h4>
                                            <p class="mb-0 opacity-75">Quét mã khi Shipper mang hàng về bưu cục
                                                (hoàn hàng hoặc lấy về)</p>
                                        </div>
                                        <div>
                                            <span class="badge badge-light p-2" id="currentHubInfo">
                                                <i class="fas fa-building"></i> Đang tải...
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Cột trái - Form quét -->
                                    <div class="col-lg-8">
                                        <div class="scan-card">
                                            <div class="scan-card-header">
                                                <div class="card-icon"><i class="fas fa-motorcycle"></i></div>
                                                <div>
                                                    <h5 class="mb-0">Quét Mã Vận Đơn</h5>
                                                    <small class="opacity-75">Hàng từ Shipper bàn giao về bưu
                                                        cục</small>
                                                </div>
                                            </div>
                                            <div class="scan-card-body">
                                                <!-- Thông tin Shipper (tùy chọn) -->
                                                <div class="shipper-info">
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-user-circle fa-2x mr-3"></i>
                                                        <div>
                                                            <div class="font-weight-bold">Shipper đang bàn giao
                                                            </div>
                                                            <small class="opacity-75">Quét mã vận đơn để xác
                                                                nhận nhận hàng</small>
                                                        </div>
                                                    </div>
                                                </div>

                                                <form id="shipperInboundForm"
                                                    onsubmit="return processShipperInbound(event)">
                                                    <!-- Dropdown chọn loại hành động -->
                                                    <div class="form-group mb-3">
                                                        <label class="font-weight-bold"><i
                                                                class="fas fa-tags text-danger"></i> Loại hành
                                                            động</label>
                                                        <select class="form-control form-control-lg" id="actionTypeId"
                                                            required>
                                                            <option value="">-- Chọn loại hành động --</option>
                                                        </select>
                                                    </div>

                                                    <div class="scan-input-group mb-4">
                                                        <i class="fas fa-barcode scan-icon"></i>
                                                        <input type="text" class="form-control form-control-lg"
                                                            id="trackingCode" placeholder="QUÉT HOẶC NHẬP MÃ VẬN ĐƠN"
                                                            autofocus autocomplete="off">
                                                    </div>
                                                    <button type="submit" class="btn btn-danger btn-lg btn-block">
                                                        <i class="fas fa-check-circle"></i> XÁC NHẬN BÀN GIAO
                                                    </button>
                                                </form>

                                                <!-- Kết quả -->
                                                <div id="resultPanel" class="result-panel"></div>

                                                <!-- Chi tiết đơn hàng vừa quét -->
                                                <div id="orderDetail" class="order-detail" style="display: none;">
                                                    <h6 class="font-weight-bold text-primary mb-3">
                                                        <i class="fas fa-info-circle"></i> Chi tiết đơn hàng
                                                    </h6>
                                                    <div class="order-detail-row">
                                                        <span class="text-muted">Mã vận đơn:</span>
                                                        <strong id="detailTrackingCode">-</strong>
                                                    </div>
                                                    <div class="order-detail-row">
                                                        <span class="text-muted">Trạng thái mới:</span>
                                                        <span class="badge badge-warning" id="detailStatus">-</span>
                                                    </div>
                                                    <div class="order-detail-row">
                                                        <span class="text-muted">Người gửi:</span>
                                                        <span id="detailSender">-</span>
                                                    </div>
                                                    <div class="order-detail-row">
                                                        <span class="text-muted">Người nhận:</span>
                                                        <span id="detailReceiver">-</span>
                                                    </div>
                                                    <div class="order-detail-row">
                                                        <span class="text-muted">Lý do hoàn:</span>
                                                        <span id="detailReason" class="text-danger">-</span>
                                                    </div>
                                                    <!-- Nút In Tem -->
                                                    <div class="mt-3 text-center">
                                                        <button type="button" class="btn btn-success btn-sm"
                                                            id="btnPrintLabel" onclick="openPrintLabel()">
                                                            <i class="fas fa-print"></i> In Tem Vận Đơn
                                                        </button>
                                                    </div>
                                                    <input type="hidden" id="currentRequestId">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Cột phải - Thống kê & Lịch sử -->
                                    <div class="col-lg-4">
                                        <!-- Thống kê hôm nay -->
                                        <div class="stats-box mb-4">
                                            <div class="stats-number" id="todayCount">0</div>
                                            <div>Đơn nhận hôm nay</div>
                                            <small class="opacity-75">Từ Shipper bàn giao</small>
                                        </div>

                                        <!-- Lịch sử quét gần đây -->
                                        <div class="scan-card">
                                            <div class="scan-card-header" style="background: #f8f9fc;">
                                                <div class="card-icon" style="background: #f5576c; color: #fff;">
                                                    <i class="fas fa-history"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0 text-gray-800">Lịch sử quét gần đây</h6>
                                                </div>
                                            </div>
                                            <div class="scan-card-body">
                                                <div class="recent-scans" id="recentScans">
                                                    <p class="text-muted text-center py-4">
                                                        <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                        Chưa có lượt quét nào
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <%@ include file="/commons/manager/footer.jsp" %>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

                <script>
                    let currentHubId = null;
                    let currentManagerId = null;
                    let todayCount = 0;
                    let recentScans = [];

                    $(document).ready(function () {
                        loadManagerInfo();
                        loadActionTypes();

                        // Focus vào input khi trang load
                        $('#trackingCode').focus();
                    });

                    // Tải danh sách ActionType từ server
                    function loadActionTypes() {
                        $.get('${pageContext.request.contextPath}/api/manager/inbound/action-types', function (response) {
                            let options = '<option value="">-- Chọn loại hành động --</option>';
                            if (Array.isArray(response)) {
                                response.forEach(function (at) {
                                    options += '<option value="' + at.actionTypeId + '">' + at.actionCode + ' - ' + at.description + '</option>';
                                });
                            }
                            $('#actionTypeId').html(options);
                        }).fail(function (xhr) {
                            console.error('Lỗi tải ActionType:', xhr);
                        });
                    }

                    function loadManagerInfo() {
                        $.get('${pageContext.request.contextPath}/api/manager/current-user', function (response) {
                            if (response.userId) {
                                currentManagerId = response.userId;
                                currentHubId = response.hubId;
                                $('#currentHubInfo').html('<i class="fas fa-building"></i> Hub ID: ' + currentHubId);
                            }
                        }).fail(function () {
                            $('#currentHubInfo').html('<span class="text-danger">Không thể tải thông tin</span>');
                        });
                    }

                    function processShipperInbound(event) {
                        event.preventDefault();

                        const trackingCode = $('#trackingCode').val().trim().toUpperCase();
                        const actionTypeId = $('#actionTypeId').val();

                        if (!actionTypeId) {
                            showResult(false, 'Vui lòng chọn loại hành động!');
                            return false;
                        }

                        if (!trackingCode) {
                            showResult(false, 'Vui lòng nhập mã vận đơn!');
                            return false;
                        }

                        if (!currentHubId || !currentManagerId) {
                            showResult(false, 'Không xác định được Hub hoặc Manager. Vui lòng đăng nhập lại!');
                            return false;
                        }

                        $.ajax({
                            url: '${pageContext.request.contextPath}/api/manager/inbound/shipper-in',
                            type: 'POST',
                            data: {
                                trackingCode: trackingCode,
                                currentHubId: currentHubId,
                                managerId: currentManagerId,
                                actionTypeId: actionTypeId
                            },
                            beforeSend: function () {
                                $('#shipperInboundForm button').prop('disabled', true)
                                    .html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');
                            },
                            success: function (response) {
                                if (response.success) {
                                    showResult(true, response.message);
                                    showOrderDetail(trackingCode, response.data);
                                    addToRecentScans(trackingCode, true);
                                    todayCount++;
                                    $('#todayCount').text(todayCount);
                                    $('#trackingCode').val('').focus();
                                } else {
                                    showResult(false, response.message);
                                    addToRecentScans(trackingCode, false, response.message);
                                }
                            },
                            error: function (xhr) {
                                const resp = xhr.responseJSON;
                                const msg = resp ? resp.message : 'Lỗi không xác định';
                                showResult(false, msg);
                                addToRecentScans(trackingCode, false, msg);
                            },
                            complete: function () {
                                $('#shipperInboundForm button').prop('disabled', false)
                                    .html('<i class="fas fa-check-circle"></i> XÁC NHẬN BÀN GIAO');
                            }
                        });

                        return false;
                    }

                    function showResult(success, message) {
                        const $result = $('#resultPanel');
                        $result.removeClass('success error')
                            .addClass(success ? 'success' : 'error')
                            .html('<i class="fas fa-' + (success ? 'check-circle' : 'times-circle') + ' mr-2"></i> ' + message)
                            .slideDown();

                        if (success) {
                            setTimeout(function () {
                                $result.slideUp();
                            }, 5000);
                        }
                    }

                    function showOrderDetail(trackingCode, data) {
                        if (!data) return;

                        $('#detailTrackingCode').text(trackingCode);
                        $('#detailStatus').text(data.status || 'RETURNED_TO_HUB');
                        $('#detailSender').text(data.pickupAddress?.contactName || '-');
                        $('#detailReceiver').text(data.deliveryAddress?.contactName || '-');
                        $('#detailReason').text(data.note || 'Không có');

                        // Lưu requestId để dùng cho nút in tem
                        if (data.requestId) {
                            $('#currentRequestId').val(data.requestId);
                        }

                        $('#orderDetail').slideDown();
                    }

                    // Mở trang in tem
                    function openPrintLabel() {
                        const requestId = $('#currentRequestId').val();
                        if (!requestId) {
                            alert('Không tìm thấy mã đơn hàng!');
                            return;
                        }
                        const printUrl = '${pageContext.request.contextPath}/manager/inbound/print-label/' + requestId;
                        window.open(printUrl, '_blank', 'width=450,height=600,scrollbars=yes');
                    }

                    function addToRecentScans(trackingCode, success, errorMsg) {
                        const scan = {
                            code: trackingCode,
                            success: success,
                            error: errorMsg || null,
                            time: new Date()
                        };

                        recentScans.unshift(scan);
                        if (recentScans.length > 20) recentScans.pop();

                        renderRecentScans();
                    }

                    function renderRecentScans() {
                        if (recentScans.length === 0) {
                            $('#recentScans').html('<p class="text-muted text-center py-4"><i class="fas fa-inbox fa-2x mb-2 d-block"></i>Chưa có lượt quét nào</p>');
                            return;
                        }

                        let html = '';
                        recentScans.forEach(function (scan) {
                            const statusIcon = scan.success ?
                                '<i class="fas fa-check-circle text-success fa-lg"></i>' :
                                '<i class="fas fa-times-circle text-danger fa-lg"></i>';
                            const timeStr = formatTime(scan.time);

                            html += '<div class="scan-item ' + (scan.success ? 'success' : 'error') + '">';
                            html += '  <div style="flex:1;">';
                            html += '    <strong>' + scan.code + '</strong>';
                            html += '    <div class="scan-time">' + timeStr + '</div>';
                            if (!scan.success && scan.error) {
                                html += '    <small class="text-danger">' + scan.error + '</small>';
                            }
                            html += '  </div>';
                            html += '  <div>' + statusIcon + '</div>';
                            html += '</div>';
                        });

                        $('#recentScans').html(html);
                    }

                    function formatTime(date) {
                        return date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                    }
                </script>
            </body>

            </html>