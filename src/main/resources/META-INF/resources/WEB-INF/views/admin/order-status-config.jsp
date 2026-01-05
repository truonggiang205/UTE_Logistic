<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <div>
      <h1 class="h3 mb-0 text-gray-800">Cấu hình loại hành động</h1>
      <div class="small text-muted">
        Quản lý các loại hành động (Action Types) trong luồng vận hành.
      </div>
    </div>
    <button
      class="btn btn-sm btn-primary shadow-sm"
      data-toggle="modal"
      data-target="#actionTypeModal"
      onclick="openAddModal()">
      <i class="fas fa-plus fa-sm text-white-50"></i> Thêm loại hành động
    </button>
  </div>

  <div class="row">
    <!-- Main Table -->
    <div class="col-lg-8">
      <!-- Filter Section -->
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
        </div>
        <div class="card-body py-2">
          <div class="row">
            <div class="col-md-9">
              <input
                type="text"
                class="form-control"
                id="filterKeyword"
                placeholder="Tìm theo mã, tên hoặc mô tả..."
                onkeyup="debounceSearch()" />
            </div>
            <div class="col-md-3">
              <button
                class="btn btn-secondary btn-block"
                onclick="resetFilters()">
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
          <h6 class="m-0 font-weight-bold text-primary">
            Danh sách loại hành động
          </h6>
          <span class="badge badge-info" id="totalCount">0 mục</span>
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
                  <th style="width: 180px">Mã</th>
                  <th style="width: 200px">Tên hiển thị</th>
                  <th>Mô tả</th>
                  <th style="width: 100px">Hành động</th>
                </tr>
              </thead>
              <tbody id="actionTypeListData">
                <tr>
                  <td colspan="5" class="text-center">Đang tải dữ liệu...</td>
                </tr>
              </tbody>
            </table>
          </div>
          <!-- Pagination -->
          <nav>
            <ul
              class="pagination justify-content-center mb-0"
              id="pagination"></ul>
          </nav>
        </div>
      </div>
    </div>

    <!-- Info Panel -->
    <div class="col-lg-4">
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-primary">Hướng dẫn</h6>
        </div>
        <div class="card-body">
          <div class="alert alert-info mb-3">
            <div class="font-weight-bold mb-1">
              <i class="fas fa-info-circle"></i> Action Types
            </div>
            <p class="mb-0 small">
              Các loại hành động được sử dụng để ghi nhận lịch sử và trạng thái
              trong quá trình vận chuyển đơn hàng.
            </p>
          </div>
          <div class="alert alert-warning mb-0">
            <div class="font-weight-bold mb-1">
              <i class="fas fa-exclamation-triangle"></i> Lưu ý
            </div>
            <ul class="mb-0 pl-3 small">
              <li>
                Mã hành động chỉ bao gồm <strong>CHỮ IN HOA</strong> và
                <strong>dấu gạch dưới (_)</strong>.
              </li>
              <li>Không nên xóa các loại hành động đang được sử dụng.</li>
              <li>
                Các mã hành động phổ biến: IMPORT_WAREHOUSE, COUNTER_SEND,
                ASSIGN_PICKUP, DELIVERY_SUCCESS...
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Quick Stats -->
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-primary">Thống kê nhanh</h6>
        </div>
        <div class="card-body">
          <div class="row text-center">
            <div class="col-12">
              <h4 class="text-primary mb-0" id="statTotal">0</h4>
              <small class="text-muted">Tổng loại hành động</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal Thêm/Sửa ActionType -->
