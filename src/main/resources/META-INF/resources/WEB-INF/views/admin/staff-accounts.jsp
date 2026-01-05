<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <div>
      <h1 class="h3 mb-0 text-gray-800">Tài khoản nhân viên</h1>
      <div class="small text-muted">
        Quản lý danh sách tài khoản nhân viên trong hệ thống.
      </div>
    </div>
    <button
      class="btn btn-sm btn-primary shadow-sm"
      data-toggle="modal"
      data-target="#staffModal"
      onclick="openAddModal()">
      <i class="fas fa-plus fa-sm text-white-50"></i> Thêm nhân viên
    </button>
  </div>

  <!-- Filter Section -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-4">
          <label class="small font-weight-bold">Trạng thái</label>
          <select
            class="form-control"
            id="filterStatus"
            onchange="loadStaffAccounts()">
            <option value="">-- Tất cả --</option>
            <option value="active">Hoạt động</option>
            <option value="inactive">Không hoạt động</option>
            <option value="banned">Đã khóa</option>
          </select>
        </div>
        <div class="col-md-6">
          <label class="small font-weight-bold">Tìm kiếm</label>
          <input
            type="text"
            class="form-control"
            id="filterKeyword"
            placeholder="Nhập username, họ tên, email hoặc SĐT..."
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
      <h6 class="m-0 font-weight-bold text-primary">Danh sách nhân viên</h6>
      <span class="badge badge-info" id="totalCount">0 tài khoản</span>
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
              <th style="width: 120px">Username</th>
              <th>Họ tên</th>
              <th>Email</th>
              <th style="width: 120px">SĐT</th>
              <th style="width: 150px">Vai trò</th>
              <th style="width: 110px">Trạng thái</th>
              <th style="width: 140px">Hành động</th>
            </tr>
          </thead>
          <tbody id="staffTableBody">
            <tr>
              <td colspan="8" class="text-center">Đang tải dữ liệu...</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- Pagination -->
      <nav>
        <ul class="pagination justify-content-center mb-0" id="pagination"></ul>
      </nav>
    </div>
  </div>
</div>

<!-- Modal Thêm/Sửa Staff -->
<div
  class="modal fade"
  id="staffModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Thêm nhân viên mới</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <form id="staffForm">
        <div class="modal-body">
          <input type="hidden" id="userId" />
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Username <span class="text-danger">*</span></label
              >
              <input
                type="text"
                class="form-control"
                id="username"
                required
                placeholder="VD: nguyenvana"
                pattern="^[a-zA-Z0-9_]+$" />
              <small class="text-muted">Chỉ chữ cái, số và dấu gạch dưới</small>
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Mật khẩu
                <span class="text-danger" id="passwordRequired">*</span></label
              >
              <input
                type="password"
                class="form-control"
                id="password"
                placeholder="Nhập mật khẩu (ít nhất 6 ký tự)" />
              <small class="text-muted" id="passwordHint"
                >Bắt buộc khi tạo mới</small
              >
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Họ tên <span class="text-danger">*</span></label
              >
              <input
                type="text"
                class="form-control"
                id="fullName"
                required
                placeholder="VD: Nguyễn Văn A" />
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold"
                >Email <span class="text-danger">*</span></label
              >
              <input
                type="email"
                class="form-control"
                id="email"
                required
                placeholder="VD: nguyenvana@company.com" />
            </div>
          </div>
          <div class="row">
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold">Số điện thoại</label>
              <input
                type="text"
                class="form-control"
                id="phone"
                placeholder="VD: 0912345678" />
            </div>
            <div class="col-md-6 form-group">
              <label class="small font-weight-bold">Trạng thái</label>
              <select class="form-control" id="status">
                <option value="active">Hoạt động</option>
                <option value="inactive">Không hoạt động</option>
                <option value="banned">Đã khóa</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="small font-weight-bold">Vai trò</label>
            <div id="roleCheckboxes" class="d-flex flex-wrap">
              <!-- Roles sẽ được load động -->
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
        <h5 class="modal-title">Thay đổi trạng thái</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="statusUserId" />
        <p>Tài khoản: <strong id="statusUsername"></strong></p>
        <div class="form-group mb-0">
          <label class="small font-weight-bold">Trạng thái mới</label>
          <select class="form-control" id="newStatus">
            <option value="active">Hoạt động</option>
            <option value="inactive">Không hoạt động</option>
            <option value="banned">Đã khóa</option>
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

