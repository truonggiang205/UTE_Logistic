<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .return-header {
    background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
    padding: 25px;
    border-radius: 15px;
    color: #fff;
    margin-bottom: 25px;
  }

  .return-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
  }

  .return-card-header {
    background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
    color: #fff;
    padding: 20px;
  }

  .return-card-body {
    padding: 25px;
  }

  .order-table {
    width: 100%;
    border-collapse: collapse;
  }

  .order-table th,
  .order-table td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #e3e6f0;
  }

  .order-table th {
    background: #f8f9fc;
    font-weight: 600;
    color: #5a5c69;
  }

  .order-table tbody tr:hover {
    background: #f8f9fc;
  }

  .badge-failed {
    background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
    color: #fff;
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 600;
  }

  .badge-pending {
    background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
    color: #fff;
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 600;
  }

  .badge-count {
    background: #dc3545;
    color: #fff;
    padding: 3px 8px;
    border-radius: 10px;
    font-size: 11px;
    font-weight: 700;
  }

  .btn-return {
    background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
    border: none;
    color: #fff;
    padding: 8px 20px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.3s;
    cursor: pointer;
  }

  .btn-return:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
    color: #fff;
  }

  .btn-return:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }

  .stat-card {
    background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
    color: #fff;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
  }

  .stat-number {
    font-size: 36px;
    font-weight: 700;
  }

  .stat-label {
    font-size: 14px;
    opacity: 0.9;
  }

  .empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #858796;
  }

  .empty-state i {
    font-size: 60px;
    margin-bottom: 20px;
    color: #28a745;
  }

  .fee-highlight {
    color: #e74c3c;
    font-weight: 700;
  }

  .loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }
</style>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay" style="display: none">
  <div class="text-center">
    <i class="fas fa-spinner fa-spin fa-3x text-primary mb-3"></i>
    <h5>Đang tải dữ liệu...</h5>
  </div>
</div>

<!-- Header -->
<div class="return-header">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1"><i class="fas fa-undo-alt mr-2"></i>Hoàn Hàng</h4>
      <p class="mb-0 opacity-75">
        Kích hoạt hoàn hàng cho đơn giao thất bại 3 lần
      </p>
    </div>
    <div>
      <span class="badge badge-light p-2">
        <i class="fas fa-calendar-day mr-1"></i>
        <fmt:formatDate
          value="<%=new java.util.Date()%>"
          pattern="dd/MM/yyyy HH:mm" />
      </span>
    </div>
  </div>
</div>

<!-- Stats Row -->
<div class="row mb-4">
  <div class="col-md-6">
    <div class="stat-card">
      <div class="stat-number" id="statPendingCount">0</div>
      <div class="stat-label">Đơn chờ hoàn hàng</div>
    </div>
  </div>
  <div class="col-md-6">
    <div
      class="stat-card"
      style="background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%)">
      <div class="stat-number" id="statTotalFees">0 ₫</div>
      <div class="stat-label">Tổng phí hoàn</div>
    </div>
  </div>
</div>

