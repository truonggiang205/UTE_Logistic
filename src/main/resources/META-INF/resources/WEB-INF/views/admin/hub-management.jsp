<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Quản lý Hub</h1>
    <button
      class="btn btn-sm btn-primary shadow-sm"
      data-toggle="modal"
      data-target="#hubModal"
      onclick="openAddModal()">
      <i class="fas fa-plus fa-sm text-white-50"></i> Thêm Hub mới
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
          <label class="small font-weight-bold">Trạng thái</label>
          <select class="form-control" id="filterStatus" onchange="loadHubs()">
            <option value="">-- Tất cả --</option>
            <option value="active">Đang hoạt động</option>
            <option value="inactive">Ngừng hoạt động</option>
          </select>
        </div>
        <div class="col-md-3">
          <label class="small font-weight-bold">Cấp Hub</label>
          <select
            class="form-control"
            id="filterHubLevel"
            onchange="loadHubs()">
            <option value="">-- Tất cả --</option>
            <option value="central">Trung tâm (Central)</option>
            <option value="regional">Vùng (Regional)</option>
            <option value="local">Cục bộ (Local)</option>
          </select>
        </div>
        <div class="col-md-4">
          <label class="small font-weight-bold">Tìm kiếm</label>
          <input
            type="text"
            class="form-control"
            id="filterKeyword"
            placeholder="Nhập tên Hub, địa chỉ, tỉnh..."
            onkeyup="debounceSearch()" />
        </div>
        <div class="col-md-2 d-flex align-items-end">
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
      <h6 class="m-0 font-weight-bold text-primary">Danh sách Hub</h6>
      <span class="badge badge-info" id="totalCount">0 Hub</span>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table
          class="table table-bordered table-hover"
          width="100%"
          cellspacing="0">
          <thead class="bg-light">
            <tr>
              <th style="width: 80px">ID</th>
              <th>Tên Hub</th>
              <th>Địa chỉ</th>
              <th>Tỉnh/TP</th>
              <th>Cấp Hub</th>
              <th>SĐT</th>
              <th>Trạng thái</th>
              <th style="width: 120px">Hành động</th>
            </tr>
          </thead>
          <tbody id="hubListData">
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

<!-- Modal Thêm/Sửa Hub -->
<div
  class="modal fade"
  id="hubModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Thêm Hub mới</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <form id="hubForm">
        <div class="modal-body">
          <input type="hidden" id="hubId" />
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Tên Hub <span class="text-danger">*</span></label
              >
              <input
                type="text"
                class="form-control"
                id="hubName"
                required
                placeholder="VD: Hub Quận 1" />
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold">Cấp Hub</label>
              <select class="form-control" id="hubLevel">
                <option value="local">Cục bộ (Local)</option>
                <option value="regional">Vùng (Regional)</option>
                <option value="central">Trung tâm (Central)</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="small font-weight-bold">Địa chỉ</label>
            <input
              type="text"
              class="form-control"
              id="address"
              placeholder="VD: 123 Nguyễn Huệ" />
          </div>
          <div class="row">
            <div class="col-md-4 form-group">
              <label class="small font-weight-bold">Phường/Xã</label>
              <input
                type="text"
                class="form-control"
                id="ward"
                placeholder="VD: Phường Bến Nghé" />
            </div>
            <div class="col-md-4 form-group">
              <label class="small font-weight-bold">Quận/Huyện</label>
              <input
                type="text"
                class="form-control"
                id="district"
                placeholder="VD: Quận 1" />
            </div>
            <div class="col-md-4 form-group">
              <label class="small font-weight-bold">Tỉnh/Thành phố</label>
              <input
                type="text"
                class="form-control"
                id="province"
                placeholder="VD: TP. Hồ Chí Minh" />
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold">Số điện thoại</label>
              <input
                type="text"
                class="form-control"
                id="contactPhone"
                placeholder="VD: 0283123456" />
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold">Email</label>
              <input
                type="email"
                class="form-control"
                id="email"
                placeholder="VD: hub1@company.vn" />
            </div>
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

