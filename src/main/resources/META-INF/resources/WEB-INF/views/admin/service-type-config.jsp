<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="container-fluid">
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <h1 class="h3 mb-0 text-gray-800">Cấu hình Dịch vụ & Giá</h1>
                <button class="btn btn-sm btn-primary shadow-sm" data-toggle="modal" data-target="#serviceModal"
                    onclick="openAddModal()">
                    <i class="fas fa-plus fa-sm text-white-50"></i> Thêm dịch vụ mới
                </button>
            </div>

            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Danh sách cấu hình dịch vụ</h6>
                    <div class="custom-control custom-switch">
                        <input type="checkbox" class="custom-control-input" id="showAllVersions"
                            onchange="loadServices()">
                        <label class="custom-control-label small" for="showAllVersions">Hiển thị lịch sử giá</label>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead class="bg-light">
                                <tr>
                                    <th>Mã</th>
                                    <th>Tên dịch vụ</th>
                                    <th>Phí cơ bản</th>
                                    <th>Phí/kg</th>
                                    <th>Phí COD (%)</th>
                                    <th>COD tối thiểu</th>
                                    <th>Bảo hiểm (%)</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="serviceListData"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="serviceModal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Cấu hình dịch vụ</h5>
                        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <form id="serviceForm">
                        <div class="modal-body">
                            <input type="hidden" id="serviceId">
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Mã dịch vụ</label>
                                    <input type="text" class="form-control" id="serviceCode" required>
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Tên dịch vụ</label>
                                    <input type="text" class="form-control" id="serviceName" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 form-group">
                                    <label class="small font-weight-bold">Phí cơ bản</label>
                                    <input type="number" class="form-control" id="baseFee" required>
                                </div>
                                <div class="col-md-4 form-group">
                                    <label class="small font-weight-bold">Phí/kg tiếp theo</label>
                                    <input type="number" class="form-control" id="extraPricePerKg">
                                </div>
                                <div class="col-md-4 form-group">
                                    <label class="small font-weight-bold">Phí COD tối thiểu</label>
                                    <input type="number" class="form-control" id="codMinFee">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Tỉ lệ phí COD (0-1)</label>
                                    <input type="number" step="0.0001" class="form-control" id="codRate">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="small font-weight-bold">Tỉ lệ bảo hiểm (0-1)</label>
                                    <input type="number" step="0.0001" class="form-control" id="insuranceRate">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="small font-weight-bold">Mô tả</label>
                                <textarea class="form-control" id="description" rows="2"></textarea>
                            </div>
                            <div id="versionNote" class="alert alert-warning d-none small">
                                Lưu ý: Thay đổi bất kỳ thông số nào bên trên sẽ tạo một phiên bản (Version) mới, giá cũ
                                sẽ hết hiệu lực.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" type="button" data-dismiss="modal">Hủy</button>
                            <button class="btn btn-primary" type="submit">Lưu cấu hình</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            var API_BASE = window.location.origin + '/api/admin/services';

            function loadServices() {
                fetch(API_BASE)
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var isShowAll = document.getElementById('showAllVersions').checked;
                        var html = '';
                        var list = isShowAll ? data : data.filter(function (s) { return s.active; });

                        for (var i = 0; i < list.length; i++) {
                            var s = list[i];
                            var statusBadge = s.active
                                ? '<span class="badge badge-success">Đang chạy</span>'
                                : '<span class="badge badge-secondary">Lịch sử</span>';

                            var rowClass = s.active ? '' : 'table-secondary text-muted';
                            var nf = new Intl.NumberFormat('vi-VN');

                            var row = '<tr class="' + rowClass + '">' +
                                '<td>' + s.serviceCode + '</td>' +
                                '<td>' + s.serviceName + '</td>' +
                                '<td>' + nf.format(s.baseFee) + 'đ</td>' +
                                '<td>' + nf.format(s.extraPricePerKg || 0) + 'đ</td>' +
                                '<td>' + ((s.codRate || 0) * 100).toFixed(1) + '%</td>' +
                                '<td>' + nf.format(s.codMinFee || 0) + 'đ</td>' + // Trường mới
                                '<td>' + ((s.insuranceRate || 0) * 100).toFixed(1) + '%</td>' + // Trường mới
                                '<td>' + statusBadge + ' (v' + s.version + ')</td>' +
                                '<td>';

                            if (s.active) {
                                row += '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' + s.serviceTypeId + ')">Sửa</button>' +
                                    '<button class="btn btn-sm btn-danger" onclick="deleteService(' + s.serviceTypeId + ')">Dừng</button>';
                            }
                            row += '</td></tr>';
                            html += row;
                        }
                        document.getElementById('serviceListData').innerHTML = html;
                    });
            }

            function openAddModal() {
                document.getElementById('serviceForm').reset();
                document.getElementById('serviceId').value = '';
                document.getElementById('serviceCode').readOnly = false;
                document.getElementById('versionNote').classList.add('d-none');
                document.getElementById('modalTitle').innerText = 'Thêm dịch vụ mới';
            }

            function openEditModal(id) {
                fetch(API_BASE + '/' + id)
                    .then(function (res) { return res.json(); })
                    .then(function (s) {
                        document.getElementById('serviceId').value = s.serviceTypeId;
                        document.getElementById('serviceCode').value = s.serviceCode;
                        document.getElementById('serviceCode').readOnly = true;
                        document.getElementById('serviceName').value = s.serviceName;
                        document.getElementById('baseFee').value = s.baseFee;
                        document.getElementById('extraPricePerKg').value = s.extraPricePerKg;
                        document.getElementById('codRate').value = s.codRate;
                        document.getElementById('codMinFee').value = s.codMinFee; // Gán giá trị mới
                        document.getElementById('insuranceRate').value = s.insuranceRate; // Gán giá trị mới
                        document.getElementById('description').value = s.description;
                        document.getElementById('versionNote').classList.remove('d-none');
                        document.getElementById('modalTitle').innerText = 'Cập nhật giá dịch vụ';
                        $('#serviceModal').modal('show');
                    });
            }

            document.getElementById('serviceForm').onsubmit = function (e) {
                e.preventDefault();
                var id = document.getElementById('serviceId').value;
                var payload = {
                    serviceCode: document.getElementById('serviceCode').value,
                    serviceName: document.getElementById('serviceName').value,
                    baseFee: document.getElementById('baseFee').value,
                    extraPricePerKg: document.getElementById('extraPricePerKg').value,
                    codRate: document.getElementById('codRate').value,
                    codMinFee: document.getElementById('codMinFee').value, // Payload mới
                    insuranceRate: document.getElementById('insuranceRate').value, // Payload mới
                    description: document.getElementById('description').value
                };

                fetch(id ? (API_BASE + '/' + id) : API_BASE, {
                    method: id ? 'PUT' : 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                }).then(function (res) {
                    if (res.ok) {
                        $('#serviceModal').modal('hide');
                        loadServices();
                    } else {
                        alert('Có lỗi xảy ra khi lưu dữ liệu!');
                    }
                });
            };

            function deleteService(id) {
                if (confirm('Dừng dịch vụ này?')) {
                    fetch(API_BASE + '/' + id, { method: 'DELETE' }).then(function () { loadServices(); });
                }
            }

            document.addEventListener('DOMContentLoaded', loadServices);
        </script>