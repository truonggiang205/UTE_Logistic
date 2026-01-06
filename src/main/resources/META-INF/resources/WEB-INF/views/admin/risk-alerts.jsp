<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <!-- Page Heading -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-exclamation-triangle text-danger"></i> Cảnh báo rủi ro vận hành
                </h1>
                <button class="btn btn-sm btn-primary shadow-sm" onclick="loadRiskData()">
                    <i class="fas fa-sync-alt fa-sm text-white-50"></i> Làm mới dữ liệu
                </button>
            </div>

            <!-- Alert Summary -->
            <div id="summaryAlert" class="alert alert-danger d-none mb-4">
                <div class="d-flex align-items-center">
                    <i class="fas fa-bell fa-2x mr-3"></i>
                    <div>
                        <h5 class="alert-heading mb-1">Phát hiện rủi ro cần xử lý!</h5>
                        <span id="summaryText"></span>
                    </div>
                </div>
            </div>

            <div id="noRiskAlert" class="alert alert-success d-none mb-4">
                <i class="fas fa-check-circle"></i> Hệ thống hoạt động bình thường, không có cảnh báo rủi ro nào.
            </div>

            <div class="row">
                <!-- Card: Đơn hàng bị treo -->
                <div class="col-xl-6 col-lg-12 mb-4">
                    <div class="card shadow h-100">
                        <div
                            class="card-header py-3 d-flex flex-row align-items-center justify-content-between bg-danger text-white">
                            <h6 class="m-0 font-weight-bold">
                                <i class="fas fa-box-open"></i> Đơn hàng bị "treo" (> 3 ngày không đổi trạng thái)
                            </h6>
                            <span class="badge badge-light" id="stuckOrderCount">0</span>
                        </div>
                        <div class="card-body">
                            <div id="stuckOrdersLoading" class="text-center py-4">
                                <div class="spinner-border text-danger" role="status">
                                    <span class="sr-only">Đang tải...</span>
                                </div>
                            </div>
                            <div id="stuckOrdersEmpty" class="text-center text-muted py-4 d-none">
                                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                <p>Không có đơn hàng nào bị treo. Tuyệt vời!</p>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-sm table-hover" id="stuckOrdersTable" style="display: none;">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Số ngày treo</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody id="stuckOrdersBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card: Shipper nợ COD -->
                <div class="col-xl-6 col-lg-12 mb-4">
                    <div class="card shadow h-100">
                        <div
                            class="card-header py-3 d-flex flex-row align-items-center justify-content-between bg-warning text-dark">
                            <h6 class="m-0 font-weight-bold">
                                <i class="fas fa-money-bill-wave"></i> Shipper nợ COD quá hạn
                            </h6>
                            <span class="badge badge-dark" id="debtShipperCount">0</span>
                        </div>
                        <div class="card-body">
                            <div class="small text-muted mb-2">
                                <strong>Tiêu chí cảnh báo:</strong><br>
                                &bull; Nợ &gt; 10 triệu VNĐ và quá 2 ngày<br>
                                &bull; Hoặc nợ &gt; 2 triệu VNĐ và quá 3 ngày<br>
                                &bull; Hoặc chưa nộp COD quá 7 ngày (bất kể số tiền)
                            </div>
                            <div class="card-body">
                                <div id="debtShippersLoading" class="text-center py-4">
                                    <div class="spinner-border text-warning" role="status">
                                        <span class="sr-only">Đang tải...</span>
                                    </div>
                                </div>
                                <div id="debtShippersEmpty" class="text-center text-muted py-4 d-none">
                                    <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                    <p>Không có shipper nào nợ quá hạn mức. Tuyệt vời!</p>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-sm table-hover" id="debtShippersTable"
                                        style="display: none;">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên Shipper</th>
                                                <th>Số điện thoại</th>
                                                <th>Tổng nợ COD</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody id="debtShippersBody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thống kê tổng quan -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-danger shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Đơn bị
                                            treo
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800" id="statStuckOrders">0</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-box fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Shipper
                                            nợ
                                            quá hạn</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800" id="statDebtShippers">0
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-user-times fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-info shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tổng nợ COD
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800" id="statTotalDebt">0 VNĐ
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card border-left-secondary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-secondary text-uppercase mb-1">Cập
                                            nhật
                                            lúc</div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800" id="statLastUpdate">--:--
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hướng dẫn xử lý -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-info-circle"></i> Hướng dẫn xử lý rủi ro
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="font-weight-bold text-danger"><i class="fas fa-box-open"></i> Đơn hàng bị
                                    treo:
                                </h6>
                                <ul class="small">
                                    <li>Kiểm tra lý do đơn không được xử lý (thiếu shipper, lỗi địa chỉ, v.v.)</li>
                                    <li>Liên hệ khách hàng để xác nhận thông tin</li>
                                    <li>Phân công lại shipper hoặc chuyển hub phù hợp</li>
                                    <li>Nếu không thể giao, tiến hành hủy đơn và hoàn tiền</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6 class="font-weight-bold text-warning"><i class="fas fa-money-bill-wave"></i> Shipper
                                    nợ
                                    COD:</h6>
                                <ul class="small">
                                    <li>Liên hệ shipper yêu cầu nộp tiền ngay lập tức</li>
                                    <li>Tạm ngưng phân công đơn mới cho shipper nợ quá hạn</li>
                                    <li>Báo cáo quản lý nếu shipper không hợp tác</li>
                                    <li>Theo dõi lịch sử thu hộ của shipper</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var RISK_API = '/api/system-log/monitoring/risks';

                document.addEventListener('DOMContentLoaded', function () {
                    loadRiskData();
                    // Tự động refresh mỗi 5 phút
                    setInterval(loadRiskData, 5 * 60 * 1000);
                });

                function loadRiskData() {
                    // Show loading
                    document.getElementById('stuckOrdersLoading').classList.remove('d-none');
                    document.getElementById('debtShippersLoading').classList.remove('d-none');
                    document.getElementById('stuckOrdersTable').style.display = 'none';
                    document.getElementById('debtShippersTable').style.display = 'none';
                    document.getElementById('stuckOrdersEmpty').classList.add('d-none');
                    document.getElementById('debtShippersEmpty').classList.add('d-none');

                    fetch(RISK_API)
                        .then(function (res) { return res.json(); })
                        .then(function (data) {
                            renderStuckOrders(data.stuckOrders || []);
                            renderDebtShippers(data.debtShippers || []);
                            updateSummary(data);
                            updateStats(data);
                        })
                        .catch(function (err) {
                            console.error('Lỗi tải dữ liệu cảnh báo:', err);
                            alert('Không thể tải dữ liệu cảnh báo. Vui lòng thử lại!');
                        });
                }

                function renderStuckOrders(orders) {
                    document.getElementById('stuckOrdersLoading').classList.add('d-none');
                    document.getElementById('stuckOrderCount').textContent = orders.length;

                    if (orders.length === 0) {
                        document.getElementById('stuckOrdersEmpty').classList.remove('d-none');
                        return;
                    }

                    document.getElementById('stuckOrdersTable').style.display = 'table';
                    var tbody = document.getElementById('stuckOrdersBody');
                    var html = '';

                    orders.forEach(function (order) {
                        var statusBadge = getStatusBadge(order.currentStatus);
                        var daysClass = order.daysStuck > 5 ? 'text-danger font-weight-bold' : 'text-warning';
                        var createdDate = order.createdTime ? new Date(order.createdTime).toLocaleDateString('vi-VN') : 'N/A';

                        html += '<tr>' +
                            '<td><code>#' + order.requestId + '</code></td>' +
                            '<td>' + statusBadge + '</td>' +
                            '<td>' + createdDate + '</td>' +
                            '<td class="' + daysClass + '">' + order.daysStuck + ' ngày</td>' +
                            '<td>' +
                            '<button class="btn btn-sm btn-outline-primary" onclick="viewOrderDetail(' + order.requestId + ')" title="Xem chi tiết">' +
                            '<i class="fas fa-eye"></i>' +
                            '</button>' +
                            '</td>' +
                            '</tr>';
                    });

                    tbody.innerHTML = html;
                }

                function renderDebtShippers(shippers) {
                    document.getElementById('debtShippersLoading').classList.add('d-none');
                    document.getElementById('debtShipperCount').textContent = shippers.length;

                    if (shippers.length === 0) {
                        document.getElementById('debtShippersEmpty').classList.remove('d-none');
                        return;
                    }

                    document.getElementById('debtShippersTable').style.display = 'table';
                    var tbody = document.getElementById('debtShippersBody');
                    var html = '';

                    shippers.forEach(function (shipper) {
                        var debtAmount = shipper.totalPendingCOD || 0;
                        var formattedDebt = new Intl.NumberFormat('vi-VN').format(debtAmount);
                        var debtClass = debtAmount > 10000000 ? 'text-danger font-weight-bold' : 'text-warning font-weight-bold';

                        html += '<tr>' +
                            '<td><code>#' + shipper.shipperId + '</code></td>' +
                            '<td>' + (shipper.shipperName || 'N/A') + '</td>' +
                            '<td><a href="tel:' + shipper.phone + '">' + (shipper.phone || 'N/A') + '</a></td>' +
                            '<td class="' + debtClass + '">' + formattedDebt + ' VNĐ</td>' +
                            '<td>' +
                            '<button class="btn btn-sm btn-outline-warning" onclick="contactShipper(\'' + shipper.phone + '\')" title="Liên hệ">' +
                            '<i class="fas fa-phone"></i>' +
                            '</button> ' +
                            '<button class="btn btn-sm btn-outline-info" onclick="viewShipperCOD(' + shipper.shipperId + ')" title="Xem chi tiết COD">' +
                            '<i class="fas fa-list"></i>' +
                            '</button>' +
                            '</td>' +
                            '</tr>';
                    });

                    tbody.innerHTML = html;
                }

                function updateSummary(data) {
                    var stuckCount = (data.stuckOrders || []).length;
                    var debtCount = (data.debtShippers || []).length;

                    if (stuckCount > 0 || debtCount > 0) {
                        document.getElementById('summaryAlert').classList.remove('d-none');
                        document.getElementById('noRiskAlert').classList.add('d-none');

                        var summaryParts = [];
                        if (stuckCount > 0) {
                            summaryParts.push('<strong>' + stuckCount + '</strong> đơn hàng bị treo');
                        }
                        if (debtCount > 0) {
                            summaryParts.push('<strong>' + debtCount + '</strong> shipper nợ COD quá hạn');
                        }
                        document.getElementById('summaryText').innerHTML = 'Phát hiện ' + summaryParts.join(' và ') + '. Vui lòng xử lý ngay!';
                    } else {
                        document.getElementById('summaryAlert').classList.add('d-none');
                        document.getElementById('noRiskAlert').classList.remove('d-none');
                    }
                }

                function updateStats(data) {
                    var stuckOrders = data.stuckOrders || [];
                    var debtShippers = data.debtShippers || [];

                    document.getElementById('statStuckOrders').textContent = stuckOrders.length;
                    document.getElementById('statDebtShippers').textContent = debtShippers.length;

                    // Tính tổng nợ COD
                    var totalDebt = 0;
                    debtShippers.forEach(function (s) {
                        totalDebt += (s.totalPendingCOD || 0);
                    });
                    document.getElementById('statTotalDebt').textContent = new Intl.NumberFormat('vi-VN').format(totalDebt) + ' VNĐ';

                    // Thời gian cập nhật
                    var now = new Date();
                    document.getElementById('statLastUpdate').textContent = now.toLocaleTimeString('vi-VN');
                }

                function getStatusBadge(status) {
                    var badgeClass = 'badge-secondary';
                    var statusText = status || 'N/A';

                    switch (status) {
                        case 'pending':
                            badgeClass = 'badge-warning';
                            statusText = 'Chờ xử lý';
                            break;
                        case 'confirmed':
                            badgeClass = 'badge-info';
                            statusText = 'Đã xác nhận';
                            break;
                        case 'picked_up':
                            badgeClass = 'badge-primary';
                            statusText = 'Đã lấy hàng';
                            break;
                        case 'in_transit':
                            badgeClass = 'badge-info';
                            statusText = 'Đang vận chuyển';
                            break;
                        case 'at_hub':
                            badgeClass = 'badge-secondary';
                            statusText = 'Tại hub';
                            break;
                        case 'out_for_delivery':
                            badgeClass = 'badge-primary';
                            statusText = 'Đang giao';
                            break;
                    }

                    return '<span class="badge ' + badgeClass + '">' + statusText + '</span>';
                }

                function viewOrderDetail(requestId) {
                    // Chuyển đến trang chi tiết đơn hàng
                    window.location.href = '${pageContext.request.contextPath}/admin/risk-alerts/' + requestId;
                }

                function contactShipper(phone) {
                    if (phone) {
                        window.open('tel:' + phone, '_self');
                    } else {
                        alert('Không có số điện thoại!');
                    }
                }

                function viewShipperCOD(shipperId) {
                    // Chuyển đến trang quản lý COD với filter theo shipper
                    window.location.href = '/admin/cod-management?shipperId=' + shipperId;
                }
            </script>