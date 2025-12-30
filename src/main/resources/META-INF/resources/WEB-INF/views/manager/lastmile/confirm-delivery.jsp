<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .delivery-header {
                    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    padding: 25px;
                    border-radius: 15px;
                    color: #fff;
                    margin-bottom: 25px;
                }

                .task-card {
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    margin-bottom: 20px;
                    overflow: hidden;
                    transition: all 0.3s;
                }

                .task-card:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
                }

                .task-header {
                    padding: 15px 20px;
                    border-bottom: 1px solid #e3e6f0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .task-body {
                    padding: 20px;
                }

                .task-status {
                    padding: 5px 12px;
                    border-radius: 15px;
                    font-size: 11px;
                    font-weight: 600;
                }

                .status-assigned {
                    background: #cce5ff;
                    color: #004085;
                }

                .status-in_progress {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-completed {
                    background: #d4edda;
                    color: #155724;
                }

                .status-failed {
                    background: #f8d7da;
                    color: #721c24;
                }

                .info-row {
                    display: flex;
                    justify-content: space-between;
                    padding: 8px 0;
                    border-bottom: 1px solid #f1f1f1;
                }

                .info-row:last-child {
                    border-bottom: none;
                }

                .info-label {
                    color: #858796;
                    font-size: 12px;
                }

                .info-value {
                    font-weight: 600;
                }

                .cod-amount {
                    font-size: 20px;
                    font-weight: 700;
                    color: #28a745;
                }

                .btn-confirm {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    border: none;
                    color: #fff;
                    padding: 8px 20px;
                    border-radius: 20px;
                    font-weight: 600;
                }

                .btn-confirm:hover {
                    color: #fff;
                    box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
                }

                .btn-delay {
                    background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
                    border: none;
                    color: #fff;
                    padding: 8px 15px;
                    border-radius: 20px;
                    font-weight: 600;
                }

                .btn-delay:hover {
                    color: #fff;
                    box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
                }

                .filter-card {
                    background: #fff;
                    border-radius: 15px;
                    padding: 20px;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    margin-bottom: 25px;
                }
            </style>

            <!-- Header -->
            <div class="delivery-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-check-circle mr-2"></i>Xác nhận Giao Xong & Hẹn Lại</h4>
                        <p class="mb-0 opacity-75">Cập nhật trạng thái giao hàng từ Shipper</p>
                    </div>
                    <div>
                        <span class="badge badge-light p-2">
                            <i class="fas fa-calendar-day mr-1"></i>
                            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm" />
                        </span>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="filter-card">
                <div class="row align-items-end">
                    <div class="col-md-3">
                        <label class="small text-muted mb-1">Shipper</label>
                        <select class="form-control" id="filterShipper">
                            <option value="">Tất cả Shipper</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="small text-muted mb-1">Trạng thái</label>
                        <select class="form-control" id="filterStatus">
                            <option value="">Tất cả</option>
                            <option value="assigned" selected>Đã phân công</option>
                            <option value="in_progress">Đang giao</option>
                            <option value="completed">Hoàn thành</option>
                            <option value="failed">Thất bại</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="small text-muted mb-1">Tìm kiếm</label>
                        <input type="text" class="form-control" id="searchTask" placeholder="Mã vận đơn, tên khách...">
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-primary btn-block" id="btnSearch">
                            <i class="fas fa-search mr-1"></i>Tìm
                        </button>
                    </div>
                </div>
            </div>

            <!-- Task List -->
            <div class="row" id="taskList">
                <div class="col-12 text-center py-5">
                    <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
                    <p class="mt-3 text-muted">Đang tải danh sách...</p>
                </div>
            </div>

            <!-- Modal Xác nhận giao xong -->
            <div class="modal fade" id="confirmDeliveryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title"><i class="fas fa-check-circle mr-2"></i>Xác nhận Giao Xong</h5>
                            <button type="button" class="close text-white"
                                data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="confirmTaskId">
                            <div class="mb-3">
                                <label class="font-weight-bold">Mã vận đơn:</label>
                                <div id="confirmTrackingCode" class="text-primary font-weight-bold"></div>
                            </div>
                            <div class="mb-3">
                                <label class="font-weight-bold">Số tiền COD cần thu:</label>
                                <div id="confirmCodRequired" class="cod-amount"></div>
                            </div>
                            <div class="mb-3">
                                <label for="codCollected" class="font-weight-bold">Số tiền COD thực thu:</label>
                                <input type="number" class="form-control form-control-lg" id="codCollected" min="0"
                                    step="1000">
                            </div>
                            <div class="mb-3">
                                <label for="confirmNote">Ghi chú:</label>
                                <textarea class="form-control" id="confirmNote" rows="2"
                                    placeholder="Ghi chú khi giao hàng"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-success" id="btnSubmitConfirm">
                                <i class="fas fa-check mr-1"></i>Xác nhận Giao Xong
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Hẹn lại -->
            <div class="modal fade" id="delayDeliveryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-warning text-dark">
                            <h5 class="modal-title"><i class="fas fa-clock mr-2"></i>Hẹn Lại Giao Hàng</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="delayTaskId">
                            <div class="mb-3">
                                <label class="font-weight-bold">Mã vận đơn:</label>
                                <div id="delayTrackingCode" class="text-primary font-weight-bold"></div>
                            </div>
                            <div class="mb-3">
                                <label class="font-weight-bold">Lý do không giao được: <span
                                        class="text-danger">*</span></label>
                                <select class="form-control mb-2" id="delayReasonSelect">
                                    <option value="">-- Chọn lý do --</option>
                                    <option value="Khách vắng nhà">Khách vắng nhà</option>
                                    <option value="Khách không nghe máy">Khách không nghe máy</option>
                                    <option value="Địa chỉ không đúng">Địa chỉ không đúng</option>
                                    <option value="Khách hẹn giao sau">Khách hẹn giao sau</option>
                                    <option value="other">Lý do khác...</option>
                                </select>
                                <textarea class="form-control d-none" id="delayReasonOther" rows="2"
                                    placeholder="Nhập lý do khác..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-warning" id="btnSubmitDelay">
                                <i class="fas fa-clock mr-1"></i>Xác nhận Hẹn Lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var contextPath = '${pageContext.request.contextPath}';

                // Wait for jQuery to be available
                function initPage() {
                    if (typeof jQuery === 'undefined') {
                        setTimeout(initPage, 50);
                        return;
                    }
                    $(document).ready(function () {
                        loadShippers();
                        loadTasks();

                        $('#filterShipper, #filterStatus').change(loadTasks);
                        $('#btnSearch').click(loadTasks);
                        $('#delayReasonSelect').change(function () {
                            if ($(this).val() === 'other') $('#delayReasonOther').removeClass('d-none');
                            else $('#delayReasonOther').addClass('d-none').val('');
                        });
                        $('#btnSubmitConfirm').click(submitConfirmDelivery);
                        $('#btnSubmitDelay').click(submitDelayDelivery);
                    });
                }

                function loadShippers() {
                    $.get(contextPath + '/api/manager/lastmile/shippers', function (response) {
                        if (response.success && response.data) {
                            var html = '<option value="">Tất cả Shipper</option>';
                            response.data.forEach(function (s) {
                                html += '<option value="' + s.shipperId + '">' + s.shipperName + '</option>';
                            });
                            $('#filterShipper').html(html);
                        }
                    });
                }

                function loadTasks() {
                    var shipperId = $('#filterShipper').val();
                    var status = $('#filterStatus').val();
                    var search = $('#searchTask').val();
                    var url = contextPath + '/api/manager/lastmile/tasks?';
                    if (shipperId) url += 'shipperId=' + shipperId + '&';
                    if (status) url += 'status=' + status + '&';

                    $.get(url, function (response) {
                        if (response.success && response.data) {
                            var tasks = response.data;
                            if (search) {
                                var keyword = search.toLowerCase();
                                tasks = tasks.filter(function (t) {
                                    return (t.trackingCode && t.trackingCode.toLowerCase().indexOf(keyword) !== -1) ||
                                        (t.receiverName && t.receiverName.toLowerCase().indexOf(keyword) !== -1);
                                });
                            }
                            renderTasks(tasks);
                        }
                    }).fail(function () {
                        $('#taskList').html('<div class="col-12 text-center py-5"><p class="text-danger">Lỗi tải dữ liệu</p></div>');
                    });
                }

                function renderTasks(tasks) {
                    if (tasks.length === 0) {
                        $('#taskList').html('<div class="col-12 text-center py-5"><p class="text-muted">Không có task nào</p></div>');
                        return;
                    }
                    var html = '';
                    tasks.forEach(function (task) {
                        var canAction = task.taskStatus === 'assigned' || task.taskStatus === 'in_progress';
                        html += '<div class="col-lg-4 col-md-6"><div class="task-card">' +
                            '<div class="task-header"><div><h6 class="mb-0 font-weight-bold">' + task.trackingCode + '</h6>' +
                            '<small class="text-muted">Shipper: ' + task.shipperName + '</small></div>' +
                            '<span class="task-status status-' + task.taskStatus + '">' + getStatusText(task.taskStatus) + '</span></div>' +
                            '<div class="task-body">' +
                            '<div class="info-row"><div class="info-label"><i class="fas fa-user mr-1"></i>Người nhận</div><div class="info-value">' + (task.receiverName || 'N/A') + '</div></div>' +
                            '<div class="info-row"><div class="info-label"><i class="fas fa-phone mr-1"></i>SĐT</div><div class="info-value">' + (task.receiverPhone || 'N/A') + '</div></div>' +
                            '<div class="info-row"><div class="info-label"><i class="fas fa-map-marker-alt mr-1"></i>Địa chỉ</div><div class="info-value small">' + (task.receiverAddress || 'N/A') + '</div></div>' +
                            '<div class="info-row"><div class="info-label"><i class="fas fa-money-bill mr-1"></i>COD</div><div class="info-value text-success font-weight-bold">' + formatCurrency(task.codAmount || 0) + '</div></div>';
                        if (canAction) {
                            html += '<div class="mt-3 d-flex">' +
                                '<button class="btn btn-confirm flex-grow-1 mr-2" onclick="openConfirmModal(' + task.taskId + ',\'' + task.trackingCode + '\',' + (task.codAmount || 0) + ')"><i class="fas fa-check mr-1"></i>Giao xong</button>' +
                                '<button class="btn btn-delay" onclick="openDelayModal(' + task.taskId + ',\'' + task.trackingCode + '\')"><i class="fas fa-clock mr-1"></i>Hẹn lại</button></div>';
                        }
                        html += '</div></div></div>';
                    });
                    $('#taskList').html(html);
                }

                function getStatusText(status) {
                    var texts = { 'assigned': 'Đã phân công', 'in_progress': 'Đang giao', 'completed': 'Hoàn thành', 'failed': 'Thất bại' };
                    return texts[status] || status;
                }

                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
                }

                function openConfirmModal(taskId, trackingCode, codAmount) {
                    $('#confirmTaskId').val(taskId);
                    $('#confirmTrackingCode').text(trackingCode);
                    $('#confirmCodRequired').text(formatCurrency(codAmount));
                    $('#codCollected').val(codAmount);
                    $('#confirmNote').val('');
                    $('#confirmDeliveryModal').modal('show');
                }

                function openDelayModal(taskId, trackingCode) {
                    $('#delayTaskId').val(taskId);
                    $('#delayTrackingCode').text(trackingCode);
                    $('#delayReasonSelect').val('');
                    $('#delayReasonOther').addClass('d-none').val('');
                    $('#delayDeliveryModal').modal('show');
                }

                function submitConfirmDelivery() {
                    var taskId = $('#confirmTaskId').val();
                    var codCollected = $('#codCollected').val();
                    var note = $('#confirmNote').val();

                    $('#btnSubmitConfirm').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');
                    $.ajax({
                        url: contextPath + '/api/manager/lastmile/confirm-delivery',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ taskId: parseInt(taskId), codCollected: parseFloat(codCollected) || 0, note: note }),
                        success: function (response) {
                            $('#confirmDeliveryModal').modal('hide');
                            alert('Xác nhận giao hàng thành công!\nMã vận đơn: ' + response.trackingCode);
                            loadTasks();
                        },
                        error: function (xhr) {
                            alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Có lỗi xảy ra'));
                        },
                        complete: function () {
                            $('#btnSubmitConfirm').prop('disabled', false).html('<i class="fas fa-check mr-1"></i>Xác nhận Giao Xong');
                        }
                    });
                }

                function submitDelayDelivery() {
                    var taskId = $('#delayTaskId').val();
                    var reason = $('#delayReasonSelect').val();
                    if (reason === 'other') reason = $('#delayReasonOther').val();
                    if (!reason) { alert('Vui lòng chọn hoặc nhập lý do'); return; }

                    $('#btnSubmitDelay').prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');
                    $.ajax({
                        url: contextPath + '/api/manager/lastmile/delivery-delay',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ taskId: parseInt(taskId), reason: reason }),
                        success: function (response) {
                            $('#delayDeliveryModal').modal('hide');
                            alert('Đã ghi nhận hẹn lại giao hàng!\nMã vận đơn: ' + response.trackingCode);
                            loadTasks();
                        },
                        error: function (xhr) {
                            alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Có lỗi xảy ra'));
                        },
                        complete: function () {
                            $('#btnSubmitDelay').prop('disabled', false).html('<i class="fas fa-clock mr-1"></i>Xác nhận Hẹn Lại');
                        }
                    });
                }

                // Start initialization
                initPage();
            </script>