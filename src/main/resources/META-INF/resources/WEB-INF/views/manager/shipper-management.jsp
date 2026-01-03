<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-sm-flex align-items-center justify-content-between mb-4">
  <h1 class="h3 mb-0 text-gray-800">
    <i class="fas fa-motorcycle text-primary me-2"></i>
    Quản Lý Shipper
  </h1>
  <div>
    <button class="btn btn-primary btn-sm" onclick="showAddShipperModal()">
      <i class="fas fa-plus me-1"></i> Thêm Shipper
    </button>
    <button
      class="btn btn-outline-primary btn-sm ms-2"
      onclick="loadShippers()">
      <i class="fas fa-sync-alt me-1"></i> Làm mới
    </button>
  </div>
</div>

<!-- Stats Cards -->
<div class="row mb-4">
  <div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-primary shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div
              class="text-xs font-weight-bold text-primary text-uppercase mb-1">
              Tổng Shipper
            </div>
            <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-total">
              0
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-users fa-2x text-gray-300"></i>
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
              Đang Sẵn Sàng
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-active">
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
  <div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-warning shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div
              class="text-xs font-weight-bold text-warning text-uppercase mb-1">
              Đang Bận
            </div>
            <div class="h5 mb-0 font-weight-bold text-gray-800" id="stat-busy">
              0
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-truck fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-danger shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div
              class="text-xs font-weight-bold text-danger text-uppercase mb-1">
              Không Hoạt Động
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-inactive">
              0
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-ban fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Filter & Search -->
<div class="card shadow mb-4">
  <div class="card-header py-3">
    <div class="row align-items-center">
      <div class="col-md-6">
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            id="search-input"
            placeholder="Tìm kiếm theo tên, SĐT, email..."
            onkeyup="handleSearch(event)" />
          <button class="btn btn-primary" onclick="searchShippers()">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </div>
      <div class="col-md-6 text-md-end mt-2 mt-md-0">
        <div class="btn-group" role="group">
          <button
            type="button"
            class="btn btn-outline-primary active"
            id="filter-all"
            onclick="filterByStatus('')">
            Tất cả
          </button>
          <button
            type="button"
            class="btn btn-outline-success"
            id="filter-active"
            onclick="filterByStatus('active')">
            Sẵn sàng
          </button>
          <button
            type="button"
            class="btn btn-outline-warning"
            id="filter-busy"
            onclick="filterByStatus('busy')">
            Đang bận
          </button>
          <button
            type="button"
            class="btn btn-outline-danger"
            id="filter-inactive"
            onclick="filterByStatus('inactive')">
            Không hoạt động
          </button>
        </div>
      </div>
    </div>
  </div>
  <div class="card-body">
    <div id="shipper-list-loading" class="text-center py-4">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="mt-2 text-muted">Đang tải danh sách...</p>
    </div>
    <div id="shipper-list-empty" class="text-center py-4 d-none">
      <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
      <p class="text-muted">Không có shipper nào</p>
    </div>
    <div class="table-responsive d-none" id="shipper-table-container">
      <table class="table table-hover" id="shipper-table">
        <thead class="table-light">
          <tr>
            <th>Shipper</th>
            <th>Liên hệ</th>
            <th>Loại</th>
            <th>Phương tiện</th>
            <th>Rating</th>
            <th>Trạng thái</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody id="shipper-table-body">
          <!-- Shipper rows will be loaded here -->
        </tbody>
      </table>

      <!-- Pagination -->
      <div
        class="d-flex justify-content-between align-items-center mt-3"
        id="pagination-container">
        <div class="text-muted">
          Hiển thị <span id="page-showing">0</span> /
          <span id="page-total">0</span> shipper
        </div>
        <nav aria-label="Page navigation">
          <ul class="pagination mb-0" id="pagination-list">
            <!-- Pagination items will be generated here -->
          </ul>
        </nav>
      </div>
    </div>
  </div>
</div>