<!-- Modal Reset Password -->
<div
  class="modal fade"
  id="passwordModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-warning">
        <h5 class="modal-title">Đặt lại mật khẩu</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="resetPasswordUserId" />
        <p>Tài khoản: <strong id="resetPasswordUsername"></strong></p>
        <div class="form-group mb-0">
          <label class="small font-weight-bold"
            >Mật khẩu mới <span class="text-danger">*</span></label
          >
          <input
            type="password"
            class="form-control"
            id="newPassword"
            required
            placeholder="Nhập mật khẩu mới (ít nhất 6 ký tự)" />
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">
          Hủy
        </button>
        <button
          class="btn btn-warning"
          type="button"
          onclick="confirmResetPassword()">
          <i class="fas fa-key"></i> Đặt lại
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var API_BASE = window.location.origin + "/api/admin/staff-accounts";
  var currentPage = 0;
  var pageSize = 10;
  var debounceTimer;
  var allRoles = [];

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadRoles();
    loadStaffAccounts();
  });

  function loadRoles() {
    fetch(API_BASE + "/roles")
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          allRoles = response.data;
          renderRoleCheckboxes();
        }
      })
      .catch(function (err) {
        console.error("Load roles failed:", err);
      });
  }

  function renderRoleCheckboxes() {
    var container = document.getElementById("roleCheckboxes");
    var html = "";
    for (var i = 0; i < allRoles.length; i++) {
      var role = allRoles[i];
      if (role !== "CUSTOMER") {
        // Không hiển thị CUSTOMER role
        html +=
          '<div class="custom-control custom-checkbox mr-3 mb-2">' +
          '<input type="checkbox" class="custom-control-input" id="role_' +
          role +
          '" value="' +
          role +
          '">' +
          '<label class="custom-control-label" for="role_' +
          role +
          '">' +
          role +
          "</label>" +
          "</div>";
      }
    }
    container.innerHTML = html;
  }

  function loadStaffAccounts() {
    var status = document.getElementById("filterStatus").value;
    var keyword = document.getElementById("filterKeyword").value;

    var url = API_BASE + "?page=" + currentPage + "&size=" + pageSize;
    if (status) url += "&status=" + status;
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
            response.data.totalElements + " tài khoản";
        } else {
          document.getElementById("staffTableBody").innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("staffTableBody").innerHTML =
          '<tr><td colspan="8" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function renderTable(items) {
    if (!items || items.length === 0) {
      document.getElementById("staffTableBody").innerHTML =
        '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < items.length; i++) {
      var u = items[i];
      var statusBadge = getStatusBadge(u.status);
      var rolesBadges = getRolesBadges(u.roles);

      var actionBtns =
        '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' +
        u.userId +
        ')" title="Sửa">' +
        '<i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-warning mr-1" onclick="openStatusModal(' +
        u.userId +
        ", '" +
        escapeHtml(u.username) +
        "')" +
        '" title="Đổi trạng thái">' +
        '<i class="fas fa-toggle-on"></i></button>' +
        '<button class="btn btn-sm btn-secondary" onclick="openPasswordModal(' +
        u.userId +
        ", '" +
        escapeHtml(u.username) +
        '\')" title="Đặt lại mật khẩu">' +
        '<i class="fas fa-key"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        u.userId +
        "</td>" +
        "<td><strong>" +
        escapeHtml(u.username) +
        "</strong></td>" +
        "<td>" +
        escapeHtml(u.fullName || "-") +
        "</td>" +
        "<td>" +
        escapeHtml(u.email || "-") +
        "</td>" +
        "<td>" +
        escapeHtml(u.phone || "-") +
        "</td>" +
        "<td>" +
        rolesBadges +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("staffTableBody").innerHTML = html;
  }

  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return '<span class="badge badge-success">Hoạt động</span>';
      case "inactive":
        return '<span class="badge badge-secondary">Không HĐ</span>';
      case "banned":
        return '<span class="badge badge-danger">Đã khóa</span>';
      default:
        return '<span class="badge badge-light">' + (status || "-") + "</span>";
    }
  }

  function getRolesBadges(roles) {
    if (!roles || roles.length === 0)
      return '<span class="text-muted">-</span>';
    var html = "";
    var roleArray = Array.isArray(roles) ? roles : Array.from(roles);
    for (var i = 0; i < roleArray.length; i++) {
      var badgeClass = "badge-primary";
      if (roleArray[i] === "ADMIN") badgeClass = "badge-danger";
      else if (roleArray[i] === "MANAGER") badgeClass = "badge-warning";
      else if (roleArray[i] === "SHIPPER") badgeClass = "badge-info";
      html +=
        '<span class="badge ' +
        badgeClass +
        ' mr-1">' +
        roleArray[i] +
        "</span>";
    }
    return html;
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
    loadStaffAccounts();
  }

  function debounceSearch() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function () {
      currentPage = 0;
      loadStaffAccounts();
    }, 500);
  }

  function resetFilters() {
    document.getElementById("filterStatus").value = "";
    document.getElementById("filterKeyword").value = "";
    currentPage = 0;
    loadStaffAccounts();
  }

  function openAddModal() {
    document.getElementById("staffForm").reset();
    document.getElementById("userId").value = "";
    document.getElementById("modalTitle").innerText = "Thêm nhân viên mới";
    document.getElementById("passwordRequired").style.display = "";
    document.getElementById("passwordHint").innerText = "Bắt buộc khi tạo mới";
    document.getElementById("password").required = true;

    // Reset role checkboxes
    var checkboxes = document.querySelectorAll(
      '#roleCheckboxes input[type="checkbox"]'
    );
    for (var i = 0; i < checkboxes.length; i++) {
      checkboxes[i].checked = false;
    }
  }

  function openEditModal(id) {
    fetch(API_BASE + "/" + id)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var u = response.data;
          document.getElementById("userId").value = u.userId;
          document.getElementById("username").value = u.username || "";
          document.getElementById("password").value = "";
          document.getElementById("fullName").value = u.fullName || "";
          document.getElementById("email").value = u.email || "";
          document.getElementById("phone").value = u.phone || "";
          document.getElementById("status").value = u.status || "active";

          document.getElementById("modalTitle").innerText =
            "Cập nhật: " + u.username;
          document.getElementById("passwordRequired").style.display = "none";
          document.getElementById("passwordHint").innerText =
            "Để trống nếu không thay đổi";
          document.getElementById("password").required = false;

          // Set role checkboxes
          var checkboxes = document.querySelectorAll(
            '#roleCheckboxes input[type="checkbox"]'
          );
          for (var i = 0; i < checkboxes.length; i++) {
            var roleName = checkboxes[i].value;
            checkboxes[i].checked =
              u.roles &&
              (Array.isArray(u.roles)
                ? u.roles.includes(roleName)
                : u.roles.has(roleName));
          }

          $("#staffModal").modal("show");
        }
      });
  }

  function openStatusModal(id, username) {
    document.getElementById("statusUserId").value = id;
    document.getElementById("statusUsername").innerText = username;
    $("#statusModal").modal("show");
  }

  function confirmStatusChange() {
    var id = document.getElementById("statusUserId").value;
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
          loadStaffAccounts();
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        $("#statusModal").modal("hide");
        showToast("error", "Lỗi kết nối server");
      });
  }

  function openPasswordModal(id, username) {
    document.getElementById("resetPasswordUserId").value = id;
    document.getElementById("resetPasswordUsername").innerText = username;
    document.getElementById("newPassword").value = "";
    $("#passwordModal").modal("show");
  }

  function confirmResetPassword() {
    var id = document.getElementById("resetPasswordUserId").value;
    var password = document.getElementById("newPassword").value;

    if (!password || password.length < 6) {
      showToast("error", "Mật khẩu phải ít nhất 6 ký tự");
      return;
    }

    fetch(API_BASE + "/" + id + "/reset-password", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ password: password }),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        $("#passwordModal").modal("hide");
        if (response.success) {
          showToast("success", "Đặt lại mật khẩu thành công!");
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        $("#passwordModal").modal("hide");
        showToast("error", "Lỗi kết nối server");
      });
  }

  // Form submit handler
  document.getElementById("staffForm").addEventListener("submit", function (e) {
    e.preventDefault();

    var userId = document.getElementById("userId").value;
    var isEdit = userId !== "";

    // Get selected roles
    var selectedRoles = [];
    var checkboxes = document.querySelectorAll(
      '#roleCheckboxes input[type="checkbox"]:checked'
    );
    for (var i = 0; i < checkboxes.length; i++) {
      selectedRoles.push(checkboxes[i].value);
    }

    var data = {
      username: document.getElementById("username").value.trim(),
      password: document.getElementById("password").value,
      fullName: document.getElementById("fullName").value.trim(),
      email: document.getElementById("email").value.trim(),
      phone: document.getElementById("phone").value.trim() || null,
      status: document.getElementById("status").value,
      roleNames: selectedRoles,
    };

    // Validate password khi tạo mới
    if (!isEdit && (!data.password || data.password.length < 6)) {
      showToast("error", "Mật khẩu phải ít nhất 6 ký tự");
      return;
    }

    var url = isEdit ? API_BASE + "/" + userId : API_BASE;
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
          $("#staffModal").modal("hide");
          showToast(
            "success",
            isEdit ? "Cập nhật thành công!" : "Thêm nhân viên mới thành công!"
          );
          loadStaffAccounts();
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
