<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Tuyến vận chuyển</h1>
    <button
      class="btn btn-sm btn-primary shadow-sm"
      data-toggle="modal"
      data-target="#routeModal"
      onclick="openAddModal()">
      <i class="fas fa-plus fa-sm text-white-50"></i> Thêm tuyến mới
    </button>
  </div>

  <!-- Filter Section -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-8">
          <label class="small font-weight-bold">Tìm kiếm</label>
          <input
            type="text"
            class="form-control"
            id="filterKeyword"
            placeholder="Nhập tên Hub, tỉnh/thành hoặc mô tả..."
            onkeyup="debounceSearch()" />
        </div>
        <div class="col-md-4 d-flex align-items-end">
          <button class="btn btn-secondary btn-block" onclick="resetFilters()">
            <i class="fas fa-redo"></i> Đặt lại
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Data Table -->
  <div class="card shadow mb-4">
    <div
      class="card-header py-3 d-flex justify-content-between align-items-center">
      <h6 class="m-0 font-weight-bold text-primary">Danh sách tuyến</h6>
      <span class="badge badge-info" id="totalCount">0 tuyến</span>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table
          class="table table-bordered table-hover"
          width="100%"
          cellspacing="0">
          <thead class="bg-light">
            <tr>
              <th style="width: 60px">ID</th>
              <th>Hub xuất phát</th>
              <th style="width: 50px"></th>
              <th>Hub đích</th>
              <th style="width: 120px">Thời gian</th>
              <th>Mô tả</th>
              <th style="width: 120px">Hành động</th>
            </tr>
          </thead>
          <tbody id="routeListData">
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

<!-- Modal Thêm/Sửa Route -->
<div
  class="modal fade"
  id="routeModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Thêm tuyến mới</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <form id="routeForm">
        <div class="modal-body">
          <input type="hidden" id="routeId" />
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Hub xuất phát <span class="text-danger">*</span></label
              >
              <select class="form-control" id="fromHubId" required>
                <option value="">-- Chọn Hub --</option>
              </select>
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Hub đích <span class="text-danger">*</span></label
              >
              <select class="form-control" id="toHubId" required>
                <option value="">-- Chọn Hub --</option>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Thời gian ước tính (phút)</label
              >
              <input
                type="number"
                class="form-control"
                id="estimatedTime"
                placeholder="VD: 120"
                min="1" />
            </div>
            <div class="col-md-6 form-group">
              <!-- Empty for alignment -->
            </div>
          </div>
          <div class="form-group">
            <label class="small font-weight-bold">Mô tả</label>
            <textarea
              class="form-control"
              id="description"
              rows="3"
              placeholder="VD: Tuyến chính, đi qua cao tốc TP.HCM - Long Thành - Dầu Giây"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" type="button" data-dismiss="modal">
            Hủy
          </button>
          <button class="btn btn-primary" type="submit">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Xác nhận xóa -->
