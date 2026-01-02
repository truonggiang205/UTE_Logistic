<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .counter-header {
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
    padding: 25px;
    border-radius: 15px;
    color: #fff;
    margin-bottom: 25px;
  }

  .pickup-card {
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
  }

  .pickup-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    padding: 20px;
  }

  .pickup-body {
    padding: 25px;
  }

  .search-box {
    position: relative;
  }

  .search-box input {
    padding-left: 45px;
    font-size: 18px;
    height: 55px;
    border-radius: 10px;
  }

  .search-box i {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: #858796;
    font-size: 18px;
  }

  .order-detail {
    background: #f8f9fc;
    border-radius: 12px;
    padding: 25px;
    margin-top: 20px;
    display: none;
  }

  .order-detail.show {
    display: block;
  }

  .detail-row {
    display: flex;
    justify-content: space-between;
    padding: 12px 0;
    border-bottom: 1px solid #e3e6f0;
  }

  .detail-row:last-child {
    border-bottom: none;
  }

  .detail-label {
    color: #858796;
  }

  .detail-value {
    font-weight: 600;
    text-align: right;
  }

  .cod-highlight {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: #fff;
    padding: 20px;
    border-radius: 12px;
    text-align: center;
    margin: 20px 0;
  }

  .cod-highlight .amount {
    font-size: 32px;
    font-weight: 700;
  }

  .btn-pickup {
    background: linear-gradient(135deg, #f5af19 0%, #f12711 100%);
    border: none;
    color: #fff;
    padding: 15px 40px;
    border-radius: 30px;
    font-size: 18px;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-pickup:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(245, 175, 25, 0.4);
    color: #fff;
  }

  .btn-pickup:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }

  .not-found {
    text-align: center;
    padding: 40px;
    color: #858796;
  }

  .not-found i {
    font-size: 50px;
    margin-bottom: 15px;
  }

  .status-badge {
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 600;
  }
  .status-pending {
    background: #fff3cd;
    color: #856404;
  }
  .status-picked {
    background: #cce5ff;
    color: #004085;
  }
  .status-in_transit {
    background: #d1ecf1;
    color: #0c5460;
  }
  .status-delivered {
    background: #d4edda;
    color: #155724;
  }
</style>

<!-- Header -->
<div class="counter-header">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1"><i class="fas fa-store mr-2"></i>Khách Nhận Tại Quầy</h4>
      <p class="mb-0 opacity-75">
        Xác nhận khi khách hàng đến nhận hàng trực tiếp tại bưu cục
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

