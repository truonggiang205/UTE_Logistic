<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <!-- Page Heading -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-desktop text-primary"></i> Trung tâm Giám sát Hệ thống
                </h1>
                <button class="btn btn-sm btn-primary shadow-sm" onclick="reloadAll()">
                    <i class="fas fa-sync-alt fa-sm text-white-50"></i> Làm mới
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng Logs
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-totalLogs">--</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-list-ol fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">User hoạt
                                        động</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-activeUsers">--</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-users fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Top Action</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-topAction">--</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-bolt fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Top User
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-mostActiveUser">--
                                    </div>
                                </div>
                                <div class="col-auto"><i class="fas fa-crown fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Risk Alert Area -->
            <div id="risk-alert-area" class="d-none mb-4">
                <div class="alert alert-danger shadow">
                    <h6 class="alert-heading font-weight-bold">
                        <i class="fas fa-exclamation-triangle"></i> Cảnh báo rủi ro vận hành
                    </h6>
                    <div id="risk-content" class="small"></div>
                    <hr>
                    <a href="${pageContext.request.contextPath}/admin/risk-alerts" class="btn btn-sm btn-danger">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                </div>
            </div>

            <!-- Filter Card -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-filter"></i> Bộ lọc 3 tầng (Thời gian / User / Action)
                    </h6>
                </div>
                <div class="card-body">
                    <form id="filterForm">
                        <div class="row">
                            <!-- Tầng 1: Thời gian -->
                            <div class="col-md-3 mb-3">
                                <label class="small font-weight-bold text-gray-600">Từ ngày</label>
                                <input type="datetime-local" class="form-control form-control-sm" id="fromDate">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="small font-weight-bold text-gray-600">Đến ngày</label>
                                <input type="datetime-local" class="form-control form-control-sm" id="toDate">
                            </div>
                            <!-- Tầng 2: User -->
                            <div class="col-md-2 mb-3">
                                <label class="small font-weight-bold text-gray-600">Người dùng</label>
                                <input type="text" class="form-control form-control-sm" id="username"
                                    placeholder="Username...">
                            </div>
                            <!-- Tầng 3: Action -->
                            <div class="col-md-2 mb-3">
                                <label class="small font-weight-bold text-gray-600">Hành động</label>
                                <select class="form-control form-control-sm" id="action">
                                    <option value="">-- Tất cả --</option>
                                    <option value="LOGIN">LOGIN</option>
                                    <option value="LOGOUT">LOGOUT</option>
                                    <option value="CREATE">CREATE</option>
                                    <option value="UPDATE">UPDATE</option>
                                    <option value="DELETE">DELETE</option>
                                    <option value="VIEW">VIEW</option>
                                    <option value="EXPORT">EXPORT</option>
                                </select>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="small font-weight-bold text-gray-600">Đối tượng</label>
                                <select class="form-control form-control-sm" id="objectType">
                                    <option value="">-- Tất cả --</option>
                                    <option value="USER">USER</option>
                                    <option value="SERVICE_REQUEST">SERVICE_REQUEST</option>
                                    <option value="SHIPPER">SHIPPER</option>
                                    <option value="HUB">HUB</option>
                                    <option value="PAYMENT">PAYMENT</option>
                                    <option value="COD">COD</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <button type="button" class="btn btn-primary btn-sm" onclick="loadData(0)">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="resetFilter()">
                                    <i class="fas fa-eraser"></i> Xóa bộ lọc
                                </button>
                                <button type="button" class="btn btn-success btn-sm" onclick="exportReport()">
                                    <i class="fas fa-file-excel"></i> Xuất Excel
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Log Table -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-table"></i> Bảng Log chi tiết
                    </h6>
                    <span class="badge badge-primary" id="totalLogsLabel">0 logs</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="logTable" width="100%" cellspacing="0">
                            <thead class="thead-light">
                                <tr>
                                    <th width="5%">ID</th>
                                    <th width="18%">Thời gian</th>
                                    <th width="15%">Người dùng</th>
                                    <th width="12%">Hành động</th>
                                    <th width="15%">Đối tượng</th>
                                    <th width="10%">Object ID</th>
                                </tr>
                            </thead>
                            <tbody id="logTableBody">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        <i class="fas fa-spinner fa-spin"></i> Đang tải dữ liệu...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div class="small text-muted" id="paginationInfo">Trang 1 / 1</div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0" id="pagination"></ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var BASE_API = '/api/system-log/monitoring';
            var currentPage = 0;
            var pageSize = 20;

            document.addEventListener('DOMContentLoaded', function () {
                loadData(0);
            });

            function getFilterBody() {
                return {
                    fromDate: document.getElementById('fromDate').value || null,
                    toDate: document.getElementById('toDate').value || null,
                    username: document.getElementById('username').value || null,
                    action: document.getElementById('action').value || null,
                    objectType: document.getElementById('objectType').value || null
                };
            }

            function loadData(page) {
                currentPage = page;
                var requestBody = getFilterBody();

                // Load Logs
                fetch(BASE_API + '/logs?page=' + page + '&size=' + pageSize, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(requestBody)
                })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        renderTable(data.content);
                        renderPagination(data.totalPages, data.number, data.totalElements);
                    })
                    .catch(function (err) {
                        console.error('Error loading logs:', err);
                        document.getElementById('logTableBody').innerHTML =
                            '<tr><td colspan="6" class="text-center text-danger py-4">' +
                            '<i class="fas fa-exclamation-circle"></i> Lỗi kết nối API</td></tr>';
                    });

                // Load Stats
                fetch(BASE_API + '/stats', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(requestBody)
                })
                    .then(function (res) { return res.json(); })
                    .then(function (stats) {
                        document.getElementById('stat-totalLogs').textContent = stats.totalLogs || 0;
                        document.getElementById('stat-activeUsers').textContent = stats.activeUsersCount || 0;
                        document.getElementById('stat-topAction').textContent = stats.topAction || 'N/A';
                        document.getElementById('stat-mostActiveUser').textContent = stats.mostActiveUser || 'N/A';
                    });

                // Load Risks
                loadRisks();
            }

            function loadRisks() {
                fetch(BASE_API + '/risks')
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var stuckCount = (data.stuckOrders || []).length;
                        var debtCount = (data.debtShippers || []).length;

                        if (stuckCount > 0 || debtCount > 0) {
                            document.getElementById('risk-alert-area').classList.remove('d-none');
                            var html = '';
                            if (stuckCount > 0) {
                                html += '<div><i class="fas fa-box text-danger"></i> Có <strong>' + stuckCount + '</strong> đơn hàng bị treo quá 3 ngày.</div>';
                            }
                            if (debtCount > 0) {
                                html += '<div><i class="fas fa-money-bill text-danger"></i> Có <strong>' + debtCount + '</strong> shipper nợ COD quá hạn (10tr/2ngày, 2tr/3ngày, hoặc &gt;7 ngày).</div>';
                            }
                            document.getElementById('risk-content').innerHTML = html;
                        } else {
                            document.getElementById('risk-alert-area').classList.add('d-none');
                        }
                    })
                    .catch(function (err) { console.error('Error loading risks:', err); });
            }

            function renderTable(list) {
                var tbody = document.getElementById('logTableBody');

                if (!list || list.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-4">' +
                        '<i class="fas fa-inbox"></i> Không có dữ liệu</td></tr>';
                    return;
                }

                var html = '';
                list.forEach(function (item) {
                    var logTime = item.logTime ? new Date(item.logTime).toLocaleString('vi-VN') : '';
                    var username = item.user ? item.user.username : '<span class="text-muted">System</span>';
                    var actionBadge = getActionBadge(item.action);

                    html += '<tr>' +
                        '<td><code>#' + item.logId + '</code></td>' +
                        '<td class="small">' + logTime + '</td>' +
                        '<td class="font-weight-bold text-primary">' + username + '</td>' +
                        '<td>' + actionBadge + '</td>' +
                        '<td><span class="badge badge-light">' + (item.objectType || '-') + '</span></td>' +
                        '<td><code>' + (item.objectId || '-') + '</code></td>' +
                        '</tr>';
                });
                tbody.innerHTML = html;
            }

            function getActionBadge(action) {
                var badgeClass = 'badge-secondary';
                switch (action) {
                    case 'LOGIN': badgeClass = 'badge-success'; break;
                    case 'LOGOUT': badgeClass = 'badge-warning'; break;
                    case 'CREATE': badgeClass = 'badge-primary'; break;
                    case 'UPDATE': badgeClass = 'badge-info'; break;
                    case 'DELETE': badgeClass = 'badge-danger'; break;
                    case 'VIEW': badgeClass = 'badge-light'; break;
                    case 'EXPORT': badgeClass = 'badge-dark'; break;
                }
                return '<span class="badge ' + badgeClass + '">' + (action || 'N/A') + '</span>';
            }

            function renderPagination(totalPages, current, totalElements) {
                document.getElementById('totalLogsLabel').textContent = totalElements + ' logs';
                document.getElementById('paginationInfo').textContent = 'Trang ' + (current + 1) + ' / ' + (totalPages || 1);

                var pagination = document.getElementById('pagination');
                var html = '';

                if (totalPages <= 1) {
                    pagination.innerHTML = '';
                    return;
                }

                // Previous button
                html += '<li class="page-item ' + (current === 0 ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="loadData(' + (current - 1) + ')">&laquo;</a></li>';

                // Page numbers (show max 5 pages)
                var startPage = Math.max(0, current - 2);
                var endPage = Math.min(totalPages, startPage + 5);

                for (var i = startPage; i < endPage; i++) {
                    html += '<li class="page-item ' + (i === current ? 'active' : '') + '">' +
                        '<a class="page-link" href="javascript:void(0)" onclick="loadData(' + i + ')">' + (i + 1) + '</a></li>';
                }

                // Next button
                html += '<li class="page-item ' + (current >= totalPages - 1 ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="loadData(' + (current + 1) + ')">&raquo;</a></li>';

                pagination.innerHTML = html;
            }

            function resetFilter() {
                document.getElementById('filterForm').reset();
                loadData(0);
            }

            function reloadAll() {
                loadData(currentPage);
            }

            function exportReport() {
                alert('Chức năng xuất Excel đang phát triển.');
            }
        </script>