<!-- Modal Đổi Trạng thái -->
<div
  class="modal fade"
  id="statusModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Thay đổi trạng thái Hub</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="statusHubId" />
        <p>Hub: <strong id="statusHubName"></strong></p>
        <div class="form-group">
          <label class="small font-weight-bold">Trạng thái mới</label>
          <select class="form-control" id="newStatus">
            <option value="active">Đang hoạt động</option>
            <option value="inactive">Ngừng hoạt động</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">
          Hủy
        </button>
        <button
          class="btn btn-primary"
          type="button"
          onclick="confirmStatusChange()">
          <i class="fas fa-check"></i> Xác nhận
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var API_BASE = window.location.origin + "/api/admin/hubs";
  var currentPage = 0;
  var pageSize = 10;
  var debounceTimer;

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadHubs();
  });

  function loadHubs() {
    var status = document.getElementById("filterStatus").value;
    var hubLevel = document.getElementById("filterHubLevel").value;
    var keyword = document.getElementById("filterKeyword").value;

    var url = API_BASE + "?page=" + currentPage + "&size=" + pageSize;
    if (status) url += "&status=" + status;
    if (hubLevel) url += "&hubLevel=" + hubLevel;
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
            response.data.totalElements + " Hub";
        } else {
          document.getElementById("hubListData").innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("hubListData").innerHTML =
          '<tr><td colspan="8" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function renderTable(hubs) {
    if (!hubs || hubs.length === 0) {
      document.getElementById("hubListData").innerHTML =
        '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < hubs.length; i++) {
      var h = hubs[i];
      var statusBadge = getStatusBadge(h.status);
      var levelBadge = getLevelBadge(h.hubLevel);
      var fullAddress = [h.address, h.ward, h.district]
        .filter(Boolean)
        .join(", ");

      var actionBtns =
        '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' +
        h.hubId +
        ')" title="Sửa">' +
        '<i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-' +
        (h.status === "active" ? "warning" : "success") +
        '" ' +
        'onclick="openStatusModal(' +
        h.hubId +
        ", '" +
        escapeHtml(h.hubName) +
        "', '" +
        h.status +
        '\')" title="Đổi trạng thái">' +
        '<i class="fas fa-' +
        (h.status === "active" ? "ban" : "check") +
        '"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        h.hubId +
        "</td>" +
        "<td><strong>" +
        escapeHtml(h.hubName) +
        "</strong></td>" +
        "<td>" +
        escapeHtml(fullAddress || "-") +
        "</td>" +
        "<td>" +
        escapeHtml(h.province || "-") +
        "</td>" +
        "<td>" +
        levelBadge +
        "</td>" +
        "<td>" +
        escapeHtml(h.contactPhone || "-") +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("hubListData").innerHTML = html;
  }

  function escapeHtml(text) {
    if (!text) return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
  }

  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Hoạt động</span>';
      case "inactive":
        return '<span class="badge badge-danger"><i class="fas fa-times-circle"></i> Ngừng</span>';
      default:
        return '<span class="badge badge-light">' + status + "</span>";
    }
  }

  function getLevelBadge(level) {
    switch (level) {
      case "central":
        return '<span class="badge badge-primary">Trung tâm</span>';
      case "regional":
        return '<span class="badge badge-info">Vùng</span>';
      case "local":
        return '<span class="badge badge-secondary">Cục bộ</span>';
      default:
        return '<span class="badge badge-light">' + (level || "-") + "</span>";
    }
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
    loadHubs();
  }

  function debounceSearch() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function () {
      currentPage = 0;
      loadHubs();
    }, 500);
  }

  function resetFilters() {
    document.getElementById("filterStatus").value = "";
    document.getElementById("filterHubLevel").value = "";
    document.getElementById("filterKeyword").value = "";
    currentPage = 0;
    loadHubs();
  }

  function openAddModal() {
    document.getElementById("hubForm").reset();
    document.getElementById("hubId").value = "";
    document.getElementById("modalTitle").innerText = "Thêm Hub mới";
  }

  function openEditModal(id) {
    fetch(API_BASE + "/" + id)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var h = response.data;
          document.getElementById("hubId").value = h.hubId;
          document.getElementById("hubName").value = h.hubName || "";
          document.getElementById("hubLevel").value = h.hubLevel || "local";
          document.getElementById("address").value = h.address || "";
          document.getElementById("ward").value = h.ward || "";
          document.getElementById("district").value = h.district || "";
          document.getElementById("province").value = h.province || "";
          document.getElementById("contactPhone").value = h.contactPhone || "";
          document.getElementById("email").value = h.email || "";
          document.getElementById("modalTitle").innerText =
            "Cập nhật Hub: " + h.hubName;
          $("#hubModal").modal("show");
        }
      });
  }

  function openStatusModal(id, name, currentStatus) {
    document.getElementById("statusHubId").value = id;
    document.getElementById("statusHubName").innerText = name;
    document.getElementById("newStatus").value =
      currentStatus === "active" ? "inactive" : "active";
    $("#statusModal").modal("show");
  }

  function confirmStatusChange() {
    var id = document.getElementById("statusHubId").value;
    var status = document.getElementById("newStatus").value;

    fetch(API_BASE + "/" + id + "/status", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: status }),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        $("#statusModal").modal("hide");
        if (response.success) {
          showToast("success", "Cập nhật trạng thái thành công!");
          loadHubs();
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        $("#statusModal").modal("hide");
        showToast("error", "Lỗi kết nối server");
      });
  }

  // Form submit handler
  document.getElementById("hubForm").addEventListener("submit", function (e) {
    e.preventDefault();

    var hubId = document.getElementById("hubId").value;
    var isEdit = hubId !== "";

    var data = {
      hubName: document.getElementById("hubName").value,
      hubLevel: document.getElementById("hubLevel").value,
      address: document.getElementById("address").value,
      ward: document.getElementById("ward").value,
      district: document.getElementById("district").value,
      province: document.getElementById("province").value,
      contactPhone: document.getElementById("contactPhone").value,
      email: document.getElementById("email").value,
    };

    var url = isEdit ? API_BASE + "/" + hubId : API_BASE;
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
          $("#hubModal").modal("hide");
          showToast(
            "success",
            isEdit ? "Cập nhật thành công!" : "Thêm Hub mới thành công!"
          );
          loadHubs();
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
