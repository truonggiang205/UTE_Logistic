<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <div>
      <h1 class="h3 mb-0 text-gray-800">Phân quyền Role</h1>
      <div class="small text-muted">
        Quản lý các vai trò (Roles) trong hệ thống.
      </div>
    </div>
    <button
      class="btn btn-sm btn-primary shadow-sm"
      data-toggle="modal"
      data-target="#roleModal"
      onclick="openAddModal()">
      <i class="fas fa-plus fa-sm text-white-50"></i> Thêm Role
    </button>
  </div>

  <!-- Thống kê -->
  <div class="row mb-4">
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                Tổng số Roles
              </div>
              <div
                class="h5 mb-0 font-weight-bold text-gray-800"
                id="statTotal">
                0
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-user-shield fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-success text-uppercase mb-1">
                Roles Active
              </div>
              <div
                class="h5 mb-0 font-weight-bold text-gray-800"
                id="statActive">
                0
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-check-circle fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Data Table -->
  <div class="card shadow mb-4">
    <div
      class="card-header py-3 d-flex justify-content-between align-items-center">
      <h6 class="m-0 font-weight-bold text-primary">Danh sách Role</h6>
      <button class="btn btn-sm btn-outline-secondary" onclick="loadRoles()">
        <i class="fas fa-sync-alt"></i> Làm mới
      </button>
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
              <th style="width: 150px">Tên Role</th>
              <th>Mô tả</th>
              <th style="width: 110px">Trạng thái</th>
              <th style="width: 100px">Số User</th>
              <th style="width: 140px">Hành động</th>
            </tr>
          </thead>
          <tbody id="roleTableBody">
            <tr>
              <td colspan="6" class="text-center">Đang tải dữ liệu...</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Modal Thêm/Sửa Role -->