<div class="row">
  <!-- Main: Tìm và xác nhận -->
  <div class="col-12">
    <div class="pickup-card">
      <div class="pickup-header">
        <h5 class="mb-0">
          <i class="fas fa-search mr-2"></i>Tìm kiếm đơn hàng
        </h5>
      </div>
      <div class="pickup-body">
        <div class="search-box">
          <i class="fas fa-barcode"></i>
          <input
            type="text"
            class="form-control form-control-lg"
            id="searchTracking"
            placeholder="Nhập mã vận đơn hoặc quét barcode..."
            autofocus />
        </div>
        <p class="text-muted small mt-2">
          <i class="fas fa-info-circle mr-1"></i>
          Nhập mã vận đơn và nhấn Enter để tìm kiếm
        </p>

        <!-- Order Detail -->
        <div class="order-detail" id="orderDetail">
          <h5 class="mb-3">
            <i class="fas fa-box text-primary mr-2"></i>Thông tin đơn hàng
          </h5>
          <div class="detail-row">
            <span class="detail-label">Mã vận đơn:</span>
            <span
              class="detail-value text-primary"
              id="detailTrackingCode"></span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Người gửi:</span>
            <span class="detail-value" id="detailSender"></span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Người nhận:</span>
            <span class="detail-value" id="detailReceiver"></span>
          </div>
          <div class="detail-row">
            <span class="detail-label">SĐT Người nhận:</span>
            <span class="detail-value" id="detailReceiverPhone"></span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Trạng thái:</span>
            <span class="detail-value" id="detailStatus"></span>
          </div>

          <div class="cod-highlight" id="codSection">
            <div class="small mb-1">Số tiền cần thu</div>
            <div class="amount" id="detailCodAmount">0 ₫</div>
          </div>

          <div class="mb-3">
            <label>Ghi chú (tùy chọn):</label>
            <textarea
              class="form-control"
              id="inputNote"
              rows="2"
              placeholder="Ghi chú khi giao..."></textarea>
          </div>

          <input type="hidden" id="inputRequestId" />
          <input type="hidden" id="inputCodAmount" />

          <div class="text-center">
            <button class="btn btn-pickup" id="btnConfirmPickup">
              <i class="fas fa-check-circle mr-2"></i>Xác nhận Đã Giao
            </button>
          </div>
        </div>

        <!-- Not Found -->
        <div class="not-found" id="notFoundMessage" style="display: none">
          <i class="fas fa-box-open"></i>
          <h5>Không tìm thấy đơn hàng</h5>
          <p>Vui lòng kiểm tra lại mã vận đơn</p>
        </div>

        <!-- Already Delivered -->
        <div class="not-found" id="alreadyDelivered" style="display: none">
          <i class="fas fa-check-circle text-success"></i>
          <h5>Đơn hàng đã được giao</h5>
          <p>Đơn này đã hoàn thành trước đó</p>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";

  function initPage() {
    if (typeof jQuery === "undefined") {
      setTimeout(initPage, 50);
      return;
    }
    $(document).ready(function () {
      $("#searchTracking").on("keypress", function (e) {
        if (e.which === 13) searchOrder();
      });
      $("#btnConfirmPickup").click(confirmPickup);
    });
  }

  function searchOrder() {
    var tracking = $("#searchTracking").val().trim();
    if (!tracking) return;

    $("#orderDetail").removeClass("show");
    $("#notFoundMessage").hide();
    $("#alreadyDelivered").hide();

    $.get(
      contextPath +
        "/api/manager/lastmile/orders?trackingCode=" +
        encodeURIComponent(tracking),
      function (response) {
        if (response.success && response.data && response.data.length > 0) {
          var order = response.data[0];
          if (order.status === "delivered") {
            $("#alreadyDelivered").show();
          } else {
            showOrderDetail(order);
          }
        } else {
          $("#notFoundMessage").show();
        }
      }
    ).fail(function () {
      $("#notFoundMessage").show();
    });
  }

  function showOrderDetail(order) {
    $("#detailTrackingCode").text(order.trackingCode);
    $("#detailSender").text(order.senderName || "N/A");
    $("#detailReceiver").text(order.receiverName || "N/A");
    $("#detailReceiverPhone").text(order.receiverPhone || "N/A");

    var statusClass = "status-" + (order.status || "pending");
    var statusText = getStatusText(order.status);
    $("#detailStatus").html(
      '<span class="status-badge ' + statusClass + '">' + statusText + "</span>"
    );

    // Sử dụng receiverPayAmount (tổng tiền người nhận phải trả)
    var totalAmount = order.receiverPayAmount || order.codAmount || 0;
    $("#detailCodAmount").text(formatCurrency(totalAmount));
    $("#inputCodAmount").val(totalAmount);
    $("#inputRequestId").val(order.requestId);
    $("#inputNote").val("");

    // Ẩn section nếu không có tiền thu
    if (totalAmount <= 0) {
      $("#codSection").hide();
    } else {
      $("#codSection").show();
    }

    $("#orderDetail").addClass("show");
  }

  function getStatusText(status) {
    var texts = {
      pending: "Chờ lấy",
      picked: "Đã lấy",
      in_transit: "Đang vận chuyển",
      delivered: "Đã giao",
    };
    return texts[status] || status;
  }

  function formatCurrency(amount) {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount);
  }

  function confirmPickup() {
    var requestId = $("#inputRequestId").val();
    var codAmount = $("#inputCodAmount").val();
    var note = $("#inputNote").val();

    if (!requestId) {
      alert("Không tìm thấy thông tin đơn hàng");
      return;
    }

    $("#btnConfirmPickup")
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...');

    $.ajax({
      url: contextPath + "/api/manager/lastmile/counter-pickup",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        requestId: parseInt(requestId),
        codCollected: parseFloat(codAmount) || 0,
        note: note || null,
      }),
      success: function (response) {
        alert(
          "Xác nhận giao hàng thành công!\nMã vận đơn: " + response.trackingCode
        );
        resetForm();
      },
      error: function (xhr) {
        alert(
          "Lỗi: " +
            (xhr.responseJSON ? xhr.responseJSON.error : "Có lỗi xảy ra")
        );
      },
      complete: function () {
        $("#btnConfirmPickup")
          .prop("disabled", false)
          .html('<i class="fas fa-check-circle mr-2"></i>Xác nhận Đã Giao');
      },
    });
  }

  function resetForm() {
    $("#searchTracking").val("").focus();
    $("#orderDetail").removeClass("show");
    $("#notFoundMessage").hide();
    $("#alreadyDelivered").hide();
  }

  initPage();
</script>