<div
  class="modal fade"
  id="actionTypeModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Thêm loại hành động mới</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <form id="actionTypeForm">
        <div class="modal-body">
          <input type="hidden" id="actionTypeId" />
          <div class="form-group">
            <label class="small font-weight-bold"
              >Mã hành động <span class="text-danger">*</span></label
            >
            <input
              type="text"
              class="form-control"
              id="actionCode"
              required
              placeholder="VD: DELIVERY_SUCCESS"
              pattern="^[A-Z_]+$"
              title="Chỉ cho phép chữ in hoa và dấu gạch dưới"
              style="text-transform: uppercase" />
            <small class="text-muted"
              >Chỉ cho phép chữ in hoa (A-Z) và dấu gạch dưới (_)</small
            >
          </div>
          <div class="form-group">
            <label class="small font-weight-bold"
              >Tên hiển thị <span class="text-danger">*</span></label
            >
            <input
              type="text"
              class="form-control"
              id="actionName"
              required
              placeholder="VD: Giao thành công" />
          </div>
          <div class="form-group mb-0">
            <label class="small font-weight-bold">Mô tả</label>
            <textarea
              class="form-control"
              id="description"
              rows="3"
              placeholder="VD: Shipper đã giao hàng thành công cho người nhận"></textarea>
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
        <input type="hidden" id="deleteActionTypeId" />
        <p>Bạn có chắc chắn muốn xóa loại hành động này?</p>
        <p class="mb-0">
          <span class="badge badge-secondary" id="deleteActionCode"></span>
          <strong id="deleteActionName"></strong>
        </p>
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
  var API_BASE = window.location.origin + "/api/admin/action-types";
  var currentPage = 0;
  var pageSize = 10;
  var debounceTimer;

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadActionTypes();
  });

  function loadActionTypes() {
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
            response.data.totalElements + " mục";
          document.getElementById("statTotal").innerText =
            response.data.totalElements;
        } else {
          document.getElementById("actionTypeListData").innerHTML =
            '<tr><td colspan="5" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("actionTypeListData").innerHTML =
          '<tr><td colspan="5" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function renderTable(items) {
    if (!items || items.length === 0) {
      document.getElementById("actionTypeListData").innerHTML =
        '<tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      var actionBtns =
        '<button class="btn btn-sm btn-info mr-1" onclick="openEditModal(' +
        item.actionTypeId +
        ')" title="Sửa">' +
        '<i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-danger" onclick="openDeleteModal(' +
        item.actionTypeId +
        ", '" +
        escapeHtml(item.actionCode) +
        "', '" +
        escapeHtml(item.actionName) +
        '\')" title="Xóa">' +
        '<i class="fas fa-trash"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        item.actionTypeId +
        "</td>" +
        '<td><span class="badge badge-secondary">' +
        escapeHtml(item.actionCode) +
        "</span></td>" +
        "<td><strong>" +
        escapeHtml(item.actionName) +
        "</strong></td>" +
        "<td><small>" +
        escapeHtml(item.description || "-") +
        "</small></td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("actionTypeListData").innerHTML = html;
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
    loadActionTypes();
  }

  function debounceSearch() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function () {
      currentPage = 0;
      loadActionTypes();
    }, 500);
  }

  function resetFilters() {
    document.getElementById("filterKeyword").value = "";
    currentPage = 0;
    loadActionTypes();
  }

  function openAddModal() {
    document.getElementById("actionTypeForm").reset();
    document.getElementById("actionTypeId").value = "";
    document.getElementById("modalTitle").innerText = "Thêm loại hành động mới";
  }

  function openEditModal(id) {
    fetch(API_BASE + "/" + id)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var item = response.data;
          document.getElementById("actionTypeId").value = item.actionTypeId;
          document.getElementById("actionCode").value = item.actionCode || "";
          document.getElementById("actionName").value = item.actionName || "";
          document.getElementById("description").value = item.description || "";
          document.getElementById("modalTitle").innerText =
            "Cập nhật: " + item.actionCode;
          $("#actionTypeModal").modal("show");
        }
      });
  }

  function openDeleteModal(id, code, name) {
    document.getElementById("deleteActionTypeId").value = id;
    document.getElementById("deleteActionCode").innerText = code;
    document.getElementById("deleteActionName").innerText = name;
    $("#deleteModal").modal("show");
  }

  function confirmDelete() {
    var id = document.getElementById("deleteActionTypeId").value;

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
          showToast("success", "Xóa thành công!");
          loadActionTypes();
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
  document
    .getElementById("actionTypeForm")
    .addEventListener("submit", function (e) {
      e.preventDefault();

      var actionTypeId = document.getElementById("actionTypeId").value;
      var isEdit = actionTypeId !== "";

      var actionCode = document
        .getElementById("actionCode")
        .value.toUpperCase()
        .trim();

      // Validate format client-side
      if (!/^[A-Z_]+$/.test(actionCode)) {
        showToast(
          "error",
          "Mã hành động chỉ được chứa chữ in hoa và dấu gạch dưới"
        );
        return;
      }

      var data = {
        actionCode: actionCode,
        actionName: document.getElementById("actionName").value.trim(),
        description: document.getElementById("description").value.trim(),
      };

      var url = isEdit ? API_BASE + "/" + actionTypeId : API_BASE;
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
            $("#actionTypeModal").modal("hide");
            showToast(
              "success",
              isEdit ? "Cập nhật thành công!" : "Thêm mới thành công!"
            );
            loadActionTypes();
          } else {
            showToast("error", response.message || "Có lỗi xảy ra");
          }
        })
        .catch(function (err) {
          showToast("error", "Lỗi kết nối server");
        });
    });

  // Auto uppercase for action code input
  document.getElementById("actionCode").addEventListener("input", function () {
    this.value = this.value.toUpperCase().replace(/[^A-Z_]/g, "");
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
