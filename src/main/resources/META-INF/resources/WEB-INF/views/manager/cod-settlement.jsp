<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-sm-flex align-items-center justify-content-between mb-4">
  <h1 class="h3 mb-0 text-gray-800">
    <i class="fas fa-money-bill-wave text-success me-2"></i>
    Quyết Toán COD
  </h1>
  <div>
    <button
      class="btn btn-outline-primary btn-sm"
      onclick="refreshCurrentTab()">
      <i class="fas fa-sync-alt me-1"></i> Làm mới
    </button>
  </div>
</div>

<!-- Tabs Navigation -->
<ul class="nav nav-tabs mb-4" id="codTabs" role="tablist">
  <li class="nav-item" role="presentation">
    <button
      class="nav-link"
      id="pending-hold-tab"
      data-bs-toggle="tab"
      data-bs-target="#pendingHoldTab"
      type="button"
      role="tab"
      onclick="switchTab('pending-hold')">
      <i class="fas fa-wallet me-1"></i>Shipper đang giữ tiền
      <span class="badge bg-danger ms-1" id="pendingHoldBadge">0</span>
    </button>
  </li>
  <li class="nav-item" role="presentation">
    <button
      class="nav-link active"
      id="collected-tab"
      data-bs-toggle="tab"
      data-bs-target="#collectedTab"
      type="button"
      role="tab"
      onclick="switchTab('collected')">
      <i class="fas fa-hand-holding-usd me-1"></i>Shipper đã nộp, chờ duyệt
      <span class="badge bg-warning ms-1" id="collectedBadge">0</span>
    </button>
  </li>
</ul>

