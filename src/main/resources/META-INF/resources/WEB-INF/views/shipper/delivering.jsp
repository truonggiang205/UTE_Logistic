<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Flash Messages -->
<c:if test="${not empty success}">
  <div
    class="alert alert-success alert-dismissible fade show mx-3 mt-3"
    role="alert">
    <i class="fas fa-check-circle"></i> ${success}
    <button type="button" class="close" data-dismiss="alert">
      <span>&times;</span>
    </button>
  </div>
</c:if>
<c:if test="${not empty error}">
  <div
    class="alert alert-danger alert-dismissible fade show mx-3 mt-3"
    role="alert">
    <i class="fas fa-exclamation-circle"></i> ${error}
    <button type="button" class="close" data-dismiss="alert">
      <span>&times;</span>
    </button>
  </div>
</c:if>

<div class="container-fluid">
  <!-- Page Heading -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-shipping-fast text-warning"></i> Đang giao hàng
    </h1>
    <button class="btn btn-sm btn-outline-primary" onclick="location.reload()">
      <i class="fas fa-sync-alt"></i> Làm mới
    </button>
  </div>

  <!-- Statistics Cards -->
  <div class="row mb-4">
    <div class="col-md-4 mb-3">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                Đang lấy hàng
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                ${pickupCount != null ? pickupCount : 0}
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-hand-holding-box fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-info text-uppercase mb-1">
                Đang giao hàng
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                ${deliveryCount != null ? deliveryCount : 0}
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-truck fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-success text-uppercase mb-1">
                COD cần thu
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${totalCodInProgress != null ? totalCodInProgress : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-money-bill-wave fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Empty State -->
  <c:if test="${empty inProgressTasks}">
    <div class="card shadow mb-4">
      <div class="card-body text-center py-5">
        <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
        <h4 class="text-gray-800">Không có đơn nào đang xử lý</h4>
        <p class="text-muted mb-4">
          Tuyệt vời! Bạn đã hoàn thành tất cả đơn hàng.
        </p>
        <a
          href="${pageContext.request.contextPath}/shipper/orders"
          class="btn btn-primary">
          <i class="fas fa-list"></i> Xem danh sách đơn hàng
        </a>
      </div>
    </div>
  </c:if>

  <!-- Đang lấy hàng (Pickup In Progress) -->
  <c:if test="${not empty pickupTasks}">
    <div class="card shadow mb-4">
      <div class="card-header py-3 bg-warning text-white">
        <h6 class="m-0 font-weight-bold">
          <i class="fas fa-hand-holding-box"></i> Đang lấy hàng
          <span class="badge badge-light ml-2">${pickupCount}</span>
        </h6>
      </div>
      <div class="card-body p-0">
        <c:forEach var="task" items="${pickupTasks}" varStatus="loop">
          <div class="border-bottom p-3 pickup-item" data-index="${loop.index}">
            <div class="d-flex justify-content-between align-items-start mb-2">
              <div>
                <span class="badge badge-warning mr-2">🔄 Đang lấy</span>
                <a
                  href="${pageContext.request.contextPath}/shipper/orders/${task.taskId}"
                  class="text-primary font-weight-bold">
                  ${task.trackingNumber}
                </a>
              </div>
            </div>
            <div class="row">
              <div class="col-md-6">
                <p class="mb-1">
                  <i class="fas fa-user text-muted"></i>
                  <strong>${task.contactName}</strong>
                </p>
                <p class="mb-1">
                  <i class="fas fa-phone text-muted"></i>
                  <a href="tel:${task.contactPhone}">${task.contactPhone}</a>
                </p>
                <p class="mb-0 text-muted small">
                  <i class="fas fa-map-marker-alt"></i> ${task.contactAddress}
                </p>
              </div>
              <div class="col-md-6">
                <div class="d-flex flex-wrap justify-content-end mt-2 mt-md-0">
                  <a
                    href="tel:${task.contactPhone}"
                    class="btn btn-sm btn-outline-primary mr-2 mb-2">
                    <i class="fas fa-phone"></i> Gọi
                  </a>
                  <a
                    href="https://www.google.com/maps/search/?api=1&query=${task.contactAddress}"
                    target="_blank"
                    class="btn btn-sm btn-outline-info mr-2 mb-2">
                    <i class="fas fa-map-marked-alt"></i> Bản đồ
                  </a>
                  <button
                    type="button"
                    class="btn btn-sm btn-success mr-2 mb-2 btn-complete-pickup"
                    data-task-id="${task.taskId}"
                    data-tracking="${task.trackingNumber}">
                    <i class="fas fa-check"></i> Hoàn thành
                  </button>
                  <button
                    type="button"
                    class="btn btn-sm btn-danger mb-2 btn-fail-pickup"
                    data-task-id="${task.taskId}"
                    data-tracking="${task.trackingNumber}">
                    <i class="fas fa-times"></i> Thất bại
                  </button>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
      <!-- Pagination cho Pickup -->
      <c:if test="${pickupCount > 5}">
        <div class="card-footer bg-light">
          <nav>
            <ul
              class="pagination pagination-sm justify-content-center mb-0"
              id="pickupPagination"></ul>
          </nav>
        </div>
      </c:if>
    </div>
  </c:if>

  <!-- Đang giao hàng (Delivery In Progress) -->
  <c:if test="${not empty deliveryTasks}">
    <div class="card shadow mb-4">
      <div class="card-header py-3 bg-info text-white">
        <h6 class="m-0 font-weight-bold">
          <i class="fas fa-truck"></i> Đang giao hàng
          <span class="badge badge-light ml-2">${deliveryCount}</span>
        </h6>
      </div>
      <div class="card-body p-0" id="deliveryList">
        <c:forEach var="task" items="${deliveryTasks}" varStatus="loop">
          <div
            class="border-bottom p-3 delivery-item"
            data-index="${loop.index}">
            <div class="d-flex justify-content-between align-items-start mb-2">
              <div>
                <span class="badge badge-info mr-2">🚚 Đang giao</span>
                <a
                  href="${pageContext.request.contextPath}/shipper/orders/${task.taskId}"
                  class="text-primary font-weight-bold">
                  ${task.trackingNumber}
                </a>
              </div>
              <c:if test="${task.codAmount > 0}">
                <span class="badge badge-danger px-2 py-1">
                  <i class="fas fa-money-bill-wave"></i> COD:
                  <fmt:formatNumber
                    value="${task.codAmount}"
                    type="currency"
                    currencySymbol=""
                    maxFractionDigits="0" />đ
                </span>
              </c:if>
            </div>
            <div class="row">
              <div class="col-md-6">
                <p class="mb-1">
                  <i class="fas fa-user text-muted"></i>
                  <strong>${task.contactName}</strong>
                </p>
                <p class="mb-1">
                  <i class="fas fa-phone text-muted"></i>
                  <a href="tel:${task.contactPhone}">${task.contactPhone}</a>
                </p>
                <p class="mb-0 text-muted small">
                  <i class="fas fa-map-marker-alt"></i> ${task.contactAddress}
                </p>
              </div>
              <div class="col-md-6">
                <div class="d-flex flex-wrap justify-content-end mt-2 mt-md-0">
                  <a
                    href="tel:${task.contactPhone}"
                    class="btn btn-sm btn-outline-primary mr-2 mb-2">
                    <i class="fas fa-phone"></i> Gọi
                  </a>
                  <a
                    href="https://www.google.com/maps/search/?api=1&query=${task.contactAddress}"
                    target="_blank"
                    class="btn btn-sm btn-outline-info mr-2 mb-2">
                    <i class="fas fa-map-marked-alt"></i> Bản đồ
                  </a>
                  <button
                    type="button"
                    class="btn btn-sm btn-success mr-2 mb-2 btn-complete-delivery"
                    data-task-id="${task.taskId}"
                    data-tracking="${task.trackingNumber}"
                    data-cod="${task.codAmount}">
                    <i class="fas fa-check"></i> Hoàn thành
                  </button>
                  <button
                    type="button"
                    class="btn btn-sm btn-danger mb-2 btn-fail-delivery"
                    data-task-id="${task.taskId}"
                    data-tracking="${task.trackingNumber}">
                    <i class="fas fa-times"></i> Thất bại
                  </button>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
      <!-- Pagination cho Delivery -->
      <c:if test="${deliveryCount > 5}">
        <div class="card-footer bg-light">
          <nav>
            <ul
              class="pagination pagination-sm justify-content-center mb-0"
              id="deliveryPagination"></ul>
          </nav>
        </div>
      </c:if>
    </div>
  </c:if>
</div>

<!-- Modal Hoàn thành -->
<div class="modal fade" id="completeModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="completeForm" method="POST" action="">
        <input type="hidden" name="status" value="completed" />
        <input type="hidden" name="from" value="delivering" />
        <div class="modal-header bg-success text-white">
          <h5 class="modal-title">
            <i class="fas fa-check-circle"></i> Xác nhận hoàn thành
          </h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span>&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <p>
            Xác nhận hoàn thành đơn
            <strong id="completeTracking" class="text-primary"></strong>?
          </p>
          <div
            id="codWarning"
            class="alert alert-warning"
            style="display: none">
            <i class="fas fa-money-bill-wave"></i>
            Đã thu COD: <strong id="codAmount"></strong>
          </div>
          <div class="form-group">
            <label for="completeNote">Ghi chú (không bắt buộc):</label>
            <textarea
              class="form-control"
              name="note"
              id="completeNote"
              rows="2"
              placeholder="VD: Khách đã ký nhận"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">
            Hủy
          </button>
          <button type="submit" class="btn btn-success">
            <i class="fas fa-check"></i> Xác nhận
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Thất bại -->
<div class="modal fade" id="failModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="failForm" method="POST" action="">
        <input type="hidden" name="status" value="failed" />
        <input type="hidden" name="from" value="delivering" />
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">
            <i class="fas fa-times-circle"></i> Báo thất bại
          </h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span>&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <p>
            Báo thất bại đơn
            <strong id="failTracking" class="text-primary"></strong>?
          </p>
          <div class="form-group">
            <label for="failNote" class="font-weight-bold"
              >Lý do thất bại <span class="text-danger">*</span>:</label
            >
            <textarea
              class="form-control"
              name="note"
              id="failNote"
              rows="3"
              required
              placeholder="VD: Khách không nghe máy, Sai địa chỉ, Khách hẹn lại..."></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">
            Hủy
          </button>
          <button type="submit" class="btn btn-danger">
            <i class="fas fa-times"></i> Xác nhận thất bại
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";

  // Hoàn thành Pickup
  document.querySelectorAll(".btn-complete-pickup").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var taskId = this.getAttribute("data-task-id");
      var tracking = this.getAttribute("data-tracking");
      document.getElementById("completeTracking").textContent = tracking;
      document.getElementById("completeNote").value = "";
      document.getElementById("codWarning").style.display = "none";
      document.getElementById("completeForm").action =
        contextPath + "/shipper/pickup/" + taskId + "/update";
      $("#completeModal").modal("show");
    });
  });

  // Hoàn thành Delivery
  document.querySelectorAll(".btn-complete-delivery").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var taskId = this.getAttribute("data-task-id");
      var tracking = this.getAttribute("data-tracking");
      var cod = parseFloat(this.getAttribute("data-cod")) || 0;

      document.getElementById("completeTracking").textContent = tracking;
      document.getElementById("completeNote").value = "";
      document.getElementById("completeForm").action =
        contextPath + "/shipper/delivery/" + taskId + "/update";

      if (cod > 0) {
        document.getElementById("codAmount").textContent =
          cod.toLocaleString("vi-VN") + "đ";
        document.getElementById("codWarning").style.display = "block";
      } else {
        document.getElementById("codWarning").style.display = "none";
      }

      $("#completeModal").modal("show");
    });
  });

  // Thất bại Pickup
  document.querySelectorAll(".btn-fail-pickup").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var taskId = this.getAttribute("data-task-id");
      var tracking = this.getAttribute("data-tracking");
      document.getElementById("failTracking").textContent = tracking;
      document.getElementById("failNote").value = "";
      document.getElementById("failForm").action =
        contextPath + "/shipper/pickup/" + taskId + "/update";
      $("#failModal").modal("show");
    });
  });

  // Thất bại Delivery
  document.querySelectorAll(".btn-fail-delivery").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var taskId = this.getAttribute("data-task-id");
      var tracking = this.getAttribute("data-tracking");
      document.getElementById("failTracking").textContent = tracking;
      document.getElementById("failNote").value = "";
      document.getElementById("failForm").action =
        contextPath + "/shipper/delivery/" + taskId + "/update";
      $("#failModal").modal("show");
    });
  });

  // Validate fail form
  document.getElementById("failForm").addEventListener("submit", function (e) {
    var note = document.getElementById("failNote").value.trim();
    if (!note) {
      e.preventDefault();
      alert("Vui lòng nhập lý do thất bại!");
      document.getElementById("failNote").focus();
    }
  });

  // ==================== PAGINATION ====================
  var itemsPerPage = 5;

  // Pagination cho Pickup
  function initPickupPagination() {
    var items = document.querySelectorAll(".pickup-item");
    var totalItems = items.length;
    var totalPages = Math.ceil(totalItems / itemsPerPage);

    if (totalPages <= 1) return;

    var paginationEl = document.getElementById("pickupPagination");
    if (!paginationEl) return;

    // Tạo pagination UI
    function renderPagination(currentPage) {
      paginationEl.innerHTML = "";

      // Previous button
      var prevLi = document.createElement("li");
      prevLi.className = "page-item" + (currentPage === 1 ? " disabled" : "");
      prevLi.innerHTML = '<a class="page-link" href="#">«</a>';
      prevLi.onclick = function (e) {
        e.preventDefault();
        if (currentPage > 1) showPickupPage(currentPage - 1);
      };
      paginationEl.appendChild(prevLi);

      // Page numbers
      for (var i = 1; i <= totalPages; i++) {
        var li = document.createElement("li");
        li.className = "page-item" + (i === currentPage ? " active" : "");
        li.innerHTML = '<a class="page-link" href="#">' + i + "</a>";
        li.setAttribute("data-page", i);
        li.onclick = function (e) {
          e.preventDefault();
          showPickupPage(parseInt(this.getAttribute("data-page")));
        };
        paginationEl.appendChild(li);
      }

      // Next button
      var nextLi = document.createElement("li");
      nextLi.className =
        "page-item" + (currentPage === totalPages ? " disabled" : "");
      nextLi.innerHTML = '<a class="page-link" href="#">»</a>';
      nextLi.onclick = function (e) {
        e.preventDefault();
        if (currentPage < totalPages) showPickupPage(currentPage + 1);
      };
      paginationEl.appendChild(nextLi);
    }

    // Show page
    window.showPickupPage = function (page) {
      var start = (page - 1) * itemsPerPage;
      var end = start + itemsPerPage;

      items.forEach(function (item, index) {
        item.style.display = index >= start && index < end ? "block" : "none";
      });

      renderPagination(page);
    };

    showPickupPage(1);
  }

  // Pagination cho Delivery
  function initDeliveryPagination() {
    var items = document.querySelectorAll(".delivery-item");
    var totalItems = items.length;
    var totalPages = Math.ceil(totalItems / itemsPerPage);

    if (totalPages <= 1) return;

    var paginationEl = document.getElementById("deliveryPagination");
    if (!paginationEl) return;

    // Tạo pagination UI
    function renderPagination(currentPage) {
      paginationEl.innerHTML = "";

      // Previous button
      var prevLi = document.createElement("li");
      prevLi.className = "page-item" + (currentPage === 1 ? " disabled" : "");
      prevLi.innerHTML = '<a class="page-link" href="#">«</a>';
      prevLi.onclick = function (e) {
        e.preventDefault();
        if (currentPage > 1) showDeliveryPage(currentPage - 1);
      };
      paginationEl.appendChild(prevLi);

      // Page numbers
      for (var i = 1; i <= totalPages; i++) {
        var li = document.createElement("li");
        li.className = "page-item" + (i === currentPage ? " active" : "");
        li.innerHTML = '<a class="page-link" href="#">' + i + "</a>";
        li.setAttribute("data-page", i);
        li.onclick = function (e) {
          e.preventDefault();
          showDeliveryPage(parseInt(this.getAttribute("data-page")));
        };
        paginationEl.appendChild(li);
      }

      // Next button
      var nextLi = document.createElement("li");
      nextLi.className =
        "page-item" + (currentPage === totalPages ? " disabled" : "");
      nextLi.innerHTML = '<a class="page-link" href="#">»</a>';
      nextLi.onclick = function (e) {
        e.preventDefault();
        if (currentPage < totalPages) showDeliveryPage(currentPage + 1);
      };
      paginationEl.appendChild(nextLi);
    }

    // Show page
    window.showDeliveryPage = function (page) {
      var start = (page - 1) * itemsPerPage;
      var end = start + itemsPerPage;

      items.forEach(function (item, index) {
        item.style.display = index >= start && index < end ? "block" : "none";
      });

      renderPagination(page);
    };

    showDeliveryPage(1);
  }

  // Init pagination on page load
  initPickupPagination();
  initDeliveryPagination();

  // Auto refresh every 60 seconds
  setTimeout(function () {
    location.reload();
  }, 60000);
</script>
