<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .return-shop-header {
    background: linear-gradient(135deg, #28a745 0%, #218838 100%);
    padding: 25px;
    border-radius: 15px;
    color: #fff;
    margin-bottom: 25px;
  }

  .return-shop-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
  }

  .return-shop-card-header {
    background: linear-gradient(135deg, #28a745 0%, #218838 100%);
    color: #fff;
    padding: 20px;
  }

  .return-shop-card-body {
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

  .badge-waiting {
    background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
    color: #fff;
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 600;
  }

  .btn-complete {
    background: linear-gradient(135deg, #28a745 0%, #218838 100%);
    border: none;
    color: #fff;
    padding: 8px 20px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.3s;
    cursor: pointer;
  }

  .btn-complete:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
    color: #fff;
  }

  .stat-card {
    background: linear-gradient(135deg, #28a745 0%, #218838 100%);
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
    color: #28a745;
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
    <i class="fas fa-spinner fa-spin fa-3x text-success mb-3"></i>
    <h5>Đang tải dữ liệu...</h5>
  </div>
</div>

<!-- Header -->
<div class="return-shop-header">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1">
        <i class="fas fa-handshake mr-2"></i>Xác Nhận Trả Shop
      </h4>
      <p class="mb-0 opacity-75">
        Xác nhận Shop đã nhận lại hàng hoàn và thu phí
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
      <div class="stat-label">Đơn chờ trả Shop</div>
    </div>
  </div>
  <div class="col-md-6">
    <div
      class="stat-card"
      style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%)">
      <div class="stat-number" id="statTotalFees">0 ₫</div>
      <div class="stat-label">Tổng phí hoàn cần thu</div>
    </div>
  </div>
</div>

<!-- Main Card -->
<div class="return-shop-card">
  <div class="return-shop-card-header">
    <h5 class="mb-0">
      <i class="fas fa-list mr-2"></i>Danh sách đơn chờ trả Shop
      <span class="badge badge-light ml-2" id="orderCount">0</span>
    </h5>
  </div>
  <div class="return-shop-card-body">
    <!-- Empty State -->
    <div class="empty-state" id="emptyState" style="display: none">
      <i class="fas fa-check-circle"></i>
      <h5>Không có đơn nào chờ trả Shop</h5>
      <p>Tất cả đơn hoàn đã được xử lý</p>
    </div>

    <!-- Orders Table -->
    <div class="table-responsive" id="ordersTableContainer">
      <table class="order-table" id="ordersTable">
        <thead>
          <tr>
            <th>Mã vận đơn</th>
            <th>Người gửi (Shop)</th>
            <th>Hub hiện tại</th>
            <th>Phí hoàn (VNĐ)</th>
            <th class="text-center">Thao tác</th>
          </tr>
        </thead>
        <tbody id="ordersBody">
          <!-- Data loaded via JavaScript -->
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var ordersData = [];

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
      contextPath + "/api/manager/lastmile/return-shop/pending",
      function (response) {
        $("#loadingOverlay").hide();

        if (response.success && response.data) {
          ordersData = response.data;
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

    orders.forEach(function (order) {
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
        (order.currentHubName || "N/A") +
        "</td>" +
        '<td class="fee-highlight">' +
        formatCurrency(order.shippingFee || 0) +
        "</td>" +
        '<td class="text-center">' +
        '<button class="btn-complete" onclick="completeReturn(' +
        order.requestId +
        ')">' +
        '<i class="fas fa-handshake mr-1"></i>Xác nhận trả Shop</button>' +
        "</td>" +
        "</tr>";
      $tbody.append(row);
    });
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

  function formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  function completeReturn(requestId) {
    if (
      !confirm(
        "Xác nhận Shop đã nhận lại hàng?\n\nĐơn hàng sẽ được đóng và thu phí hoàn."
      )
    ) {
      return;
    }

    var $btn = $('tr[data-id="' + requestId + '"] .btn-complete');
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
            "Đã trả lại hàng cho Shop!\n\nMã vận đơn: " +
              response.trackingCode +
              "\nPhí hoàn đã thu: " +
              formatCurrency(response.settledAmount)
          );
          loadPendingOrders(); // Reload the list
        } else {
          alert("Lỗi: " + (response.error || "Không thể xử lý"));
          $btn
            .prop("disabled", false)
            .html('<i class="fas fa-handshake mr-1"></i>Xác nhận trả Shop');
        }
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
        $btn
          .prop("disabled", false)
          .html('<i class="fas fa-handshake mr-1"></i>Xác nhận trả Shop');
      },
    });
  }

  initPage();
</script>