<!-- Stats Cards - Hàng 1 -->
<div class="row mb-2">
  <div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-primary shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div
              class="text-xs font-weight-bold text-primary text-uppercase mb-1">
              Shipper Chờ Duyệt
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-shipper-count">
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
              Tiền Chờ Duyệt (Collected)
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-total-amount">
              0đ
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-hand-holding-usd fa-2x text-gray-300"></i>
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
              Tiền Shipper Đang Giữ (Pending)
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-pending-total">
              0đ
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-wallet fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-xl-3 col-md-6 mb-4">
    <div class="card border-left-info shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
              Tổng Đơn Chờ Duyệt
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-order-count">
              0
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-receipt fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Stats Cards - Hàng 2 -->
<div class="row mb-4">
  <div class="col-xl-6 col-md-6 mb-4">
    <div class="card border-left-warning shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div
              class="text-xs font-weight-bold text-warning text-uppercase mb-1">
              Hôm Nay Đã Duyệt
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-settled-today">
              0đ
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-calendar-check fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-xl-6 col-md-6 mb-4">
    <div class="card border-left-dark shadow h-100 py-2">
      <div class="card-body">
        <div class="row no-gutters align-items-center">
          <div class="col mr-2">
            <div class="text-xs font-weight-bold text-dark text-uppercase mb-1">
              Tổng Doanh Thu Đã Duyệt
            </div>
            <div
              class="h5 mb-0 font-weight-bold text-gray-800"
              id="stat-total-settled">
              0đ
            </div>
          </div>
          <div class="col-auto">
            <i class="fas fa-chart-line fa-2x text-gray-300"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="row">
  <!-- Danh sách Shipper -->
  <div class="col-lg-5">
    <div class="card shadow mb-4">
      <div
        class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">
          <i class="fas fa-motorcycle me-2"></i>Shipper Chờ Quyết Toán
        </h6>
      </div>
      <div class="card-body">
        <div id="shipper-list-loading" class="text-center py-4">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-2 text-muted">Đang tải danh sách...</p>
        </div>
        <div id="shipper-list-empty" class="text-center py-4 d-none">
          <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
          <p class="text-muted">Không có shipper nào cần quyết toán COD</p>
        </div>
        <div id="shipper-list" class="list-group">
          <!-- Shipper items will be loaded here -->
        </div>
      </div>
    </div>
  </div>

  <!-- Chi tiết COD của Shipper được chọn -->
  <div class="col-lg-7">
    <div class="card shadow mb-4">
      <div
        class="card-header py-3 d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">
          <i class="fas fa-list-alt me-2"></i>
          <span id="detail-title">Chi Tiết COD</span>
        </h6>
        <button
          class="btn btn-success btn-sm d-none"
          id="btn-settle-all"
          onclick="settleAllCod()">
          <i class="fas fa-check-double me-1"></i> Quyết Toán Tất Cả
        </button>
      </div>
      <div class="card-body">
        <div id="detail-placeholder" class="text-center py-5">
          <i class="fas fa-hand-point-left fa-3x text-muted mb-3"></i>
          <p class="text-muted">
            Chọn một Shipper từ danh sách bên trái để xem chi tiết
          </p>
        </div>
        <div id="detail-loading" class="text-center py-4 d-none">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        <div id="detail-content" class="d-none">
          <!-- Thông tin Shipper -->
          <div class="row mb-3">
            <div class="col-md-6">
              <div class="d-flex align-items-center">
                <div class="avatar-circle bg-primary text-white me-3">
                  <i class="fas fa-user"></i>
                </div>
                <div>
                  <h6 class="mb-0" id="detail-shipper-name">-</h6>
                  <small class="text-muted" id="detail-shipper-phone">-</small>
                </div>
              </div>
            </div>
            <div class="col-md-6 text-md-end">
              <div class="h4 text-success mb-0" id="detail-total-amount">
                0đ
              </div>
              <small class="text-muted"
                ><span id="detail-total-count">0</span> đơn hàng</small
              >
            </div>
          </div>

          <!-- Bảng COD -->
          <div class="table-responsive">
            <table class="table table-sm table-hover" id="cod-table">
              <thead class="table-light">
                <tr>
                  <th>
                    <input
                      type="checkbox"
                      id="select-all"
                      onclick="toggleSelectAll()" />
                  </th>
                  <th>Mã Đơn</th>
                  <th>Khách Hàng</th>
                  <th class="text-end">Số Tiền</th>
                  <th>Ngày Thu</th>
                </tr>
              </thead>
              <tbody id="cod-table-body">
                <!-- COD rows will be loaded here -->
              </tbody>
            </table>
          </div>

          <!-- Actions -->
          <div class="mt-3 d-flex justify-content-between align-items-center">
            <div>
              <span class="text-muted">Đã chọn: </span>
              <span class="badge bg-primary" id="selected-count">0</span>
              <span class="text-muted ms-2">Tổng: </span>
              <span class="fw-bold text-success" id="selected-amount">0đ</span>
            </div>
            <button
              class="btn btn-success"
              id="btn-settle-selected"
              type="button"
              onclick="settleSelectedCod()">
              <i class="fas fa-check me-1"></i> Quyết Toán Đã Chọn
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal Xác nhận Quyết toán -->
<div
  class="modal fade"
  id="settleModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title">
          <i class="fas fa-check-circle mr-2"></i>Xác Nhận Quyết Toán
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
        <div class="alert alert-info">
          <i class="fas fa-info-circle mr-2"></i>
          Bạn đang thực hiện quyết toán COD cho
          <strong id="modal-shipper-name">-</strong>
        </div>
        <div class="row text-center mb-3">
          <div class="col-6">
            <div class="h3 text-success mb-0" id="modal-amount">0đ</div>
            <small class="text-muted">Tổng tiền</small>
          </div>
          <div class="col-6">
            <div class="h3 text-primary mb-0" id="modal-count">0</div>
            <small class="text-muted">Số đơn</small>
          </div>
        </div>
        <div class="form-group mb-3">
          <label class="form-label">Ghi chú (tùy chọn)</label>
          <textarea
            class="form-control"
            id="settle-note"
            rows="2"
            placeholder="Nhập ghi chú nếu có..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          Hủy
        </button>
        <button
          type="button"
          class="btn btn-success"
          id="btn-confirm-settle"
          onclick="confirmSettle()">
          <i class="fas fa-check mr-1"></i> Xác Nhận Quyết Toán
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Kết quả -->
<div
  class="modal fade"
  id="resultModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header" id="result-header">
        <h5 class="modal-title" id="result-title">Kết Quả</h5>
        <button
          type="button"
          class="close text-white"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body text-center py-4">
        <i class="fas fa-3x mb-3" id="result-icon"></i>
        <h4 id="result-message">-</h4>
        <div id="result-details" class="mt-3"></div>
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn btn-primary"
          data-dismiss="modal"
          onclick="loadPendingShippers()">
          Đóng
        </button>
      </div>
    </div>
  </div>
</div>

