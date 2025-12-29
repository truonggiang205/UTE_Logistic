<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">Bảng điều khiển Logistic</h1>
                <button class="btn btn-sm btn-primary shadow-sm" onclick="refreshDashboardData()">
                    <i class="fas fa-sync-alt fa-sm"></i> Làm mới dữ liệu
                </button>
            </div>

            <div class="row">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Đơn mới</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="kpiNewOrder">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-box fa-2x text-gray-300"></i></div>
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
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="kpiCompleted">0</div>
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
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tổng doanh thu
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="kpiRevenue">0đ</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-hand-holding-usd fa-2x text-gray-300"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-danger shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Sự cố
                                        (Hủy/Lỗi)</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800" id="kpiIncident">0</div>
                                </div>
                                <div class="col-auto"><i class="fas fa-exclamation-circle fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xl-6 col-lg-6">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Doanh thu 7 ngày gần nhất</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-area" style="height: 320px;"><canvas id="revenueChart"></canvas></div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 bg-primary">
                            <h6 class="m-0 font-weight-bold text-white">Top Hub hiệu quả</h6>
                        </div>
                        <div class="card-body" id="topHubList" style="max-height: 320px; overflow-y: auto;"></div>
                    </div>
                </div>

                <div class="col-xl-3 col-lg-3">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 bg-success">
                            <h6 class="m-0 font-weight-bold text-white">Top Shipper</h6>
                        </div>
                        <div class="card-body" id="topShipperList" style="max-height: 320px; overflow-y: auto;"></div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            var myChart; // Dùng var để tương thích tốt hơn

            function refreshDashboardData() {
                // Dùng đường dẫn trực tiếp, không dùng biến template để tránh đụng độ JSP
                var apiUrl = '/api/admin/dashboard';

                // 1. KPI
                fetch(apiUrl + '/kpi')
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        document.getElementById('kpiNewOrder').innerText = data.newOrders || 0;
                        document.getElementById('kpiCompleted').innerText = data.completedOrders || 0;
                        document.getElementById('kpiIncident').innerText = data.incidentCount || 0;
                        document.getElementById('kpiRevenue').innerText = new Intl.NumberFormat('vi-VN').format(data.totalRevenue || 0) + 'đ';
                    })
                    .catch(function (err) { console.error("Lỗi KPI:", err); });

                // 2. Chart
                fetch(apiUrl + '/revenue-chart')
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var ctx = document.getElementById('revenueChart').getContext('2d');
                        if (myChart) myChart.destroy();
                        myChart = new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: data.labels,
                                datasets: [{
                                    label: 'Doanh thu (VNĐ)',
                                    data: data.data,
                                    borderColor: '#4e73df',
                                    backgroundColor: 'rgba(78, 115, 223, 0.1)',
                                    fill: true,
                                    tension: 0.3
                                }]
                            },
                            options: { maintainAspectRatio: false }
                        });
                    });

                // 3. Top Hubs
                // 3. Top Hubs (Hiển thị cả Success và Pending)
                fetch(apiUrl + '/top-hubs')
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var html = '<div class="list-group list-group-flush">';
                        data.forEach(function (h) {
                            html += '<div class="list-group-item px-0 py-2">' +
                                '<div class="row align-items-center no-gutters">' +
                                '<div class="col mr-2">' +
                                '<h6 class="mb-0 small text-primary font-weight-bold">' + h.name + '</h6>' +
                                '<small class="text-muted d-block text-truncate" style="max-width:180px;">' + (h.extraInfo || '') + '</small>' +
                                '</div>' +
                                '<div class="col-auto text-right">' +
                                '<div class="badge badge-success mb-1" title="Thành công">' + (h.successCount || 0) + ' <i class="fas fa-check"></i></div><br>' +
                                '<div class="badge badge-warning" title="Đang xử lý">' + (h.pendingCount || 0) + ' <i class="fas fa-clock"></i></div>' +
                                '</div>' +
                                '</div>' +
                                '</div>';
                        });
                        document.getElementById('topHubList').innerHTML = html + '</div>';
                    });

                // 4. Top Shippers (Hiển thị hiệu suất giao hàng)
                fetch(apiUrl + '/top-shippers')
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var html = '<div class="list-group list-group-flush">';
                        data.forEach(function (s) {
                            var total = (s.successCount || 0) + (s.pendingCount || 0);
                            var percent = total > 0 ? Math.round((s.successCount / total) * 100) : 0;

                            html += '<div class="list-group-item px-0 py-2">' +
                                '<div class="mb-1 d-flex justify-content-between align-items-center">' +
                                '<div>' +
                                '<strong class="small">' + s.name + '</strong> ' +
                                '<small class="text-muted">(' + s.extraInfo + ')</small>' +
                                '</div>' +
                                '<span class="badge badge-info">' + percent + '%</span>' +
                                '</div>' +
                                '<div class="progress progress-sm" style="height: 5px;">' +
                                '<div class="progress-bar bg-success" role="progressbar" style="width: ' + percent + '%"></div>' +
                                '</div>' +
                                '<div class="d-flex justify-content-between mt-1">' +
                                '<small class="text-success">' + s.successCount + ' xong</small>' +
                                '<small class="text-warning">' + s.pendingCount + ' đang đi</small>' +
                                '</div>' +
                                '</div>';
                        });
                        document.getElementById('topShipperList').innerHTML = html + '</div>';
                    });
            }

            // Tự động làm mới
            setInterval(refreshDashboardData, 300000);
            // Chạy khi trang sẵn sàng
            document.addEventListener("DOMContentLoaded", function () {
                refreshDashboardData();
            });
        </script>