<div
  class="modal fade"
  id="roleModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Thêm Role mới</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <form id="roleForm">
        <div class="modal-body">
          <input type="hidden" id="roleId" />
          <div class="form-group">
            <label class="small font-weight-bold"
              >Tên Role <span class="text-danger">*</span></label
            >
            <input
              type="text"
              class="form-control"
              id="roleName"
              required
              placeholder="VD: MANAGER, STAFF"
              pattern="^[A-Z_]+$"
              style="text-transform: uppercase"
              oninput="this.value = this.value.toUpperCase().replace(/[^A-Z_]/g, '')" />
            <small class="text-muted"
              >Chỉ CHỮ IN HOA và dấu gạch dưới (_)</small
            >
          </div>
          <div class="form-group">
            <label class="small font-weight-bold">Mô tả</label>
            <textarea
              class="form-control"
              id="description"
              rows="3"
              placeholder="Mô tả vai trò này..."></textarea>
          </div>
          <div class="form-group mb-0">
            <label class="small font-weight-bold">Trạng thái</label>
            <select class="form-control" id="status">
              <option value="active">Hoạt động (active)</option>
              <option value="inactive">Không hoạt động (inactive)</option>
            </select>
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
        <input type="hidden" id="statusRoleId" />
        <p>Role: <strong id="statusRoleName"></strong></p>
        <div class="form-group mb-0">
          <label class="small font-weight-bold">Trạng thái mới</label>
          <select class="form-control" id="newStatus">
            <option value="active">Hoạt động</option>
            <option value="inactive">Không hoạt động</option>
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
        <input type="hidden" id="deleteRoleId" />
        <p>Bạn có chắc chắn muốn xóa role này?</p>
        <p class="mb-0 font-weight-bold" id="deleteRoleName"></p>
        <div class="alert alert-warning mt-3 mb-0">
          <i class="fas fa-exclamation-triangle"></i>
          Chỉ có thể xóa nếu không có user nào đang sử dụng role này!
        </div>
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
  var API_BASE = window.location.origin + "/api/admin/roles";

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadRoles();
  });

  function loadRoles() {
    fetch(API_BASE)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          renderTable(response.data);
          updateStats(response.data);
        } else {
          document.getElementById("roleTableBody").innerHTML =
            '<tr><td colspan="6" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("roleTableBody").innerHTML =
          '<tr><td colspan="6" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function updateStats(roles) {
    document.getElementById("statTotal").innerText = roles.length;
    var activeCount = roles.filter(function (r) {
      return r.status === "active";
    }).length;
    document.getElementById("statActive").innerText = activeCount;
  }

  function renderTable(items) {
    if (!items || items.length === 0) {
      document.getElementById("roleTableBody").innerHTML =
        '<tr><td colspan="6" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < items.length; i++) {
      var r = items[i];
      var statusBadge = getStatusBadge(r.status);
      var userCountBadge =
        '<span class="badge badge-' +
        (r.userCount > 0 ? "info" : "secondary") +
        '">' +
        r.userCount +
        " user</span>";

      var actionBtns =
        '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' +
        r.roleId +
        ')" title="Sửa">' +
        '<i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-warning mr-1" onclick="openStatusModal(' +
        r.roleId +
        ", '" +
        escapeHtml(r.roleName) +
        "')" +
        '" title="Đổi trạng thái">' +
        '<i class="fas fa-toggle-on"></i></button>' +
        '<button class="btn btn-sm btn-danger" onclick="openDeleteModal(' +
        r.roleId +
        ", '" +
        escapeHtml(r.roleName) +
        "', " +
        r.userCount +
        ')" title="Xóa">' +
        '<i class="fas fa-trash"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        r.roleId +
        "</td>" +
        '<td><span class="badge badge-primary font-weight-bold">' +
        escapeHtml(r.roleName) +
        "</span></td>" +
        "<td>" +
        escapeHtml(r.description || "-") +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        '<td class="text-center">' +
        userCountBadge +
        "</td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("roleTableBody").innerHTML = html;
  }

  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return '<span class="badge badge-success">Hoạt động</span>';
      case "inactive":
        return '<span class="badge badge-secondary">Không HĐ</span>';
      default:
        return '<span class="badge badge-light">' + (status || "-") + "</span>";
    }
  }

  function escapeHtml(text) {
    if (!text) return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
  }

  function openAddModal() {
    document.getElementById("roleForm").reset();
    document.getElementById("roleId").value = "";
    document.getElementById("status").value = "active";
    document.getElementById("modalTitle").innerText = "Thêm Role mới";
  }

  function openEditModal(id) {
    fetch(API_BASE + "/" + id)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var r = response.data;
          document.getElementById("roleId").value = r.roleId;
          document.getElementById("roleName").value = r.roleName || "";
          document.getElementById("description").value = r.description || "";
          document.getElementById("status").value = r.status || "active";
          document.getElementById("modalTitle").innerText =
            "Cập nhật: " + r.roleName;
          $("#roleModal").modal("show");
        }
      });
  }

  function openStatusModal(id, roleName) {
    document.getElementById("statusRoleId").value = id;
    document.getElementById("statusRoleName").innerText = roleName;
    $("#statusModal").modal("show");
  }

  function confirmStatusChange() {
    var id = document.getElementById("statusRoleId").value;
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
          loadRoles();
        } else {
          showToast("error", response.message || "Có lỗi xảy ra");
        }
      })
      .catch(function (err) {
        $("#statusModal").modal("hide");
        showToast("error", "Lỗi kết nối server");
      });
  }

  function openDeleteModal(id, roleName, userCount) {
    if (userCount > 0) {
      showToast(
        "error",
        "Không thể xóa role đang được sử dụng bởi " + userCount + " user"
      );
      return;
    }
    document.getElementById("deleteRoleId").value = id;
    document.getElementById("deleteRoleName").innerText = roleName;
    $("#deleteModal").modal("show");
  }

  function confirmDelete() {
    var id = document.getElementById("deleteRoleId").value;

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
          showToast("success", "Xóa role thành công!");
          loadRoles();
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
  document.getElementById("roleForm").addEventListener("submit", function (e) {
    e.preventDefault();

    var roleId = document.getElementById("roleId").value;
    var isEdit = roleId !== "";

    var data = {
      roleName: document.getElementById("roleName").value.trim().toUpperCase(),
      description: document.getElementById("description").value.trim() || null,
      status: document.getElementById("status").value,
    };

    // Validate role name format
    if (!/^[A-Z_]+$/.test(data.roleName)) {
      showToast("error", "Tên role chỉ được chứa CHỮ IN HOA và dấu gạch dưới");
      return;
    }

    var url = isEdit ? API_BASE + "/" + roleId : API_BASE;
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
          $("#roleModal").modal("hide");
          showToast(
            "success",
            isEdit ? "Cập nhật thành công!" : "Thêm role mới thành công!"
          );
          loadRoles();
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
