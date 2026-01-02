<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

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

  .task-type-pickup {
    border-left: 4px solid #17a2b8;
  }
  .task-type-delivery {
    border-left: 4px solid #28a745;
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

  .nav-pills .nav-link {
    border-radius: 25px;
    padding: 12px 25px;
    font-weight: 600;
    margin-right: 10px;
  }
  .nav-pills .nav-link.active {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  }
  .badge-count {
    background: rgba(255, 255, 255, 0.3);
    padding: 3px 8px;
    border-radius: 10px;
    margin-left: 5px;
  }
  .tab-content {
    padding-top: 20px;
  }
</style>

<!-- Header -->
<div class="delivery-header">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1">
        <i class="fas fa-check-circle mr-2"></i>Cập nhật Kết quả Giao nhận
      </h4>
      <p class="mb-0 opacity-75">Xác nhận hoàn thành hoặc hẹn lại các task</p>
    </div>
    <div>
      <span class="badge badge-light p-2">
        <i class="fas fa-calendar-day mr-1"></i>
        <fmt:formatDate
          value="<%=new java.util.Date()%>"
          pattern="dd/MM/yyyy HH:mm" />
      </span>
    </div>
  </div>
</div>

<!-- Tabs -->
<ul class="nav nav-pills mb-3" id="taskTabs">
  <li class="nav-item">
    <a class="nav-link active" data-toggle="pill" href="#pickupTab">
      <i class="fas fa-box mr-2"></i>Đơn Nhận hàng
      <span class="badge-count" id="pickupBadge">0</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="pill" href="#deliveryTab">
      <i class="fas fa-truck mr-2"></i>Đơn Giao hàng
      <span class="badge-count" id="deliveryBadge">0</span>
    </a>
  </li>
</ul>

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
        <option value="in_progress">Đang xử lý</option>
        <option value="completed">Hoàn thành</option>
        <option value="failed">Thất bại</option>
      </select>
    </div>
    <div class="col-md-4">
      <label class="small text-muted mb-1">Tìm kiếm</label>
      <input
        type="text"
        class="form-control"
        id="searchTask"
        placeholder="Mã vận đơn, tên khách..." />
    </div>
    <div class="col-md-2">
      <button class="btn btn-primary btn-block" id="btnSearch">
        <i class="fas fa-search mr-1"></i>Tìm
      </button>
    </div>
  </div>
</div>

<!-- Tab Content -->
<div class="tab-content">
  <!-- Pickup Tab -->
  <div class="tab-pane fade show active" id="pickupTab">
    <div class="row" id="pickupTaskList">
      <div class="col-12 text-center py-5">
        <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
        <p class="mt-3 text-muted">Đang tải danh sách...</p>
      </div>
    </div>
  </div>

  <!-- Delivery Tab -->
  <div class="tab-pane fade" id="deliveryTab">
    <div class="row" id="deliveryTaskList">
      <div class="col-12 text-center py-5">
        <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
        <p class="mt-3 text-muted">Đang tải danh sách...</p>
      </div>
    </div>
  </div>
</div>

<!-- Modal Xác nhận hoàn thành -->
<div class="modal fade" id="confirmModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title">
          <i class="fas fa-check-circle mr-2"></i>Xác nhận Hoàn thành
        </h5>
        <button type="button" class="close text-white" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="confirmTaskId" />
        <input type="hidden" id="confirmTaskType" />
        <div class="mb-3">
          <label class="font-weight-bold">Mã vận đơn:</label>
          <div
            id="confirmTrackingCode"
            class="text-primary font-weight-bold"></div>
        </div>
        <div class="mb-3" id="codSection">
          <label class="font-weight-bold">Số tiền COD cần thu:</label>
          <div id="confirmCodRequired" class="cod-amount"></div>
          <label for="codCollected" class="font-weight-bold mt-2"
            >Số tiền COD thực thu:</label
          >
          <input
            type="number"
            class="form-control form-control-lg"
            id="codCollected"
            min="0"
            step="1000" />
        </div>
        <div class="mb-3">
          <label for="confirmNote">Ghi chú:</label>
          <textarea
            class="form-control"
            id="confirmNote"
            rows="2"
            placeholder="Ghi chú..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button type="button" class="btn btn-success" id="btnSubmitConfirm">
          <i class="fas fa-check mr-1"></i>Xác nhận Hoàn thành
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Hẹn lại -->
<div class="modal fade" id="delayModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title"><i class="fas fa-clock mr-2"></i>Hẹn Lại</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="delayTaskId" />
        <div class="mb-3">
          <label class="font-weight-bold">Mã vận đơn:</label>
          <div
            id="delayTrackingCode"
            class="text-primary font-weight-bold"></div>
        </div>
        <div class="mb-3">
          <label class="font-weight-bold"
            >Lý do: <span class="text-danger">*</span></label
          >
          <select class="form-control mb-2" id="delayReasonSelect">
            <option value="">-- Chọn lý do --</option>
            <option value="Khách vắng nhà">Khách vắng nhà</option>
            <option value="Khách không nghe máy">Khách không nghe máy</option>
            <option value="Địa chỉ không đúng">Địa chỉ không đúng</option>
            <option value="Khách hẹn lấy/giao sau">
              Khách hẹn lấy/giao sau
            </option>
            <option value="other">Lý do khác...</option>
          </select>
          <textarea
            class="form-control d-none"
            id="delayReasonOther"
            rows="2"
            placeholder="Nhập lý do khác..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button type="button" class="btn btn-warning" id="btnSubmitDelay">
          <i class="fas fa-clock mr-1"></i>Xác nhận Hẹn Lại
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var allTasks = [];

  function initPage() {
    if (typeof jQuery === "undefined") {
      setTimeout(initPage, 50);
      return;
    }
    $(document).ready(function () {
      loadShippers();
      loadTasks();

      $("#filterShipper, #filterStatus").change(filterAndRender);
      $("#btnSearch").click(filterAndRender);
      $("#searchTask").keypress(function (e) {
        if (e.which === 13) filterAndRender();
      });
      $("#delayReasonSelect").change(function () {
        if ($(this).val() === "other")
          $("#delayReasonOther").removeClass("d-none");
        else $("#delayReasonOther").addClass("d-none").val("");
      });
      $("#btnSubmitConfirm").click(submitConfirm);
      $("#btnSubmitDelay").click(submitDelay);
    });
  }

  function loadShippers() {
    $.get(contextPath + "/api/manager/lastmile/shippers", function (response) {
      if (response.success && response.data) {
        var html = '<option value="">Tất cả Shipper</option>';
        response.data.forEach(function (s) {
          html +=
            '<option value="' +
            s.shipperId +
            '">' +
            s.shipperName +
            "</option>";
        });
        $("#filterShipper").html(html);
      }
    });
  }

  function loadTasks() {
    $.get(contextPath + "/api/manager/lastmile/tasks", function (response) {
      if (response.success && response.data) {
        allTasks = response.data;
        filterAndRender();
      }
    }).fail(function () {
      $("#pickupTaskList, #deliveryTaskList").html(
        '<div class="col-12 text-center py-5"><p class="text-danger">Lỗi tải dữ liệu</p></div>'
      );
    });
  }

  function filterAndRender() {
    var shipperId = $("#filterShipper").val();
    var status = $("#filterStatus").val();
    var search = $("#searchTask").val().toLowerCase();

    var filtered = allTasks.filter(function (t) {
      if (shipperId && t.shipperId != shipperId) return false;
      if (status && t.taskStatus !== status) return false;
      if (search) {
        var match =
          (t.trackingCode &&
            t.trackingCode.toLowerCase().indexOf(search) !== -1) ||
          (t.receiverName &&
            t.receiverName.toLowerCase().indexOf(search) !== -1);
        if (!match) return false;
      }
      return true;
    });

    var pickupTasks = filtered.filter(function (t) {
      return t.taskType === "pickup";
    });
    var deliveryTasks = filtered.filter(function (t) {
      return t.taskType === "delivery";
    });

    renderTasks(pickupTasks, "pickupTaskList", "pickup");
    renderTasks(deliveryTasks, "deliveryTaskList", "delivery");

    $("#pickupBadge").text(pickupTasks.length);
    $("#deliveryBadge").text(deliveryTasks.length);
  }

  function renderTasks(tasks, containerId, taskType) {
    if (tasks.length === 0) {
      $("#" + containerId).html(
        '<div class="col-12 text-center py-5"><p class="text-muted">Không có task nào</p></div>'
      );
      return;
    }
    var html = "";
    tasks.forEach(function (task) {
      var canAction =
        task.taskStatus === "assigned" || task.taskStatus === "in_progress";
      var typeClass = "task-type-" + taskType;
      var typeIcon = taskType === "pickup" ? "fa-box" : "fa-truck";
      var typeLabel = taskType === "pickup" ? "Nhận hàng" : "Giao hàng";
      var addressLabel = taskType === "pickup" ? "Địa chỉ lấy" : "Địa chỉ giao";

      var contactName =
        task.contactName ||
        (taskType === "pickup" ? task.senderName : task.receiverName) ||
        "Chưa có tên";
      var contactPhone =
        task.contactPhone ||
        (taskType === "pickup" ? task.senderPhone : task.receiverPhone) ||
        "Chưa có SĐT";
      var contactAddress =
        task.contactAddress ||
        (taskType === "pickup" ? task.senderAddress : task.receiverAddress) ||
        "Chưa có địa chỉ";

      // Sử dụng receiverPayAmount thay vì codAmount
      var payAmount = task.receiverPayAmount || task.codAmount || 0;

      html +=
        '<div class="col-lg-4 col-md-6"><div class="task-card ' +
        typeClass +
        '">' +
        '<div class="task-header"><div><h6 class="mb-0 font-weight-bold">' +
        task.trackingCode +
        "</h6>" +
        '<small class="text-muted"><i class="fas ' +
        typeIcon +
        ' mr-1"></i>' +
        typeLabel +
        " - " +
        task.shipperName +
        "</small></div>" +
        '<span class="task-status status-' +
        task.taskStatus +
        '">' +
        getStatusText(task.taskStatus) +
        "</span></div>" +
        '<div class="task-body">' +
        '<div class="info-row"><div class="info-label"><i class="fas fa-user mr-1"></i>Khách hàng</div><div class="info-value">' +
        contactName +
        "</div></div>" +
        '<div class="info-row"><div class="info-label"><i class="fas fa-phone mr-1"></i>SĐT</div><div class="info-value">' +
        contactPhone +
        "</div></div>" +
        '<div class="info-row"><div class="info-label"><i class="fas fa-map-marker-alt mr-1"></i>' +
        addressLabel +
        '</div><div class="info-value small">' +
        contactAddress +
        "</div></div>" +
        '<div class="info-row"><div class="info-label"><i class="fas fa-money-bill mr-1"></i>Tiền thu</div><div class="info-value text-success font-weight-bold">' +
        formatCurrency(payAmount) +
        "</div></div>";
      if (canAction) {
        html +=
          '<div class="mt-3 d-flex">' +
          '<button class="btn btn-confirm flex-grow-1 mr-2" onclick="openConfirmModal(' +
          task.taskId +
          ",'" +
          task.trackingCode +
          "'," +
          payAmount +
          ",'" +
          taskType +
          '\')"><i class="fas fa-check mr-1"></i>Hoàn thành</button>' +
          '<button class="btn btn-delay" onclick="openDelayModal(' +
          task.taskId +
          ",'" +
          task.trackingCode +
          '\')"><i class="fas fa-clock mr-1"></i>Hẹn lại</button></div>';
      }
      html += "</div></div></div>";
    });
    $("#" + containerId).html(html);
  }

  function getStatusText(status) {
    var texts = {
      assigned: "Đã phân công",
      in_progress: "Đang xử lý",
      completed: "Hoàn thành",
      failed: "Thất bại",
    };
    return texts[status] || status;
  }

  function formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  function openConfirmModal(taskId, trackingCode, codAmount, taskType) {
    $("#confirmTaskId").val(taskId);
    $("#confirmTaskType").val(taskType);
    $("#confirmTrackingCode").text(trackingCode);
    $("#confirmCodRequired").text(formatCurrency(codAmount));
    $("#codCollected").val(codAmount);
    $("#confirmNote").val("");
    // Show/hide COD section based on task type
    if (taskType === "pickup" || codAmount <= 0) {
      $("#codSection").hide();
    } else {
      $("#codSection").show();
    }
    $("#confirmModal").modal("show");
  }

  function openDelayModal(taskId, trackingCode) {
    $("#delayTaskId").val(taskId);
    $("#delayTrackingCode").text(trackingCode);
    $("#delayReasonSelect").val("");
    $("#delayReasonOther").addClass("d-none").val("");
    $("#delayModal").modal("show");
  }

  function submitConfirm() {
    var taskId = $("#confirmTaskId").val();
    var taskType = $("#confirmTaskType").val();
    var codCollected = $("#codCollected").val();
    var note = $("#confirmNote").val();

    $("#btnSubmitConfirm")
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');
    $.ajax({
      url: contextPath + "/api/manager/lastmile/confirm-delivery",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        taskId: parseInt(taskId),
        codCollected: parseFloat(codCollected) || 0,
        note: note,
      }),
      success: function (response) {
        $("#confirmModal").modal("hide");
        alert("Xác nhận hoàn thành!\nMã vận đơn: " + response.trackingCode);
        loadTasks();
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
      },
      complete: function () {
        $("#btnSubmitConfirm")
          .prop("disabled", false)
          .html('<i class="fas fa-check mr-1"></i>Xác nhận Hoàn thành');
      },
    });
  }

  function submitDelay() {
    var taskId = $("#delayTaskId").val();
    var reason = $("#delayReasonSelect").val();
    if (reason === "other") reason = $("#delayReasonOther").val();
    if (!reason) {
      alert("Vui lòng chọn hoặc nhập lý do");
      return;
    }

    $("#btnSubmitDelay")
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');
    $.ajax({
      url: contextPath + "/api/manager/lastmile/delivery-delay",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ taskId: parseInt(taskId), reason: reason }),
      success: function (response) {
        $("#delayModal").modal("hide");
        alert("Đã ghi nhận hẹn lại!\nMã vận đơn: " + response.trackingCode);
        loadTasks();
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
      },
      complete: function () {
        $("#btnSubmitDelay")
          .prop("disabled", false)
          .html('<i class="fas fa-clock mr-1"></i>Xác nhận Hẹn Lại');
      },
    });
  }

  initPage();
</script>