<!-- Main Card -->
<div class="return-card">
  <div class="return-card-header">
    <h5 class="mb-0">
      <i class="fas fa-list mr-2"></i>Danh sách đơn cần hoàn hàng
      <span class="badge badge-light ml-2" id="orderCount">0</span>
    </h5>
  </div>
  <div class="return-card-body">
    <!-- Empty State -->
    <div class="empty-state" id="emptyState" style="display: none">
      <i class="fas fa-check-circle"></i>
      <h5>Không có đơn nào cần hoàn hàng</h5>
      <p>Tất cả đơn hàng đang được giao bình thường</p>
    </div>

    <!-- Orders Table -->
    <div class="table-responsive" id="ordersTableContainer">
      <table class="order-table" id="ordersTable">
        <thead>
          <tr>
            <th>Mã vận đơn</th>
            <th>Người gửi</th>
            <th>Người nhận</th>
            <th>Lần thất bại</th>
            <th>Phí hoàn (VNĐ)</th>
            <th>Trạng thái</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody id="ordersBody">
          <!-- Data loaded via JavaScript -->
        </tbody>
      </table>

      <!-- Pagination -->
      <div
        class="d-flex justify-content-between align-items-center mt-3"
        id="paginationContainer"
        style="display: none !important">
        <div class="text-muted">
          Hiển thị <span id="showingStart">0</span> -
          <span id="showingEnd">0</span> trong tổng số
          <span id="totalOrders">0</span> đơn
        </div>
        <nav>
          <ul class="pagination mb-0" id="pagination">
            <!-- Pagination buttons will be rendered here -->
          </ul>
        </nav>
      </div>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var ordersData = [];
  var currentPage = 1;
  var itemsPerPage = 6;

  function initPage() {
    if (typeof jQuery === "undefined") {
      setTimeout(initPage, 50);
      return;
    }
    $(document).ready(function () {
      loadPendingOrders();
    });
  }

  function loadPendingOrders() {
    $("#loadingOverlay").show();

    $.get(
      contextPath + "/api/manager/lastmile/return-goods/pending",
      function (response) {
        $("#loadingOverlay").hide();

        if (response.success && response.data) {
          ordersData = response.data;
          currentPage = 1;
          renderOrders(ordersData);
          updateStats(ordersData);
        } else {
          showEmpty();
        }
      }
    ).fail(function () {
      $("#loadingOverlay").hide();
      alert("Lỗi khi tải dữ liệu. Vui lòng thử lại.");
    });
  }

  function renderOrders(orders) {
    var $tbody = $("#ordersBody");
    $tbody.empty();

    if (orders.length === 0) {
      showEmpty();
      return;
    }

    $("#emptyState").hide();
    $("#ordersTableContainer").show();
    $("#orderCount").text(orders.length);

    // Calculate pagination
    var totalPages = Math.ceil(orders.length / itemsPerPage);
    var startIndex = (currentPage - 1) * itemsPerPage;
    var endIndex = Math.min(startIndex + itemsPerPage, orders.length);
    var pageOrders = orders.slice(startIndex, endIndex);

    pageOrders.forEach(function (order) {
      var statusBadge = order.alreadyActivated
        ? '<span class="badge-failed">Đã hoàn</span>'
        : '<span class="badge-pending">' +
          getStatusText(order.status) +
          "</span>";

      var actionBtn = order.alreadyActivated
        ? '<span class="text-success"><i class="fas fa-check-circle mr-1"></i>Đã xử lý</span>'
        : '<button class="btn-return" onclick="activateReturn(' +
          order.requestId +
          ')"><i class="fas fa-undo-alt mr-1"></i>Hoàn hàng</button>';

      var row =
        '<tr data-id="' +
        order.requestId +
        '">' +
        '<td><span class="text-primary font-weight-bold">' +
        order.trackingCode +
        "</span></td>" +
        "<td>" +
        (order.senderName || "N/A") +
        '<br><small class="text-muted">' +
        (order.senderPhone || "") +
        "</small></td>" +
        "<td>" +
        (order.receiverName || "N/A") +
        '<br><small class="text-muted">' +
        (order.receiverPhone || "") +
        "</small></td>" +
        '<td class="text-center"><span class="badge-count">' +
        order.failedCount +
        " lần</span></td>" +
        '<td class="fee-highlight">' +
        formatCurrency(order.shippingFee || 0) +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        '<td class="text-center">' +
        actionBtn +
        "</td>" +
        "</tr>";
      $tbody.append(row);
    });

    // Render pagination
    renderPagination(totalPages, orders.length, startIndex, endIndex);
  }

  function renderPagination(totalPages, totalOrders, startIndex, endIndex) {
    if (totalPages <= 1) {
      $("#paginationContainer").hide();
      return;
    }

    $("#paginationContainer").show();
    $("#showingStart").text(startIndex + 1);
    $("#showingEnd").text(endIndex);
    $("#totalOrders").text(totalOrders);

    var $pagination = $("#pagination");
    $pagination.empty();

    // Previous button
    var prevDisabled = currentPage === 1 ? "disabled" : "";
    $pagination.append(
      '<li class="page-item ' +
        prevDisabled +
        '">' +
        '<a class="page-link" href="#" onclick="changePage(' +
        (currentPage - 1) +
        '); return false;">Trước</a>' +
        "</li>"
    );

    // Page numbers
    for (var i = 1; i <= totalPages; i++) {
      var activeClass = i === currentPage ? "active" : "";
      $pagination.append(
        '<li class="page-item ' +
          activeClass +
          '">' +
          '<a class="page-link" href="#" onclick="changePage(' +
          i +
          '); return false;">' +
          i +
          "</a>" +
          "</li>"
      );
    }

    // Next button
    var nextDisabled = currentPage === totalPages ? "disabled" : "";
    $pagination.append(
      '<li class="page-item ' +
        nextDisabled +
        '">' +
        '<a class="page-link" href="#" onclick="changePage(' +
        (currentPage + 1) +
        '); return false;">Sau</a>' +
        "</li>"
    );
  }

  function changePage(page) {
    var totalPages = Math.ceil(ordersData.length / itemsPerPage);
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    renderOrders(ordersData);
  }

  function showEmpty() {
    $("#emptyState").show();
    $("#ordersTableContainer").hide();
    $("#orderCount").text("0");
  }

  function updateStats(orders) {
    var count = orders.length;
    var totalFees = orders.reduce(function (sum, o) {
      return sum + (o.shippingFee || 0);
    }, 0);

    $("#statPendingCount").text(count);
    $("#statTotalFees").text(formatCurrency(totalFees));
  }

  function getStatusText(status) {
    var texts = {
      pending: "Chờ lấy",
      picked: "Đã lấy",
      in_transit: "Đang vận chuyển",
      delivered: "Đã giao",
      failed: "Đã hoàn",
      cancelled: "Đã hủy",
    };
    return texts[status] || status;
  }

  function formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  function activateReturn(requestId) {
    if (
      !confirm(
        "Bạn có chắc muốn kích hoạt hoàn hàng cho đơn này?\n\nĐơn hàng sẽ được đánh dấu thất bại và tạo phí hoàn."
      )
    ) {
      return;
    }

    var $btn = $('tr[data-id="' + requestId + '"] .btn-return');
    $btn
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');

    $.ajax({
      url: contextPath + "/api/manager/lastmile/return-goods/activate",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ requestId: requestId }),
      success: function (response) {
        if (response.success) {
          alert(
            "Hoàn hàng thành công!\n\nMã vận đơn: " +
              response.trackingCode +
              "\nPhí hoàn: " +
              formatCurrency(response.returnFee)
          );
          loadPendingOrders(); // Reload the list
        } else {
          alert("Lỗi: " + (response.error || "Không thể hoàn hàng"));
          $btn
            .prop("disabled", false)
            .html('<i class="fas fa-undo-alt mr-1"></i>Hoàn hàng');
        }
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
        $btn
          .prop("disabled", false)
          .html('<i class="fas fa-undo-alt mr-1"></i>Hoàn hàng');
      },
    });
  }

  function completeReturn(requestId) {
    if (
      !confirm(
        "Xác nhận Shop đã nhận lại hàng?\\n\\nĐơn hàng sẽ được đóng và thu phí hoàn."
      )
    ) {
      return;
    }

    var $btn = $('tr[data-id="' + requestId + '"] .btn-success');
    $btn
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin mr-1"></i>Đang xử lý...');

    $.ajax({
      url: contextPath + "/api/manager/lastmile/return-goods/complete",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ requestId: requestId }),
      success: function (response) {
        if (response.success) {
          alert(
            "Đã trả lại hàng cho Shop!\\n\\nMã vận đơn: " +
              response.trackingCode +
              "\\nPhí hoàn đã thu: " +
              formatCurrency(response.settledAmount)
          );
          loadPendingOrders(); // Reload the list
        } else {
          alert("Lỗi: " + (response.error || "Không thể xử lý"));
          $btn
            .prop("disabled", false)
            .html('<i class="fas fa-handshake mr-1"></i>Trả lại Shop');
        }
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
        $btn
          .prop("disabled", false)
          .html('<i class="fas fa-handshake mr-1"></i>Trả lại Shop');
      },
    });
  }

  initPage();
</script>
