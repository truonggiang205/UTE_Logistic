<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <div class="container-fluid">
        <!-- Page Heading -->
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-800">
                <i class="fas fa-tachometer-alt"></i> Tổng quan Bưu cục
            </h1>
            <div>
                <span class="badge badge-info p-2" id="hubInfo">
                    <i class="fas fa-building"></i> Đang tải...
                </span>
                <button class="btn btn-sm btn-primary shadow-sm ml-2" onclick="loadDashboardStats()">
                    <i class="fas fa-sync-alt fa-sm text-white-50"></i> Làm mới
                </button>
            </div>
        </div>

        <!-- KPI Cards Row 1 - Tổng quan đơn hàng -->
        <div class="row">
            <!-- Tổng đơn hàng -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2 kpi-card" data-status="all"
                    data-title="Tổng đơn hàng" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                    Tổng đơn hàng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="totalOrders">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-box fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đang chờ xử lý -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-warning shadow h-100 py-2 kpi-card" data-status="pending"
                    data-title="Đơn chờ xử lý" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                    Chờ xử lý</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="pendingCount">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-clock fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đã lấy hàng -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-info shadow h-100 py-2 kpi-card" data-status="picked"
                    data-title="Đơn đã lấy hàng" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                    Đã lấy hàng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="pickedCount">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-hand-paper fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đang vận chuyển -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2 kpi-card" data-status="in_transit"
                    data-title="Đơn đang vận chuyển" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                    Đang vận chuyển</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="inTransitCount">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-truck fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPI Cards Row 2 - Hoàn thành & COD -->
        <div class="row">
            <!-- Giao thành công -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-success shadow h-100 py-2 kpi-card" data-status="delivered"
                    data-title="Đơn giao thành công" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                    Giao thành công</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="deliveredCount">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đã hủy / Thất bại -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-danger shadow h-100 py-2 kpi-card" data-status="cancelled,failed"
                    data-title="Đơn hủy / Thất bại" style="cursor: pointer;">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                    Hủy / Thất bại</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <span id="cancelledCount">0</span> / <span id="failedCount">0</span>
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-times-circle fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- COD đang giữ -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-warning shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                    COD đang giữ</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="codPending">0 ₫</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-money-bill-wave fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- COD đã thu -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-success shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                    COD đã thu</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="codCollected">0 ₫</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-wallet fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPI Cards Row 3 - Shipper & Task -->
        <div class="row">
            <!-- Shipper hoạt động -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-info shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                    Shipper hoạt động</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="activeShippers">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-user-tie fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Task hôm nay -->
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card border-left-primary shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                    Task hôm nay</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800" id="todayTasks">0</div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-tasks fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tỷ lệ thành công -->
            <div class="col-xl-6 col-md-12 mb-4">
                <div class="card border-left-success shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                    Tỷ lệ giao thành công</div>
                                <div class="row no-gutters align-items-center">
                                    <div class="col-auto">
                                        <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800" id="successRateText">0%
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="progress progress-sm mr-2">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: 0%"
                                                id="successRateBar" aria-valuenow="0" aria-valuemin="0"
                                                aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-auto">
                                <i class="fas fa-chart-line fa-2x text-gray-300"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Tracking Section -->
        <div class="row">
            <div class="col-12">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-search"></i> Tra cứu đơn hàng
                        </h6>
                    </div>
                    <div class="card-body">
                        <!-- Search Form -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <input type="text" class="form-control" id="trackingKeyword"
                                        placeholder="Nhập mã vận đơn (tracking code) hoặc số điện thoại..."
                                        onkeypress="if(event.keyCode==13) searchOrder()">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="button" onclick="searchOrder()">
                                            <i class="fas fa-search fa-sm"></i> Tìm kiếm
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-right">
                                <button class="btn btn-outline-secondary" onclick="clearSearch()">
                                    <i class="fas fa-eraser"></i> Xóa kết quả
                                </button>
                            </div>
                        </div>

                        <!-- Search Results -->
                        <div id="searchResults" style="display: none;">
                            <div class="alert alert-info" id="searchInfo">
                                <i class="fas fa-info-circle"></i> <span id="searchResultCount">0</span> kết quả tìm
                                thấy
                            </div>

                            <!-- Results Table -->
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover" id="ordersTable">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Người gửi</th>
                                            <th>Người nhận</th>
                                            <th>Trạng thái</th>
                                            <th>COD</th>
                                            <th>Hub hiện tại</th>
                                            <th>Ngày tạo</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody id="ordersTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- No Results Message -->
                        <div id="noResults" class="text-center py-4" style="display: none;">
                            <i class="fas fa-inbox fa-3x text-gray-300 mb-3"></i>
                            <p class="text-muted">Không tìm thấy đơn hàng nào</p>
                        </div>

                        <!-- Order Detail Modal Trigger Area -->
                        <div id="orderDetailArea" style="display: none;">
                            <hr>
                            <h5 class="font-weight-bold text-primary mb-3">
                                <i class="fas fa-info-circle"></i> Chi tiết đơn hàng #<span id="detailRequestId"></span>
                            </h5>

                            <div class="row">
                                <!-- Order Info -->
                                <div class="col-md-6">
                                    <div class="card mb-3">
                                        <div class="card-header bg-primary text-white py-2">
                                            <i class="fas fa-user"></i> Thông tin người gửi
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-1"><strong>Tên:</strong> <span id="detailSenderName">-</span>
                                            </p>
                                            <p class="mb-1"><strong>SĐT:</strong> <span id="detailSenderPhone">-</span>
                                            </p>
                                            <p class="mb-0"><strong>Địa chỉ:</strong> <span
                                                    id="detailPickupAddress">-</span></p>
                                        </div>
                                    </div>

                                    <div class="card mb-3">
                                        <div class="card-header bg-success text-white py-2">
                                            <i class="fas fa-map-marker-alt"></i> Thông tin người nhận
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-1"><strong>Tên:</strong> <span id="detailReceiverName">-</span>
                                            </p>
                                            <p class="mb-1"><strong>SĐT:</strong> <span
                                                    id="detailReceiverPhone">-</span></p>
                                            <p class="mb-0"><strong>Địa chỉ:</strong> <span
                                                    id="detailDeliveryAddress">-</span></p>
                                        </div>
                                    </div>

                                    <div class="card mb-3">
                                        <div class="card-header bg-info text-white py-2">
                                            <i class="fas fa-box"></i> Thông tin hàng hóa
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-1"><strong>Tên hàng:</strong> <span
                                                    id="detailItemName">-</span></p>
                                            <p class="mb-1"><strong>Trọng lượng:</strong> <span
                                                    id="detailWeight">-</span></p>
                                            <p class="mb-1"><strong>Kích thước:</strong> <span
                                                    id="detailDimensions">-</span></p>
                                            <p class="mb-1"><strong>Dịch vụ:</strong> <span
                                                    id="detailServiceType">-</span></p>
                                            <p class="mb-0"><strong>Ghi chú:</strong> <span id="detailNote">-</span></p>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header bg-warning py-2">
                                            <i class="fas fa-money-bill"></i> Thông tin thanh toán
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-1"><strong>Tiền COD:</strong> <span id="detailCodAmount"
                                                    class="text-danger font-weight-bold">-</span></p>
                                            <p class="mb-1"><strong>Phí ship:</strong> <span
                                                    id="detailShippingFee">-</span></p>
                                            <p class="mb-1"><strong>Tổng tiền:</strong> <span id="detailTotalPrice"
                                                    class="text-success font-weight-bold">-</span></p>
                                            <p class="mb-0"><strong>Trạng thái TT:</strong> <span
                                                    id="detailPaymentStatus">-</span></p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Timeline -->
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-header bg-secondary text-white py-2">
                                            <i class="fas fa-history"></i> Lịch sử hành trình
                                        </div>
                                        <div class="card-body" style="max-height: 600px; overflow-y: auto;">
                                            <div id="orderTimeline">
                                                <!-- Timeline items will be rendered here -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KPI Orders Modal -->
    <div class="modal fade" id="kpiOrdersModal" tabindex="-1" role="dialog" aria-labelledby="kpiOrdersModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="kpiOrdersModalLabel">
                        <i class="fas fa-list"></i> <span id="kpiModalTitle">Danh sách đơn hàng</span>
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="kpiModalLoading" class="text-center py-4">
                        <i class="fas fa-spinner fa-spin fa-2x text-primary"></i>
                        <p class="mt-2">Đang tải dữ liệu...</p>
                    </div>
                    <div id="kpiModalContent" style="display: none;">
                        <div class="alert alert-info mb-3">
                            <i class="fas fa-info-circle"></i> Tìm thấy <strong id="kpiOrderCount">0</strong> đơn hàng
                        </div>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-striped" id="kpiOrdersTable">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>#</th>
                                        <th>Mã vận đơn</th>
                                        <th>Mã đơn</th>
                                        <th>Người gửi</th>
                                        <th>Người nhận</th>
                                        <th>Trạng thái</th>
                                        <th>COD</th>
                                        <th>Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="kpiOrdersTableBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div id="kpiModalEmpty" class="text-center py-4" style="display: none;">
                        <i class="fas fa-inbox fa-3x text-gray-300 mb-3"></i>
                        <p class="text-muted">Không có đơn hàng nào</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        <i class="fas fa-times"></i> Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Custom Styles -->
    <style>
        .timeline-item {
            position: relative;
            padding-left: 30px;
            padding-bottom: 20px;
            border-left: 2px solid #e3e6f0;
        }

        .timeline-item:last-child {
            border-left: 2px solid transparent;
            padding-bottom: 0;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -8px;
            top: 0;
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: #4e73df;
            border: 2px solid #fff;
            box-shadow: 0 0 0 2px #4e73df;
        }

        .timeline-item:first-child::before {
            background: #1cc88a;
            box-shadow: 0 0 0 2px #1cc88a;
        }

        .timeline-item .timeline-time {
            font-size: 0.75rem;
            color: #858796;
        }

        .timeline-item .timeline-title {
            font-weight: 600;
            color: #5a5c69;
        }

        .timeline-item .timeline-desc {
            font-size: 0.85rem;
            color: #6e707e;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
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
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-delivered {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .status-failed {
            background: #f5c6cb;
            color: #721c24;
        }
    </style>

    <!-- JavaScript -->
    <script>
        var contextPath = '${pageContext.request.contextPath}';

        // Load dashboard stats on page load
        // Dùng window.addEventListener vì jQuery được load sau body content trong SiteMesh
        window.addEventListener('load', function () {
            // Đảm bảo jQuery đã sẵn sàng
            if (typeof $ !== 'undefined') {
                initDashboard();
            } else {
                // Fallback: đợi thêm 100ms nếu jQuery chưa sẵn sàng
                setTimeout(initDashboard, 100);
            }
        });

        function initDashboard() {
            console.log('Initializing dashboard...');
            // Gọi loadDashboardStats ngay khi trang load xong
            loadDashboardStats();

            // Add click event to KPI cards
            $('.kpi-card').on('click', function () {
                var status = $(this).data('status');
                var title = $(this).data('title');
                showOrdersByStatus(status, title);
            });
        }


        // Load Dashboard Statistics
        function loadDashboardStats() {
            console.log('Loading dashboard stats...');
            $.ajax({
                url: contextPath + '/api/manager/dashboard/stats',
                type: 'GET',
                cache: false,
                success: function (response) {
                    console.log('Dashboard stats response:', response);
                    if (response.success && response.data) {
                        var data = response.data;

                        // Update KPI cards
                        $('#totalOrders').text(formatNumber(data.totalOrders || 0));
                        $('#pendingCount').text(formatNumber(data.pendingCount || 0));
                        $('#pickedCount').text(formatNumber(data.pickedCount || 0));
                        $('#inTransitCount').text(formatNumber(data.inTransitCount || 0));
                        $('#deliveredCount').text(formatNumber(data.deliveredCount || 0));
                        $('#cancelledCount').text(formatNumber(data.cancelledCount || 0));
                        $('#failedCount').text(formatNumber(data.failedCount || 0));

                        // COD
                        $('#codPending').text(formatCurrency(data.currentCodPendingAmount || 0));
                        $('#codCollected').text(formatCurrency(data.totalCodCollected || 0));

                        // Shipper & Tasks
                        $('#activeShippers').text(formatNumber(data.activeShipperCount || 0));
                        $('#todayTasks').text(formatNumber(data.todayTaskCount || 0));

                        // Use success rate from API
                        var successRate = data.successRate || 0;
                        successRate = Math.round(successRate * 100) / 100; // Round to 2 decimals
                        $('#successRateText').text(successRate + '%');
                        $('#successRateBar').css('width', successRate + '%').attr('aria-valuenow', successRate);

                        // Hub info - show hub name hoặc hubId từ response
                        if (data.hubName) {
                            $('#hubInfo').html('<i class="fas fa-building"></i> Hub: ' + data.hubName);
                        } else if (response.hubId) {
                            $('#hubInfo').html('<i class="fas fa-building"></i> Hub ID: ' + response.hubId);
                        }
                    } else if (response.hubId) {
                        // Trường hợp không có data nhưng có hubId
                        $('#hubInfo').html('<i class="fas fa-building"></i> Hub ID: ' + response.hubId);
                    }
                },
                error: function (xhr) {
                    console.error('Error loading stats:', xhr);
                    if (xhr.status === 401) {
                        showToast('Vui lòng đăng nhập để xem thống kê', 'warning');
                        $('#hubInfo').html('<i class="fas fa-exclamation-triangle"></i> Chưa đăng nhập');
                    } else {
                        showToast('Lỗi khi tải thống kê', 'error');
                        $('#hubInfo').html('<i class="fas fa-times-circle"></i> Lỗi tải dữ liệu');
                    }
                }
            });
        }

        // Search Order
        function searchOrder() {
            var keyword = $('#trackingKeyword').val().trim();
            if (!keyword) {
                showToast('Vui lòng nhập mã đơn hoặc số điện thoại', 'warning');
                return;
            }

            $.ajax({
                url: contextPath + '/api/manager/tracking',
                type: 'GET',
                data: { keyword: keyword },
                success: function (response) {
                    if (response.success) {
                        var orders = response.data || [];
                        $('#searchResultCount').text(orders.length);

                        if (orders.length > 0) {
                            renderOrdersTable(orders);
                            $('#searchResults').show();
                            $('#noResults').hide();
                        } else {
                            $('#searchResults').hide();
                            $('#noResults').show();
                        }
                        $('#orderDetailArea').hide();
                    }
                },
                error: function (xhr) {
                    console.error('Error searching:', xhr);
                    showToast('Lỗi khi tìm kiếm đơn hàng', 'error');
                }
            });
        }

        // Render Orders Table
        function renderOrdersTable(orders) {
            var tbody = $('#ordersTableBody');
            tbody.empty();

            orders.forEach(function (order) {
                var statusBadge = getStatusBadge(order.status, order.statusDisplay);
                var row = '<tr>' +
                    '<td><strong>#' + order.requestId + '</strong></td>' +
                    '<td>' + (order.senderName || '-') + '<br><small class="text-muted">' + (order.senderPhone || '') + '</small></td>' +
                    '<td>' + (order.receiverName || '-') + '<br><small class="text-muted">' + (order.receiverPhone || '') + '</small></td>' +
                    '<td>' + statusBadge + '</td>' +
                    '<td class="text-danger">' + formatCurrency(order.codAmount || 0) + '</td>' +
                    '<td>' + (order.currentHubName || '-') + '</td>' +
                    '<td>' + formatDateTime(order.createdAt) + '</td>' +
                    '<td><button class="btn btn-sm btn-info" onclick="viewOrderDetail(' + order.requestId + ')">' +
                    '<i class="fas fa-eye"></i></button></td>' +
                    '</tr>';
                tbody.append(row);
            });
        }

        // View Order Detail
        function viewOrderDetail(requestId) {
            $.ajax({
                url: contextPath + '/api/manager/tracking/' + requestId,
                type: 'GET',
                success: function (response) {
                    if (response.success && response.data) {
                        var order = response.data;
                        renderOrderDetail(order);
                        $('#orderDetailArea').show();

                        // Scroll to detail
                        $('html, body').animate({
                            scrollTop: $('#orderDetailArea').offset().top - 100
                        }, 500);
                    }
                },
                error: function (xhr) {
                    console.error('Error loading detail:', xhr);
                    showToast('Lỗi khi tải chi tiết đơn hàng', 'error');
                }
            });
        }

        // Render Order Detail
        function renderOrderDetail(order) {
            $('#detailRequestId').text(order.requestId);

            // Sender info
            $('#detailSenderName').text(order.senderName || '-');
            $('#detailSenderPhone').text(order.senderPhone || '-');
            $('#detailPickupAddress').text(order.pickupAddress || '-');

            // Receiver info
            $('#detailReceiverName').text(order.receiverName || '-');
            $('#detailReceiverPhone').text(order.receiverPhone || '-');
            $('#detailDeliveryAddress').text(order.deliveryAddress || '-');

            // Item info
            $('#detailItemName').text(order.itemName || '-');
            $('#detailWeight').text(order.weight ? order.weight + ' kg' : '-');
            $('#detailDimensions').text(order.dimensions || '-');
            $('#detailServiceType').text(order.serviceTypeName || '-');
            $('#detailNote').text(order.note || '-');

            // Payment info
            $('#detailCodAmount').text(formatCurrency(order.codAmount || 0));
            $('#detailShippingFee').text(formatCurrency(order.shippingFee || 0));
            $('#detailTotalPrice').text(formatCurrency(order.totalPrice || 0));
            $('#detailPaymentStatus').html(getPaymentStatusBadge(order.paymentStatus));

            // Render timeline
            renderTimeline(order.actionHistory || []);
        }

        // Render Timeline
        function renderTimeline(actions) {
            var timeline = $('#orderTimeline');
            timeline.empty();

            if (!actions || actions.length === 0) {
                timeline.html('<p class="text-muted text-center"><i class="fas fa-info-circle"></i> Chưa có lịch sử hành trình</p>');
                return;
            }

            actions.forEach(function (action) {
                var hubInfo = '';
                if (action.fromHubName && action.toHubName) {
                    hubInfo = action.fromHubName + ' -> ' + action.toHubName;
                } else if (action.fromHubName) {
                    hubInfo = 'Tu: ' + action.fromHubName;
                } else if (action.toHubName) {
                    hubInfo = 'Den: ' + action.toHubName;
                }

                var item = '<div class="timeline-item">' +
                    '<div class="timeline-time">' + formatDateTime(action.actionTime) + '</div>' +
                    '<div class="timeline-title">' + (action.actionName || action.actionCode || '-') + '</div>' +
                    '<div class="timeline-desc">' +
                    (hubInfo ? '<div><i class="fas fa-building text-primary"></i> ' + hubInfo + '</div>' : '') +
                    (action.actorName ? '<div><i class="fas fa-user text-info"></i> ' + action.actorName + (action.actorPhone ? ' (' + action.actorPhone + ')' : '') + '</div>' : '') +
                    (action.note ? '<div><i class="fas fa-sticky-note text-warning"></i> ' + action.note + '</div>' : '') +
                    '</div></div>';
                timeline.append(item);
            });
        }

        // Clear Search
        function clearSearch() {
            $('#trackingKeyword').val('');
            $('#searchResults').hide();
            $('#noResults').hide();
            $('#orderDetailArea').hide();
        }

        // Show Orders By Status (KPI Card Click)
        function showOrdersByStatus(status, title) {
            $('#kpiModalTitle').text(title || 'Danh sách đơn hàng');
            $('#kpiModalLoading').show();
            $('#kpiModalContent').hide();
            $('#kpiModalEmpty').hide();
            $('#kpiOrdersModal').modal('show');

            $.ajax({
                url: contextPath + '/api/manager/orders',
                type: 'GET',
                data: { status: status },
                success: function (response) {
                    $('#kpiModalLoading').hide();

                    if (response.success && response.data && response.data.length > 0) {
                        var orders = response.data;
                        $('#kpiOrderCount').text(orders.length);
                        renderKpiOrdersTable(orders);
                        $('#kpiModalContent').show();
                    } else {
                        $('#kpiModalEmpty').show();
                    }
                },
                error: function (xhr) {
                    $('#kpiModalLoading').hide();
                    $('#kpiModalEmpty').show();
                    console.error('Error loading orders by status:', xhr);
                    showToast('Lỗi khi tải danh sách đơn hàng', 'error');
                }
            });
        }

        // Render KPI Orders Table
        function renderKpiOrdersTable(orders) {
            var tbody = $('#kpiOrdersTableBody');
            tbody.empty();

            orders.forEach(function (order, index) {
                var statusBadge = getStatusBadge(order.status, order.statusDisplay);
                var row = '<tr>' +
                    '<td>' + (index + 1) + '</td>' +
                    '<td><code>' + (order.trackingCode || '-') + '</code></td>' +
                    '<td><strong>#' + order.requestId + '</strong></td>' +
                    '<td>' + (order.senderName || '-') + '<br><small class="text-muted">' + (order.senderPhone || '') + '</small></td>' +
                    '<td>' + (order.receiverName || '-') + '<br><small class="text-muted">' + (order.receiverPhone || '') + '</small></td>' +
                    '<td>' + statusBadge + '</td>' +
                    '<td class="text-danger font-weight-bold">' + formatCurrency(order.codAmount || 0) + '</td>' +
                    '<td>' + formatDateTime(order.createdAt) + '</td>' +
                    '<td><button class="btn btn-sm btn-info" onclick="viewOrderFromModal(' + order.requestId + ')">' +
                    '<i class="fas fa-eye"></i></button></td>' +
                    '</tr>';
                tbody.append(row);
            });
        }

        // View Order from Modal (close modal and show detail)
        function viewOrderFromModal(requestId) {
            $('#kpiOrdersModal').modal('hide');
            setTimeout(function () {
                viewOrderDetail(requestId);
            }, 300);
        }

        // Helper Functions
        function formatNumber(num) {
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        function formatCurrency(amount) {
            if (amount === null || amount === undefined) return '0 VND';
            return formatNumber(Math.round(amount)) + ' VND';
        }

        function formatDateTime(dateStr) {
            if (!dateStr) return '-';
            try {
                var date = new Date(dateStr);
                var day = ('0' + date.getDate()).slice(-2);
                var month = ('0' + (date.getMonth() + 1)).slice(-2);
                var year = date.getFullYear();
                var hours = ('0' + date.getHours()).slice(-2);
                var minutes = ('0' + date.getMinutes()).slice(-2);
                return day + '/' + month + '/' + year + ' ' + hours + ':' + minutes;
            } catch (e) {
                return dateStr;
            }
        }

        function getStatusBadge(status, display) {
            var text = display || status || 'N/A';
            var cls = 'status-' + (status || 'pending');
            return '<span class="status-badge ' + cls + '">' + text + '</span>';
        }

        function getPaymentStatusBadge(status) {
            var badges = {
                'paid': '<span class="badge badge-success">Da thanh toan</span>',
                'unpaid': '<span class="badge badge-warning">Chua thanh toan</span>',
                'refunded': '<span class="badge badge-info">Da hoan tien</span>'
            };
            return badges[status] || '<span class="badge badge-secondary">' + (status || '-') + '</span>';
        }

        function showToast(message, type) {
            var alertClass = 'alert-info';
            if (type === 'error') alertClass = 'alert-danger';
            if (type === 'warning') alertClass = 'alert-warning';
            if (type === 'success') alertClass = 'alert-success';

            var toast = $('<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert" style="position:fixed;top:20px;right:20px;z-index:9999;min-width:300px;">' +
                message +
                '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>');
            $('body').append(toast);

            setTimeout(function () {
                toast.alert('close');
            }, 3000);
        }
    </script>