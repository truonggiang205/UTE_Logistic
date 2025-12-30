<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">Quản lý Tài xế</h1>
                <button class="btn btn-sm btn-primary shadow-sm" data-toggle="modal" data-target="#driverModal"
                    onclick="openAddModal()">
                    <i class="fas fa-plus fa-sm text-white-50"></i> Thêm tài xế mới
                </button>
            </div>

            <!-- Filter Section -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="small font-weight-bold">Trạng thái</label>
                            <select class="form-control" id="filterStatus" onchange="loadDrivers()">
                                <option value="">-- Tất cả --</option>
                                <option value="active">Đang hoạt động</option>
                                <option value="inactive">Ngừng hoạt động</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="small font-weight-bold">Tìm kiếm</label>
                            <input type="text" class="form-control" id="filterKeyword"
                                placeholder="Nhập tên hoặc SĐT..." onkeyup="debounceSearch()">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button class="btn btn-secondary btn-block" onclick="resetFilters()">
                                <i class="fas fa-redo"></i> Đặt lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Data Table -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách tài xế</h6>
                    <span class="badge badge-info" id="totalCount">0 tài xế</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                            <thead class="bg-light">
                                <tr>
                                    <th>Họ tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Số bằng lái</th>
                                    <th>Hạng bằng</th>
                                    <th>CCCD</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th style="width: 150px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="driverListData">
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

        <!-- Modal Thêm/Sửa Tài xế -->
        <div class="modal fade" id="driverModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Thêm tài xế mới</h5>
                        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <form id="driverForm">
                        <div class="modal-body">
                            <input type="hidden" id="driverId">
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Họ tên <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" required
                                        placeholder="Nhập họ tên đầy đủ">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phoneNumber"
                                        placeholder="VD: 0901234567">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Số bằng lái <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="licenseNumber" required
                                        placeholder="Nhập số bằng lái">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Hạng bằng</label>
                                    <select class="form-control" id="licenseClass">
                                        <option value="B2">B2 - Xe tải dưới 3.5 tấn</option>
                                        <option value="C">C - Xe tải từ 3.5 tấn</option>
                                        <option value="D">D - Xe khách từ 10-30 chỗ</option>
                                        <option value="E">E - Xe khách trên 30 chỗ</option>
                                        <option value="FC">FC - Container</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Số CCCD <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="identityCard" required
                                        placeholder="Nhập số CCCD (12 số)">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy</button>
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-save"></i> Lưu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Đổi Trạng thái -->
        <div class="modal fade" id="statusModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thay đổi trạng thái tài xế</h5>
                        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="statusDriverId">
                        <p>Tài xế: <strong id="statusDriverName"></strong></p>
                        <div class="form-group">
                            <label class="small font-weight-bold">Trạng thái mới</label>
                            <select class="form-control" id="newStatus">
                                <option value="active">Đang hoạt động</option>
                                <option value="inactive">Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy</button>
                        <button class="btn btn-primary" type="button" onclick="confirmStatusChange()">
                            <i class="fas fa-check"></i> Xác nhận
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var API_BASE = window.location.origin + '/api/admin/drivers';
            var currentPage = 0;
            var pageSize = 10;
            var debounceTimer;

            // Load data on page ready
            document.addEventListener('DOMContentLoaded', function () {
                loadDrivers();
            });

            function loadDrivers() {
                var status = document.getElementById('filterStatus').value;
                var keyword = document.getElementById('filterKeyword').value;

                var url = API_BASE + '?page=' + currentPage + '&size=' + pageSize;
                if (status) url += '&status=' + status;
                if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

                fetch(url)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            renderTable(response.data.content);
                            renderPagination(response.data);
                            document.getElementById('totalCount').innerText = response.data.totalElements + ' tài xế';
                        } else {
                            document.getElementById('driverListData').innerHTML =
                                '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Error:', err);
                        document.getElementById('driverListData').innerHTML =
                            '<tr><td colspan="8" class="text-center text-danger">Lỗi kết nối server</td></tr>';
                    });
            }

            function renderTable(drivers) {
                if (!drivers || drivers.length === 0) {
                    document.getElementById('driverListData').innerHTML =
                        '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
                    return;
                }

                var html = '';
                for (var i = 0; i < drivers.length; i++) {
                    var d = drivers[i];
                    var statusBadge = getStatusBadge(d.status);
                    var createdAt = d.createdAt ? new Date(d.createdAt).toLocaleDateString('vi-VN') : '-';

                    var actionBtns = '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' + d.driverId + ')" title="Sửa">' +
                        '<i class="fas fa-edit"></i></button>' +
                        '<button class="btn btn-sm btn-' + (d.status === 'active' ? 'warning' : 'success') + '" ' +
                        'onclick="openStatusModal(' + d.driverId + ', \'' + d.fullName + '\', \'' + d.status + '\')" title="Đổi trạng thái">' +
                        '<i class="fas fa-' + (d.status === 'active' ? 'ban' : 'check') + '"></i></button>';

                    html += '<tr>' +
                        '<td><strong>' + d.fullName + '</strong></td>' +
                        '<td>' + (d.phoneNumber || '-') + '</td>' +
                        '<td>' + d.licenseNumber + '</td>' +
                        '<td><span class="badge badge-primary">' + (d.licenseClass || 'C') + '</span></td>' +
                        '<td>' + d.identityCard + '</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '<td>' + createdAt + '</td>' +
                        '<td>' + actionBtns + '</td>' +
                        '</tr>';
                }
                document.getElementById('driverListData').innerHTML = html;
            }

            function getStatusBadge(status) {
                switch (status) {
                    case 'active':
                        return '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Đang hoạt động</span>';
                    case 'inactive':
                        return '<span class="badge badge-danger"><i class="fas fa-times-circle"></i> Ngừng hoạt động</span>';
                    default:
                        return '<span class="badge badge-light">' + status + '</span>';
                }
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
                loadDrivers();
            }

            function debounceSearch() {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function () {
                    currentPage = 0;
                    loadDrivers();
                }, 500);
            }

            function resetFilters() {
                document.getElementById('filterStatus').value = '';
                document.getElementById('filterKeyword').value = '';
                currentPage = 0;
                loadDrivers();
            }

            function openAddModal() {
                document.getElementById('driverForm').reset();
                document.getElementById('driverId').value = '';
                document.getElementById('modalTitle').innerText = 'Thêm tài xế mới';
            }

            function openEditModal(id) {
                fetch(API_BASE + '/' + id)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            var d = response.data;
                            document.getElementById('driverId').value = d.driverId;
                            document.getElementById('fullName').value = d.fullName;
                            document.getElementById('phoneNumber').value = d.phoneNumber || '';
                            document.getElementById('licenseNumber').value = d.licenseNumber;
                            document.getElementById('licenseClass').value = d.licenseClass || 'C';
                            document.getElementById('identityCard').value = d.identityCard;
                            document.getElementById('modalTitle').innerText = 'Cập nhật tài xế: ' + d.fullName;
                            $('#driverModal').modal('show');
                        }
                    });
            }

            function openStatusModal(id, name, currentStatus) {
                document.getElementById('statusDriverId').value = id;
                document.getElementById('statusDriverName').innerText = name;
                document.getElementById('newStatus').value = currentStatus === 'active' ? 'inactive' : 'active';
                $('#statusModal').modal('show');
            }

            function confirmStatusChange() {
                var id = document.getElementById('statusDriverId').value;
                var status = document.getElementById('newStatus').value;

                fetch(API_BASE + '/' + id + '/status', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ status: status })
                })
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        $('#statusModal').modal('hide');
                        if (response.success) {
                            showToast('success', 'Cập nhật trạng thái thành công!');
                            loadDrivers();
                        } else {
                            showToast('error', response.message || 'Có lỗi xảy ra');
                        }
                    })
                    .catch(function (err) {
                        $('#statusModal').modal('hide');
                        showToast('error', 'Lỗi kết nối server');
                    });
            }

            // Form submit handler
            document.getElementById('driverForm').addEventListener('submit', function (e) {
                e.preventDefault();

                var driverId = document.getElementById('driverId').value;
                var isEdit = driverId !== '';

                var data = {
                    fullName: document.getElementById('fullName').value,
                    phoneNumber: document.getElementById('phoneNumber').value,
                    licenseNumber: document.getElementById('licenseNumber').value,
                    licenseClass: document.getElementById('licenseClass').value,
                    identityCard: document.getElementById('identityCard').value
                };

                var url = isEdit ? (API_BASE + '/' + driverId) : API_BASE;
                var method = isEdit ? 'PUT' : 'POST';

                fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success) {
                            $('#driverModal').modal('hide');
                            showToast('success', isEdit ? 'Cập nhật thành công!' : 'Thêm tài xế mới thành công!');
                            loadDrivers();
                        } else {
                            showToast('error', response.message || 'Có lỗi xảy ra');
                        }
                    })
                    .catch(function (err) {
                        showToast('error', 'Lỗi kết nối server');
                    });
            });

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
        </style>