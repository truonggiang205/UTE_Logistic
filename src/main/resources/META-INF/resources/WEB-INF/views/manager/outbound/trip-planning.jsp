<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Điều Phối Xe - Trip Planning</title>
            <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
            <style>
                .trip-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .form-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    margin-bottom: 20px;
                }

                .form-card-header {
                    background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
                    color: #fff;
                    padding: 15px 20px;
                    border-radius: 15px 15px 0 0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .form-card-body {
                    padding: 20px;
                }

                .search-box {
                    position: relative;
                    margin-bottom: 15px;
                }

                .search-box input {
                    padding-left: 40px;
                    border-radius: 25px;
                    border: 2px solid #e3e6f0;
                    height: 42px;
                }

                .search-box input:focus {
                    border-color: #4e73df;
                    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
                }

                .search-box i {
                    position: absolute;
                    left: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #858796;
                }

                .vehicle-option,
                .driver-option {
                    border: 2px solid #e3e6f0;
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .vehicle-option:hover,
                .driver-option:hover {
                    border-color: #4e73df;
                    background: #f8f9fc;
                    transform: translateY(-2px);
                }

                .vehicle-option.selected,
                .driver-option.selected {
                    border-color: #1cc88a;
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                    box-shadow: 0 3px 10px rgba(28, 200, 138, 0.3);
                }

                .vehicle-option.unavailable,
                .driver-option.unavailable {
                    opacity: 0.5;
                    background: #f8f9fc;
                }

                .vehicle-option.hidden,
                .driver-option.hidden {
                    display: none;
                }

                .status-badge {
                    font-size: 0.75rem;
                    padding: 3px 8px;
                    border-radius: 20px;
                }

                .trip-card {
                    background: #fff;
                    border-radius: 10px;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
                    padding: 15px;
                    margin-bottom: 10px;
                    border-left: 4px solid #4e73df;
                    transition: all 0.3s;
                    cursor: pointer;
                    position: relative;
                }

                .trip-card:hover {
                    transform: translateX(5px);
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.12);
                }

                .trip-card .action-buttons {
                    position: absolute;
                    right: 10px;
                    top: 50%;
                    transform: translateY(-50%);
                    opacity: 0;
                    transition: opacity 0.3s;
                }

                .trip-card:hover .action-buttons {
                    opacity: 1;
                }

                .trip-card .action-buttons .btn {
                    padding: 5px 10px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                }

                .btn-create-trip {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    padding: 15px 30px;
                    font-size: 1.1rem;
                    border-radius: 10px;
                }

                .btn-create-trip:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
                }

                .hub-select-card {
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    border-radius: 10px;
                    padding: 20px;
                    color: #fff;
                    margin-bottom: 20px;
                }

                .hub-select-card label {
                    font-weight: bold;
                    margin-bottom: 8px;
                }

                .hub-select-card select {
                    border: none;
                    border-radius: 8px;
                    padding: 10px 15px;
                }

                .list-container {
                    max-height: 350px;
                    overflow-y: auto;
                }

                .list-container::-webkit-scrollbar {
                    width: 6px;
                }

                .list-container::-webkit-scrollbar-track {
                    background: #f1f1f1;
                    border-radius: 3px;
                }

                .list-container::-webkit-scrollbar-thumb {
                    background: #c1c1c1;
                    border-radius: 3px;
                }

                .trips-search-box {
                    padding: 15px;
                    background: #f8f9fc;
                    border-bottom: 1px solid #e3e6f0;
                }

                .trips-search-box input {
                    border-radius: 20px;
                    padding-left: 35px;
                }

                .no-results {
                    text-align: center;
                    padding: 30px;
                    color: #858796;
                }

                .no-results i {
                    font-size: 40px;
                    margin-bottom: 15px;
                    opacity: 0.5;
                }

                /* Toast Styles */
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
                    color: #000;
                }

                .custom-toast.info {
                    background: linear-gradient(135deg, #36b9cc 0%, #1a8e9e 100%);
                    color: #fff;
                }

                .custom-toast .toast-icon {
                    font-size: 24px;
                    margin-right: 15px;
                }

                .custom-toast .toast-content {
                    flex: 1;
                }

                .custom-toast .toast-title {
                    font-weight: bold;
                    margin-bottom: 3px;
                }

                .custom-toast .toast-message {
                    font-size: 0.9rem;
                    opacity: 0.9;
                }

                .custom-toast .toast-close {
                    background: none;
                    border: none;
                    color: inherit;
                    font-size: 18px;
                    cursor: pointer;
                    opacity: 0.7;
                    margin-left: 10px;
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

                /* Selection Summary */
                .selection-summary {
                    background: linear-gradient(135deg, #f8f9fc 0%, #e3e6f0 100%);
                    border-radius: 10px;
                    padding: 15px;
                    margin-bottom: 15px;
                    border: 2px dashed #d1d3e2;
                }

                .selection-summary.has-selection {
                    border-color: #1cc88a;
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                }

                .selection-item {
                    display: flex;
                    align-items: center;
                    margin-bottom: 8px;
                }

                .selection-item:last-child {
                    margin-bottom: 0;
                }

                .selection-item i {
                    width: 30px;
                    color: #858796;
                }

                .selection-item.selected i {
                    color: #1cc88a;
                }

                .selection-item .label {
                    width: 100px;
                    font-weight: 600;
                    color: #5a5c69;
                }

                .selection-item .value {
                    flex: 1;
                    color: #858796;
                }

                .selection-item.selected .value {
                    color: #1cc88a;
                    font-weight: 600;
                }
            </style>
        </head>

        <body id="page-top">
            <!-- Toast Container -->
            <div class="toast-container" id="toastContainer"></div>

            <div id="wrapper">
                <div id="content-wrapper" class="d-flex flex-column">
                    <div id="content">
                        <div class="container-fluid py-4">
                            <!-- Header -->
                            <div class="trip-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h3 class="mb-2"><i class="fas fa-truck-loading mr-2"></i> Điều Phối Xe (Trip
                                            Planning)</h3>
                                        <p class="mb-0 opacity-75">Tạo chuyến xe, gắn tài xế và tuyến đường</p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <span class="badge badge-light px-3 py-2">
                                            <i class="fas fa-truck mr-1"></i> ${vehicles.size()} xe |
                                            <i class="fas fa-user mr-1"></i> ${drivers.size()} tài xế
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Left Column: Tạo chuyến xe -->
                                <div class="col-lg-7">
                                    <!-- Hub Selection -->
                                    <div class="hub-select-card">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label><i class="fas fa-warehouse mr-1"></i> Hub xuất phát:</label>
                                                <select class="form-control" id="fromHubSelect">
                                                    <option value="">-- Chọn Hub xuất phát --</option>
                                                    <c:forEach var="hub" items="${hubs}">
                                                        <option value="${hub.hubId}">${hub.hubName} - ${hub.province}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6">
                                                <label><i class="fas fa-map-marker-alt mr-1"></i> Hub đích đến:</label>
                                                <select class="form-control" id="toHubSelect">
                                                    <option value="">-- Chọn Hub đích --</option>
                                                    <c:forEach var="hub" items="${hubs}">
                                                        <option value="${hub.hubId}">${hub.hubName} - ${hub.province}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Selection Summary -->
                                    <div class="selection-summary" id="selectionSummary">
                                        <h6 class="font-weight-bold mb-3"><i class="fas fa-clipboard-check mr-2"></i>
                                            Thông tin đã chọn:</h6>
                                        <div class="selection-item" id="summaryVehicle">
                                            <i class="fas fa-truck"></i>
                                            <span class="label">Xe:</span>
                                            <span class="value">Chưa chọn</span>
                                        </div>
                                        <div class="selection-item" id="summaryDriver">
                                            <i class="fas fa-user"></i>
                                            <span class="label">Tài xế:</span>
                                            <span class="value">Chưa chọn</span>
                                        </div>
                                        <div class="selection-item" id="summaryRoute">
                                            <i class="fas fa-route"></i>
                                            <span class="label">Tuyến:</span>
                                            <span class="value">Chưa chọn</span>
                                        </div>
                                    </div>

                                    <!-- Vehicle & Driver Selection -->
                                    <div class="row">
                                        <!-- Chọn xe -->
                                        <div class="col-md-6">
                                            <div class="form-card">
                                                <div class="form-card-header">
                                                    <span><i class="fas fa-truck mr-2"></i> Chọn Xe</span>
                                                    <span class="badge badge-light"
                                                        id="vehicleCount">${vehicles.size()}</span>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="search-box">
                                                        <i class="fas fa-search"></i>
                                                        <input type="text" class="form-control" id="searchVehicle"
                                                            placeholder="Tìm theo biển số, loại xe...">
                                                    </div>
                                                    <div class="list-container" id="vehiclesList">
                                                        <c:forEach var="vehicle" items="${vehicles}">
                                                            <div class="vehicle-option ${vehicle.status != 'available' ? 'unavailable' : ''}"
                                                                data-id="${vehicle.vehicleId}"
                                                                data-plate="${vehicle.plateNumber}"
                                                                data-type="${vehicle.vehicleType}"
                                                                data-capacity="${vehicle.loadCapacity}"
                                                                data-status="${vehicle.status}">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center">
                                                                    <div>
                                                                        <strong
                                                                            class="text-primary">${vehicle.plateNumber}</strong>
                                                                        <br><small class="text-muted"><i
                                                                                class="fas fa-car mr-1"></i>${vehicle.vehicleType}</small>
                                                                        <br><small><i
                                                                                class="fas fa-weight mr-1"></i>Tải:
                                                                            ${vehicle.loadCapacity} kg</small>
                                                                    </div>
                                                                    <span
                                                                        class="status-badge badge ${vehicle.status == 'available' ? 'badge-success' : 'badge-secondary'}">
                                                                        ${vehicle.status == 'available' ? 'Sẵn sàng' :
                                                                        vehicle.status}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                        <div class="no-results" id="noVehicleResults"
                                                            style="display: none;">
                                                            <i class="fas fa-truck"></i>
                                                            <p>Không tìm thấy xe phù hợp</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Chọn tài xế -->
                                        <div class="col-md-6">
                                            <div class="form-card">
                                                <div class="form-card-header">
                                                    <span><i class="fas fa-user-tie mr-2"></i> Chọn Tài Xế</span>
                                                    <span class="badge badge-light"
                                                        id="driverCount">${drivers.size()}</span>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="search-box">
                                                        <i class="fas fa-search"></i>
                                                        <input type="text" class="form-control" id="searchDriver"
                                                            placeholder="Tìm theo tên, SĐT, GPLX...">
                                                    </div>
                                                    <div class="list-container" id="driversList">
                                                        <c:forEach var="driver" items="${drivers}">
                                                            <div class="driver-option ${driver.status != 'active' ? 'unavailable' : ''}"
                                                                data-id="${driver.driverId}"
                                                                data-name="${driver.fullName}"
                                                                data-phone="${driver.phoneNumber}"
                                                                data-license="${driver.licenseClass}"
                                                                data-status="${driver.status}">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-center">
                                                                    <div>
                                                                        <strong
                                                                            class="text-primary">${driver.fullName}</strong>
                                                                        <br><small class="text-muted"><i
                                                                                class="fas fa-phone mr-1"></i>${driver.phoneNumber}</small>
                                                                        <br><small><i
                                                                                class="fas fa-id-card mr-1"></i>GPLX:
                                                                            ${driver.licenseClass}</small>
                                                                    </div>
                                                                    <span
                                                                        class="status-badge badge ${driver.status == 'active' ? 'badge-success' : 'badge-secondary'}">
                                                                        ${driver.status == 'active' ? 'Hoạt động' :
                                                                        driver.status}
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                        <div class="no-results" id="noDriverResults"
                                                            style="display: none;">
                                                            <i class="fas fa-user-slash"></i>
                                                            <p>Không tìm thấy tài xế phù hợp</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Create Trip Button -->
                                    <button class="btn btn-primary btn-create-trip btn-block mt-3" id="btnCreateTrip"
                                        disabled>
                                        <i class="fas fa-plus-circle mr-2"></i> TẠO CHUYẾN XE MỚI
                                    </button>
                                </div>

                                <!-- Right Column: Danh sách chuyến xe -->
                                <div class="col-lg-5">
                                    <div class="card shadow">
                                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                            <h6 class="m-0 font-weight-bold text-primary">
                                                <i class="fas fa-list mr-2"></i> Chuyến xe đang xử lý
                                            </h6>
                                            <span class="badge badge-primary" id="tripCount">${trips.size()}</span>
                                        </div>
                                        <div class="trips-search-box">
                                            <div class="search-box mb-0">
                                                <i class="fas fa-search"></i>
                                                <input type="text" class="form-control" id="searchTrip"
                                                    placeholder="Tìm theo mã chuyến, biển số, tài xế...">
                                            </div>
                                        </div>
                                        <div class="card-body" id="tripsList"
                                            style="max-height: 550px; overflow-y: auto;">
                                            <c:choose>
                                                <c:when test="${not empty trips}">
                                                    <c:forEach var="trip" items="${trips}">
                                                        <div class="trip-card" data-trip-id="${trip.tripId}"
                                                            data-code="${trip.tripCode}"
                                                            data-plate="${trip.vehicle.plateNumber}"
                                                            data-driver="${trip.driver.fullName}">
                                                            <div
                                                                class="d-flex justify-content-between align-items-start">
                                                                <div>
                                                                    <strong
                                                                        class="text-primary">${trip.tripCode}</strong>
                                                                    <span
                                                                        class="badge badge-warning ml-2">${trip.status}</span>
                                                                </div>
                                                            </div>
                                                            <div class="mt-2">
                                                                <small class="text-muted">
                                                                    <i
                                                                        class="fas fa-truck mr-1"></i>${trip.vehicle.plateNumber}
                                                                    <span class="mx-2">|</span>
                                                                    <i
                                                                        class="fas fa-user mr-1"></i>${trip.driver.fullName}
                                                                </small>
                                                                <br>
                                                                <small class="text-info">
                                                                    <i
                                                                        class="fas fa-route mr-1"></i>${trip.fromHub.hubName}
                                                                    → ${trip.toHub.hubName}
                                                                </small>
                                                            </div>
                                                            <div class="action-buttons">
                                                                <button class="btn btn-sm btn-info btn-view-trip"
                                                                    data-trip-id="${trip.tripId}" title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button class="btn btn-sm btn-danger btn-delete-trip"
                                                                    data-trip-id="${trip.tripId}"
                                                                    data-trip-code="${trip.tripCode}"
                                                                    title="Hủy chuyến">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-results">
                                                        <i class="fas fa-inbox"></i>
                                                        <p>Chưa có chuyến xe nào</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Trip Detail Modal -->
            <div class="modal fade" id="tripDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-info-circle mr-2"></i> Chi tiết chuyến xe</h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body" id="tripDetailContent"></div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Delete Confirm Modal -->
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title"><i class="fas fa-exclamation-triangle mr-2"></i> Xác nhận hủy chuyến
                            </h5>
                            <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn hủy chuyến xe <strong id="deleteTripCode"></strong>?</p>
                            <p class="text-danger"><small>Lưu ý: Chỉ có thể hủy chuyến khi chưa có bao hàng nào được xếp
                                    lên xe.</small></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Không</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xác nhận hủy</button>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
            <script>
                var contextPath = '${pageContext.request.contextPath}';
                var selectedVehicleId = null;
                var selectedVehiclePlate = null;
                var selectedDriverId = null;
                var selectedDriverName = null;
                var tripIdToDelete = null;
                var managerId = 1;

                // Toast Functions
                function showToast(type, title, message) {
                    var icons = {
                        'success': 'fa-check-circle',
                        'error': 'fa-times-circle',
                        'warning': 'fa-exclamation-triangle',
                        'info': 'fa-info-circle'
                    };
                    var toastHtml = '<div class="custom-toast ' + type + '">' +
                        '<div class="toast-icon"><i class="fas ' + icons[type] + '"></i></div>' +
                        '<div class="toast-content">' +
                        '<div class="toast-title">' + title + '</div>' +
                        '<div class="toast-message">' + message + '</div>' +
                        '</div>' +
                        '<button class="toast-close" onclick="closeToast(this)">&times;</button>' +
                        '</div>';
                    var $toast = $(toastHtml);
                    $('#toastContainer').append($toast);
                    setTimeout(function () {
                        $toast.css('animation', 'slideOut 0.3s ease');
                        setTimeout(function () { $toast.remove(); }, 300);
                    }, 4000);
                }

                function closeToast(btn) {
                    var $toast = $(btn).closest('.custom-toast');
                    $toast.css('animation', 'slideOut 0.3s ease');
                    setTimeout(function () { $toast.remove(); }, 300);
                }

                // Update Selection Summary
                function updateSelectionSummary() {
                    var fromHub = $('#fromHubSelect option:selected').text();
                    var toHub = $('#toHubSelect option:selected').text();

                    // Vehicle
                    if (selectedVehiclePlate) {
                        $('#summaryVehicle').addClass('selected');
                        $('#summaryVehicle .value').text(selectedVehiclePlate);
                    } else {
                        $('#summaryVehicle').removeClass('selected');
                        $('#summaryVehicle .value').text('Chưa chọn');
                    }

                    // Driver
                    if (selectedDriverName) {
                        $('#summaryDriver').addClass('selected');
                        $('#summaryDriver .value').text(selectedDriverName);
                    } else {
                        $('#summaryDriver').removeClass('selected');
                        $('#summaryDriver .value').text('Chưa chọn');
                    }

                    // Route
                    if ($('#fromHubSelect').val() && $('#toHubSelect').val()) {
                        $('#summaryRoute').addClass('selected');
                        $('#summaryRoute .value').text(fromHub.split(' - ')[0] + ' → ' + toHub.split(' - ')[0]);
                    } else {
                        $('#summaryRoute').removeClass('selected');
                        $('#summaryRoute .value').text('Chưa chọn');
                    }

                    // Update summary card style
                    if (selectedVehicleId && selectedDriverId && $('#fromHubSelect').val() && $('#toHubSelect').val()) {
                        $('#selectionSummary').addClass('has-selection');
                    } else {
                        $('#selectionSummary').removeClass('has-selection');
                    }
                }

                $(document).ready(function () {
                    // Search Vehicle
                    $('#searchVehicle').on('keyup', function () {
                        var searchTerm = $(this).val().toLowerCase();
                        var visibleCount = 0;
                        $('.vehicle-option').each(function () {
                            var plate = $(this).data('plate').toString().toLowerCase();
                            var type = $(this).data('type').toString().toLowerCase();
                            if (plate.indexOf(searchTerm) > -1 || type.indexOf(searchTerm) > -1) {
                                $(this).removeClass('hidden');
                                visibleCount++;
                            } else {
                                $(this).addClass('hidden');
                            }
                        });
                        $('#vehicleCount').text(visibleCount);
                        $('#noVehicleResults').toggle(visibleCount === 0);
                    });

                    // Search Driver
                    $('#searchDriver').on('keyup', function () {
                        var searchTerm = $(this).val().toLowerCase();
                        var visibleCount = 0;
                        $('.driver-option').each(function () {
                            var name = $(this).data('name').toString().toLowerCase();
                            var phone = $(this).data('phone').toString().toLowerCase();
                            var license = $(this).data('license').toString().toLowerCase();
                            if (name.indexOf(searchTerm) > -1 || phone.indexOf(searchTerm) > -1 || license.indexOf(searchTerm) > -1) {
                                $(this).removeClass('hidden');
                                visibleCount++;
                            } else {
                                $(this).addClass('hidden');
                            }
                        });
                        $('#driverCount').text(visibleCount);
                        $('#noDriverResults').toggle(visibleCount === 0);
                    });

                    // Search Trip
                    $('#searchTrip').on('keyup', function () {
                        var searchTerm = $(this).val().toLowerCase();
                        var visibleCount = 0;
                        $('.trip-card').each(function () {
                            var code = $(this).data('code').toString().toLowerCase();
                            var plate = $(this).data('plate').toString().toLowerCase();
                            var driver = $(this).data('driver').toString().toLowerCase();
                            if (code.indexOf(searchTerm) > -1 || plate.indexOf(searchTerm) > -1 || driver.indexOf(searchTerm) > -1) {
                                $(this).show();
                                visibleCount++;
                            } else {
                                $(this).hide();
                            }
                        });
                        $('#tripCount').text(visibleCount);
                    });

                    // Select Vehicle
                    $('.vehicle-option').click(function () {
                        if ($(this).hasClass('unavailable')) {
                            if (!confirm('Xe này đang không khả dụng. Bạn vẫn muốn chọn?')) return;
                        }
                        $('.vehicle-option').removeClass('selected');
                        $(this).addClass('selected');
                        selectedVehicleId = $(this).data('id');
                        selectedVehiclePlate = $(this).data('plate');
                        updateCreateButton();
                        updateSelectionSummary();
                    });

                    // Select Driver
                    $('.driver-option').click(function () {
                        if ($(this).hasClass('unavailable')) {
                            if (!confirm('Tài xế này đang không hoạt động. Bạn vẫn muốn chọn?')) return;
                        }
                        $('.driver-option').removeClass('selected');
                        $(this).addClass('selected');
                        selectedDriverId = $(this).data('id');
                        selectedDriverName = $(this).data('name');
                        updateCreateButton();
                        updateSelectionSummary();
                    });

                    // Hub Selection Change
                    $('#fromHubSelect, #toHubSelect').change(function () {
                        updateCreateButton();
                        updateSelectionSummary();
                    });

                    // Create Trip
                    $('#btnCreateTrip').click(function () {
                        var fromHubId = $('#fromHubSelect').val();
                        var toHubId = $('#toHubSelect').val();
                        if (!fromHubId || !toHubId || !selectedVehicleId || !selectedDriverId) {
                            showToast('warning', 'Thiếu thông tin', 'Vui lòng chọn đầy đủ xe, tài xế và tuyến đường');
                            return;
                        }
                        if (fromHubId === toHubId) {
                            showToast('warning', 'Lỗi tuyến đường', 'Hub xuất phát và Hub đích không được trùng nhau');
                            return;
                        }
                        $(this).prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i> Đang tạo...');
                        $.ajax({
                            url: contextPath + '/api/manager/outbound/trips?actorId=' + managerId,
                            method: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                vehicleId: selectedVehicleId,
                                driverId: selectedDriverId,
                                fromHubId: parseInt(fromHubId),
                                toHubId: parseInt(toHubId)
                            }),
                            success: function (response) {
                                if (response.success) {
                                    showToast('success', 'Tạo chuyến thành công!', 'Mã chuyến: ' + response.data.tripCode);
                                    setTimeout(function () { location.reload(); }, 1500);
                                } else {
                                    showToast('error', 'Lỗi', response.message);
                                }
                            },
                            error: function (xhr) {
                                var error = xhr.responseJSON || {};
                                showToast('error', 'Lỗi tạo chuyến', error.message || 'Không thể tạo chuyến xe');
                            },
                            complete: function () {
                                $('#btnCreateTrip').prop('disabled', false).html('<i class="fas fa-plus-circle mr-2"></i> TẠO CHUYẾN XE MỚI');
                                updateCreateButton();
                            }
                        });
                    });

                    // View Trip Detail
                    $(document).on('click', '.btn-view-trip', function (e) {
                        e.stopPropagation();
                        var tripId = $(this).data('trip-id');
                        viewTripDetail(tripId);
                    });

                    // Click on trip card to view detail
                    $(document).on('click', '.trip-card', function (e) {
                        if (!$(e.target).hasClass('btn') && !$(e.target).closest('.btn').length) {
                            var tripId = $(this).data('trip-id');
                            viewTripDetail(tripId);
                        }
                    });

                    // Delete Trip
                    $(document).on('click', '.btn-delete-trip', function (e) {
                        e.stopPropagation();
                        tripIdToDelete = $(this).data('trip-id');
                        var tripCode = $(this).data('trip-code');
                        $('#deleteTripCode').text(tripCode);
                        $('#deleteConfirmModal').modal('show');
                    });

                    // Confirm Delete
                    $('#confirmDeleteBtn').click(function () {
                        if (!tripIdToDelete) return;
                        $(this).prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i> Đang hủy...');
                        $.ajax({
                            url: contextPath + '/api/manager/outbound/trips/' + tripIdToDelete + '/cancel?actorId=' + managerId,
                            method: 'PUT',
                            success: function (response) {
                                if (response.success) {
                                    showToast('success', 'Đã hủy chuyến', 'Chuyến xe đã được hủy thành công');
                                    $('#deleteConfirmModal').modal('hide');
                                    setTimeout(function () { location.reload(); }, 1500);
                                } else {
                                    showToast('error', 'Không thể hủy', response.message);
                                }
                            },
                            error: function (xhr) {
                                var error = xhr.responseJSON || {};
                                showToast('error', 'Lỗi', error.message || 'Không thể hủy chuyến xe');
                            },
                            complete: function () {
                                $('#confirmDeleteBtn').prop('disabled', false).html('Xác nhận hủy');
                            }
                        });
                    });
                });

                function updateCreateButton() {
                    var fromHubId = $('#fromHubSelect').val();
                    var toHubId = $('#toHubSelect').val();
                    var canCreate = fromHubId && toHubId && selectedVehicleId && selectedDriverId;
                    $('#btnCreateTrip').prop('disabled', !canCreate);
                }

                function viewTripDetail(tripId) {
                    $('#tripDetailContent').html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin fa-2x text-primary"></i><p class="mt-2">Đang tải...</p></div>');
                    $('#tripDetailModal').modal('show');
                    $.get(contextPath + '/api/manager/outbound/trips/' + tripId, function (response) {
                        if (response.success) {
                            var trip = response.data;
                            var containersHtml = '';
                            if (trip.containers && trip.containers.length > 0) {
                                trip.containers.forEach(function (c) {
                                    var statusClass = c.tripContainerStatus === 'loaded' ? 'success' : 'secondary';
                                    containersHtml += '<tr>' +
                                        '<td><strong>' + c.containerCode + '</strong></td>' +
                                        '<td><span class="badge badge-info">' + c.type + '</span></td>' +
                                        '<td>' + c.orderCount + '</td>' +
                                        '<td>' + (c.weight || 0) + ' kg</td>' +
                                        '<td><span class="badge badge-' + statusClass + '">' + c.tripContainerStatus + '</span></td>' +
                                        '</tr>';
                                });
                            } else {
                                containersHtml = '<tr><td colspan="5" class="text-center text-muted py-3"><i class="fas fa-box-open mr-2"></i>Chưa có bao hàng nào</td></tr>';
                            }

                            var html = '<div class="row">' +
                                '<div class="col-md-6">' +
                                '<div class="card bg-light mb-3"><div class="card-body">' +
                                '<h6 class="font-weight-bold text-primary"><i class="fas fa-info-circle mr-2"></i>Thông tin chuyến</h6>' +
                                '<p class="mb-1"><strong>Mã chuyến:</strong> ' + trip.tripCode + '</p>' +
                                '<p class="mb-1"><strong>Trạng thái:</strong> <span class="badge badge-warning">' + trip.status + '</span></p>' +
                                '<p class="mb-0"><strong>Tạo lúc:</strong> ' + formatDate(trip.createdAt) + '</p>' +
                                '</div></div>' +
                                '</div>' +
                                '<div class="col-md-6">' +
                                '<div class="card bg-light mb-3"><div class="card-body">' +
                                '<h6 class="font-weight-bold text-primary"><i class="fas fa-truck mr-2"></i>Xe & Tài xế</h6>' +
                                '<p class="mb-1"><strong>Xe:</strong> ' + trip.vehicle.plateNumber + ' (' + trip.vehicle.vehicleType + ')</p>' +
                                '<p class="mb-1"><strong>Sức chứa:</strong> ' + (trip.vehicleCapacity || 0) + ' kg</p>' +
                                '<p class="mb-1"><strong>Tài xế:</strong> ' + trip.driver.fullName + '</p>' +
                                '<p class="mb-0"><strong>SĐT:</strong> ' + trip.driver.phoneNumber + '</p>' +
                                '</div></div>' +
                                '</div>' +
                                '</div>' +
                                '<div class="card bg-info text-white mb-3"><div class="card-body py-2">' +
                                '<i class="fas fa-route mr-2"></i>' + trip.fromHub.hubName + ' <i class="fas fa-arrow-right mx-2"></i> ' + trip.toHub.hubName +
                                '</div></div>' +
                                '<h6 class="font-weight-bold"><i class="fas fa-boxes mr-2"></i>Bao hàng trên xe (' + trip.containerCount + ' bao - ' + (trip.totalLoadedWeight || 0) + ' kg)</h6>' +
                                '<table class="table table-sm table-bordered table-hover">' +
                                '<thead class="thead-light">' +
                                '<tr><th>Mã bao</th><th>Loại</th><th>Số đơn</th><th>Trọng lượng</th><th>Trạng thái</th></tr>' +
                                '</thead>' +
                                '<tbody>' + containersHtml + '</tbody>' +
                                '</table>';
                            $('#tripDetailContent').html(html);
                        }
                    }).fail(function () {
                        $('#tripDetailContent').html('<div class="alert alert-danger"><i class="fas fa-exclamation-circle mr-2"></i>Không thể tải thông tin chuyến xe</div>');
                    });
                }

                function formatDate(dateStr) {
                    if (!dateStr) return 'N/A';
                    var date = new Date(dateStr);
                    return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
                }
            </script>
        </body>

        </html>