<!-- Modal Chi tiết Shipper -->
<div
  class="modal fade"
  id="shipperDetailModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">
          <i class="fas fa-user me-2"></i>Chi Tiết Shipper
        </h5>
        <button
          type="button"
          class="close text-white"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-md-4 text-center">
            <div
              class="avatar-lg bg-primary text-white rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center"
              style="width: 100px; height: 100px">
              <i class="fas fa-user fa-3x"></i>
            </div>
            <h5 id="detail-name">-</h5>
            <span class="badge" id="detail-status-badge">-</span>
          </div>
          <div class="col-md-8">
            <table class="table table-borderless">
              <tr>
                <td><strong>Điện thoại:</strong></td>
                <td id="detail-phone">-</td>
              </tr>
              <tr>
                <td><strong>Email:</strong></td>
                <td id="detail-email">-</td>
              </tr>
              <tr>
                <td><strong>Loại:</strong></td>
                <td id="detail-type">-</td>
              </tr>
              <tr>
                <td><strong>Phương tiện:</strong></td>
                <td id="detail-vehicle">-</td>
              </tr>
              <tr>
                <td><strong>Ngày tham gia:</strong></td>
                <td id="detail-joined">-</td>
              </tr>
              <tr>
                <td><strong>Rating:</strong></td>
                <td id="detail-rating">-</td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Đóng
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Cập nhật Status -->
<div
  class="modal fade"
  id="updateStatusModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title">
          <i class="fas fa-exchange-alt me-2"></i>Cập Nhật Trạng Thái
        </h5>
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>
          Cập nhật trạng thái cho shipper:
          <strong id="modal-shipper-name">-</strong>
        </p>
        <div class="form-group">
          <label>Trạng thái mới:</label>
          <select class="form-control" id="new-status">
            <option value="active">Sẵn sàng (Active)</option>
            <option value="busy">Đang bận (Busy)</option>
            <option value="inactive">Không hoạt động (Inactive)</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button
          type="button"
          class="btn btn-warning"
          onclick="confirmUpdateStatus()">
          <i class="fas fa-save me-1"></i>Cập nhật
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Thêm Shipper Mới -->
<div
  class="modal fade"
  id="addShipperModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title">
          <i class="fas fa-user-plus me-2"></i>Thêm Shipper Mới
        </h5>
        <button
          type="button"
          class="close text-white"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="createShipperForm">
          <div class="row">
            <div class="col-md-6">
              <h6 class="text-muted mb-3">
                <i class="fas fa-key me-1"></i>Thông tin đăng nhập
              </h6>
              <div class="form-group mb-3">
                <label>Tên đăng nhập <span class="text-danger">*</span></label>
                <input
                  type="text"
                  class="form-control"
                  id="new-username"
                  placeholder="VD: shipper001"
                  required />
                <div class="invalid-feedback" id="error-username"></div>
                <small class="text-muted">Dùng để đăng nhập vào hệ thống</small>
              </div>
              <div class="form-group mb-3">
                <label>Mật khẩu <span class="text-danger">*</span></label>
                <input
                  type="password"
                  class="form-control"
                  id="new-password"
                  placeholder="Tối thiểu 6 ký tự"
                  required />
                <div class="invalid-feedback" id="error-password"></div>
              </div>
              <div class="form-group mb-3">
                <label>Email <span class="text-danger">*</span></label>
                <input
                  type="email"
                  class="form-control"
                  id="new-email"
                  placeholder="shipper@gmail.com"
                  required />
                <div class="invalid-feedback" id="error-email"></div>
              </div>
            </div>
            <div class="col-md-6">
              <h6 class="text-muted mb-3">
                <i class="fas fa-user me-1"></i>Thông tin cá nhân
              </h6>
              <div class="form-group mb-3">
                <label>Họ và tên <span class="text-danger">*</span></label>
                <input
                  type="text"
                  class="form-control"
                  id="new-fullname"
                  placeholder="Nguyễn Văn A"
                  required />
                <div class="invalid-feedback" id="error-fullName"></div>
              </div>
              <div class="form-group mb-3">
                <label>Số điện thoại</label>
                <input
                  type="tel"
                  class="form-control"
                  id="new-phone"
                  placeholder="0901234567" />
                <div class="invalid-feedback" id="error-phone"></div>
              </div>
              <div class="form-group mb-3">
                <label>Loại Shipper <span class="text-danger">*</span></label>
                <select class="form-control" id="new-shipper-type">
                  <option value="fulltime">Full-time (Toàn thời gian)</option>
                  <option value="parttime">Part-time (Bán thời gian)</option>
                </select>
                <div class="invalid-feedback" id="error-shipperType"></div>
              </div>
              <div class="form-group mb-3">
                <label>Phương tiện</label>
                <select class="form-control" id="new-vehicle-type">
                  <option value="Xe máy">Xe máy</option>
                  <option value="Xe đạp">Xe đạp</option>
                  <option value="Xe tải nhỏ">Xe tải nhỏ</option>
                  <option value="Khác">Khác</option>
                </select>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button
          type="button"
          class="btn btn-success"
          onclick="submitCreateShipper()"
          id="btn-create-shipper">
          <i class="fas fa-plus me-1"></i>Tạo Shipper
        </button>
      </div>
    </div>
  </div>
