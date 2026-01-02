<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Tài xế & Xe - Resource Management</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .page-header {
                    background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .tab-nav {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 20px;
                }

                .tab-btn {
                    padding: 12px 25px;
                    border: none;
                    border-radius: 10px;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .tab-btn.active {
                    background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
                    color: #fff;
                }

                .tab-btn:not(.active) {
                    background: #f8f9fc;
                    color: #5a5c69;
                }

                .tab-btn:hover:not(.active) {
                    background: #e3e6f0;
                }

                .panel-card {
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                    margin-bottom: 20px;
                }

                .panel-card-header {
                    padding: 15px 20px;
                    border-bottom: 1px solid #eee;
                    border-radius: 12px 12px 0 0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .panel-card-body {
                    padding: 20px;
                }

                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .data-table th,
                .data-table td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #e3e6f0;
                }

                .data-table th {
                    background: #f8f9fc;
                    font-weight: 600;
                    color: #5a5c69;
                }

                .data-table tr:hover {
                    background: #f8f9fc;
                }

                .status-badge {
                    padding: 5px 12px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .status-active,
                .status-available {
                    background: #d4edda;
                    color: #155724;
                }

                .status-inactive,
                .status-maintenance {
                    background: #f8d7da;
                    color: #721c24;
                }

                .status-in_transit {
                    background: #cce5ff;
                    color: #004085;
                }

                .search-box {
                    position: relative;
                    margin-bottom: 15px;
                }

                .search-box input {
                    padding-left: 35px;
                    border-radius: 20px;
                    border: 1px solid #d1d3e2;
                    width: 300px;
                }

                .search-box i {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #858796;
                }

                .btn-action {
                    padding: 5px 10px;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    margin: 0 2px;
                }

                .btn-edit {
                    background: #4e73df;
                    color: #fff;
                }

                .btn-delete {
                    background: #e74a3b;
                    color: #fff;
                }

                .btn-edit:hover {
                    background: #2e59d9;
                    color: #fff;
                }

                .btn-delete:hover {
                    background: #be2617;
                    color: #fff;
                }

                .toast-container {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                }

                .custom-toast {
                    min-width: 350px;
                    padding: 15px 20px;
                    border-radius: 10px;
                    margin-bottom: 10px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                    animation: slideIn 0.3s ease;
                    display: flex;
                    align-items: center;
                }

                .custom-toast.success {
                    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
                    color: #fff;
                }

                .custom-toast.error {
                    background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%);
                    color: #fff;
                }

                .custom-toast.warning {
                    background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%);
                    color: #fff;
                }

                .custom-toast .toast-icon {
                    font-size: 1.5rem;
                    margin-right: 15px;
                }

                .custom-toast .toast-content {
                    flex: 1;
                }

                .custom-toast .toast-title {
                    font-weight: bold;
                    margin-bottom: 3px;
                }

                .custom-toast .toast-close {
                    background: none;
                    border: none;
                    color: #fff;
                    font-size: 1.2rem;
                    cursor: pointer;
                    opacity: 0.7;
                }

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

                @keyframes slideOut {
                    from {
                        transform: translateX(0);
                        opacity: 1;
                    }

                    to {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                }

                .tab-content {
                    display: none;
                }

                .tab-content.active {
                    display: block;
                }
            </style>
        </head>

        <body id="page-top">
            <div class="toast-container" id="toastContainer"></div>

            <!-- Modal Thêm/Sửa Tài xế -->
            <div class="modal fade" id="driverModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="driverModalTitle"><i class="fas fa-user mr-2"></i> Thêm Tài xế
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <form id="driverForm">
                                <input type="hidden" id="driverId">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Họ và tên <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="driverFullName" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Số điện thoại <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="driverPhone" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Số GPLX <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="driverLicenseNumber" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Hạng GPLX</label>
                                            <select class="form-control" id="driverLicenseClass">
                                                <option value="B1">B1</option>
                                                <option value="B2">B2</option>
                                                <option value="C">C</option>
                                                <option value="D">D</option>
                                                <option value="E">E</option>
                                                <option value="FC">FC</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Số CMND/CCCD <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="driverIdentityCard" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Trạng thái</label>
                                            <select class="form-control" id="driverStatus">
                                                <option value="active">Hoạt động</option>
                                                <option value="inactive">Nghỉ việc</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary" onclick="saveDriver()"><i
                                    class="fas fa-save mr-1"></i> Lưu</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Thêm/Sửa Xe -->
            <div class="modal fade" id="vehicleModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title" id="vehicleModalTitle"><i class="fas fa-truck mr-2"></i> Thêm Xe
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <form id="vehicleForm">
                                <input type="hidden" id="vehicleId">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Biển số xe <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="vehiclePlateNumber" required
                                                placeholder="VD: 51C-12345">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Loại xe</label>
                                            <select class="form-control" id="vehicleType">
                                                <option value="Xe tải nhỏ">Xe tải nhỏ (< 2 tấn)</option>
                                                <option value="Xe tải trung">Xe tải trung (2-5 tấn)</option>
                                                <option value="Xe tải lớn">Xe tải lớn (> 5 tấn)</option>
                                                <option value="Container">Container</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Tải trọng (kg) <span
                                                    class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="vehicleLoadCapacity" required
                                                placeholder="VD: 2000">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Hub hiện tại</label>
                                            <select class="form-control" id="vehicleCurrentHub">
                                                <option value="">-- Chưa xác định --</option>
                                                <c:forEach var="hub" items="${hubs}">
                                                    <option value="${hub.hubId}">${hub.hubName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="font-weight-bold">Trạng thái</label>
                                            <select class="form-control" id="vehicleStatus">
                                                <option value="available">Sẵn sàng</option>
                                                <option value="in_transit">Đang vận chuyển</option>
                                                <option value="maintenance">Bảo trì</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-success" onclick="saveVehicle()"><i
                                    class="fas fa-save mr-1"></i> Lưu</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Xác nhận Xóa -->
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title"><i class="fas fa-exclamation-triangle mr-2"></i> Xác nhận xóa</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body text-center py-4">
                            <i class="fas fa-trash-alt fa-4x text-danger mb-3"></i>
                            <h5 id="deleteConfirmMessage">Bạn có chắc muốn xóa?</h5>
                            <p class="text-muted">Hành động này không thể hoàn tác.</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-secondary px-4" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-danger px-4" id="confirmDeleteBtn">Xóa</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <div class="page-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-users-cog mr-2"></i> Quản lý Tài xế & Xe</h3>
                                        <p class="mb-0 opacity-75">Thêm, sửa, xóa thông tin tài xế và phương tiện</p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="d-flex justify-content-end">
                                            <div class="text-center mr-3">
                                                <div class="h4 mb-0" id="totalDriversCount">0</div>
                                                <small class="opacity-75">Tài xế</small>
                                            </div>
                                            <div class="text-center">
                                                <div class="h4 mb-0" id="totalVehiclesCount">0</div>
                                                <small class="opacity-75">Xe</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-nav">
                                <button class="tab-btn active" data-tab="drivers"><i class="fas fa-user mr-2"></i>Tài
                                    xế</button>
                                <button class="tab-btn" data-tab="vehicles"><i class="fas fa-truck mr-2"></i>Phương
                                    tiện</button>
                            </div>

                            <!-- Tab Tài xế -->
                            <div class="tab-content active" id="tab-drivers">
                                <div class="panel-card">
                                    <div class="panel-card-header"
                                        style="background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); color: #fff;">
                                        <span><i class="fas fa-users mr-2"></i> Danh sách Tài xế</span>
                                        <button class="btn btn-sm btn-light" onclick="showAddDriver()"><i
                                                class="fas fa-plus mr-1"></i> Thêm tài xế</button>
                                    </div>
                                    <div class="panel-card-body">
                                        <div class="d-flex justify-content-between mb-3">
                                            <div class="search-box">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="driverSearchInput"
                                                    placeholder="Tìm theo tên, SĐT, GPLX...">
                                            </div>
                                            <select class="form-control" id="driverStatusFilter" style="width: 150px;">
                                                <option value="">Tất cả</option>
                                                <option value="active">Hoạt động</option>
                                                <option value="inactive">Nghỉ việc</option>
                                            </select>
                                        </div>
                                        <table class="data-table" id="driversTable">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Họ tên</th>
                                                    <th>Số điện thoại</th>
                                                    <th>Số GPLX</th>
                                                    <th>Hạng</th>
                                                    <th>CMND/CCCD</th>
                                                    <th>Trạng thái</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody id="driversTableBody"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Phương tiện -->
                            <div class="tab-content" id="tab-vehicles">
                                <div class="panel-card">
                                    <div class="panel-card-header"
                                        style="background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); color: #fff;">
                                        <span><i class="fas fa-truck mr-2"></i> Danh sách Phương tiện</span>
                                        <button class="btn btn-sm btn-light" onclick="showAddVehicle()"><i
                                                class="fas fa-plus mr-1"></i> Thêm xe</button>
                                    </div>
                                    <div class="panel-card-body">
                                        <div class="d-flex justify-content-between mb-3">
                                            <div class="search-box">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="vehicleSearchInput"
                                                    placeholder="Tìm theo biển số, loại xe...">
                                            </div>
                                            <select class="form-control" id="vehicleStatusFilter" style="width: 180px;">
                                                <option value="">Tất cả</option>
                                                <option value="available">Sẵn sàng</option>
                                                <option value="in_transit">Đang vận chuyển</option>
                                                <option value="maintenance">Bảo trì</option>
                                            </select>
                                        </div>
                                        <table class="data-table" id="vehiclesTable">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Biển số</th>
                                                    <th>Loại xe</th>
                                                    <th>Tải trọng</th>
                                                    <th>Hub hiện tại</th>
                                                    <th>Trạng thái</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody id="vehiclesTableBody"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
            <script>
                var contextPath = '${pageContext.request.contextPath}';
                var allDrivers = [];
                var allVehicles = [];
                var deleteType = '';
                var deleteId = null;

                $(document).ready(function () {
                    loadDrivers();
                    loadVehicles();

                    $('.tab-btn').click(function () {
                        var tab = $(this).data('tab');
                        $('.tab-btn').removeClass('active');
                        $(this).addClass('active');
                        $('.tab-content').removeClass('active');
                        $('#tab-' + tab).addClass('active');
                    });

                    $('#driverSearchInput').on('input', function () { filterDrivers(); });
                    $('#driverStatusFilter').change(function () { filterDrivers(); });
                    $('#vehicleSearchInput').on('input', function () { filterVehicles(); });
                    $('#vehicleStatusFilter').change(function () { filterVehicles(); });
                });

                function showToast(type, title, message) {
                    var icons = { 'success': 'fa-check-circle', 'error': 'fa-times-circle', 'warning': 'fa-exclamation-triangle' };
                    var toastHtml = '<div class="custom-toast ' + type + '"><div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div><div class="toast-content"><div class="toast-title">' + title + '</div><div class="toast-message">' + message + '</div></div><button class="toast-close" onclick="$(this).closest(\'.custom-toast\').remove()">&times;</button></div>';
                    $('#toastContainer').append(toastHtml);
                    setTimeout(function () { $('#toastContainer .custom-toast:first').remove(); }, 4000);
                }

                // ============ DRIVERS ============
                function loadDrivers() {
                    $.get(contextPath + '/api/manager/resource/drivers', function (response) {
                        if (response.success) {
                            allDrivers = response.data;
                            $('#totalDriversCount').text(allDrivers.length);
                            filterDrivers();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách tài xế'); });
                }

                function filterDrivers() {
                    var search = $('#driverSearchInput').val().toLowerCase();
                    var status = $('#driverStatusFilter').val();
                    var filtered = allDrivers.filter(function (d) {
                        if (status && d.status !== status) return false;
                        if (search) {
                            return (d.fullName && d.fullName.toLowerCase().includes(search)) ||
                                (d.phoneNumber && d.phoneNumber.includes(search)) ||
                                (d.licenseNumber && d.licenseNumber.toLowerCase().includes(search));
                        }
                        return true;
                    });
                    renderDrivers(filtered);
                }

                function renderDrivers(drivers) {
                    var tbody = $('#driversTableBody');
                    tbody.empty();
                    if (drivers.length === 0) {
                        tbody.html('<tr><td colspan="8" class="text-center text-muted py-4">Không có dữ liệu</td></tr>');
                        return;
                    }
                    drivers.forEach(function (d) {
                        var statusClass = 'status-' + d.status;
                        var statusText = d.status === 'active' ? 'Hoạt động' : 'Nghỉ việc';
                        var html = '<tr><td>' + d.driverId + '</td><td class="font-weight-bold">' + d.fullName + '</td>' +
                            '<td>' + (d.phoneNumber || 'N/A') + '</td><td>' + d.licenseNumber + '</td>' +
                            '<td>' + (d.licenseClass || 'N/A') + '</td><td>' + (d.identityCard || 'N/A') + '</td>' +
                            '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td><button class="btn-action btn-edit" onclick="editDriver(' + d.driverId + ')"><i class="fas fa-edit"></i></button>' +
                            '<button class="btn-action btn-delete" onclick="confirmDeleteDriver(' + d.driverId + ', \'' + d.fullName + '\')"><i class="fas fa-trash"></i></button></td></tr>';
                        tbody.append(html);
                    });
                }

                function showAddDriver() {
                    $('#driverModalTitle').html('<i class="fas fa-user mr-2"></i> Thêm Tài xế');
                    $('#driverForm')[0].reset();
                    $('#driverId').val('');
                    $('#driverModal').modal('show');
                }

                function editDriver(id) {
                    var driver = allDrivers.find(function (d) { return d.driverId == id; });
                    if (driver) {
                        $('#driverModalTitle').html('<i class="fas fa-edit mr-2"></i> Sửa Tài xế');
                        $('#driverId').val(driver.driverId);
                        $('#driverFullName').val(driver.fullName);
                        $('#driverPhone').val(driver.phoneNumber);
                        $('#driverLicenseNumber').val(driver.licenseNumber);
                        $('#driverLicenseClass').val(driver.licenseClass);
                        $('#driverIdentityCard').val(driver.identityCard);
                        $('#driverStatus').val(driver.status);
                        $('#driverModal').modal('show');
                    }
                }

                function saveDriver() {
                    var id = $('#driverId').val();
                    var data = {
                        fullName: $('#driverFullName').val(),
                        phoneNumber: $('#driverPhone').val(),
                        licenseNumber: $('#driverLicenseNumber').val(),
                        licenseClass: $('#driverLicenseClass').val(),
                        identityCard: $('#driverIdentityCard').val(),
                        status: $('#driverStatus').val()
                    };

                    if (!data.fullName || !data.licenseNumber || !data.identityCard) {
                        showToast('warning', 'Thiếu thông tin', 'Vui lòng điền đầy đủ thông tin bắt buộc');
                        return;
                    }

                    var url = id ? contextPath + '/api/manager/resource/drivers/' + id : contextPath + '/api/manager/resource/drivers';
                    var method = id ? 'PUT' : 'POST';

                    $.ajax({
                        url: url, method: method, contentType: 'application/json', data: JSON.stringify(data),
                        success: function (response) {
                            if (response.success) {
                                $('#driverModal').modal('hide');
                                showToast('success', 'Thành công!', id ? 'Đã cập nhật tài xế' : 'Đã thêm tài xế mới');
                                loadDrivers();
                            } else {
                                showToast('error', 'Lỗi', response.message);
                            }
                        },
                        error: function (xhr) { showToast('error', 'Lỗi', xhr.responseJSON?.message || 'Không thể lưu tài xế'); }
                    });
                }

                function confirmDeleteDriver(id, name) {
                    deleteType = 'driver';
                    deleteId = id;
                    $('#deleteConfirmMessage').text('Bạn có chắc muốn xóa tài xế "' + name + '"?');
                    $('#confirmDeleteBtn').off('click').on('click', function () { deleteDriver(); });
                    $('#deleteConfirmModal').modal('show');
                }

                function deleteDriver() {
                    $.ajax({
                        url: contextPath + '/api/manager/resource/drivers/' + deleteId, method: 'DELETE',
                        success: function (response) {
                            $('#deleteConfirmModal').modal('hide');
                            if (response.success) {
                                showToast('success', 'Đã xóa!', 'Tài xế đã được xóa');
                                loadDrivers();
                            } else {
                                showToast('error', 'Lỗi', response.message);
                            }
                        },
                        error: function (xhr) { showToast('error', 'Lỗi', xhr.responseJSON?.message || 'Không thể xóa tài xế'); }
                    });
                }

                // ============ VEHICLES ============
                function loadVehicles() {
                    $.get(contextPath + '/api/manager/resource/vehicles', function (response) {
                        if (response.success) {
                            allVehicles = response.data;
                            $('#totalVehiclesCount').text(allVehicles.length);
                            filterVehicles();
                        }
                    }).fail(function () { showToast('error', 'Lỗi', 'Không thể tải danh sách xe'); });
                }

                function filterVehicles() {
                    var search = $('#vehicleSearchInput').val().toLowerCase();
                    var status = $('#vehicleStatusFilter').val();
                    var filtered = allVehicles.filter(function (v) {
                        if (status && v.status !== status) return false;
                        if (search) {
                            return (v.plateNumber && v.plateNumber.toLowerCase().includes(search)) ||
                                (v.vehicleType && v.vehicleType.toLowerCase().includes(search));
                        }
                        return true;
                    });
                    renderVehicles(filtered);
                }

                function renderVehicles(vehicles) {
                    var tbody = $('#vehiclesTableBody');
                    tbody.empty();
                    if (vehicles.length === 0) {
                        tbody.html('<tr><td colspan="7" class="text-center text-muted py-4">Không có dữ liệu</td></tr>');
                        return;
                    }
                    vehicles.forEach(function (v) {
                        var statusClass = 'status-' + v.status;
                        var statusText = v.status === 'available' ? 'Sẵn sàng' : (v.status === 'in_transit' ? 'Đang vận chuyển' : 'Bảo trì');
                        var html = '<tr><td>' + v.vehicleId + '</td><td class="font-weight-bold">' + v.plateNumber + '</td>' +
                            '<td>' + (v.vehicleType || 'N/A') + '</td><td>' + (v.loadCapacity || 0) + ' kg</td>' +
                            '<td>' + (v.currentHubName || 'Chưa xác định') + '</td>' +
                            '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>' +
                            '<td><button class="btn-action btn-edit" onclick="editVehicle(' + v.vehicleId + ')"><i class="fas fa-edit"></i></button>' +
                            '<button class="btn-action btn-delete" onclick="confirmDeleteVehicle(' + v.vehicleId + ', \'' + v.plateNumber + '\')"><i class="fas fa-trash"></i></button></td></tr>';
                        tbody.append(html);
                    });
                }

                function showAddVehicle() {
                    $('#vehicleModalTitle').html('<i class="fas fa-truck mr-2"></i> Thêm Xe');
                    $('#vehicleForm')[0].reset();
                    $('#vehicleId').val('');
                    $('#vehicleModal').modal('show');
                }

                function editVehicle(id) {
                    var vehicle = allVehicles.find(function (v) { return v.vehicleId == id; });
                    if (vehicle) {
                        $('#vehicleModalTitle').html('<i class="fas fa-edit mr-2"></i> Sửa Xe');
                        $('#vehicleId').val(vehicle.vehicleId);
                        $('#vehiclePlateNumber').val(vehicle.plateNumber);
                        $('#vehicleType').val(vehicle.vehicleType);
                        $('#vehicleLoadCapacity').val(vehicle.loadCapacity);
                        $('#vehicleCurrentHub').val(vehicle.currentHubId || '');
                        $('#vehicleStatus').val(vehicle.status);
                        $('#vehicleModal').modal('show');
                    }
                }

                function saveVehicle() {
                    var id = $('#vehicleId').val();
                    var data = {
                        plateNumber: $('#vehiclePlateNumber').val(),
                        vehicleType: $('#vehicleType').val(),
                        loadCapacity: parseFloat($('#vehicleLoadCapacity').val()) || 0,
                        currentHubId: $('#vehicleCurrentHub').val() ? parseInt($('#vehicleCurrentHub').val()) : null,
                        status: $('#vehicleStatus').val()
                    };

                    if (!data.plateNumber || !data.loadCapacity) {
                        showToast('warning', 'Thiếu thông tin', 'Vui lòng điền đầy đủ thông tin bắt buộc');
                        return;
                    }

                    var url = id ? contextPath + '/api/manager/resource/vehicles/' + id : contextPath + '/api/manager/resource/vehicles';
                    var method = id ? 'PUT' : 'POST';

                    $.ajax({
                        url: url, method: method, contentType: 'application/json', data: JSON.stringify(data),
                        success: function (response) {
                            if (response.success) {
                                $('#vehicleModal').modal('hide');
                                showToast('success', 'Thành công!', id ? 'Đã cập nhật xe' : 'Đã thêm xe mới');
                                loadVehicles();
                            } else {
                                showToast('error', 'Lỗi', response.message);
                            }
                        },
                        error: function (xhr) { showToast('error', 'Lỗi', xhr.responseJSON?.message || 'Không thể lưu xe'); }
                    });
                }

                function confirmDeleteVehicle(id, plate) {
                    deleteType = 'vehicle';
                    deleteId = id;
                    $('#deleteConfirmMessage').text('Bạn có chắc muốn xóa xe "' + plate + '"?');
                    $('#confirmDeleteBtn').off('click').on('click', function () { deleteVehicle(); });
                    $('#deleteConfirmModal').modal('show');
                }

                function deleteVehicle() {
                    $.ajax({
                        url: contextPath + '/api/manager/resource/vehicles/' + deleteId, method: 'DELETE',
                        success: function (response) {
                            $('#deleteConfirmModal').modal('hide');
                            if (response.success) {
                                showToast('success', 'Đã xóa!', 'Xe đã được xóa');
                                loadVehicles();
                            } else {
                                showToast('error', 'Lỗi', response.message);
                            }
                        },
                        error: function (xhr) { showToast('error', 'Lỗi', xhr.responseJSON?.message || 'Không thể xóa xe'); }
                    });
                }
            </script>
        </body>

        </html>