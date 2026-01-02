<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Xuất Bến - Gate Out</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .gateout-header {
                    background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .trip-card-ready {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                    border: 2px solid #1cc88a;
                    transition: all 0.3s;
                }

                .trip-card-ready:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                }

                .trip-card-not-ready {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                    border: 2px solid #e74a3b;
                    opacity: 0.7;
                }

                .trip-card-header {
                    padding: 15px 20px;
                    border-bottom: 1px solid #eee;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .trip-card-body {
                    padding: 20px;
                }

                .trip-card-footer {
                    padding: 15px 20px;
                    background: #f8f9fc;
                    border-radius: 0 0 12px 12px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .capacity-bar {
                    height: 10px;
                    border-radius: 5px;
                    background: #e9ecef;
                    overflow: hidden;
                    margin-top: 5px;
                }

                .capacity-bar-fill {
                    height: 100%;
                    border-radius: 5px;
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

                .btn-gateout {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    border: none;
                    padding: 10px 25px;
                    font-weight: 600;
                    border-radius: 8px;
                }

                .btn-gateout:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(28, 200, 138, 0.4);
                }

                .btn-gateout:disabled {
                    background: #858796;
                    cursor: not-allowed;
                }

                .route-display {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .route-hub {
                    background: #4e73df;
                    color: #fff;
                    padding: 5px 12px;
                    border-radius: 20px;
                    font-size: 0.85rem;
                }

                .route-arrow {
                    color: #858796;
                }

                .stats-card {
                    background: #fff;
                    border-radius: 10px;
                    padding: 15px 20px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                    text-align: center;
                }

                .stats-card h2 {
                    margin-bottom: 5px;
                    font-weight: 700;
                }

                .hub-filter-card {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    border-radius: 10px;
                    padding: 20px;
                    color: #fff;
                    margin-bottom: 25px;
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

                .search-box {
                    position: relative;
                    margin-bottom: 15px;
                }

                .search-box input {
                    padding-left: 35px;
                    border-radius: 20px;
                }

                .search-box i {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #858796;
                }
            </style>
        </head>

        <body id="page-top">
            <div class="toast-container" id="toastContainer"></div>
            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <div class="gateout-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-sign-out-alt mr-2"></i> Xuất Bến (Gate Out)
                                        </h3>
                                        <p class="mb-0 opacity-75">Xác nhận xe xuất phát, chuyển trạng thái đơn hàng
                                            sang "in_transit"</p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="stats-card d-inline-block mr-2">
                                            <h2 class="text-success" id="readyCount">0</h2>
                                            <small>Sẵn sàng</small>
                                        </div>
                                        <div class="stats-card d-inline-block">
                                            <h2 class="text-warning" id="loadingCount">0</h2>
                                            <small>Đang xếp</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="hub-filter-card">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <label class="font-weight-bold mb-2">Chọn Hub xuất phát:</label>
                                        <select class="form-control" id="hubSelect">
                                            <option value="">-- Tất cả Hub --</option>
                                            <c:forEach var="hub" items="${hubs}">
                                                <option value="${hub.hubId}">${hub.hubName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-8">
                                        <p class="mb-0"><i class="fas fa-info-circle mr-1"></i> Chỉ hiển thị các chuyến
                                            xe có trạng thái "loading"</p>
                                    </div>
                                </div>
                            </div>
                            <div class="row" id="tripContainer"></div>
                            <div class="text-center py-5" id="emptyState" style="display:none;">
                                <i class="fas fa-truck fa-4x text-muted mb-3" style="opacity: 0.3"></i>
                                <h5 class="text-muted">Không có chuyến xe nào đang chờ xuất bến</h5>
                                <p class="text-muted">Vui lòng tạo chuyến xe và xếp bao hàng trước</p>
                                <a href="${pageContext.request.contextPath}/manager/outbound/trip-planning"
                                    class="btn btn-primary mt-2">
                                    <i class="fas fa-plus mr-1"></i> Tạo chuyến mới
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="confirmModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title"><i class="fas fa-exclamation-triangle mr-2"></i> Xác nhận xuất bến
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body text-center py-4">
                            <i class="fas fa-truck-loading fa-3x text-success mb-3"></i>
                            <h5>Bạn có chắc chắn muốn xuất bến chuyến <strong id="confirmTripCode"></strong>?</h5>
                            <p class="text-muted">Thao tác này sẽ:</p>
                            <ul class="text-left">
                                <li>Chuyển trạng thái chuyến xe sang <span class="badge badge-info">on_way</span></li>
                                <li>Chuyển trạng thái xe sang <span class="badge badge-warning">in_transit</span></li>
                                <li>Chuyển tất cả đơn hàng sang <span class="badge badge-primary">in_transit</span></li>
                                <li>Ghi nhận lịch sử hành động "gate_out_hub"</li>
                            </ul>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-success" id="confirmGateOutBtn">
                                <i class="fas fa-check mr-1"></i> Xác nhận xuất bến
                            </button>
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
                var pendingTripId = null;

                $(document).ready(function () {
                    // Không gọi loadAllTrips() tự động vì API yêu cầu hubId
                    // loadAllTrips();

                    $('#hubSelect').change(function () {
                        var hubId = $(this).val();
                        if (hubId) {
                            loadTripsForHub(hubId);
                        } else {
                            // Clear danh sách nếu không chọn Hub
                            $('#tripContainer').empty();
                            $('#emptyState').show();
                            updateStats();
                        }
                    });

                    $('#confirmGateOutBtn').click(function () {
                        if (!pendingTripId) return;
                        $(this).prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-1"></i> Đang xử lý...');
                        $.ajax({
                            url: contextPath + '/api/manager/outbound/trips/' + pendingTripId + '/gate-out?actorId=' + managerId,
                            method: 'POST',
                            success: function (response) {
                                if (response.success) {
                                    $('#confirmModal').modal('hide');
                                    showToast('success', 'Xuất bến thành công!', 'Chuyến xe đã bắt đầu hành trình');
                                    setTimeout(function () { location.reload(); }, 1500);
                                } else {
                                    showToast('error', 'Lỗi xuất bến', response.message);
                                }
                            },
                            error: function (xhr) {
                                var error = xhr.responseJSON || {};
                                showToast('error', 'Lỗi xuất bến', error.message || 'Không thể xuất bến');
                            },
                            complete: function () {
                                $('#confirmGateOutBtn').prop('disabled', false).html('<i class="fas fa-check mr-1"></i> Xác nhận xuất bến');
                            }
                        });
                    });
                });

                function loadTripsForHub(hubId) {
                    $.get(contextPath + '/api/manager/outbound/trips?hubId=' + hubId, function (response) {
                        if (response.success) {
                            renderTrips(response.data);
                            updateStats();
                        }
                    });
                }

                function gateOut(tripId, tripCode) {
                    pendingTripId = tripId;
                    $('#confirmTripCode').text(tripCode);
                    $('#confirmModal').modal('show');
                }

                function renderTrips(trips) {
                    var container = $('#tripContainer');
                    container.empty();

                    if (!trips || trips.length === 0) {
                        $('#emptyState').show();
                        return;
                    }
                    $('#emptyState').hide();

                    trips.forEach(function (trip) {
                        var isReady = trip.containerCount > 0;
                        var totalWeight = trip.totalWeight || 0;
                        var vehicleCap = trip.vehicleCapacity || 0;
                        var loadPercent = vehicleCap > 0 ? (totalWeight / vehicleCap) * 100 : 0;
                        var capacityClass = loadPercent <= 70 ? 'capacity-safe' : (loadPercent <= 90 ? 'capacity-warning' : 'capacity-danger');
                        var cardClass = isReady ? 'trip-card-ready' : 'trip-card-not-ready';

                        // TripListResponse trả về flat fields, không phải nested objects
                        var vehiclePlate = trip.vehiclePlate || 'N/A';
                        var vehicleType = trip.vehicleType || '';
                        var driverName = trip.driverName || 'N/A';
                        var driverPhone = trip.driverPhone || '';
                        var fromHubName = trip.fromHubName || 'N/A';
                        var toHubName = trip.toHubName || 'N/A';

                        var card = '<div class="col-lg-6">' +
                            '<div class="' + cardClass + '">' +
                            '<div class="trip-card-header">' +
                            '<div><h5 class="mb-0 font-weight-bold text-dark">' + trip.tripCode + '</h5></div>' +
                            '<span class="badge badge-warning px-3 py-2">' + trip.status + '</span>' +
                            '</div>' +
                            '<div class="trip-card-body">' +
                            '<div class="row mb-3">' +
                            '<div class="col-md-6"><p class="mb-1"><i class="fas fa-truck text-primary mr-2"></i><strong>' + vehiclePlate + '</strong></p><small class="text-muted">' + vehicleType + ' - ' + vehicleCap + ' kg</small></div>' +
                            '<div class="col-md-6"><p class="mb-1"><i class="fas fa-user text-success mr-2"></i><strong>' + driverName + '</strong></p><small class="text-muted"><i class="fas fa-phone mr-1"></i>' + driverPhone + '</small></div>' +
                            '</div>' +
                            '<div class="route-display mb-3"><span class="route-hub">' + fromHubName + '</span><i class="fas fa-long-arrow-alt-right route-arrow"></i><span class="route-hub">' + toHubName + '</span></div>' +
                            '<div class="mb-3"><strong>Trọng tải:</strong><span class="float-right">' + totalWeight + '/' + vehicleCap + ' kg (' + loadPercent.toFixed(1) + '%)</span>' +
                            '<div class="capacity-bar"><div class="capacity-bar-fill ' + capacityClass + '" style="width:' + Math.min(loadPercent, 100) + '%"></div></div></div>' +
                            '<div class="mb-0"><strong>Bao hàng (' + trip.containerCount + '):</strong></div>' +
                            '</div>' +
                            '<div class="trip-card-footer">' +
                            '<span class="text-muted"><i class="fas fa-box mr-1"></i> ' + trip.containerCount + ' bao | <i class="fas fa-weight-hanging mr-1"></i> ' + totalWeight + ' kg</span>' +
                            (isReady ? '<button class="btn btn-success btn-gateout" onclick="gateOut(' + trip.tripId + ',\'' + trip.tripCode + '\')"><i class="fas fa-check-circle mr-1"></i> XUẤT BẾN</button>' : '<button class="btn btn-secondary" disabled><i class="fas fa-times-circle mr-1"></i> CHƯA SẴN SÀNG</button>') +
                            '</div></div></div>';

                        container.append(card);
                    });
                }

                function updateStats() {
                    var readyCount = $('.trip-card-ready').length;
                    var loadingCount = $('.trip-card-not-ready').length;
                    $('#readyCount').text(readyCount);
                    $('#loadingCount').text(loadingCount);
                }

                function showToast(type, title, message) {
                    var icons = { 'success': 'fa-check-circle', 'error': 'fa-times-circle', 'warning': 'fa-exclamation-triangle', 'info': 'fa-info-circle' };
                    var toastHtml = '<div class="custom-toast ' + type + '"><div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div><div class="toast-content"><div class="toast-title">' + title + '</div><div class="toast-message">' + message + '</div></div><button class="toast-close" onclick="closeToast(this)">&times;</button></div>';
                    var $toast = $(toastHtml);
                    $('#toastContainer').append($toast);
                    setTimeout(function () { $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }, 4000);
                }
                function closeToast(btn) { var $toast = $(btn).closest('.custom-toast'); $toast.css('animation', 'slideOut 0.3s ease'); setTimeout(function () { $toast.remove(); }, 300); }
            </script>
        </body>

        </html>