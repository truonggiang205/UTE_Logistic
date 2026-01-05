<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .page-hero {
    background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%);
    padding: 22px;
    border-radius: 14px;
    color: #1f2937;
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
  .status-badge {
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
  }
  .status-available { background:#d4edda; color:#155724; }
  .status-maintenance { background:#f8d7da; color:#721c24; }
  .status-in_transit { background:#cce5ff; color:#004085; }
</style>

<div class="page-hero">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1"><i class="fas fa-truck mr-2"></i>Phương tiện (Xe tải)</h4>
      <div class="opacity-75">Quản lý xe phục vụ điều phối chuyến (trip)</div>
    </div>
    <div>
      <button class="btn btn-dark" id="btnReloadVehicles"><i class="fas fa-sync-alt mr-1"></i>Làm mới</button>
    </div>
  </div>
</div>

<div class="panel">
  <div class="panel-header">
    <div class="d-flex align-items-center">
      <i class="fas fa-list mr-2 text-primary"></i>
      <strong>Danh sách xe</strong>
    </div>
    <div class="d-flex">
      <input class="form-control form-control-sm mr-2" style="width: 260px;" id="vehicleSearch" placeholder="Tìm theo biển số..." />
      <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#vehicleModal"><i class="fas fa-plus mr-1"></i>Thêm xe</button>
    </div>
  </div>
  <div class="card-body">
    <div class="table-responsive">
      <table class="table table-bordered" id="vehicleTable" width="100%" cellspacing="0">
        <thead>
          <tr>
            <th style="width: 70px;">ID</th>
            <th>Biển số</th>
            <th>Loại xe</th>
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

<!-- Modal Add/Edit Vehicle -->
<div class="modal fade" id="vehicleModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-truck mr-2"></i><span id="vehicleModalTitle">Thêm xe</span></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="vehicleId" />
        <div class="form-group">
          <label class="small text-muted mb-1">Biển số</label>
          <input class="form-control" id="vehiclePlate" placeholder="51C-123.45" />
        </div>
        <div class="form-group">
          <label class="small text-muted mb-1">Loại xe</label>
          <input class="form-control" id="vehicleType" placeholder="Xe tải 1.5T" />
        </div>
        <div class="form-group">
          <label class="small text-muted mb-1">Trạng thái</label>
          <select class="form-control" id="vehicleStatus">
            <option value="available">Available</option>
            <option value="in_transit">In Transit</option>
            <option value="maintenance">Maintenance</option>
          </select>
        </div>
        <div class="alert alert-danger" id="vehicleError" style="display:none;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
        <button type="button" class="btn btn-primary" id="btnSaveVehicle"><i class="fas fa-save mr-1"></i>Lưu</button>
      </div>
    </div>
  </div>
</div>

<script>
  (function () {
    var contextPath = "${pageContext.request.contextPath}";
    var vehicles = [];

    function escapeHtml(s) {
      return String(s || "").replace(/[&<>"']/g, function (c) {
        return ({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"})[c];
      });
    }

    function render(list) {
      var tbody = $("#vehicleTable tbody");
      if (!list || list.length === 0) {
        tbody.html('<tr><td colspan="6" class="text-center text-muted py-4">Chưa có dữ liệu</td></tr>');
        return;
      }
      tbody.empty();
      list.forEach(function (v) {
        var status = (v.status || v.vehicleStatus || "").toString().toLowerCase();
        var cls = "status-available";
        if (status === "maintenance") cls = "status-maintenance";
        else if (status === "in_transit") cls = "status-in_transit";

        var hub = v.hubName || v.hubId || "-";
        tbody.append(
          '<tr>' +
            '<td>' + escapeHtml(v.vehicleId || v.id) + '</td>' +
            '<td>' + escapeHtml(v.plateNumber || v.plate || v.licensePlate) + '</td>' +
            '<td>' + escapeHtml(v.vehicleType || v.type || "-") + '</td>' +
            '<td>' + escapeHtml(hub) + '</td>' +
            '<td><span class="status-badge ' + cls + '">' + escapeHtml(status || "unknown") + '</span></td>' +
            '<td>' +
              '<button class="btn btn-sm btn-outline-primary mr-1 btn-edit" data-id="' + escapeHtml(v.vehicleId || v.id) + '"><i class="fas fa-edit"></i></button>' +
              '<button class="btn btn-sm btn-outline-danger btn-del" data-id="' + escapeHtml(v.vehicleId || v.id) + '"><i class="fas fa-trash"></i></button>' +
            '</td>' +
          '</tr>'
        );
      });
    }

    function loadVehicles() {
      $("#vehicleTable tbody").html('<tr><td colspan="6" class="text-center text-muted py-4">Đang tải...</td></tr>');
      $.get(contextPath + "/api/manager/resource/vehicles", function (res) {
        vehicles = (res && res.data) ? res.data : (res || []);
        applyFilter();
      }).fail(function () {
        vehicles = [];
        render([]);
      });
    }

    function applyFilter() {
      var q = ($("#vehicleSearch").val() || "").toLowerCase().trim();
      if (!q) {
        render(vehicles);
        return;
      }
      render(vehicles.filter(function (v) {
        var plate = (v.plateNumber || v.plate || v.licensePlate || "").toLowerCase();
        return plate.indexOf(q) !== -1;
      }));
    }

    function openCreate() {
      $("#vehicleModalTitle").text("Thêm xe");
      $("#vehicleId").val("");
      $("#vehiclePlate").val("");
      $("#vehicleType").val("");
      $("#vehicleStatus").val("available");
      $("#vehicleError").hide();
    }

    function openEdit(id) {
      var v = vehicles.find(function (x) { return String(x.vehicleId || x.id) === String(id); });
      if (!v) return;
      $("#vehicleModalTitle").text("Cập nhật xe");
      $("#vehicleId").val(v.vehicleId || v.id);
      $("#vehiclePlate").val(v.plateNumber || v.plate || v.licensePlate || "");
      $("#vehicleType").val(v.vehicleType || v.type || "");
      var st = (v.status || v.vehicleStatus || "available").toString().toLowerCase();
      $("#vehicleStatus").val(st);
      $("#vehicleError").hide();
      $("#vehicleModal").modal("show");
    }

    function saveVehicle() {
      var id = $("#vehicleId").val();
      var payload = {
        plateNumber: $("#vehiclePlate").val(),
        vehicleType: $("#vehicleType").val(),
        status: $("#vehicleStatus").val()
      };

      $("#vehicleError").hide();

      var method = id ? "PUT" : "POST";
      var url = contextPath + "/api/manager/resource/vehicles" + (id ? ("/" + encodeURIComponent(id)) : "");

      $.ajax({
        url: url,
        method: method,
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function () {
          $("#vehicleModal").modal("hide");
          loadVehicles();
        },
        error: function (xhr) {
          var msg = "Lưu thất bại";
          try {
            var json = xhr.responseJSON;
            if (json && json.message) msg = json.message;
            if (json && json.error) msg = json.error;
          } catch (e) {}
          $("#vehicleError").text(msg).show();
        }
      });
    }

    function deleteVehicle(id) {
      if (!confirm("Xóa xe này?")) return;
      $.ajax({
        url: contextPath + "/api/manager/resource/vehicles/" + encodeURIComponent(id),
        method: "DELETE",
        success: function () { loadVehicles(); },
        error: function () { alert("Xóa thất bại"); }
      });
    }

    function init() {
      if (typeof jQuery === "undefined") {
        setTimeout(init, 50);
        return;
      }
      $(document).ready(function () {
        loadVehicles();
        $("#btnReloadVehicles").click(loadVehicles);
        $("#vehicleSearch").on("input", applyFilter);
        $("#vehicleModal").on("show.bs.modal", openCreate);
        $("#btnSaveVehicle").click(saveVehicle);

        $(document).on("click", ".btn-edit", function () { openEdit($(this).data("id")); });
        $(document).on("click", ".btn-del", function () { deleteVehicle($(this).data("id")); });
      });
    }

    init();
  })();
</script>
