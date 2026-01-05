<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .page-hero {
    background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%);
    padding: 22px;
    border-radius: 14px;
    color: #fff;
    margin-bottom: 18px;
  }
  .panel {
    background: #fff;
    border-radius: 14px;
    box-shadow: 0 5px 18px rgba(0,0,0,0.08);
    overflow: hidden;
  }
  .panel-header {
    padding: 14px 16px;
    border-bottom: 1px solid #e3e6f0;
    background: #f8f9fc;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .table thead th { background: #f8f9fc; }
  .status-badge {
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
  }
  .status-active { background:#d4edda; color:#155724; }
  .status-inactive { background:#f8d7da; color:#721c24; }
</style>

<div class="page-hero">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1"><i class="fas fa-user-shield mr-2"></i>Đội ngũ Tài xế</h4>
      <div class="opacity-75">Quản lý danh sách tài xế phục vụ điều phối xe</div>
    </div>
    <div>
      <button class="btn btn-light" id="btnReloadDrivers"><i class="fas fa-sync-alt mr-1"></i>Làm mới</button>
    </div>
  </div>
</div>

<div class="panel">
  <div class="panel-header">
    <div class="d-flex align-items-center">
      <i class="fas fa-list mr-2 text-primary"></i>
      <strong>Danh sách tài xế</strong>
    </div>
    <div class="d-flex">
      <input class="form-control form-control-sm mr-2" style="width: 260px;" id="driverSearch" placeholder="Tìm theo tên/SĐT..." />
      <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#driverModal"><i class="fas fa-plus mr-1"></i>Thêm tài xế</button>
    </div>
  </div>
  <div class="card-body">
    <div class="table-responsive">
      <table class="table table-bordered" id="driverTable" width="100%" cellspacing="0">
        <thead>
          <tr>
            <th style="width: 70px;">ID</th>
            <th>Họ tên</th>
            <th>SĐT</th>
            <th>Hub</th>
            <th>Trạng thái</th>
            <th style="width: 150px;">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <tr><td colspan="6" class="text-center text-muted py-4">Đang tải...</td></tr>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal Add/Edit Driver -->
<div class="modal fade" id="driverModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-id-card mr-2"></i><span id="driverModalTitle">Thêm tài xế</span></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="driverId" />
        <div class="form-group">
          <label class="small text-muted mb-1">Họ tên</label>
          <input class="form-control" id="driverName" placeholder="Nguyễn Văn A" />
        </div>
        <div class="form-group">
          <label class="small text-muted mb-1">Số điện thoại</label>
          <input class="form-control" id="driverPhone" placeholder="09xxxxxxxx" />
        </div>
        <div class="form-group">
          <label class="small text-muted mb-1">Trạng thái</label>
          <select class="form-control" id="driverStatus">
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>
        <div class="alert alert-danger" id="driverError" style="display:none;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
        <button type="button" class="btn btn-primary" id="btnSaveDriver"><i class="fas fa-save mr-1"></i>Lưu</button>
      </div>
    </div>
  </div>
</div>

<script>
  (function () {
    var contextPath = "${pageContext.request.contextPath}";
    var drivers = [];

    function escapeHtml(s) {
      return String(s || "").replace(/[&<>"']/g, function (c) {
        return ({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"})[c];
      });
    }

    function render(list) {
      var tbody = $("#driverTable tbody");
      if (!list || list.length === 0) {
        tbody.html('<tr><td colspan="6" class="text-center text-muted py-4">Chưa có dữ liệu</td></tr>');
        return;
      }
      tbody.empty();
      list.forEach(function (d) {
        var status = (d.status || d.driverStatus || "").toString().toLowerCase();
        var statusCls = status === "active" ? "status-active" : "status-inactive";
        var statusText = status || "unknown";
        var hub = d.hubName || d.hubId || "-";

        tbody.append(
          '<tr>' +
            '<td>' + escapeHtml(d.driverId || d.id) + '</td>' +
            '<td>' + escapeHtml(d.fullName || d.name || d.driverName) + '</td>' +
            '<td>' + escapeHtml(d.phone || d.driverPhone) + '</td>' +
            '<td>' + escapeHtml(hub) + '</td>' +
            '<td><span class="status-badge ' + statusCls + '">' + escapeHtml(statusText) + '</span></td>' +
            '<td>' +
              '<button class="btn btn-sm btn-outline-primary mr-1 btn-edit" data-id="' + escapeHtml(d.driverId || d.id) + '"><i class="fas fa-edit"></i></button>' +
              '<button class="btn btn-sm btn-outline-danger btn-del" data-id="' + escapeHtml(d.driverId || d.id) + '"><i class="fas fa-trash"></i></button>' +
            '</td>' +
          '</tr>'
        );
      });
    }

    function loadDrivers() {
      $("#driverTable tbody").html('<tr><td colspan="6" class="text-center text-muted py-4">Đang tải...</td></tr>');
      $.get(contextPath + "/api/manager/resource/drivers", function (res) {
        // ApiResponse.success wraps data
        drivers = (res && res.data) ? res.data : (res || []);
        applyFilter();
      }).fail(function () {
        drivers = [];
        render([]);
      });
    }

    function applyFilter() {
      var q = ($("#driverSearch").val() || "").toLowerCase().trim();
      if (!q) {
        render(drivers);
        return;
      }
      render(drivers.filter(function (d) {
        var name = (d.fullName || d.name || d.driverName || "").toLowerCase();
        var phone = (d.phone || d.driverPhone || "").toLowerCase();
        return name.indexOf(q) !== -1 || phone.indexOf(q) !== -1;
      }));
    }

    function openCreate() {
      $("#driverModalTitle").text("Thêm tài xế");
      $("#driverId").val("");
      $("#driverName").val("");
      $("#driverPhone").val("");
      $("#driverStatus").val("active");
      $("#driverError").hide();
    }

    function openEdit(id) {
      var d = drivers.find(function (x) { return String(x.driverId || x.id) === String(id); });
      if (!d) return;
      $("#driverModalTitle").text("Cập nhật tài xế");
      $("#driverId").val(d.driverId || d.id);
      $("#driverName").val(d.fullName || d.name || d.driverName || "");
      $("#driverPhone").val(d.phone || d.driverPhone || "");
      var st = (d.status || d.driverStatus || "active").toString().toLowerCase();
      $("#driverStatus").val(st);
      $("#driverError").hide();
      $("#driverModal").modal("show");
    }

    function saveDriver() {
      var id = $("#driverId").val();
      var payload = {
        fullName: $("#driverName").val(),
        phone: $("#driverPhone").val(),
        status: $("#driverStatus").val()
      };

      $("#driverError").hide();

      var method = id ? "PUT" : "POST";
      var url = contextPath + "/api/manager/resource/drivers" + (id ? ("/" + encodeURIComponent(id)) : "");

      $.ajax({
        url: url,
        method: method,
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function () {
          $("#driverModal").modal("hide");
          loadDrivers();
        },
        error: function (xhr) {
          var msg = "Lưu thất bại";
          try {
            var json = xhr.responseJSON;
            if (json && json.message) msg = json.message;
            if (json && json.error) msg = json.error;
          } catch (e) {}
          $("#driverError").text(msg).show();
        }
      });
    }

    function deleteDriver(id) {
      if (!confirm("Xóa tài xế này?")) return;
      $.ajax({
        url: contextPath + "/api/manager/resource/drivers/" + encodeURIComponent(id),
        method: "DELETE",
        success: function () { loadDrivers(); },
        error: function () { alert("Xóa thất bại"); }
      });
    }

    function init() {
      if (typeof jQuery === "undefined") {
        setTimeout(init, 50);
        return;
      }
      $(document).ready(function () {
        loadDrivers();
        $("#btnReloadDrivers").click(loadDrivers);
        $("#driverSearch").on("input", applyFilter);
        $("#driverModal").on("show.bs.modal", openCreate);
        $("#btnSaveDriver").click(saveDriver);

        $(document).on("click", ".btn-edit", function () { openEdit($(this).data("id")); });
        $(document).on("click", ".btn-del", function () { deleteDriver($(this).data("id")); });
      });
    }

    init();
  })();
</script>