<style>
  .avatar-circle {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
  }
  .shipper-item {
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .shipper-item:hover {
    background-color: #f8f9fc;
  }
  .shipper-item.active {
    background-color: #4e73df;
    color: white;
  }
  .shipper-item.active .text-muted {
    color: rgba(255, 255, 255, 0.8) !important;
  }
  .shipper-item.active .badge {
    background-color: white !important;
    color: #4e73df !important;
  }
  .border-left-primary {
    border-left: 4px solid #4e73df !important;
  }
  .border-left-success {
    border-left: 4px solid #1cc88a !important;
  }
  .border-left-info {
    border-left: 4px solid #36b9cc !important;
  }
  .border-left-warning {
    border-left: 4px solid #f6c23e !important;
  }
  .border-left-danger {
    border-left: 4px solid #e74a3b !important;
  }
  .border-left-dark {
    border-left: 4px solid #5a5c69 !important;
  }
</style>

<script>
  var currentShipperId = null;
  var currentShipperData = null;
  var selectedCodTxIds = [];
  var currentTab = "collected"; // 'collected' hoặc 'pending-hold'

  // Load khi trang được mở
  document.addEventListener("DOMContentLoaded", function () {
    loadCollectedShippers(); // Mặc định load tab "đã nộp, chờ duyệt"
    loadPendingHoldCount(); // Load số lượng shipper đang giữ tiền
  });

  // Chuyển tab
  function switchTab(tab) {
    currentTab = tab;
    resetDetail();
    if (tab === "pending-hold") {
      loadPendingHoldShippers();
    } else {
      loadCollectedShippers();
    }
  }

  // Làm mới tab hiện tại
  function refreshCurrentTab() {
    if (currentTab === "pending-hold") {
      loadPendingHoldShippers();
    } else {
      loadCollectedShippers();
    }
  }

  // Load số lượng shipper đang giữ tiền (cho badge)
  function loadPendingHoldCount() {
    fetch("/api/manager/cod/pending-hold")
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        document.getElementById("pendingHoldBadge").textContent =
          data.count || 0;
      })
      .catch(function (err) {
        console.error("Error loading pending hold count:", err);
      });
  }

  // Load danh sách shipper đang giữ tiền (pending - chưa nộp)
  function loadPendingHoldShippers() {
    document.getElementById("shipper-list-loading").classList.remove("d-none");
    document.getElementById("shipper-list-empty").classList.add("d-none");
    document.getElementById("shipper-list").innerHTML = "";
    resetDetail();

    fetch("/api/manager/cod/pending-hold")
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        document.getElementById("shipper-list-loading").classList.add("d-none");

        if (data.data && data.data.length > 0) {
          renderShipperList(data.data, "pending-hold");
          document.getElementById("pendingHoldBadge").textContent =
            data.count || data.data.length;
        } else {
          document
            .getElementById("shipper-list-empty")
            .classList.remove("d-none");
          document
            .getElementById("shipper-list-empty")
            .querySelector("p").textContent =
            "Không có shipper nào đang giữ tiền COD";
        }
      })
      .catch(function (err) {
        console.error("Error loading pending hold shippers:", err);
        document.getElementById("shipper-list-loading").classList.add("d-none");
        document.getElementById("shipper-list").innerHTML =
          '<div class="alert alert-danger">Lỗi tải dữ liệu: ' +
          err.message +
          "</div>";
      });
  }

  // Load danh sách shipper đã nộp, chờ duyệt (collected)
  function loadCollectedShippers() {
    document.getElementById("shipper-list-loading").classList.remove("d-none");
    document.getElementById("shipper-list-empty").classList.add("d-none");
    document.getElementById("shipper-list").innerHTML = "";
    resetDetail();

    fetch("/api/manager/cod/pending")
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        document.getElementById("shipper-list-loading").classList.add("d-none");

        if (data.data && data.data.length > 0) {
          renderShipperList(data.data, "collected");
          updateStats(
            data.data,
            data.settledToday,
            data.pendingTotal,
            data.totalSettled
          );
          document.getElementById("collectedBadge").textContent =
            data.count || data.data.length;
        } else {
          document
            .getElementById("shipper-list-empty")
            .classList.remove("d-none");
          document
            .getElementById("shipper-list-empty")
            .querySelector("p").textContent =
            "Không có shipper nào cần quyết toán COD";
          updateStats(
            [],
            data.settledToday,
            data.pendingTotal,
            data.totalSettled
          );
        }
      })
      .catch(function (err) {
        console.error("Error loading collected shippers:", err);
        document.getElementById("shipper-list-loading").classList.add("d-none");
        document.getElementById("shipper-list").innerHTML =
          '<div class="alert alert-danger">Lỗi tải dữ liệu: ' +
          err.message +
          "</div>";
      });
  }

  // Alias cũ để tương thích
  function loadPendingShippers() {
    loadCollectedShippers();
  }

  // Render danh sách shipper
  function renderShipperList(shippers, tabType) {
    var container = document.getElementById("shipper-list");
    var html = "";
    var badgeClass = tabType === "pending-hold" ? "bg-danger" : "bg-warning";
    var statusText = tabType === "pending-hold" ? "đang giữ" : "chờ duyệt";

    for (var i = 0; i < shippers.length; i++) {
      var s = shippers[i];
      html +=
        '<a href="javascript:void(0)" class="list-group-item list-group-item-action shipper-item" ' +
        'data-shipper-id="' +
        s.shipperId +
        '" ' +
        'data-tab-type="' +
        tabType +
        '" ' +
        'onclick="selectShipper(' +
        s.shipperId +
        ", this, '" +
        tabType +
        "')\">" +
        '<div class="d-flex justify-content-between align-items-center">' +
        "<div>" +
        '<h6 class="mb-1">' +
        (s.shipperName || "N/A") +
        "</h6>" +
        '<small class="text-muted">' +
        (s.shipperPhone || "") +
        "</small>" +
        "</div>" +
        '<div class="text-end">' +
        '<div class="h6 mb-0 text-success">' +
        formatCurrency(s.totalCollectedAmount) +
        "</div>" +
        '<span class="badge ' +
        badgeClass +
        '">' +
        s.totalCollectedCount +
        " đơn - " +
        statusText +
        "</span>" +
        "</div>" +
        "</div>" +
        "</a>";
    }

    container.innerHTML = html;
  }

  // Cập nhật thống kê
  function updateStats(shippers, settledToday, pendingTotal, totalSettled) {
    var totalAmount = 0;
    var totalOrders = 0;

    for (var i = 0; i < shippers.length; i++) {
      totalAmount += parseFloat(shippers[i].totalCollectedAmount) || 0;
      totalOrders += parseInt(shippers[i].totalCollectedCount) || 0;
    }

    document.getElementById("stat-shipper-count").textContent = shippers.length;
    document.getElementById("stat-total-amount").textContent =
      formatCurrency(totalAmount);
    document.getElementById("stat-order-count").textContent = totalOrders;
    document.getElementById("stat-settled-today").textContent = formatCurrency(
      settledToday || 0
    );
    document.getElementById("stat-pending-total").textContent = formatCurrency(
      pendingTotal || 0
    );
    document.getElementById("stat-total-settled").textContent = formatCurrency(
      totalSettled || 0
    );
  }

  // Chọn shipper để xem chi tiết
  function selectShipper(shipperId, element, tabType) {
    // Update UI
    var items = document.querySelectorAll(".shipper-item");
    for (var i = 0; i < items.length; i++) {
      items[i].classList.remove("active");
    }
    element.classList.add("active");

    currentShipperId = shipperId;
    loadShipperDetail(shipperId, tabType || currentTab);
  }

  // Load chi tiết COD của shipper
  function loadShipperDetail(shipperId, tabType) {
    document.getElementById("detail-placeholder").classList.add("d-none");
    document.getElementById("detail-loading").classList.remove("d-none");
    document.getElementById("detail-content").classList.add("d-none");

    // Chọn API endpoint dựa vào tab type
    var apiUrl;
    if (tabType === "pending-hold") {
      apiUrl = "/api/manager/cod/shipper/" + shipperId + "/pending";
      // Ẩn nút quyết toán cho tab pending-hold (shipper chưa nộp tiền)
      document.getElementById("btn-settle-all").classList.add("d-none");
      document.getElementById("btn-settle-selected").classList.add("d-none");
      document.getElementById("detail-title").textContent =
        "COD Shipper đang giữ (chưa nộp)";
    } else {
      apiUrl = "/api/manager/cod/shipper/" + shipperId;
      // Hiển thị nút quyết toán cho tab collected
      document.getElementById("detail-title").textContent =
        "Chi Tiết COD (chờ duyệt)";
    }

    fetch(apiUrl)
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        document.getElementById("detail-loading").classList.add("d-none");

        if (data.success && data.data) {
          currentShipperData = data.data;
          renderShipperDetail(data.data);
        } else {
          alert("Không thể tải dữ liệu: " + (data.message || "Unknown error"));
        }
      })
      .catch(function (err) {
        console.error("Error loading detail:", err);
        document.getElementById("detail-loading").classList.add("d-none");
        alert("Lỗi tải dữ liệu: " + err.message);
      });
  }

  // Render chi tiết COD
  function renderShipperDetail(data) {
    document.getElementById("detail-content").classList.remove("d-none");

    // Chỉ hiển thị nút quyết toán khi tab = collected (đã nộp, chờ duyệt)
    if (currentTab === "collected") {
      document.getElementById("btn-settle-all").classList.remove("d-none");
    } else {
      document.getElementById("btn-settle-all").classList.add("d-none");
    }

    document.getElementById("detail-shipper-name").textContent =
      data.shipperName || "N/A";
    document.getElementById("detail-shipper-phone").textContent =
      data.shipperPhone || "";
    document.getElementById("detail-total-amount").textContent = formatCurrency(
      data.totalCollectedAmount
    );
    document.getElementById("detail-total-count").textContent =
      data.totalCollectedCount || 0;

    // Render table
    var tbody = document.getElementById("cod-table-body");
    var html = "";
    var transactions = data.transactions || [];

    for (var i = 0; i < transactions.length; i++) {
      var tx = transactions[i];
      html +=
        "<tr>" +
        "<td>" +
        '<input type="checkbox" class="cod-checkbox form-check-input" value="' +
        tx.codTxId +
        '" ' +
        'data-amount="' +
        tx.amount +
        '" onclick="updateSelection()">' +
        "</td>" +
        "<td>" +
        '<span class="badge bg-info">' +
        (tx.trackingCode || "N/A") +
        "</span>" +
        "</td>" +
        "<td>" +
        (tx.customerName || "N/A") +
        "</td>" +
        '<td class="text-end fw-bold text-success">' +
        formatCurrency(tx.amount) +
        "</td>" +
        "<td>" +
        formatDate(tx.collectedAt) +
        "</td>" +
        "</tr>";
    }

    tbody.innerHTML = html;

    // Reset selection
    selectedCodTxIds = [];
    document.getElementById("select-all").checked = false;
    updateSelectionDisplay();
  }

  // Reset detail panel
  function resetDetail() {
    currentShipperId = null;
    currentShipperData = null;
    selectedCodTxIds = [];
    document.getElementById("detail-placeholder").classList.remove("d-none");
    document.getElementById("detail-content").classList.add("d-none");
    document.getElementById("btn-settle-all").classList.add("d-none");
  }

  // Toggle select all checkboxes
  function toggleSelectAll() {
    var selectAll = document.getElementById("select-all").checked;
    var checkboxes = document.querySelectorAll(".cod-checkbox");
    for (var i = 0; i < checkboxes.length; i++) {
      checkboxes[i].checked = selectAll;
    }
    updateSelection();
  }

  // Update selection when checkbox changes
  function updateSelection() {
    selectedCodTxIds = [];
    var totalAmount = 0;

    var checkboxes = document.querySelectorAll(".cod-checkbox:checked");

    for (var i = 0; i < checkboxes.length; i++) {
      selectedCodTxIds.push(parseInt(checkboxes[i].value));
      totalAmount += parseFloat(checkboxes[i].dataset.amount) || 0;
    }

    updateSelectionDisplay(totalAmount);
  }

  // Update selection display
  function updateSelectionDisplay(totalAmount) {
    totalAmount = totalAmount || 0;

    document.getElementById("selected-count").textContent =
      selectedCodTxIds.length;
    document.getElementById("selected-amount").textContent =
      formatCurrency(totalAmount);

    var btn = document.getElementById("btn-settle-selected");
    btn.disabled = selectedCodTxIds.length === 0;
  }

  // Settle all COD
  function settleAllCod() {
    if (!currentShipperData) return;

    showSettleModal(
      currentShipperData.shipperName,
      currentShipperData.totalCollectedAmount,
      currentShipperData.totalCollectedCount,
      [] // Empty means settle all
    );
  }

  // Settle selected COD
  function settleSelectedCod() {
    if (selectedCodTxIds.length === 0) {
      alert("Vui lòng chọn ít nhất một đơn hàng");
      return;
    }

    var totalAmount = 0;
    var checkboxes = document.querySelectorAll(".cod-checkbox:checked");
    for (var i = 0; i < checkboxes.length; i++) {
      totalAmount += parseFloat(checkboxes[i].dataset.amount) || 0;
    }

    console.log(
      "Calling showSettleModal with:",
      currentShipperData.shipperName,
      totalAmount,
      selectedCodTxIds.length,
      selectedCodTxIds
    );

    showSettleModal(
      currentShipperData.shipperName,
      totalAmount,
      selectedCodTxIds.length,
      selectedCodTxIds
    );
  }

  // Show settle confirmation modal
  function showSettleModal(shipperName, amount, count, codTxIds) {
    document.getElementById("modal-shipper-name").textContent = shipperName;
    document.getElementById("modal-amount").textContent =
      formatCurrency(amount);
    document.getElementById("modal-count").textContent = count;
    document.getElementById("settle-note").value = "";

    // Store data for confirmation
    window.pendingSettlement = {
      shipperId: currentShipperId,
      amount: amount,
      codTxIds: codTxIds,
    };

    // Dùng jQuery modal (được load từ layout)
    $("#settleModal").modal("show");
  }

  // Confirm settlement
  function confirmSettle() {
    if (!window.pendingSettlement) return;

    var btn = document.getElementById("btn-confirm-settle");
    btn.disabled = true;
    btn.innerHTML =
      '<span class="spinner-border spinner-border-sm me-1"></span> Đang xử lý...';

    var requestBody = {
      shipperId: window.pendingSettlement.shipperId,
      amount: window.pendingSettlement.amount,
      codTxIds:
        window.pendingSettlement.codTxIds.length > 0
          ? window.pendingSettlement.codTxIds
          : null,
      note: document.getElementById("settle-note").value,
    };

    fetch("/api/manager/cod/settle", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestBody),
    })
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        // Hide modal
        $("#settleModal").modal("hide");
        showResultModal(data);
      })
      .catch(function (err) {
        console.error("Error settling COD:", err);
        showResultModal({
          success: false,
          message: "Lỗi hệ thống: " + err.message,
        });
      })
      .finally(function () {
        btn.disabled = false;
        btn.innerHTML = '<i class="fas fa-check me-1"></i> Xác Nhận Quyết Toán';
      });
  }

  // Show result modal
  function showResultModal(result) {
    var header = document.getElementById("result-header");
    var icon = document.getElementById("result-icon");
    var title = document.getElementById("result-title");
    var message = document.getElementById("result-message");
    var details = document.getElementById("result-details");

    if (result.success) {
      header.className = "modal-header bg-success text-white";
      icon.className = "fas fa-check-circle fa-3x text-success mb-3";
      title.textContent = "Thành Công!";
      message.textContent = result.message || "Quyết toán COD thành công";

      if (result.data) {
        details.innerHTML =
          '<div class="row text-center">' +
          '<div class="col-4">' +
          '<div class="h5 text-success">' +
          formatCurrency(result.data.settledAmount) +
          "</div>" +
          '<small class="text-muted">Số tiền</small>' +
          "</div>" +
          '<div class="col-4">' +
          '<div class="h5 text-primary">' +
          result.data.settledCount +
          "</div>" +
          '<small class="text-muted">Số đơn</small>' +
          "</div>" +
          '<div class="col-4">' +
          '<div class="h6">' +
          (result.data.settledBy || "-") +
          "</div>" +
          '<small class="text-muted">Người duyệt</small>' +
          "</div>" +
          "</div>";
      }
    } else {
      header.className = "modal-header bg-danger text-white";
      icon.className = "fas fa-times-circle fa-3x text-danger mb-3";
      title.textContent = "Thất Bại";
      message.textContent = result.message || "Có lỗi xảy ra";
      details.innerHTML = "";
    }

    $("#resultModal").modal("show");
  }

  // Format currency
  function formatCurrency(value) {
    if (!value && value !== 0) return "0đ";
    return new Intl.NumberFormat("vi-VN").format(value) + "đ";
  }

  // Format date
  function formatDate(dateStr) {
    if (!dateStr) return "N/A";
    var date = new Date(dateStr);
    return date.toLocaleDateString("vi-VN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  }
</script>
