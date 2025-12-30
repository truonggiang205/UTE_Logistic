<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">Quản lý Đội xe</h1>
                <button class="btn btn-sm btn-primary shadow-sm" data-toggle="modal" data-target="#vehicleModal"
                    onclick="openAddModal()">
                    <i class="fas fa-plus fa-sm text-white-50"></i> Thêm xe mới
                </button>
            </div>

            <!-- Filter Section -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="small font-weight-bold">Hub hiện tại</label>
                            <select class="form-control" id="filterHub" onchange="loadVehicles()">
                                <option value="">-- Tất cả --</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="small font-weight-bold">Trạng thái</label>
                            <select class="form-control" id="filterStatus" onchange="loadVehicles()">
                                <option value="">-- Tất cả --</option>
                                <option value="available">Sẵn sàng</option>
                                <option value="in_transit">Đang chạy</option>
                                <option value="maintenance">Bảo trì</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="small font-weight-bold">Biển số</label>
                            <input type="text" class="form-control" id="filterPlateNumber" placeholder="Nhập biển số..."
                                onkeyup="debounceSearch()">
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
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách xe</h6>
                    <span class="badge badge-info" id="totalCount">0 xe</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                            <thead class="bg-light">
                                <tr>
                                    <th>Biển số</th>
                                    <th>Loại xe</th>
                                    <th>Tải trọng (kg)</th>
                                    <th>Hub hiện tại</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th style="width: 120px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="vehicleListData">
                                <tr>
                                    <td colspan="7" class="text-center">Đang tải dữ liệu...</td>
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

        <!-- Modal Thêm/Sửa Xe -->
        <div class="modal fade" id="vehicleModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Thêm xe mới</h5>
                        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <form id="vehicleForm">
                        <div class="modal-body">
                            <input type="hidden" id="vehicleId">
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Biển số xe <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="plateNumber" required
                                        placeholder="VD: 51C-123.45">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Loại xe</label>
                                    <select class="form-control" id="vehicleType">
                                        <option value="Xe tải nhẹ">Xe tải nhẹ (< 2.5 tấn)</option>
                                        <option value="Xe tải trung">Xe tải trung (2.5 - 8 tấn)</option>
                                        <option value="Xe tải nặng">Xe tải nặng (> 8 tấn)</option>
                                        <option value="Xe container">Xe container</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Tải trọng (kg) <span
                                            class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="loadCapacity" required
                                        placeholder="VD: 2500">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Hub hiện tại</label>
                                    <select class="form-control" id="currentHubId">
                                        <option value="">-- Chọn Hub --</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row" id="statusRow" style="display: none;">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Trạng thái</label>
                                    <select class="form-control" id="status">
                                        <option value="available">Sẵn sàng</option>
                                        <option value="in_transit">Đang chạy</option>
                                        <option value="maintenance">Bảo trì</option>
                                    </select>
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

        <!-- Modal Xác nhận Xóa -->
        <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Xác nhận xóa</h5>
                        <button class="close text-white" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa xe <strong id="deletePlateNumber"></strong>?</p>
                        <p class="text-muted small">Hành động này không thể hoàn tác.</p>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" id="deleteVehicleId">
                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy</button>
                        <button class="btn btn-danger" type="button" onclick="confirmDelete()">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var API_BASE = window.location.origin + '/api/admin/vehicles';
            var HUB_API = window.location.origin + '/api/admin/hubs/filter';
            var currentPage = 0;
            var pageSize = 10;
            var debounceTimer;

            // Load data on page ready
            document.addEventListener('DOMContentLoaded', function () {
                loadHubs();
                loadVehicles();
            });

            function loadHubs() {
                fetch(HUB_API)
                    .then(function (res) { return res.json(); })
                    .then(function (hubs) {
                        var filterHtml = '<option value="">-- Tất cả --</option>';
                        var formHtml = '<option value="">-- Chọn Hub --</option>';
                        for (var i = 0; i < hubs.length; i++) {
                            filterHtml += '<option value="' + hubs[i].hubId + '">' + hubs[i].hubName + '</option>';
                            formHtml += '<option value="' + hubs[i].hubId + '">' + hubs[i].hubName + '</option>';
                        }
                        document.getElementById('filterHub').innerHTML = filterHtml;
                        document.getElementById('currentHubId').innerHTML = formHtml;
                    })
                    .catch(function (err) {
                        console.error('Error loading hubs:', err);
                    });
            }

            function loadVehicles() {
                var hubId = document.getElementById('filterHub').value;
                var status = document.getElementById('filterStatus').value;
                var plateNumber = document.getElementById('filterPlateNumber').value;

                var url = API_BASE + '?page=' + currentPage + '&size=' + pageSize;
                if (hubId) url += '&hubId=' + hubId;
                if (status) url += '&status=' + status;
                if (plateNumber) url += '&plateNumber=' + encodeURIComponent(plateNumber);

                fetch(url)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            renderTable(response.data.content);
                            renderPagination(response.data);
                            document.getElementById('totalCount').innerText = response.data.totalElements + ' xe';
                        } else {
                            document.getElementById('vehicleListData').innerHTML =
                                '<tr><td colspan="7" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Error:', err);
                        document.getElementById('vehicleListData').innerHTML =
                            '<tr><td colspan="7" class="text-center text-danger">Lỗi kết nối server</td></tr>';
                    });
            }

            function renderTable(vehicles) {
                if (!vehicles || vehicles.length === 0) {
                    document.getElementById('vehicleListData').innerHTML =
                        '<tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr>';
                    return;
                }

                var html = '';
                for (var i = 0; i < vehicles.length; i++) {
                    var v = vehicles[i];
                    var statusBadge = getStatusBadge(v.status);
                    var nf = new Intl.NumberFormat('vi-VN');
                    var createdAt = v.createdAt ? new Date(v.createdAt).toLocaleDateString('vi-VN') : '-';

                    var actionBtns = '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' + v.vehicleId + ')" title="Sửa">' +
                        '<i class="fas fa-edit"></i></button>';

                    // Hide delete button if vehicle is in_transit
                    if (v.status !== 'in_transit') {
                        actionBtns += '<button class="btn btn-sm btn-danger" onclick="openDeleteModal(' + v.vehicleId + ', \'' + v.plateNumber + '\')" title="Xóa">' +
                            '<i class="fas fa-trash"></i></button>';
                    }

                    html += '<tr>' +
                        '<td><strong>' + v.plateNumber + '</strong></td>' +
                        '<td>' + (v.vehicleType || '-') + '</td>' +
                        '<td>' + nf.format(v.loadCapacity) + '</td>' +
                        '<td>' + (v.currentHubName || '<span class="text-muted">Chưa gán</span>') + '</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '<td>' + createdAt + '</td>' +
                        '<td>' + actionBtns + '</td>' +
                        '</tr>';
                }
                document.getElementById('vehicleListData').innerHTML = html;
            }

            function getStatusBadge(status) {
                switch (status) {
                    case 'available':
                        return '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Sẵn sàng</span>';
                    case 'in_transit':
                        return '<span class="badge badge-warning"><i class="fas fa-truck"></i> Đang chạy</span>';
                    case 'maintenance':
                        return '<span class="badge badge-secondary"><i class="fas fa-tools"></i> Bảo trì</span>';
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

                // Previous button
                html += '<li class="page-item ' + (pageData.first ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage - 1) + ')">Trước</a></li>';

                // Page numbers
                for (var i = 0; i < totalPages; i++) {
                    if (i === currentPage) {
                        html += '<li class="page-item active"><a class="page-link" href="javascript:void(0)">' + (i + 1) + '</a></li>';
                    } else if (Math.abs(i - currentPage) <= 2 || i === 0 || i === totalPages - 1) {
                        html += '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(' + i + ')">' + (i + 1) + '</a></li>';
                    } else if (Math.abs(i - currentPage) === 3) {
                        html += '<li class="page-item disabled"><a class="page-link">...</a></li>';
                    }
                }

                // Next button
                html += '<li class="page-item ' + (pageData.last ? 'disabled' : '') + '">' +
                    '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage + 1) + ')">Sau</a></li>';

                document.getElementById('pagination').innerHTML = html;
            }

            function goToPage(page) {
                currentPage = page;
                loadVehicles();
            }

            function debounceSearch() {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function () {
                    currentPage = 0;
                    loadVehicles();
                }, 500);
            }

            function resetFilters() {
                document.getElementById('filterHub').value = '';
                document.getElementById('filterStatus').value = '';
                document.getElementById('filterPlateNumber').value = '';
                currentPage = 0;
                loadVehicles();
            }

            function openAddModal() {
                document.getElementById('vehicleForm').reset();
                document.getElementById('vehicleId').value = '';
                document.getElementById('modalTitle').innerText = 'Thêm xe mới';
                document.getElementById('statusRow').style.display = 'none';
            }

            function openEditModal(id) {
                fetch(API_BASE + '/' + id)
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success && response.data) {
                            var v = response.data;
                            document.getElementById('vehicleId').value = v.vehicleId;
                            document.getElementById('plateNumber').value = v.plateNumber;
                            document.getElementById('vehicleType').value = v.vehicleType || 'Xe tải nhẹ';
                            document.getElementById('loadCapacity').value = v.loadCapacity;
                            document.getElementById('currentHubId').value = v.currentHubId || '';
                            document.getElementById('status').value = v.status;
                            document.getElementById('statusRow').style.display = 'flex';
                            document.getElementById('modalTitle').innerText = 'Cập nhật xe: ' + v.plateNumber;
                            $('#vehicleModal').modal('show');
                        }
                    });
            }

            function openDeleteModal(id, plateNumber) {
                document.getElementById('deleteVehicleId').value = id;
                document.getElementById('deletePlateNumber').innerText = plateNumber;
                $('#deleteModal').modal('show');
            }

            function confirmDelete() {
                var id = document.getElementById('deleteVehicleId').value;
                fetch(API_BASE + '/' + id, { method: 'DELETE' })
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        $('#deleteModal').modal('hide');
                        if (response.success) {
                            showToast('success', 'Xóa xe thành công!');
                            loadVehicles();
                        } else {
                            showToast('error', response.message || 'Không thể xóa xe');
                        }
                    })
                    .catch(function (err) {
                        $('#deleteModal').modal('hide');
                        showToast('error', 'Lỗi kết nối server');
                    });
            }

            // Form submit handler
            document.getElementById('vehicleForm').addEventListener('submit', function (e) {
                e.preventDefault();

                var vehicleId = document.getElementById('vehicleId').value;
                var isEdit = vehicleId !== '';

                var data = {
                    plateNumber: document.getElementById('plateNumber').value,
                    vehicleType: document.getElementById('vehicleType').value,
                    loadCapacity: parseFloat(document.getElementById('loadCapacity').value),
                    currentHubId: document.getElementById('currentHubId').value || null
                };

                if (isEdit) {
                    data.status = document.getElementById('status').value;
                }

                var url = isEdit ? (API_BASE + '/' + vehicleId) : API_BASE;
                var method = isEdit ? 'PUT' : 'POST';

                fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                    .then(function (res) { return res.json(); })
                    .then(function (response) {
                        if (response.success) {
                            $('#vehicleModal').modal('hide');
                            showToast('success', isEdit ? 'Cập nhật thành công!' : 'Thêm xe mới thành công!');
                            loadVehicles();
                        } else {
                            showToast('error', response.message || 'Có lỗi xảy ra');
                        }
                    })
                    .catch(function (err) {
                        showToast('error', 'Lỗi kết nối server');
                    });
            });

            function showToast(type, message) {
                // Simple toast notification
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