</div>

<style>
  .border-left-primary {
    border-left: 4px solid #4e73df !important;
  }
  .border-left-success {
    border-left: 4px solid #1cc88a !important;
  }
  .border-left-warning {
    border-left: 4px solid #f6c23e !important;
  }
  .border-left-danger {
    border-left: 4px solid #e74a3b !important;
  }

  .avatar-sm {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
  }

  .rating-stars {
    color: #f6c23e;
  }
</style>

<script>
  var currentFilter = "";
  var currentKeyword = "";
  var currentPage = 0;
  var pageSize = 6;
  var totalPages = 0;
  var totalElements = 0;
  var selectedShipperId = null;

  // Load khi trang được mở
  document.addEventListener("DOMContentLoaded", function () {
    loadShippers();
  });

  // Load danh sách shipper (có phân trang)
  function loadShippers(page) {
    if (page !== undefined) currentPage = page;

    document.getElementById("shipper-list-loading").classList.remove("d-none");
    document.getElementById("shipper-list-empty").classList.add("d-none");
    document.getElementById("shipper-table-container").classList.add("d-none");

    var url = "/api/manager/shippers";
    var params = [];

    params.push("page=" + currentPage);
    params.push("size=" + pageSize);
    if (currentFilter) params.push("status=" + currentFilter);
    if (currentKeyword)
      params.push("keyword=" + encodeURIComponent(currentKeyword));

    url += "?" + params.join("&");

    fetch(url)
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        document.getElementById("shipper-list-loading").classList.add("d-none");

        if (data.success && data.data && data.data.length > 0) {
          renderShipperTable(data.data);

          // Cập nhật thông tin phân trang
          totalPages = data.totalPages || 1;
          totalElements = data.totalElements || data.data.length;
          currentPage = data.currentPage || 0;

          renderPagination();
          updatePageInfo(data.count, totalElements);

          document
            .getElementById("shipper-table-container")
            .classList.remove("d-none");
        } else {
          document
            .getElementById("shipper-list-empty")
            .classList.remove("d-none");
        }

        if (data.stats) {
          updateStats(data.stats);
        }
      })
      .catch(function (err) {
        console.error("Error loading shippers:", err);
        document.getElementById("shipper-list-loading").classList.add("d-none");
        alert("Lỗi tải dữ liệu: " + err.message);
      });
  }

  // Render pagination
  function renderPagination() {
    var paginationList = document.getElementById("pagination-list");
    var html = "";

    // Previous button
    html +=
      '<li class="page-item ' + (currentPage === 0 ? "disabled" : "") + '">';
    html +=
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage - 1) +
      ')" aria-label="Previous">';
    html += '<span aria-hidden="true">&laquo;</span></a></li>';

    // Page numbers
    var startPage = Math.max(0, currentPage - 2);
    var endPage = Math.min(totalPages - 1, currentPage + 2);

    if (startPage > 0) {
      html +=
        '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(0)">1</a></li>';
      if (startPage > 1) {
        html +=
          '<li class="page-item disabled"><span class="page-link">...</span></li>';
      }
    }

    for (var i = startPage; i <= endPage; i++) {
      html +=
        '<li class="page-item ' + (i === currentPage ? "active" : "") + '">';
      html +=
        '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
        i +
        ')">' +
        (i + 1) +
        "</a></li>";
    }

    if (endPage < totalPages - 1) {
      if (endPage < totalPages - 2) {
        html +=
          '<li class="page-item disabled"><span class="page-link">...</span></li>';
      }
      html +=
        '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
        (totalPages - 1) +
        ')">' +
        totalPages +
        "</a></li>";
    }

    // Next button
    html +=
      '<li class="page-item ' +
      (currentPage >= totalPages - 1 ? "disabled" : "") +
      '">';
    html +=
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage + 1) +
      ')" aria-label="Next">';
    html += '<span aria-hidden="true">&raquo;</span></a></li>';

    paginationList.innerHTML = html;
  }

  // Cập nhật thông tin trang
  function updatePageInfo(showing, total) {
    document.getElementById("page-showing").textContent = showing;
    document.getElementById("page-total").textContent = total;
  }

  // Chuyển trang
  function goToPage(page) {
    if (page < 0 || page >= totalPages) return;
    loadShippers(page);
  }

  // Render bảng shipper
  function renderShipperTable(shippers) {
    var tbody = document.getElementById("shipper-table-body");
    var html = "";

    for (var i = 0; i < shippers.length; i++) {
      var s = shippers[i];
      var statusBadge = getStatusBadge(s.status);
      var ratingStars = renderRating(s.rating);

      html +=
        "<tr>" +
        "<td>" +
        '<div class="d-flex align-items-center">' +
        '<div class="avatar-sm bg-primary text-white me-3">' +
        '<i class="fas fa-user"></i>' +
        "</div>" +
        "<div>" +
        '<div class="fw-bold">' +
        (s.fullName || "N/A") +
        "</div>" +
        '<small class="text-muted">ID: ' +
        s.shipperId +
        "</small>" +
        "</div>" +
        "</div>" +
        "</td>" +
        "<td>" +
        '<div><i class="fas fa-phone text-muted me-1"></i>' +
        (s.phone || "N/A") +
        "</div>" +
        '<small class="text-muted"><i class="fas fa-envelope me-1"></i>' +
        (s.email || "N/A") +
        "</small>" +
        "</td>" +
        "<td>" +
        formatShipperType(s.shipperType) +
        "</td>" +
        '<td><i class="fas fa-motorcycle me-1"></i>' +
        (s.vehicleType || "N/A") +
        "</td>" +
        '<td class="rating-stars">' +
        ratingStars +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        '<td class="text-center">' +
        '<button class="btn btn-sm btn-info me-1" onclick="viewShipperDetail(' +
        s.shipperId +
        ')" title="Xem chi tiết">' +
        '<i class="fas fa-eye"></i>' +
        "</button>" +
        '<button class="btn btn-sm btn-warning" onclick="showUpdateStatusModal(' +
        s.shipperId +
        ", '" +
        s.fullName +
        "', '" +
        s.status +
        '\')" title="Cập nhật trạng thái">' +
        '<i class="fas fa-edit"></i>' +
        "</button>" +
        "</td>" +
        "</tr>";
    }

    tbody.innerHTML = html;
  }

  // Cập nhật thống kê
  function updateStats(stats) {
    document.getElementById("stat-total").textContent = stats.total || 0;
    document.getElementById("stat-active").textContent = stats.active || 0;
    document.getElementById("stat-busy").textContent = stats.busy || 0;
    document.getElementById("stat-inactive").textContent = stats.inactive || 0;
  }

  // Filter theo status
  function filterByStatus(status) {
    currentFilter = status;
    currentPage = 0; // Reset về trang đầu

    // Update button active state
    document.querySelectorAll(".btn-group .btn").forEach(function (btn) {
      btn.classList.remove("active");
    });

    var btnId = status ? "filter-" + status : "filter-all";
    document.getElementById(btnId).classList.add("active");

    loadShippers();
  }

  // Tìm kiếm
  function handleSearch(event) {
    if (event.key === "Enter") {
      searchShippers();
    }
  }

  function searchShippers() {
    currentKeyword = document.getElementById("search-input").value;
    currentPage = 0; // Reset về trang đầu
    loadShippers();
  }

  // Xem chi tiết shipper
  function viewShipperDetail(shipperId) {
    fetch("/api/manager/shippers/" + shipperId)
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        if (data.success && data.data) {
          var s = data.data;
          document.getElementById("detail-name").textContent =
            s.fullName || "N/A";
          document.getElementById("detail-phone").textContent =
            s.phone || "N/A";
          document.getElementById("detail-email").textContent =
            s.email || "N/A";
          document.getElementById("detail-type").textContent =
            formatShipperType(s.shipperType);
          document.getElementById("detail-vehicle").textContent =
            s.vehicleType || "N/A";
          document.getElementById("detail-joined").textContent = formatDate(
            s.joinedAt
          );
          document.getElementById("detail-rating").innerHTML = renderRating(
            s.rating
          );

          var badge = document.getElementById("detail-status-badge");
          badge.innerHTML = getStatusBadge(s.status);

          $("#shipperDetailModal").modal("show");
        }
      });
  }

  // Hiển thị modal cập nhật status
  function showUpdateStatusModal(shipperId, name, currentStatus) {
    selectedShipperId = shipperId;
    document.getElementById("modal-shipper-name").textContent = name;
    document.getElementById("new-status").value = currentStatus;
    $("#updateStatusModal").modal("show");
  }

  // Xác nhận cập nhật status
  function confirmUpdateStatus() {
    if (!selectedShipperId) return;

    var newStatus = document.getElementById("new-status").value;

    fetch("/api/manager/shippers/" + selectedShipperId + "/status", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: newStatus }),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        $("#updateStatusModal").modal("hide");
        if (data.success) {
          alert("Cập nhật trạng thái thành công!");
          loadShippers();
        } else {
          alert("Lỗi: " + (data.message || "Không thể cập nhật"));
        }
      })
      .catch(function (err) {
        alert("Lỗi: " + err.message);
      });
  }

  // Helper functions
  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return '<span class="badge bg-success">Sẵn sàng</span>';
      case "busy":
        return '<span class="badge bg-warning text-dark">Đang bận</span>';
      case "inactive":
        return '<span class="badge bg-danger">Không hoạt động</span>';
      default:
        return '<span class="badge bg-secondary">' + status + "</span>";
    }
  }

  function formatShipperType(type) {
    switch (type) {
      case "fulltime":
        return '<span class="badge bg-primary">Full-time</span>';
      case "parttime":
        return '<span class="badge bg-info">Part-time</span>';
      default:
        return (
          '<span class="badge bg-secondary">' + (type || "N/A") + "</span>"
        );
    }
  }

  function renderRating(rating) {
    var r = parseFloat(rating) || 0;
    var stars = "";
    for (var i = 1; i <= 5; i++) {
      if (i <= r) {
        stars += '<i class="fas fa-star"></i>';
      } else if (i - 0.5 <= r) {
        stars += '<i class="fas fa-star-half-alt"></i>';
      } else {
        stars += '<i class="far fa-star"></i>';
      }
    }
    return stars + " <small>(" + r.toFixed(1) + ")</small>";
  }

  function formatDate(dateStr) {
    if (!dateStr) return "N/A";
    var date = new Date(dateStr);
    return date.toLocaleDateString("vi-VN");
  }

  // Mở modal thêm shipper mới
  function showAddShipperModal() {
    // Reset form và xóa errors
    document.getElementById("createShipperForm").reset();
    clearFormErrors();
    $("#addShipperModal").modal("show");
  }

  // Xóa tất cả lỗi trên form
  function clearFormErrors() {
    // Xóa class is-invalid
    document
      .querySelectorAll("#createShipperForm .form-control")
      .forEach(function (el) {
        el.classList.remove("is-invalid");
      });
    // Xóa nội dung error
    document
      .querySelectorAll("#createShipperForm .invalid-feedback")
      .forEach(function (el) {
        el.textContent = "";
        el.style.display = "none";
      });
  }

  // Hiển thị lỗi cho một field
  function showFieldError(fieldName, message) {
    // Map field name từ server sang ID trên form
    var fieldMap = {
      username: "new-username",
      password: "new-password",
      email: "new-email",
      fullName: "new-fullname",
      phone: "new-phone",
      shipperType: "new-shipper-type",
      vehicleType: "new-vehicle-type",
    };

    var inputId = fieldMap[fieldName];
    if (inputId) {
      var input = document.getElementById(inputId);
      if (input) {
        input.classList.add("is-invalid");
      }
    }

    var errorDiv = document.getElementById("error-" + fieldName);
    if (errorDiv) {
      errorDiv.textContent = message;
      errorDiv.style.display = "block";
    }
  }

  // Submit tạo shipper mới
  function submitCreateShipper() {
    clearFormErrors(); // Xóa errors cũ

    var username = document.getElementById("new-username").value.trim();
    var password = document.getElementById("new-password").value;
    var email = document.getElementById("new-email").value.trim();
    var fullName = document.getElementById("new-fullname").value.trim();
    var phone = document.getElementById("new-phone").value.trim();
    var shipperType = document.getElementById("new-shipper-type").value;
    var vehicleType = document.getElementById("new-vehicle-type").value;

    // Disable button
    var btn = document.getElementById("btn-create-shipper");
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tạo...';

    var requestData = {
      username: username,
      password: password,
      email: email,
      fullName: fullName,
      phone: phone,
      shipperType: shipperType,
      vehicleType: vehicleType,
    };

    fetch("/api/manager/shippers", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestData),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-plus me-1"></i>Tạo Shipper';

        if (data.success) {
          $("#addShipperModal").modal("hide");
          alert(
            "Tạo shipper thành công!\n\nThông tin đăng nhập:\n- Username: " +
              username +
              "\n- Password: (mật khẩu bạn đã nhập)"
          );
          loadShippers();
        } else {
          // Hiển thị lỗi trên form nếu có field errors
          if (data.errors) {
            for (var field in data.errors) {
              showFieldError(field, data.errors[field]);
            }
          } else {
            // Lỗi chung - hiển thị alert
            alert("Lỗi: " + (data.message || "Không thể tạo shipper"));
          }
        }
      })
      .catch(function (err) {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-plus me-1"></i>Tạo Shipper';
        alert("Lỗi kết nối: " + err.message);
      });
  }
</script>