<div
  class="modal fade"
  id="deleteModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Xác nhận xóa</h5>
        <button
          class="close text-white"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="deleteRouteId" />
        <p>Bạn có chắc chắn muốn xóa tuyến vận chuyển này?</p>
        <p class="mb-0"><strong id="deleteRouteName"></strong></p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">
          Hủy
        </button>
        <button class="btn btn-danger" type="button" onclick="confirmDelete()">
          <i class="fas fa-trash"></i> Xóa
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var API_BASE = window.location.origin + "/api/admin/routes";
  var HUB_API = window.location.origin + "/api/admin/hubs/filter";
  var currentPage = 0;
  var pageSize = 10;
  var debounceTimer;
  var hubList = [];

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadHubs();
    loadRoutes();
  });

  function loadHubs() {
    fetch(HUB_API)
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        hubList = data || [];
        populateHubSelects();
      })
      .catch(function (err) {
        console.error("Load hubs failed:", err);
      });
  }

  function populateHubSelects() {
    var fromSelect = document.getElementById("fromHubId");
    var toSelect = document.getElementById("toHubId");
    var html = '<option value="">-- Chọn Hub --</option>';

    for (var i = 0; i < hubList.length; i++) {
      html +=
        '<option value="' +
        hubList[i].hubId +
        '">' +
        escapeHtml(hubList[i].hubName) +
        "</option>";
    }

    fromSelect.innerHTML = html;
    toSelect.innerHTML = html;
  }

  function loadRoutes() {
    var keyword = document.getElementById("filterKeyword").value;

    var url = API_BASE + "?page=" + currentPage + "&size=" + pageSize;
    if (keyword) url += "&keyword=" + encodeURIComponent(keyword);

    fetch(url)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          renderTable(response.data.content);
          renderPagination(response.data);
          document.getElementById("totalCount").innerText =
            response.data.totalElements + " tuyến";
        } else {
          document.getElementById("routeListData").innerHTML =
            '<tr><td colspan="7" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("routeListData").innerHTML =
          '<tr><td colspan="7" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function renderTable(routes) {
    if (!routes || routes.length === 0) {
      document.getElementById("routeListData").innerHTML =
        '<tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < routes.length; i++) {
      var r = routes[i];
      var fromInfo =
        escapeHtml(r.fromHubName) +
        (r.fromHubProvince
          ? '<br><small class="text-muted">' +
            escapeHtml(r.fromHubProvince) +
            "</small>"
          : "");
      var toInfo =
        escapeHtml(r.toHubName) +
        (r.toHubProvince
          ? '<br><small class="text-muted">' +
            escapeHtml(r.toHubProvince) +
            "</small>"
          : "");
      var timeText = r.estimatedTime ? formatTime(r.estimatedTime) : "-";

      var actionBtns =
        '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' +
        r.routeId +
        ')" title="Sửa">' +
        '<i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-danger" onclick="openDeleteModal(' +
        r.routeId +
        ", '" +
        escapeHtml(r.fromHubName) +
        " → " +
        escapeHtml(r.toHubName) +
        '\')" title="Xóa">' +
        '<i class="fas fa-trash"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        r.routeId +
        "</td>" +
        "<td>" +
        fromInfo +
        "</td>" +
        '<td class="text-center"><i class="fas fa-arrow-right text-primary"></i></td>' +
        "<td>" +
        toInfo +
        "</td>" +
        "<td>" +
        timeText +
        "</td>" +
        "<td>" +
        escapeHtml(r.description || "-") +
        "</td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("routeListData").innerHTML = html;
  }

  function formatTime(minutes) {
    if (minutes < 60) {
      return minutes + " phút";
    }
    var hours = Math.floor(minutes / 60);
    var mins = minutes % 60;
    return hours + "h" + (mins > 0 ? mins + "p" : "");
  }

  function escapeHtml(text) {
    if (!text) return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
  }

  function renderPagination(pageData) {
    var html = "";
    var totalPages = pageData.totalPages;

    if (totalPages <= 1) {
      document.getElementById("pagination").innerHTML = "";
      return;
    }

    html +=
      '<li class="page-item ' +
      (pageData.first ? "disabled" : "") +
      '">' +
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage - 1) +
      ')">Trước</a></li>';

    for (var i = 0; i < totalPages; i++) {
      if (i === currentPage) {
        html +=
          '<li class="page-item active"><a class="page-link" href="javascript:void(0)">' +
          (i + 1) +
          "</a></li>";
      } else if (
        Math.abs(i - currentPage) <= 2 ||
        i === 0 ||
        i === totalPages - 1
      ) {
        html +=
          '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
          i +
          ')">' +
          (i + 1) +
          "</a></li>";
      } else if (Math.abs(i - currentPage) === 3) {
        html +=
          '<li class="page-item disabled"><a class="page-link">...</a></li>';
      }
    }

    html +=
      '<li class="page-item ' +
      (pageData.last ? "disabled" : "") +
      '">' +
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage + 1) +
      ')">Sau</a></li>';

    document.getElementById("pagination").innerHTML = html;
  }

  function goToPage(page) {
    currentPage = page;
    loadRoutes();
  }

  function debounceSearch() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function () {
      currentPage = 0;
      loadRoutes();
    }, 500);
  }

  function resetFilters() {
    document.getElementById("filterKeyword").value = "";
    currentPage = 0;
    loadRoutes();
  }

  function openAddModal() {
    document.getElementById("routeForm").reset();
    document.getElementById("routeId").value = "";
    document.getElementById("modalTitle").innerText = "Thêm tuyến mới";
  }

  function openEditModal(id) {
    fetch(API_BASE + "/" + id)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var r = response.data;
          document.getElementById("routeId").value = r.routeId;
          document.getElementById("fromHubId").value = r.fromHubId || "";
          document.getElementById("toHubId").value = r.toHubId || "";
          document.getElementById("estimatedTime").value =
            r.estimatedTime || "";
          document.getElementById("description").value = r.description || "";
          document.getElementById("modalTitle").innerText =
            "Cập nhật tuyến: " + r.fromHubName + " → " + r.toHubName;
          $("#routeModal").modal("show");
        }
      });
  }

  function openDeleteModal(id, name) {
    document.getElementById("deleteRouteId").value = id;
    document.getElementById("deleteRouteName").innerText = name;
    $("#deleteModal").modal("show");
  }

  function confirmDelete() {
    var id = document.getElementById("deleteRouteId").value;

    fetch(API_BASE + "/" + id, {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        $("#deleteModal").modal("hide");
        if (response.success) {
          showToast("success", "Xóa tuyến thành công!");
          loadRoutes();
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        $("#deleteModal").modal("hide");
        showToast("error", "Lỗi kết nối server");
      });
  }

  // Form submit handler
  document.getElementById("routeForm").addEventListener("submit", function (e) {
    e.preventDefault();

    var routeId = document.getElementById("routeId").value;
    var isEdit = routeId !== "";

    var fromHubId = document.getElementById("fromHubId").value;
    var toHubId = document.getElementById("toHubId").value;

    // Validate client-side
    if (fromHubId === toHubId) {
      showToast("error", "Hub xuất phát và Hub đích không được trùng nhau");
      return;
    }

    var data = {
      fromHubId: parseInt(fromHubId),
      toHubId: parseInt(toHubId),
      estimatedTime: document.getElementById("estimatedTime").value
        ? parseInt(document.getElementById("estimatedTime").value)
        : null,
      description: document.getElementById("description").value,
    };

    var url = isEdit ? API_BASE + "/" + routeId : API_BASE;
    var method = isEdit ? "PUT" : "POST";

    fetch(url, {
      method: method,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success) {
          $("#routeModal").modal("hide");
          showToast(
            "success",
            isEdit ? "Cập nhật thành công!" : "Thêm tuyến mới thành công!"
          );
          loadRoutes();
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        showToast("error", "Lỗi kết nối server");
      });
  });

  function showToast(type, message) {
    var bgClass = type === "success" ? "bg-success" : "bg-danger";
    var toast = document.createElement("div");
    toast.className = "toast-notification " + bgClass;
    toast.innerHTML =
      '<i class="fas fa-' +
      (type === "success" ? "check" : "times") +
      '-circle mr-2"></i>' +
      message;
    toast.style.cssText =
      "position:fixed;top:20px;right:20px;padding:15px 25px;color:white;border-radius:5px;z-index:9999;animation:slideIn 0.3s ease;";
    document.body.appendChild(toast);
    setTimeout(function () {
      toast.remove();
    }, 3000);
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
