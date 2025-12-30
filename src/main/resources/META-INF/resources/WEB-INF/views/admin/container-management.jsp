<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-box-open text-primary"></i> Tra cứu & Xử lý Bao hàng
                </h1>
            </div>

            <!-- Search Section -->
            <div class="card shadow mb-4">
                <div class="card-body">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <div class="input-group input-group-lg">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-primary text-white">
                                        <i class="fas fa-search"></i>
                                    </span>
                                </div>
                                <input type="text" class="form-control form-control-lg" id="searchCode"
                                    placeholder="Nhập mã bao hàng để tìm kiếm (VD: BAO-2024-001234)"
                                    onkeyup="debounceSearch(event)">
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="button" onclick="searchContainers()">
                                        Tìm kiếm
                                    </button>
                                </div>
                            </div>
                            <small class="text-muted">Nhập mã bao hàng đầy đủ hoặc một phần để tìm kiếm</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search Results -->
            <div id="searchResults" style="display: none;">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-list"></i> Kết quả tìm kiếm
                        </h6>
                        <span class="badge badge-info" id="resultCount">0 kết quả</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Mã bao</th>
                                        <th>Loại</th>
                                        <th>Trọng lượng</th>
                                        <th>Hub tạo</th>
                                        <th>Hub đích</th>
                                        <th>Người tạo</th>
                                        <th>Trạng thái</th>
                                        <th style="width: 150px;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="containerListData">
                                    <tr>
                                        <td colspan="8" class="text-center">Không có dữ liệu</td>
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

            <!-- Container Detail Panel -->
            <div id="containerDetail" style="display: none;">
                <div class="card shadow mb-4 border-left-primary">
                    <div class="card-header py-3 bg-gradient-primary text-white">
                        <h6 class="m-0 font-weight-bold">
                            <i class="fas fa-info-circle"></i> Chi tiết Bao hàng: <span id="detailCode"></span>
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <table class="table table-sm">
                                    <tr>
                                        <th width="40%">Mã bao:</th>
                                        <td><strong id="infoCode" class="text-primary"></strong></td>
                                    </tr>
                                    <tr>
                                        <th>Loại bao:</th>
                                        <td id="infoType"></td>
                                    </tr>
                                    <tr>
                                        <th>Trọng lượng:</th>
                                        <td id="infoWeight"></td>
                                    </tr>
                                    <tr>
                                        <th>Trạng thái:</th>
                                        <td id="infoStatus"></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-sm">
                                    <tr>
                                        <th width="40%">Hub tạo:</th>
                                        <td id="infoCreatedHub"></td>
                                    </tr>
                                    <tr>
                                        <th>Hub đích:</th>
                                        <td id="infoDestHub"></td>
                                    </tr>
                                    <tr>
                                        <th>Người tạo:</th>
                                        <td id="infoCreatedBy"></td>
                                    </tr>
                                    <tr>
                                        <th>Ngày tạo:</th>
                                        <td id="infoCreatedAt"></td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="border-top pt-3 mt-3">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="alert alert-warning mb-0" id="actionWarning" style="display: none;">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <strong>Lưu ý:</strong> Bao hàng này đang trong quá trình vận chuyển.
                                        Chỉ sử dụng "Xả bao cưỡng chế" khi có sự cố nghiêm trọng.
                                    </div>
                                </div>
                                <div class="col-md-4 text-right">
                                    <input type="hidden" id="selectedContainerId">
                                    <button class="btn btn-danger btn-lg" id="forceUnpackBtn"
                                        onclick="openForceUnpackModal()">
                                        <i class="fas fa-box-open"></i> Xả bao cưỡng chế
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-5">
                <i class="fas fa-search fa-4x text-gray-300 mb-4"></i>
                <h5 class="text-gray-500">Nhập mã bao hàng để bắt đầu tìm kiếm</h5>
                <p class="text-muted">Hệ thống sẽ hiển thị thông tin chi tiết và các hành động có thể thực hiện</p>
            </div>
        </div>

        <!-- Modal Xác nhận Xả bao cưỡng chế -->
        <div class="modal fade" id="forceUnpackModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle"></i> Xác nhận Xả bao cưỡng chế
                        </h5>
                        <button class="close text-white" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger">
                            <i class="fas fa-radiation-alt fa-2x float-left mr-3"></i>
                            <strong>CẢNH BÁO!</strong><br>
                            Hành động này chỉ dành cho Admin và không thể hoàn tác!
                        </div>
                        <p>Bạn đang chuẩn bị <strong>xả bao cưỡng chế</strong> cho:</p>
                        <div class="card bg-light mb-3">
                            <div class="card-body py-2">
                                <strong>Mã bao:</strong> <span id="confirmCode" class="text-primary"></span><br>
                                <strong>Hub đích:</strong> <span id="confirmDestHub"></span>
                            </div>
                        </div>
                        <p class="text-danger">
                            <i class="fas fa-info-circle"></i> Thao tác này sẽ:
                        </p>
                        <ul class="text-muted">
                            <li>Đặt trạng thái bao hàng thành <strong>"unpacked"</strong></li>
                            <li>Cập nhật vị trí các đơn hàng bên trong về Hub đích</li>
                            <li>Ghi log hành động của Admin vào hệ thống</li>
                        </ul>
                        <div class="form-group">
                            <label class="font-weight-bold">Nhập "XAC NHAN" để tiếp tục:</label>
                            <input type="text" class="form-control" id="confirmText" placeholder="XAC NHAN">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy bỏ</button>
                        <button class="btn btn-danger" type="button" id="confirmForceUnpackBtn"
                            onclick="confirmForceUnpack()" disabled>
                            <i class="fas fa-box-open"></i> Xả bao cưỡng chế
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var API_BASE = window.location.origin + '/api/admin/containers';
            var currentPage = 0;
            var pageSize = 10;
            var debounceTimer;

            // Enable confirm button when correct text is entered
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('confirmText').addEventListener('input', function () {
                    var btn = document.getElementById('confirmForceUnpackBtn');
                    btn.disabled = this.value !== 'XAC NHAN';
                });
            });

            function debounceSearch(event) {
                if (event.key === 'Enter') {
                    searchContainers();
                    return;
                }
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function () {
                    searchContainers();
                }, 500);
            }

            function searchContainers() {
                var code = document.getElementById('searchCode').value.trim();

                if (code.length < 2) {
                    document.getElementById('searchResults').style.display = 'none';
                    document.getElementById('containerDetail').style.display = 'none';
                    document.getElementById('emptyState').style.display = 'block';
                    return;
                }

                document.getElementById('emptyState').style.display = 'none';

                var url = API_BASE + '?code=' + encodeURIComponent(code) + '&page=' + currentPage + '&size=' + pageSize;

                fetch(url)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            document.getElementById('searchResults').style.display = 'block';
                            renderTable(response.data.content);
                            renderPagination(response.data);
                            document.getElementById('resultCount').innerText = response.data.totalElements + ' kết quả';
                        } else {
                            document.getElementById('searchResults').style.display = 'block';
                            document.getElementById('containerListData').innerHTML =
                                '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Error:', err);
                    });
            }

            function renderTable(containers) {
                if (!containers || containers.length === 0) {
                    document.getElementById('containerListData').innerHTML =
                        '<tr><td colspan="8" class="text-center">Không tìm thấy bao hàng nào</td></tr>';
                    return;
                }

                var html = '';
                var nf = new Intl.NumberFormat('vi-VN');

                for (var i = 0; i < containers.length; i++) {
                    var c = containers[i];

                    html += '<tr>' +
                        '<td><strong class="text-primary">' + c.containerCode + '</strong></td>' +
                        '<td>' + getTypeBadge(c.type) + '</td>' +
                        '<td>' + nf.format(c.weight || 0) + ' kg</td>' +
                        '<td>' + (c.createdAtHubName || '-') + '</td>' +
                        '<td>' + (c.destinationHubName || '-') + '</td>' +
                        '<td>' + (c.createdByName || '-') + '</td>' +
                        '<td>' + getStatusBadge(c.status) + '</td>' +
                        '<td>' +
                        '<button class="btn btn-sm btn-info" onclick="viewContainerDetail(' + c.containerId + ')" title="Xem chi tiết">' +
                        '<i class="fas fa-eye"></i> Chi tiết</button>' +
                        '</td>' +
                        '</tr>';
                }
                document.getElementById('containerListData').innerHTML = html;
            }

            function getTypeBadge(type) {
                var badges = {
                    'standard': '<span class="badge badge-secondary">Thường</span>',
                    'fragile': '<span class="badge badge-warning">Dễ vỡ</span>',
                    'frozen': '<span class="badge badge-info">Đông lạnh</span>',
                    'express': '<span class="badge badge-danger">Hỏa tốc</span>'
                };
                return badges[type] || '<span class="badge badge-light">' + type + '</span>';
            }

            function getStatusBadge(status) {
                var badges = {
                    'created': '<span class="badge badge-secondary"><i class="fas fa-plus-circle"></i> Mới tạo</span>',
                    'closed': '<span class="badge badge-info"><i class="fas fa-lock"></i> Đã đóng</span>',
                    'loaded': '<span class="badge badge-primary"><i class="fas fa-truck-loading"></i> Đã xếp</span>',
                    'received': '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Đã nhận</span>',
                    'unpacked': '<span class="badge badge-dark"><i class="fas fa-box-open"></i> Đã xả</span>'
                };
                return badges[status] || '<span class="badge badge-light">' + status + '</span>';
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
                    }
                }

                html += '<li class="page-item ' + (pageData.last ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage + 1) + ')">Sau</a></li>';

                document.getElementById('pagination').innerHTML = html;
            }

            function goToPage(page) {
                currentPage = page;
                searchContainers();
            }

            function viewContainerDetail(containerId) {
                fetch(API_BASE + '/' + containerId)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            var c = response.data;
                            var nf = new Intl.NumberFormat('vi-VN');

                            document.getElementById('selectedContainerId').value = c.containerId;
                            document.getElementById('detailCode').innerText = c.containerCode;
                            document.getElementById('infoCode').innerText = c.containerCode;
                            document.getElementById('infoType').innerHTML = getTypeBadge(c.type);
                            document.getElementById('infoWeight').innerText = nf.format(c.weight || 0) + ' kg';
                            document.getElementById('infoStatus').innerHTML = getStatusBadge(c.status);
                            document.getElementById('infoCreatedHub').innerText = c.createdAtHubName || '-';
                            document.getElementById('infoDestHub').innerText = c.destinationHubName || '-';
                            document.getElementById('infoCreatedBy').innerText = c.createdByName || '-';
                            document.getElementById('infoCreatedAt').innerText = c.createdAt
                                ? new Date(c.createdAt).toLocaleString('vi-VN') : '-';

                            // Show/hide warning and disable button based on status
                            var forceBtn = document.getElementById('forceUnpackBtn');
                            var warning = document.getElementById('actionWarning');

                            if (c.status === 'unpacked') {
                                forceBtn.disabled = true;
                                forceBtn.innerHTML = '<i class="fas fa-check"></i> Đã xả bao';
                                forceBtn.className = 'btn btn-secondary btn-lg';
                                warning.style.display = 'none';
                            } else {
                                forceBtn.disabled = false;
                                forceBtn.innerHTML = '<i class="fas fa-box-open"></i> Xả bao cưỡng chế';
                                forceBtn.className = 'btn btn-danger btn-lg';
                                warning.style.display = (c.status === 'loaded') ? 'block' : 'none';
                            }

                            // Store data for modal
                            document.getElementById('confirmCode').innerText = c.containerCode;
                            document.getElementById('confirmDestHub').innerText = c.destinationHubName || '-';

                            document.getElementById('containerDetail').style.display = 'block';

                            // Scroll to detail
                            document.getElementById('containerDetail').scrollIntoView({ behavior: 'smooth' });
                        }
                    });
            }

            function openForceUnpackModal() {
                document.getElementById('confirmText').value = '';
                document.getElementById('confirmForceUnpackBtn').disabled = true;
                $('#forceUnpackModal').modal('show');
            }

            function confirmForceUnpack() {
                var containerId = document.getElementById('selectedContainerId').value;

                fetch(API_BASE + '/' + containerId + '/force-unpack', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                })
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        $('#forceUnpackModal').modal('hide');
                        if (response.success) {
                            showToast('success', 'Xả bao cưỡng chế thành công!');
                            // Refresh the detail view
                            viewContainerDetail(containerId);
                        } else {
                            showToast('error', response.message || 'Có lỗi xảy ra');
                        }
                    })
                    .catch(function (err) {
                        $('#forceUnpackModal').modal('hide');
                        showToast('error', 'Lỗi kết nối server');
                    });
            }

            function showToast(type, message) {
                var bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
                var toast = document.createElement('div');
                toast.className = 'toast-notification ' + bgClass;
                toast.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : 'times') + '-circle mr-2"></i>' + message;
                toast.style.cssText = 'position:fixed;top:20px;right:20px;padding:15px 25px;color:white;border-radius:5px;z-index:9999;animation:slideIn 0.3s ease;';
                document.body.appendChild(toast);
                setTimeout(function () { toast.remove(); }, 3000);
            }
        </script>

        <style>
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

            .bg-gradient-primary {
                background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            }
        </style>