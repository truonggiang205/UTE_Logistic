<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-route text-primary"></i> Giám sát Chuyến xe
                </h1>
                <span class="badge badge-info px-3 py-2" id="liveIndicator">
                    <i class="fas fa-circle text-success mr-1" style="font-size: 8px;"></i> Dữ liệu trực tiếp
                </span>
            </div>

            <!-- Filter Section -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Bộ lọc chuyến xe</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="small font-weight-bold">Hub đi</label>
                            <select class="form-control" id="filterFromHub" onchange="loadTrips()">
                                <option value="">-- Tất cả --</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="small font-weight-bold">Hub đến</label>
                            <select class="form-control" id="filterToHub" onchange="loadTrips()">
                                <option value="">-- Tất cả --</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="small font-weight-bold">Trạng thái</label>
                            <select class="form-control" id="filterStatus" onchange="loadTrips()">
                                <option value="">-- Tất cả --</option>
                                <option value="loading">Đang xếp hàng</option>
                                <option value="on_way">Đang chạy</option>
                                <option value="completed">Hoàn thành</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="small font-weight-bold">Ngày</label>
                            <input type="date" class="form-control" id="filterDate" onchange="loadTrips()">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button class="btn btn-secondary btn-block" onclick="resetFilters()">
                                <i class="fas fa-redo"></i> Đặt lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Đang xếp hàng
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="statLoading">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-boxes fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Đang trên
                                        đường</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="statOnWay">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-truck fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Hoàn thành
                                        hôm nay</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="statCompleted">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-check-circle fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tổng chuyến
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="statTotal">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-list fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Data Table -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách chuyến xe</h6>
                    <button class="btn btn-sm btn-outline-primary" onclick="loadTrips()">
                        <i class="fas fa-sync-alt"></i> Làm mới
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                            <thead class="bg-light">
                                <tr>
                                    <th>Mã chuyến</th>
                                    <th>Biển số xe</th>
                                    <th>Tài xế</th>
                                    <th>Tuyến đường</th>
                                    <th>Giờ đi</th>
                                    <th>Giờ đến</th>
                                    <th>Trạng thái</th>
                                    <th style="width: 80px;">Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody id="tripListData">
                                <tr>
                                    <td colspan="8" class="text-center">Đang tải dữ liệu...</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <nav>
                        <ul class="pagination justify-content-center" id="pagination"></ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Modal Chi tiết Chuyến xe -->
        <div class="modal fade" id="tripDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-truck mr-2"></i> Chi tiết chuyến xe: <span id="detailTripCode"></span>
                        </h5>
                        <button class="close text-white" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Trip Info -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card border-left-info h-100">
                                    <div class="card-body">
                                        <h6 class="font-weight-bold text-info mb-3">
                                            <i class="fas fa-truck"></i> Thông tin Xe
                                        </h6>
                                        <p><strong>Biển số:</strong> <span id="detailPlateNumber"></span></p>
                                        <p><strong>Loại xe:</strong> <span id="detailVehicleType"></span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card border-left-success h-100">
                                    <div class="card-body">
                                        <h6 class="font-weight-bold text-success mb-3">
                                            <i class="fas fa-user"></i> Thông tin Tài xế
                                        </h6>
                                        <p><strong>Họ tên:</strong> <span id="detailDriverName"></span></p>
                                        <p><strong>SĐT:</strong> <span id="detailDriverPhone"></span></p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Route Info -->
                        <div class="card border-left-warning mb-4">
                            <div class="card-body">
                                <h6 class="font-weight-bold text-warning mb-3">
                                    <i class="fas fa-route"></i> Thông tin Tuyến đường
                                </h6>
                                <div class="row">
                                    <div class="col-md-4">
                                        <p class="mb-1"><strong>Hub đi:</strong></p>
                                        <p class="text-primary" id="detailFromHub">-</p>
                                    </div>
                                    <div class="col-md-1 text-center d-flex align-items-center justify-content-center">
                                        <i class="fas fa-arrow-right text-muted fa-2x"></i>
                                    </div>
                                    <div class="col-md-4">
                                        <p class="mb-1"><strong>Hub đến:</strong></p>
                                        <p class="text-danger" id="detailToHub">-</p>
                                    </div>
                                    <div class="col-md-3 text-right">
                                        <p class="mb-1"><strong>Trạng thái:</strong></p>
                                        <span id="detailStatus"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Containers List -->
                        <h6 class="font-weight-bold text-primary mb-3">
                            <i class="fas fa-box"></i> Danh sách Bao hàng trên chuyến (<span
                                id="containerCount">0</span> bao)
                        </h6>
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Mã bao</th>
                                        <th>Loại</th>
                                        <th>Trọng lượng</th>
                                        <th>Hub đích</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody id="containerListData">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Không có bao hàng</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var API_BASE = window.location.origin + '/api/admin/trips';
            var HUB_API = window.location.origin + '/api/admin/hubs/filter';
            var currentPage = 0;
            var pageSize = 10;

            // Load data on page ready
            document.addEventListener('DOMContentLoaded', function () {
                loadHubs();
                loadTrips();
                // Set default date to today
                document.getElementById('filterDate').value = new Date().toISOString().split('T')[0];
            });

            function loadHubs() {
                fetch(HUB_API)
                    .then(function (res) { return res.json(); })
                    .then(function (hubs) {
                        var html = '<option value="">-- Tất cả --</option>';
                        for (var i = 0; i < hubs.length; i++) {
                            html += '<option value="' + hubs[i].hubId + '">' + hubs[i].hubName + '</option>';
                        }
                        document.getElementById('filterFromHub').innerHTML = html;
                        document.getElementById('filterToHub').innerHTML = html;
                    })
                    .catch(function (err) {
                        console.error('Error loading hubs:', err);
                    });
            }

            function loadTrips() {
                var fromHubId = document.getElementById('filterFromHub').value;
                var toHubId = document.getElementById('filterToHub').value;
                var status = document.getElementById('filterStatus').value;
                var date = document.getElementById('filterDate').value;

                var url = API_BASE + '?page=' + currentPage + '&size=' + pageSize;
                if (fromHubId) url += '&fromHubId=' + fromHubId;
                if (toHubId) url += '&toHubId=' + toHubId;
                if (status) url += '&status=' + status;
                if (date) url += '&date=' + date;

                fetch(url)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            renderTable(response.data.content);
                            renderPagination(response.data);
                            updateStats(response.data.content, response.data.totalElements);
                        } else {
                            document.getElementById('tripListData').innerHTML =
                                '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Error:', err);
                        document.getElementById('tripListData').innerHTML =
                            '<tr><td colspan="8" class="text-center text-danger">Lỗi kết nối server</td></tr>';
                    });
            }

            function updateStats(trips, total) {
                var loading = 0, onWay = 0, completed = 0;
                for (var i = 0; i < trips.length; i++) {
                    switch (trips[i].status) {
                        case 'loading': loading++; break;
                        case 'on_way': onWay++; break;
                        case 'completed': completed++; break;
                    }
                }
                document.getElementById('statLoading').innerText = loading;
                document.getElementById('statOnWay').innerText = onWay;
                document.getElementById('statCompleted').innerText = completed;
                document.getElementById('statTotal').innerText = total;
            }

            function renderTable(trips) {
                if (!trips || trips.length === 0) {
                    document.getElementById('tripListData').innerHTML =
                        '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
                    return;
                }

                var html = '';
                for (var i = 0; i < trips.length; i++) {
                    var t = trips[i];
                    var statusBadge = getStatusBadge(t.status);
                    var departedAt = t.departedAt ? formatDateTime(t.departedAt) : '<span class="text-muted">Chưa xuất phát</span>';
                    var arrivedAt = t.arrivedAt ? formatDateTime(t.arrivedAt) : '<span class="text-muted">-</span>';

                    html += '<tr>' +
                        '<td><strong class="text-primary">' + t.tripCode + '</strong></td>' +
                        '<td><i class="fas fa-truck text-muted mr-1"></i>' + t.plateNumber + '</td>' +
                        '<td>' + t.driverName + '</td>' +
                        '<td><span class="text-success">' + t.fromHubName + '</span>' +
                        ' <i class="fas fa-arrow-right text-muted mx-1"></i> ' +
                        '<span class="text-danger">' + t.toHubName + '</span></td>' +
                        '<td>' + departedAt + '</td>' +
                        '<td>' + arrivedAt + '</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '<td class="text-center">' +
                        '<button class="btn btn-sm btn-outline-primary" onclick="viewTripDetail(' + t.tripId + ')" title="Xem chi tiết">' +
                        '<i class="fas fa-eye"></i></button>' +
                        '</td>' +
                        '</tr>';
                }
                document.getElementById('tripListData').innerHTML = html;
            }

            function getStatusBadge(status) {
                switch (status) {
                    case 'loading':
                        return '<span class="badge badge-warning"><i class="fas fa-boxes"></i> Đang xếp</span>';
                    case 'on_way':
                        return '<span class="badge badge-primary"><i class="fas fa-truck"></i> Đang chạy</span>';
                    case 'completed':
                        return '<span class="badge badge-success"><i class="fas fa-check"></i> Hoàn thành</span>';
                    default:
                        return '<span class="badge badge-light">' + status + '</span>';
                }
            }

            function formatDateTime(dateStr) {
                var date = new Date(dateStr);
                return date.toLocaleString('vi-VN', {
                    day: '2-digit', month: '2-digit',
                    hour: '2-digit', minute: '2-digit'
                });
            }

            function renderPagination(pageData) {
                var html = '';
                var totalPages = pageData.totalPages;

                if (totalPages <= 1) {
                    document.getElementById('pagination').innerHTML = '';
                    return;
                }

                html += '<li class="page-item ' + (pageData.first ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage - 1) + ')">Trước</a></li>';

                for (var i = 0; i < totalPages; i++) {
                    if (i === currentPage) {
                        html += '<li class="page-item active"><a class="page-link" href="javascript:void(0)">' + (i + 1) + '</a></li>';
                    } else if (Math.abs(i - currentPage) <= 2 || i === 0 || i === totalPages - 1) {
                        html += '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(' + i + ')">' + (i + 1) + '</a></li>';
                    } else if (Math.abs(i - currentPage) === 3) {
                        html += '<li class="page-item disabled"><a class="page-link">...</a></li>';
                    }
                }

                html += '<li class="page-item ' + (pageData.last ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage + 1) + ')">Sau</a></li>';

                document.getElementById('pagination').innerHTML = html;
            }

            function goToPage(page) {
                currentPage = page;
                loadTrips();
            }

            function resetFilters() {
                document.getElementById('filterFromHub').value = '';
                document.getElementById('filterToHub').value = '';
                document.getElementById('filterStatus').value = '';
                document.getElementById('filterDate').value = new Date().toISOString().split('T')[0];
                currentPage = 0;
                loadTrips();
            }

            function viewTripDetail(tripId) {
                fetch(API_BASE + '/' + tripId)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            var t = response.data;

                            // Fill trip info
                            document.getElementById('detailTripCode').innerText = t.tripCode;
                            document.getElementById('detailPlateNumber').innerText = t.plateNumber;
                            document.getElementById('detailVehicleType').innerText = t.vehicleType || '-';
                            document.getElementById('detailDriverName').innerText = t.driverName;
                            document.getElementById('detailDriverPhone').innerText = t.driverPhone || '-';
                            document.getElementById('detailFromHub').innerText = t.fromHubName;
                            document.getElementById('detailToHub').innerText = t.toHubName;
                            document.getElementById('detailStatus').innerHTML = getStatusBadge(t.status);

                            // Fill containers
                            var containers = t.containers || [];
                            document.getElementById('containerCount').innerText = containers.length;

                            if (containers.length === 0) {
                                document.getElementById('containerListData').innerHTML =
                                    '<tr><td colspan="5" class="text-center text-muted">Không có bao hàng</td></tr>';
                            } else {
                                var html = '';
                                var nf = new Intl.NumberFormat('vi-VN');
                                for (var i = 0; i < containers.length; i++) {
                                    var c = containers[i];
                                    html += '<tr>' +
                                        '<td><strong>' + c.containerCode + '</strong></td>' +
                                        '<td>' + getContainerTypeBadge(c.type) + '</td>' +
                                        '<td>' + nf.format(c.weight || 0) + ' kg</td>' +
                                        '<td>' + (c.destinationHubName || '-') + '</td>' +
                                        '<td>' + getContainerStatusBadge(c.status) + '</td>' +
                                        '</tr>';
                                }
                                document.getElementById('containerListData').innerHTML = html;
                            }

                            $('#tripDetailModal').modal('show');
                        }
                    });
            }

            function getContainerTypeBadge(type) {
                var badges = {
                    'standard': '<span class="badge badge-secondary">Thường</span>',
                    'fragile': '<span class="badge badge-warning">Dễ vỡ</span>',
                    'frozen': '<span class="badge badge-info">Đông lạnh</span>',
                    'express': '<span class="badge badge-danger">Hỏa tốc</span>'
                };
                return badges[type] || '<span class="badge badge-light">' + type + '</span>';
            }

            function getContainerStatusBadge(status) {
                var badges = {
                    'created': '<span class="badge badge-secondary">Mới tạo</span>',
                    'closed': '<span class="badge badge-info">Đã đóng</span>',
                    'loaded': '<span class="badge badge-primary">Đã xếp</span>',
                    'received': '<span class="badge badge-success">Đã nhận</span>',
                    'unpacked': '<span class="badge badge-dark">Đã xả</span>'
                };
                return badges[status] || '<span class="badge badge-light">' + status + '</span>';
            }
        </script>