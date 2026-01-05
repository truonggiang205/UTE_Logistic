<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <div>
      <h1 class="h3 mb-0 text-gray-800">Quản lý Thông báo</h1>
      <div class="small text-muted">
        Gửi thông báo và email đến người dùng theo vai trò.
      </div>
    </div>
  </div>

  <div id="notifySuccess" class="alert alert-success d-none" role="alert"></div>
  <div id="notifyError" class="alert alert-danger d-none" role="alert"></div>

  <!-- Stats Cards -->
  <div class="row mb-4" id="statsRow">
    <div class="col-xl-2 col-md-4 col-sm-6 mb-3">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body py-2">
          <div
            class="text-xs font-weight-bold text-primary text-uppercase mb-1">
            Tổng cộng
          </div>
          <div class="h5 mb-0 font-weight-bold text-gray-800" id="statTotal">
            -
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-sm-6 mb-3">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body py-2">
          <div
            class="text-xs font-weight-bold text-success text-uppercase mb-1">
            ALL
          </div>
          <div class="h5 mb-0 font-weight-bold text-gray-800" id="statAll">
            -
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-sm-6 mb-3">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
            MANAGER
          </div>
          <div class="h5 mb-0 font-weight-bold text-gray-800" id="statManager">
            -
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-sm-6 mb-3">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body py-2">
          <div
            class="text-xs font-weight-bold text-warning text-uppercase mb-1">
            SHIPPER
          </div>
          <div class="h5 mb-0 font-weight-bold text-gray-800" id="statShipper">
            -
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-sm-6 mb-3">
      <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
            CUSTOMER
          </div>
          <div class="h5 mb-0 font-weight-bold text-gray-800" id="statCustomer">
            -
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <!-- Form gửi thông báo -->
    <div class="col-lg-5">
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-primary">
            <i class="fas fa-edit mr-2"></i>Soạn thông báo
          </h6>
        </div>
        <div class="card-body">
          <form id="notifyForm">
            <div class="form-group">
              <label class="font-weight-bold"
                >Tiêu đề <span class="text-danger">*</span></label
              >
              <input
                type="text"
                class="form-control"
                id="notifyTitle"
                maxlength="120"
                placeholder="Ví dụ: Bảo trì hệ thống lúc 22:00"
                required />
            </div>

            <div class="form-group">
              <label class="font-weight-bold"
                >Gửi đến <span class="text-danger">*</span></label
              >
              <select class="form-control" id="notifyTarget" required>
                <option value="ALL">📢 Tất cả người dùng</option>
                <option value="ADMIN">👑 Admin</option>
                <option value="MANAGER">👔 Manager</option>
                <option value="SHIPPER">🛵 Shipper</option>
                <option value="CUSTOMER">👤 Customer</option>
              </select>
            </div>

            <div class="form-group">
              <label class="font-weight-bold"
                >Nội dung <span class="text-danger">*</span></label
              >
              <textarea
                class="form-control"
                id="notifyBody"
                rows="5"
                maxlength="2000"
                placeholder="Nhập nội dung thông báo..."
                required></textarea>
              <div class="small text-muted mt-1">Tối đa 2000 ký tự.</div>
            </div>

            <!-- Email checkbox -->
            <div class="form-group">
              <div class="custom-control custom-checkbox">
                <input
                  type="checkbox"
                  class="custom-control-input"
                  id="sendEmailCheckbox" />
                <label class="custom-control-label" for="sendEmailCheckbox">
                  <i class="fas fa-envelope text-primary"></i> Gửi kèm Email
                </label>
                <small class="form-text text-muted">
                  Email sẽ được gửi đến tất cả người dùng thuộc nhóm đã chọn.
                </small>
              </div>
            </div>

            <button
              type="submit"
              class="btn btn-primary btn-block"
              id="btnSubmit">
              <i class="fas fa-paper-plane mr-1"></i> Gửi thông báo
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- Lịch sử thông báo -->
    <div class="col-lg-7">
      <div class="card shadow mb-4">
        <div
          class="card-header py-3 d-flex justify-content-between align-items-center">
          <h6 class="m-0 font-weight-bold text-primary">
            <i class="fas fa-history mr-2"></i>Lịch sử thông báo
          </h6>
          <button
            class="btn btn-sm btn-outline-primary"
            onclick="loadHistory(0)">
            <i class="fas fa-sync-alt"></i> Làm mới
          </button>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover mb-0" id="historyTable">
              <thead class="thead-light">
                <tr>
                  <th style="width: 35%">Tiêu đề</th>
                  <th style="width: 15%">Đối tượng</th>
                  <th style="width: 20%">Thời gian</th>
                  <th style="width: 15%">Email</th>
                  <th style="width: 15%">Thao tác</th>
                </tr>
              </thead>
              <tbody id="historyBody">
                <tr>
                  <td colspan="5" class="text-center text-muted py-4">
                    <i class="fas fa-spinner fa-spin"></i> Đang tải...
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div
          class="card-footer d-flex justify-content-between align-items-center"
          id="paginationFooter">
          <small class="text-muted" id="paginationInfo">Trang 1</small>
          <div>
            <button
              class="btn btn-sm btn-outline-secondary mr-1"
              id="btnPrev"
              disabled
              onclick="changePage(-1)">
              <i class="fas fa-chevron-left"></i> Trước
            </button>
            <button
              class="btn btn-sm btn-outline-secondary"
              id="btnNext"
              disabled
              onclick="changePage(1)">
              Sau <i class="fas fa-chevron-right"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Xác nhận xóa</h5>
        <button type="button" class="close" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        Bạn có chắc muốn xóa thông báo "<span
          id="deleteTitle"
          class="font-weight-bold"></span
        >"?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button type="button" class="btn btn-danger" id="btnConfirmDelete">
          <i class="fas fa-trash"></i> Xóa
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var CTX = "${pageContext.request.contextPath}";
  var API_BASE = CTX + "/api/admin/notifications";
  var currentPage = 0;
  var totalPages = 0;
  var deleteId = null;

  // ==================== Utility ====================
  function showBox(id, message) {
    var el = document.getElementById(id);
    if (!message) {
      el.classList.add("d-none");
      el.textContent = "";
      return;
    }
    el.textContent = message;
    el.classList.remove("d-none");
    setTimeout(function () {
      el.classList.add("d-none");
    }, 5000);
  }

  function formatDate(dateStr) {
    if (!dateStr) return "-";
    var d = new Date(dateStr);
    var day = String(d.getDate()).padStart(2, "0");
    var month = String(d.getMonth() + 1).padStart(2, "0");
    var year = d.getFullYear();
    var hour = String(d.getHours()).padStart(2, "0");
    var min = String(d.getMinutes()).padStart(2, "0");
    return day + "/" + month + "/" + year + " " + hour + ":" + min;
  }

  function getRoleBadge(role) {
    var badges = {
      ALL: '<span class="badge badge-success">ALL</span>',
      ADMIN: '<span class="badge badge-dark">ADMIN</span>',
      MANAGER: '<span class="badge badge-info">MANAGER</span>',
      SHIPPER: '<span class="badge badge-warning">SHIPPER</span>',
      CUSTOMER: '<span class="badge badge-secondary">CUSTOMER</span>',
    };
    return (
      badges[role] || '<span class="badge badge-light">' + role + "</span>"
    );
  }

  // ==================== Load Stats ====================
  function loadStats() {
    fetch(API_BASE + "/stats")
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        if (data.ok && data.stats) {
          document.getElementById("statTotal").textContent =
            data.stats.total || 0;
          document.getElementById("statAll").textContent = data.stats.ALL || 0;
          document.getElementById("statManager").textContent =
            data.stats.MANAGER || 0;
          document.getElementById("statShipper").textContent =
            data.stats.SHIPPER || 0;
          document.getElementById("statCustomer").textContent =
            data.stats.CUSTOMER || 0;
        }
      })
      .catch(function (err) {
        console.error("Load stats error:", err);
      });
  }

  // ==================== Load History ====================
  function loadHistory(page) {
    currentPage = page;
    var tbody = document.getElementById("historyBody");
    tbody.innerHTML =
      '<tr><td colspan="5" class="text-center text-muted py-4"><i class="fas fa-spinner fa-spin"></i> Đang tải...</td></tr>';

    fetch(API_BASE + "?page=" + page + "&size=8")
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        if (!data.ok) {
          tbody.innerHTML =
            '<tr><td colspan="5" class="text-center text-danger py-4">Lỗi: ' +
            (data.message || "Không thể tải dữ liệu") +
            "</td></tr>";
          return;
        }
        totalPages = data.totalPages || 1;
        var items = data.content || [];

        if (items.length === 0) {
          tbody.innerHTML =
            '<tr><td colspan="5" class="text-center text-muted py-4"><i class="fas fa-inbox"></i> Chưa có thông báo nào.</td></tr>';
        } else {
          var html = "";
          items.forEach(function (n) {
            var emailBadge = n.emailSent
              ? '<span class="badge badge-success"><i class="fas fa-check"></i> ' +
                (n.emailCount || 0) +
                "</span>"
              : '<span class="badge badge-light">-</span>';
            html +=
              "<tr>" +
              '<td class="text-truncate" style="max-width: 200px;" title="' +
              (n.title || "").replace(/"/g, "&quot;") +
              '">' +
              (n.title || "") +
              "</td>" +
              "<td>" +
              getRoleBadge(n.targetRole) +
              "</td>" +
              '<td class="small">' +
              formatDate(n.createdAt) +
              "</td>" +
              "<td>" +
              emailBadge +
              "</td>" +
              "<td>" +
              '  <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete(' +
              n.notificationId +
              ", '" +
              (n.title || "").replace(/'/g, "\\'") +
              "')\">" +
              '    <i class="fas fa-trash"></i>' +
              "  </button>" +
              "</td>" +
              "</tr>";
          });
          tbody.innerHTML = html;
        }

        // Update pagination
        document.getElementById("paginationInfo").textContent =
          "Trang " +
          (currentPage + 1) +
          " / " +
          totalPages +
          " (" +
          data.totalElements +
          " thông báo)";
        document.getElementById("btnPrev").disabled = currentPage <= 0;
        document.getElementById("btnNext").disabled =
          currentPage >= totalPages - 1;
      })
      .catch(function (err) {
        console.error("Load history error:", err);
        tbody.innerHTML =
          '<tr><td colspan="5" class="text-center text-danger py-4">Lỗi kết nối.</td></tr>';
      });
  }

  function changePage(delta) {
    var newPage = currentPage + delta;
    if (newPage >= 0 && newPage < totalPages) {
      loadHistory(newPage);
    }
  }

  // ==================== Delete ====================
  function confirmDelete(id, title) {
    deleteId = id;
    document.getElementById("deleteTitle").textContent = title;
    $("#deleteModal").modal("show");
  }

  document
    .getElementById("btnConfirmDelete")
    .addEventListener("click", function () {
      if (!deleteId) return;

      fetch(API_BASE + "/" + deleteId, { method: "DELETE" })
        .then(function (res) {
          return res.json();
        })
        .then(function (data) {
          $("#deleteModal").modal("hide");
          if (data.ok) {
            showBox("notifySuccess", data.message || "Đã xóa thông báo.");
            loadHistory(currentPage);
            loadStats();
          } else {
            showBox("notifyError", data.message || "Không thể xóa.");
          }
        })
        .catch(function (err) {
          $("#deleteModal").modal("hide");
          showBox("notifyError", "Lỗi kết nối.");
        });
    });

  // ==================== Send Notification ====================
  document
    .getElementById("notifyForm")
    .addEventListener("submit", function (e) {
      e.preventDefault();

      showBox("notifySuccess", null);
      showBox("notifyError", null);

      var title = document.getElementById("notifyTitle").value.trim();
      var target = document.getElementById("notifyTarget").value;
      var body = document.getElementById("notifyBody").value.trim();
      var sendEmail = document.getElementById("sendEmailCheckbox").checked;

      if (!title || !body) {
        showBox("notifyError", "Vui lòng nhập đầy đủ tiêu đề và nội dung.");
        return;
      }

      var btn = document.getElementById("btnSubmit");
      btn.disabled = true;
      btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

      fetch(API_BASE + "/send", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          title: title,
          target: target,
          body: body,
          sendEmail: sendEmail,
        }),
      })
        .then(function (res) {
          if (!res.ok) throw new Error("HTTP " + res.status);
          return res.json();
        })
        .then(function (data) {
          btn.disabled = false;
          btn.innerHTML =
            '<i class="fas fa-paper-plane mr-1"></i> Gửi thông báo';

          if (data && data.ok) {
            showBox(
              "notifySuccess",
              data.message || "Gửi thông báo thành công."
            );
            document.getElementById("notifyTitle").value = "";
            document.getElementById("notifyBody").value = "";
            document.getElementById("sendEmailCheckbox").checked = false;
            loadHistory(0);
            loadStats();
          } else {
            showBox("notifyError", data.message || "Không thể gửi thông báo.");
          }
        })
        .catch(function (err) {
          console.error("Send notification failed:", err);
          btn.disabled = false;
          btn.innerHTML =
            '<i class="fas fa-paper-plane mr-1"></i> Gửi thông báo';
          showBox("notifyError", "Không thể gửi thông báo. Vui lòng thử lại.");
        });
    });

  // ==================== Init ====================
  document.addEventListener("DOMContentLoaded", function () {
    loadStats();
    loadHistory(0);
  });
</script>
