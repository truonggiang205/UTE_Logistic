<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <!-- Page Heading -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-file-alt text-primary"></i> Xuất Báo cáo Tổng hợp
                </h1>
            </div>

            <!-- Report Cards -->
            <div class="row">
                <!-- Báo cáo Doanh thu -->
                <div class="col-xl-4 col-md-6 mb-4">
                    <div class="card shadow h-100">
                        <div class="card-header py-3 bg-primary">
                            <h6 class="m-0 font-weight-bold text-white">
                                <i class="fas fa-chart-line"></i> Báo cáo Doanh thu
                            </h6>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted mb-3">
                                Thống kê doanh thu từ tất cả đơn hàng theo thời gian.
                                Bao gồm: Mã đơn, Doanh thu, Ngày tạo.
                            </p>
                            <form id="revenueForm">
                                <div class="form-group">
                                    <label class="small font-weight-bold">Từ ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm"
                                        id="revenueFromDate">
                                </div>
                                <div class="form-group">
                                    <label class="small font-weight-bold">Đến ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm"
                                        id="revenueToDate">
                                </div>
                            </form>
                        </div>
                        <div class="card-footer bg-light">
                            <button class="btn btn-success btn-sm btn-block" onclick="exportReport('REVENUE')">
                                <i class="fas fa-file-excel"></i> Xuất Excel
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Báo cáo Hiệu suất Hub -->
                <div class="col-xl-4 col-md-6 mb-4">
                    <div class="card shadow h-100">
                        <div class="card-header py-3 bg-info">
                            <h6 class="m-0 font-weight-bold text-white">
                                <i class="fas fa-warehouse"></i> Báo cáo Hiệu suất Hub
                            </h6>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted mb-3">
                                Đánh giá hiệu suất hoạt động của các Hub/Kho.
                                Bao gồm: Tên Hub, Số lượng hàng xử lý, Tỉ lệ hoàn thành.
                            </p>
                            <form id="hubForm">
                                <div class="form-group">
                                    <label class="small font-weight-bold">Từ ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm" id="hubFromDate">
                                </div>
                                <div class="form-group">
                                    <label class="small font-weight-bold">Đến ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm" id="hubToDate">
                                </div>
                            </form>
                        </div>
                        <div class="card-footer bg-light">
                            <button class="btn btn-success btn-sm btn-block" onclick="exportReport('HUB_PERFORMANCE')">
                                <i class="fas fa-file-excel"></i> Xuất Excel
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Báo cáo Công nợ COD -->
                <div class="col-xl-4 col-md-6 mb-4">
                    <div class="card shadow h-100">
                        <div class="card-header py-3 bg-warning">
                            <h6 class="m-0 font-weight-bold text-white">
                                <i class="fas fa-money-bill-wave"></i> Báo cáo Công nợ COD
                            </h6>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted mb-3">
                                Tổng hợp công nợ COD của Shipper.
                                Bao gồm: Tên Shipper, Số tiền nợ, SĐT liên hệ.
                            </p>
                            <form id="codForm">
                                <div class="form-group">
                                    <label class="small font-weight-bold">Từ ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm" id="codFromDate">
                                </div>
                                <div class="form-group">
                                    <label class="small font-weight-bold">Đến ngày</label>
                                    <input type="datetime-local" class="form-control form-control-sm" id="codToDate">
                                </div>
                            </form>
                        </div>
                        <div class="card-footer bg-light">
                            <button class="btn btn-success btn-sm btn-block" onclick="exportReport('COD_DEBT')">
                                <i class="fas fa-file-excel"></i> Xuất Excel
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Báo cáo Vận tải -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-dark">
                    <h6 class="m-0 font-weight-bold text-white">
                        <i class="fas fa-truck"></i> Báo cáo Vận tải
                    </h6>
                </div>
                <div class="card-body">
                    <p class="small text-muted mb-3">
                        Thống kê số chuyến xe chạy theo từng ngày và tổng trọng lượng vận chuyển.
                    </p>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="small font-weight-bold">Từ ngày</label>
                            <input type="date" class="form-control form-control-sm" id="transportFromDate">
                        </div>
                        <div class="col-md-4">
                            <label class="small font-weight-bold">Đến ngày</label>
                            <input type="date" class="form-control form-control-sm" id="transportToDate">
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button class="btn btn-dark btn-sm" onclick="loadTransportReport()">
                                <i class="fas fa-search"></i> Xem báo cáo
                            </button>
                            <button class="btn btn-success btn-sm ml-2" onclick="exportReport('TRANSPORT')">
                                <i class="fas fa-file-excel"></i> Xuất Excel
                            </button>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bordered table-sm" id="transportReportTable">
                            <thead class="bg-light">
                                <tr>
                                    <th>Ngày</th>
                                    <th>Số chuyến xe</th>
                                    <th>Tổng trọng lượng (kg)</th>
                                    <th>Chuyến hoàn thành</th>
                                    <th>Chuyến đang chạy</th>
                                </tr>
                            </thead>
                            <tbody id="transportReportData">
                                <tr>
                                    <td colspan="5" class="text-center text-muted">Chọn khoảng thời gian và nhấn "Xem
                                        báo cáo"</td>
                                </tr>
                            </tbody>
                            <tfoot class="bg-light font-weight-bold" id="transportReportFooter" style="display: none;">
                                <tr>
                                    <td>Tổng cộng</td>
                                    <td id="totalTrips">0</td>
                                    <td id="totalWeight">0</td>
                                    <td id="totalCompleted">0</td>
                                    <td id="totalOngoing">0</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Export Section -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-bolt"></i> Xuất nhanh (Toàn bộ dữ liệu)
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4 mb-2">
                            <button class="btn btn-outline-primary btn-block" onclick="exportReport('REVENUE', true)">
                                <i class="fas fa-chart-line"></i> Tất cả Doanh thu
                            </button>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button class="btn btn-outline-info btn-block"
                                onclick="exportReport('HUB_PERFORMANCE', true)">
                                <i class="fas fa-warehouse"></i> Tất cả Hub
                            </button>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button class="btn btn-outline-warning btn-block" onclick="exportReport('COD_DEBT', true)">
                                <i class="fas fa-money-bill-wave"></i> Tất cả Công nợ COD
                            </button>
                        </div>
                        <div class="col-md-4 mb-2">
                            <button class="btn btn-outline-dark btn-block" onclick="exportReport('TRANSPORT', true)">
                                <i class="fas fa-truck"></i> Tất cả Vận tải
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Info Card -->
            <div class="card shadow mb-4 border-left-info">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Hướng dẫn sử dụng</div>
                            <div class="small text-gray-800">
                                <ul class="mb-0 pl-3">
                                    <li>Chọn khoảng thời gian cần xuất báo cáo (Từ ngày - Đến ngày)</li>
                                    <li>Nhấn <strong>Xuất Excel</strong> để tải file báo cáo về máy</li>
                                    <li>Hoặc sử dụng <strong>Xuất nhanh</strong> để tải toàn bộ dữ liệu</li>
                                    <li>File Excel sẽ được đặt tên theo format:
                                        <code>Report_[TYPE]_[TIMESTAMP].xlsx</code>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-info-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loading Modal -->
        <div class="modal fade" id="loadingModal" tabindex="-1" role="dialog" data-backdrop="static"
            data-keyboard="false">
            <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-body text-center py-4">
                        <div class="spinner-border text-primary mb-3" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        <p class="mb-0">Đang xuất báo cáo...</p>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var BASE_API = '/api/system-log/monitoring';

            function hideLoading() {
                var modal = document.getElementById('loadingModal');
                if (modal) {
                    modal.classList.remove('show');
                    modal.style.display = 'none';
                    document.body.classList.remove('modal-open');
                    var backdrop = document.querySelector('.modal-backdrop');
                    if (backdrop) {
                        backdrop.remove();
                    }
                }
            }

            function showLoading() {
                var modal = document.getElementById('loadingModal');
                if (modal) {
                    modal.classList.add('show');
                    modal.style.display = 'block';
                    document.body.classList.add('modal-open');
                    // Add backdrop
                    var backdrop = document.createElement('div');
                    backdrop.className = 'modal-backdrop fade show';
                    document.body.appendChild(backdrop);
                }
            }

            function exportReport(reportType, exportAll) {
                var fromDate = null;
                var toDate = null;

                if (!exportAll) {
                    // Get dates based on report type
                    switch (reportType) {
                        case 'REVENUE':
                            fromDate = document.getElementById('revenueFromDate').value || null;
                            toDate = document.getElementById('revenueToDate').value || null;
                            break;
                        case 'HUB_PERFORMANCE':
                            fromDate = document.getElementById('hubFromDate').value || null;
                            toDate = document.getElementById('hubToDate').value || null;
                            break;
                        case 'COD_DEBT':
                            fromDate = document.getElementById('codFromDate').value || null;
                            toDate = document.getElementById('codToDate').value || null;
                            break;
                    }
                }

                var requestBody = {
                    type: reportType,
                    fromDate: fromDate,
                    toDate: toDate,
                    hubId: null
                };

                // Show loading
                showLoading();

                fetch(BASE_API + '/export', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(requestBody)
                })
                    .then(function (response) {
                        if (!response.ok) {
                            throw new Error('Lỗi xuất báo cáo');
                        }
                        // Get filename from header
                        var disposition = response.headers.get('Content-Disposition');
                        var filename = 'report.xlsx';
                        if (disposition && disposition.indexOf('filename=') !== -1) {
                            filename = disposition.split('filename=')[1].replace(/"/g, '');
                        }
                        return response.blob().then(function (blob) {
                            return { blob: blob, filename: filename };
                        });
                    })
                    .then(function (data) {
                        // Create download link
                        var url = window.URL.createObjectURL(data.blob);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = data.filename;
                        document.body.appendChild(a);
                        a.click();
                        window.URL.revokeObjectURL(url);
                        a.remove();

                        // Hide loading and show success
                        hideLoading();
                        showAlert('success', 'Xuất báo cáo thành công!');
                    })
                    .catch(function (error) {
                        hideLoading();
                        showAlert('danger', 'Lỗi: ' + error.message);
                        console.error('Export error:', error);
                    });
            }

            function showAlert(type, message) {
                var alertHtml = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                    message +
                    '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                    '</div>';

                // Insert at top of container
                var container = document.querySelector('.container-fluid');
                var alertDiv = document.createElement('div');
                alertDiv.innerHTML = alertHtml;
                container.insertBefore(alertDiv.firstChild, container.firstChild.nextSibling);

                // Auto dismiss after 3 seconds
                setTimeout(function () {
                    $('.alert').alert('close');
                }, 3000);
            }

            // Transport Report Functions
            function loadTransportReport() {
                var fromDate = document.getElementById('transportFromDate').value;
                var toDate = document.getElementById('transportToDate').value;

                if (!fromDate || !toDate) {
                    showAlert('warning', 'Vui lòng chọn khoảng thời gian');
                    return;
                }

                var url = '/api/admin/stats/transport-report?fromDate=' + fromDate + '&toDate=' + toDate;

                fetch(url)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            renderTransportReport(response.data);
                        } else {
                            showAlert('danger', 'Lỗi tải dữ liệu báo cáo');
                        }
                    })
                    .catch(function (err) {
                        console.error('Error:', err);
                        showAlert('danger', 'Lỗi kết nối server');
                    });
            }

            function renderTransportReport(data) {
                var tbody = document.getElementById('transportReportData');
                var footer = document.getElementById('transportReportFooter');
                var nf = new Intl.NumberFormat('vi-VN');

                if (!data.dailyStats || data.dailyStats.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">Không có dữ liệu trong khoảng thời gian này</td></tr>';
                    footer.style.display = 'none';
                    return;
                }

                var html = '';
                var totalTrips = 0, totalWeight = 0, totalCompleted = 0, totalOngoing = 0;

                for (var i = 0; i < data.dailyStats.length; i++) {
                    var row = data.dailyStats[i];
                    totalTrips += row.tripCount || 0;
                    totalWeight += row.totalWeight || 0;
                    totalCompleted += row.completedCount || 0;
                    totalOngoing += row.ongoingCount || 0;

                    html += '<tr>' +
                        '<td>' + row.date + '</td>' +
                        '<td>' + (row.tripCount || 0) + '</td>' +
                        '<td>' + nf.format(row.totalWeight || 0) + '</td>' +
                        '<td><span class="badge badge-success">' + (row.completedCount || 0) + '</span></td>' +
                        '<td><span class="badge badge-warning">' + (row.ongoingCount || 0) + '</span></td>' +
                        '</tr>';
                }

                tbody.innerHTML = html;
                footer.style.display = 'table-footer-group';
                document.getElementById('totalTrips').innerText = totalTrips;
                document.getElementById('totalWeight').innerText = nf.format(totalWeight) + ' kg';
                document.getElementById('totalCompleted').innerText = totalCompleted;
                document.getElementById('totalOngoing').innerText = totalOngoing;
            }

            // Initialize default dates (last 7 days)
            document.addEventListener('DOMContentLoaded', function () {
                var today = new Date();
                var lastWeek = new Date();
                lastWeek.setDate(today.getDate() - 7);

                document.getElementById('transportFromDate').value = lastWeek.toISOString().split('T')[0];
                document.getElementById('transportToDate').value = today.toISOString().split('T')[0];
            });
        </script>