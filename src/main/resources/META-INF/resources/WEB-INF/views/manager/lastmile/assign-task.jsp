<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phân công Shipper - Manager Portal</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
      rel="stylesheet" />
    <style>
      :root {
        --primary-color: #4f46e5;
        --primary-light: #6366f1;
        --success-color: #10b981;
        --warning-color: #f59e0b;
        --danger-color: #ef4444;
        --bg-dark: #1e293b;
        --bg-card: #ffffff;
        --text-primary: #1e293b;
        --text-muted: #64748b;
        --border-color: #e2e8f0;
      }

      body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
      }

      .main-container {
        padding: 20px;
      }

      .page-header {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 16px;
        padding: 24px;
        margin-bottom: 24px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      }

      .page-title {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--text-primary);
        margin: 0;
      }

      .tab-container {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      }

      .nav-tabs {
        border-bottom: 2px solid var(--border-color);
        background: #f8fafc;
        padding: 0 16px;
      }

      .nav-tabs .nav-link {
        border: none;
        padding: 16px 24px;
        font-weight: 600;
        color: var(--text-muted);
        border-bottom: 3px solid transparent;
        margin-bottom: -2px;
        transition: all 0.3s ease;
      }

      .nav-tabs .nav-link:hover {
        color: var(--primary-color);
        background: rgba(79, 70, 229, 0.05);
      }

      .nav-tabs .nav-link.active {
        color: var(--primary-color);
        background: transparent;
        border-bottom-color: var(--primary-color);
      }

      .tab-content {
        padding: 24px;
      }

      .order-card {
        background: #fff;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 16px;
        transition: all 0.3s ease;
      }

      .order-card:hover {
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        transform: translateY(-2px);
      }

      .order-id {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--primary-color);
      }

      .order-badge {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
      }

      .badge-pickup {
        background: #fef3c7;
        color: #d97706;
      }

      .badge-delivery {
        background: #dbeafe;
        color: #2563eb;
      }

      .order-info {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-top: 16px;
      }

      .info-group {
        background: #f8fafc;
        padding: 12px;
        border-radius: 8px;
      }

      .info-label {
        font-size: 0.75rem;
        color: var(--text-muted);
        text-transform: uppercase;
        margin-bottom: 4px;
      }

      .info-value {
        font-weight: 600;
        color: var(--text-primary);
      }

      .cod-amount {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--success-color);
      }

      .shipper-select {
        margin-top: 16px;
        padding-top: 16px;
        border-top: 1px dashed var(--border-color);
      }

      .shipper-dropdown {
        display: flex;
        gap: 12px;
        align-items: center;
      }

      .shipper-dropdown select {
        flex: 1;
        padding: 10px 16px;
        border: 2px solid var(--border-color);
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.3s ease;
      }

      .shipper-dropdown select:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        outline: none;
      }

      .btn-assign {
        background: linear-gradient(
          135deg,
          var(--primary-color),
          var(--primary-light)
        );
        color: white;
        border: none;
        padding: 10px 24px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
      }

      .btn-assign:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(79, 70, 229, 0.4);
        color: white;
      }

      .btn-assign:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
      }

      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: var(--text-muted);
      }

      .empty-state i {
        font-size: 4rem;
        margin-bottom: 16px;
        opacity: 0.5;
      }

      .stats-row {
        display: flex;
        gap: 16px;
        margin-bottom: 24px;
      }

      .stat-card {
        flex: 1;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      }

      .stat-number {
        font-size: 2rem;
        font-weight: 700;
        color: var(--primary-color);
      }

      .stat-label {
        color: var(--text-muted);
        font-size: 0.875rem;
      }

      .loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.8);
        display: none;
        justify-content: center;
        align-items: center;
        z-index: 9999;
      }

      .loading-overlay.show {
        display: flex;
      }

      .toast-container {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
      }

      @media (max-width: 768px) {
        .order-info {
          grid-template-columns: 1fr;
        }

        .stats-row {
          flex-wrap: wrap;
        }

        .stat-card {
          min-width: 45%;
        }
      }
    </style>
  </head>
  <body>
    <div class="loading-overlay" id="loadingOverlay">
      <div
        class="spinner-border text-primary"
        style="width: 3rem; height: 3rem"></div>
    </div>

    <div class="toast-container" id="toastContainer"></div>

    <div class="main-container">
      <!-- Header -->
      <div
        class="page-header d-flex justify-content-between align-items-center">
        <div>
          <h1 class="page-title">
            <i class="bi bi-people-fill me-2"></i>Phân công Shipper
          </h1>
          <p class="text-muted mb-0">
            Phân công đơn hàng cho shipper đi lấy/giao
          </p>
        </div>
        <button class="btn btn-outline-primary" onclick="refreshData()">
          <i class="bi bi-arrow-clockwise me-2"></i>Làm mới
        </button>
      </div>

      <!-- Stats -->
      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-number" id="pickupCount">0</div>
          <div class="stat-label">Đơn cần lấy hàng</div>
        </div>
        <div class="stat-card">
          <div class="stat-number" id="deliveryCount">0</div>
          <div class="stat-label">Đơn cần giao hàng</div>
        </div>
        <div class="stat-card">
          <div class="stat-number" id="shipperCount">0</div>
          <div class="stat-label">Shipper khả dụng</div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="tab-container">
        <ul class="nav nav-tabs" role="tablist">
          <li class="nav-item">
            <button
              class="nav-link active"
              data-bs-toggle="tab"
              data-bs-target="#pickupTab">
              <i class="bi bi-box-arrow-in-down me-2"></i>Cần lấy hàng
              <span class="badge bg-warning ms-2" id="pickupBadge">0</span>
            </button>
          </li>
          <li class="nav-item">
            <button
              class="nav-link"
              data-bs-toggle="tab"
              data-bs-target="#deliveryTab">
              <i class="bi bi-truck me-2"></i>Cần giao hàng
              <span class="badge bg-primary ms-2" id="deliveryBadge">0</span>
            </button>
          </li>
        </ul>

        <div class="tab-content">
          <!-- Pickup Tab -->
          <div class="tab-pane fade show active" id="pickupTab">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <label class="me-2">Hiển thị:</label>
                <select
                  id="pickupPageSize"
                  class="form-select form-select-sm d-inline-block"
                  style="width: auto"
                  onchange="changePickupPageSize()">
                  <option value="5">5</option>
                  <option value="10" selected>10</option>
                  <option value="20">20</option>
                  <option value="50">50</option>
                </select>
                <span class="ms-2">đơn/trang</span>
              </div>
              <div class="text-muted" id="pickupPageInfo"></div>
            </div>
            <div id="pickupOrders"></div>
            <nav id="pickupPagination" class="mt-3"></nav>
          </div>

          <!-- Delivery Tab -->
          <div class="tab-pane fade" id="deliveryTab">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <label class="me-2">Hiển thị:</label>
                <select
                  id="deliveryPageSize"
                  class="form-select form-select-sm d-inline-block"
                  style="width: auto"
                  onchange="changeDeliveryPageSize()">
                  <option value="5">5</option>
                  <option value="10" selected>10</option>
                  <option value="20">20</option>
                  <option value="50">50</option>
                </select>
                <span class="ms-2">đơn/trang</span>
              </div>
              <div class="text-muted" id="deliveryPageInfo"></div>
            </div>
            <div id="deliveryOrders"></div>
            <nav id="deliveryPagination" class="mt-3"></nav>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      let shippers = [];

      // Pagination state
      let pickupState = { page: 0, size: 10, totalPages: 0, totalElements: 0 };
      let deliveryState = {
        page: 0,
        size: 10,
        totalPages: 0,
        totalElements: 0,
      };

      // Load data on page load
      document.addEventListener("DOMContentLoaded", function () {
        loadShippers();
        loadPickupOrders();
        loadDeliveryOrders();
      });

      // Load danh sách shipper
      async function loadShippers() {
        try {
          const response = await fetch(
            "/api/manager/shippers?status=active&size=50"
          );
          const data = await response.json();
          if (data.success) {
            shippers = data.data || [];
            document.getElementById("shipperCount").textContent =
              shippers.length;
          }
        } catch (error) {
          console.error("Error loading shippers:", error);
        }
      }

      // Load đơn cần pickup với phân trang
      async function loadPickupOrders(page) {
        if (page === undefined) page = pickupState.page;
        showLoading(true);
        var size = pickupState.size;
        try {
          var response = await fetch(
            "/api/manager/tasks/pending-pickup?page=" + page + "&size=" + size
          );
          var data = await response.json();

          if (data.success) {
            pickupState.page = data.page;
            pickupState.totalPages = data.totalPages;
            pickupState.totalElements = data.totalElements;

            renderOrders(data.data, "pickupOrders", "pickup");
            document.getElementById("pickupCount").textContent =
              data.totalElements;
            document.getElementById("pickupBadge").textContent =
              data.totalElements;
            updatePageInfo("pickup");
            renderPagination("pickup");
          }
        } catch (error) {
          showToast("Lỗi tải dữ liệu", "danger");
        }
        showLoading(false);
      }

      // Load đơn cần delivery với phân trang
      async function loadDeliveryOrders(page) {
        if (page === undefined) page = deliveryState.page;
        var size = deliveryState.size;
        try {
          var response = await fetch(
            "/api/manager/tasks/pending-delivery?page=" + page + "&size=" + size
          );
          var data = await response.json();

          if (data.success) {
            deliveryState.page = data.page;
            deliveryState.totalPages = data.totalPages;
            deliveryState.totalElements = data.totalElements;

            renderOrders(data.data, "deliveryOrders", "delivery");
            document.getElementById("deliveryCount").textContent =
              data.totalElements;
            document.getElementById("deliveryBadge").textContent =
              data.totalElements;
            updatePageInfo("delivery");
            renderPagination("delivery");
          }
        } catch (error) {
          showToast("Lỗi tải dữ liệu", "danger");
        }
      }

      // Change page size
      function changePickupPageSize() {
        pickupState.size = parseInt(
          document.getElementById("pickupPageSize").value
        );
        pickupState.page = 0;
        loadPickupOrders();
      }

      function changeDeliveryPageSize() {
        deliveryState.size = parseInt(
          document.getElementById("deliveryPageSize").value
        );
        deliveryState.page = 0;
        loadDeliveryOrders();
      }

      // Go to specific page
      function goToPickupPage(page) {
        if (page >= 0 && page < pickupState.totalPages) {
          loadPickupOrders(page);
        }
      }

      function goToDeliveryPage(page) {
        if (page >= 0 && page < deliveryState.totalPages) {
          loadDeliveryOrders(page);
        }
      }

      // Update page info text
      function updatePageInfo(type) {
        var state = type === "pickup" ? pickupState : deliveryState;
        var start = state.page * state.size + 1;
        var end = Math.min((state.page + 1) * state.size, state.totalElements);
        var info =
          state.totalElements > 0
            ? "Hiển thị " +
              start +
              "-" +
              end +
              " / " +
              state.totalElements +
              " đơn"
            : "Không có đơn hàng";
        document.getElementById(type + "PageInfo").textContent = info;
      }

      // Render pagination controls
      function renderPagination(type) {
        var state = type === "pickup" ? pickupState : deliveryState;
        var goToFn = type === "pickup" ? "goToPickupPage" : "goToDeliveryPage";
        var container = document.getElementById(type + "Pagination");

        if (state.totalPages <= 1) {
          container.innerHTML = "";
          return;
        }

        var html = '<ul class="pagination justify-content-center">';

        // Previous button
        var prevDisabled = state.page === 0 ? "disabled" : "";
        html += '<li class="page-item ' + prevDisabled + '">';
        html +=
          '<a class="page-link" href="#" onclick="' +
          goToFn +
          "(" +
          (state.page - 1) +
          '); return false;">«</a>';
        html += "</li>";

        // Page numbers (show max 5 pages)
        var startPage = Math.max(0, state.page - 2);
        var endPage = Math.min(state.totalPages - 1, startPage + 4);

        for (var i = startPage; i <= endPage; i++) {
          var activeClass = i === state.page ? "active" : "";
          html += '<li class="page-item ' + activeClass + '">';
          html +=
            '<a class="page-link" href="#" onclick="' +
            goToFn +
            "(" +
            i +
            '); return false;">' +
            (i + 1) +
            "</a>";
          html += "</li>";
        }

        // Next button
        var nextDisabled = state.page >= state.totalPages - 1 ? "disabled" : "";
        html += '<li class="page-item ' + nextDisabled + '">';
        html +=
          '<a class="page-link" href="#" onclick="' +
          goToFn +
          "(" +
          (state.page + 1) +
          '); return false;">»</a>';
        html += "</li>";

        html += "</ul>";
        container.innerHTML = html;
      }

      // Render danh sách đơn hàng
      function renderOrders(orders, containerId, taskType) {
        const container = document.getElementById(containerId);

        if (!orders || orders.length === 0) {
          var emptyMsg = taskType === "pickup" ? "cần lấy" : "cần giao";
          container.innerHTML =
            '<div class="empty-state">' +
            '<i class="bi bi-inbox"></i>' +
            "<h5>Không có đơn hàng</h5>" +
            "<p>Chưa có đơn " +
            emptyMsg +
            " trong khu vực</p>" +
            "</div>";
          return;
        }

        var html = "";
        orders.forEach(function (order) {
          var badgeClass =
            taskType === "pickup" ? "badge-pickup" : "badge-delivery";
          var badgeText = taskType === "pickup" ? "Lấy hàng" : "Giao hàng";
          var addressLabel = taskType === "pickup" ? "lấy" : "giao";
          var address =
            taskType === "pickup"
              ? order.pickupAddress || order.senderAddress || "Chưa có địa chỉ"
              : order.deliveryAddress ||
                order.receiverAddress ||
                "Chưa có địa chỉ";
          var district =
            taskType === "pickup"
              ? order.pickupDistrict || ""
              : order.deliveryDistrict || "";
          var contactName =
            taskType === "pickup"
              ? order.senderName || "Chưa có tên"
              : order.receiverName || "Chưa có tên";
          var contactPhone =
            taskType === "pickup"
              ? order.senderPhone || "Chưa có SĐT"
              : order.receiverPhone || "Chưa có SĐT";

          // Sử dụng receiverPayAmount (tổng tiền người nhận phải trả)
          var totalAmount = order.receiverPayAmount || 0;
          var codDisplay =
            totalAmount > 0
              ? formatCurrency(totalAmount)
              : '<span class="text-muted">Không thu tiền</span>';

          var shipperOptions = '<option value="">-- Chọn Shipper --</option>';
          shippers.forEach(function (s) {
            shipperOptions +=
              '<option value="' +
              s.shipperId +
              '">' +
              s.fullName +
              " - " +
              s.phone +
              "</option>";
          });

          html +=
            '<div class="order-card" id="order-' +
            order.requestId +
            '">' +
            '<div class="d-flex justify-content-between align-items-start">' +
            "<div>" +
            '<span class="order-id">#' +
            order.requestId +
            "</span>" +
            '<span class="order-badge ' +
            badgeClass +
            ' ms-2">' +
            badgeText +
            "</span>" +
            "</div>" +
            '<div class="cod-amount">' +
            codDisplay +
            "</div>" +
            "</div>" +
            '<div class="order-info">' +
            '<div class="info-group">' +
            '<div class="info-label"><i class="bi bi-geo-alt me-1"></i>Địa chỉ ' +
            addressLabel +
            "</div>" +
            '<div class="info-value">' +
            address +
            "</div>" +
            '<div class="text-muted small">' +
            district +
            "</div>" +
            "</div>" +
            '<div class="info-group">' +
            '<div class="info-label"><i class="bi bi-person me-1"></i>Liên hệ</div>' +
            '<div class="info-value">' +
            contactName +
            "</div>" +
            '<div class="text-muted small"><i class="bi bi-telephone me-1"></i>' +
            contactPhone +
            "</div>" +
            "</div>" +
            "</div>" +
            '<div class="shipper-select">' +
            '<div class="shipper-dropdown">' +
            '<select id="shipper-' +
            order.requestId +
            '" class="form-select">' +
            shipperOptions +
            "</select>" +
            '<button class="btn btn-assign" onclick="assignShipper(' +
            order.requestId +
            ", '" +
            taskType +
            "')\">" +
            '<i class="bi bi-check2-circle me-1"></i>Phân công' +
            "</button>" +
            "</div>" +
            "</div>" +
            "</div>";
        });

        container.innerHTML = html;
      }

      // Phân công shipper
      async function assignShipper(requestId, taskType) {
        const shipperId = document.getElementById("shipper-" + requestId).value;

        if (!shipperId) {
          showToast("Vui lòng chọn shipper", "warning");
          return;
        }

        showLoading(true);
        try {
          const response = await fetch("/api/manager/tasks/assign", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              requestId: requestId,
              shipperId: parseInt(shipperId),
              taskType: taskType,
            }),
          });

          const data = await response.json();

          if (data.success) {
            showToast(data.message, "success");
            // Remove card from UI
            var card = document.getElementById("order-" + requestId);
            if (card) card.remove();
            // Update counts
            if (taskType === "pickup") {
              loadPickupOrders();
            } else {
              loadDeliveryOrders();
            }
          } else {
            showToast(data.message, "danger");
          }
        } catch (error) {
          showToast("Có lỗi xảy ra", "danger");
        }
        showLoading(false);
      }

      // Refresh all data
      function refreshData() {
        loadShippers();
        loadPickupOrders();
        loadDeliveryOrders();
        showToast("Đã làm mới dữ liệu", "success");
      }

      // Format currency
      function formatCurrency(amount) {
        return new Intl.NumberFormat("vi-VN", {
          style: "currency",
          currency: "VND",
        }).format(amount);
      }

      // Show/hide loading
      function showLoading(show) {
        document
          .getElementById("loadingOverlay")
          .classList.toggle("show", show);
      }

      // Show toast notification
      function showToast(message, type) {
        type = type || "info";
        const container = document.getElementById("toastContainer");
        const id = "toast-" + Date.now();

        var bgClass = "bg-info";
        if (type === "success") bgClass = "bg-success";
        else if (type === "danger") bgClass = "bg-danger";
        else if (type === "warning") bgClass = "bg-warning";

        container.innerHTML +=
          '<div id="' +
          id +
          '" class="toast align-items-center text-white ' +
          bgClass +
          ' border-0" role="alert">' +
          '<div class="d-flex">' +
          '<div class="toast-body">' +
          message +
          "</div>" +
          '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>' +
          "</div>" +
          "</div>";

        const toastEl = document.getElementById(id);
        const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
        toast.show();

        toastEl.addEventListener("hidden.bs.toast", function () {
          toastEl.remove();
        });
      }
    </script>
  </body>
</html>
