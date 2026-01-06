<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Shipper Bàn Giao - Manager Portal</title>

    <link
      href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
      rel="stylesheet" />
    <link
      href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
      rel="stylesheet" />
    <link
      href="${pageContext.request.contextPath}/css/sb-admin-2.min.css"
      rel="stylesheet" />

    <style>
      .scan-header {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        padding: 30px;
        border-radius: 15px;
        color: #fff;
        margin-bottom: 25px;
      }

      .scan-card {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        margin-bottom: 20px;
      }

      .scan-card-header {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: #fff;
        padding: 20px;
        display: flex;
        align-items: center;
      }

      .card-icon {
        width: 50px;
        height: 50px;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        font-size: 1.5rem;
      }

      .scan-card-body {
        padding: 30px;
      }

      .scan-input-group {
        position: relative;
      }

      .scan-input-group input {
        padding-left: 50px;
        height: 60px;
        font-size: 1.3rem;
        font-weight: 600;
        border-radius: 10px;
        border: 2px solid #e3e6f0;
        text-transform: uppercase;
      }

      .scan-input-group input:focus {
        border-color: #f5576c;
        box-shadow: 0 0 0 3px rgba(245, 87, 108, 0.2);
      }

      .scan-icon {
        position: absolute;
        left: 18px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 1.3rem;
        color: #858796;
      }

      .result-panel {
        margin-top: 15px;
        padding: 12px 16px;
        border-radius: 8px;
        display: none;
        font-size: 0.95rem;
        border: 1px solid transparent;
      }

      .result-panel.success {
        background-color: #d4edda;
        border-color: #c3e6cb;
        color: #155724;
      }

      .result-panel.error {
        background-color: #f8d7da;
        border-color: #f5c6cb;
        color: #721c24;
      }

      .recent-scans {
        max-height: 300px;
        overflow-y: auto;
      }

      .scan-item {
        display: flex;
        align-items: center;
        padding: 12px;
        border: 1px solid #e3e6f0;
        border-radius: 10px;
        margin-bottom: 8px;
        transition: all 0.3s;
        font-size: 13px;
      }

      .scan-item:hover {
        border-color: #f5576c;
        background: #f8f9fc;
      }

      .scan-item.success {
        border-left: 4px solid #28a745;
      }

      .scan-item.error {
        border-left: 4px solid #dc3545;
      }

      .stats-box {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        border-radius: 15px;
        padding: 25px;
        color: #fff;
        text-align: center;
      }

      .stats-number {
        font-size: 3rem;
        font-weight: 700;
      }

      .order-detail {
        background: #f8f9fc;
        border-radius: 10px;
        padding: 20px;
        margin-top: 15px;
      }

      .order-detail-row {
        display: flex;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid #e3e6f0;
      }

      .order-detail-row:last-child {
        border-bottom: none;
      }

      .shipper-info {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 10px;
        padding: 15px;
        color: #fff;
        margin-bottom: 20px;
      }

      /* Pending orders list */
      .pending-orders-table {
        max-height: 400px;
        overflow-y: auto;
      }

      .pending-order-item {
        padding: 12px;
        border: 1px solid #e3e6f0;
        border-radius: 8px;
        margin-bottom: 10px;
        cursor: pointer;
        transition: all 0.2s;
      }

      .pending-order-item:hover {
        border-color: #f5576c;
        background: #fff5f7;
      }

      .pending-order-item.selected {
        border-color: #f5576c;
        background: #fff5f7;
        box-shadow: 0 2px 8px rgba(245, 87, 108, 0.2);
      }

      /* Lookup result section */
      .lookup-result {
        background: linear-gradient(135deg, #e0f7fa 0%, #fff 100%);
        border: 2px solid #00bcd4;
        border-radius: 12px;
        padding: 20px;
        margin-top: 15px;
        display: none;
      }

      .address-box {
        background: #fff;
        border-radius: 8px;
        padding: 12px;
        margin-bottom: 10px;
        border-left: 4px solid #28a745;
      }

      .address-box.receiver {
        border-left-color: #f5576c;
      }
    </style>
  </head>

  <body id="page-top">
    <div id="wrapper">
      <div id="content-wrapper" class="d-flex flex-column">
        <div id="content">
          <div class="container-fluid py-4">
            <!-- Header -->
            <div class="scan-header">
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <h4 class="mb-1">
                    <i class="fas fa-motorcycle"></i> Shipper Bàn Giao Hàng
                  </h4>
                  <p class="mb-0 opacity-75">
                    Quét mã khi Shipper mang hàng về bưu cục
                  </p>
                </div>
                <div>
                  <span class="badge badge-light p-2" id="currentHubInfo">
                    <i class="fas fa-building"></i> Đang tải...
                  </span>
                </div>
              </div>
            </div>

            <div class="row">
              <!-- Cột trái - Form quét -->
              <div class="col-lg-8">
                <div class="scan-card">
                  <div class="scan-card-header">
                    <div class="card-icon">
                      <i class="fas fa-motorcycle"></i>
                    </div>
                    <div>
                      <h5 class="mb-0">Quét Mã Vận Đơn</h5>
                      <small class="opacity-75"
                        >Hàng từ Shipper bàn giao về bưu cục</small
                      >
                    </div>
                  </div>
                  <div class="scan-card-body">
                    <!-- Thông tin Shipper -->
                    <div class="shipper-info">
                      <div class="d-flex align-items-center">
                        <i class="fas fa-user-circle fa-2x mr-3"></i>
                        <div>
                          <div class="font-weight-bold">
                            Shipper đang bàn giao
                          </div>
                          <small class="opacity-75"
                            >Quét mã vận đơn để xem chi tiết và chọn tuyến
                            đường</small
                          >
                        </div>
                      </div>
                    </div>

                    <form
                      id="shipperInboundForm"
                      onsubmit="return processShipperInbound(event)">
                      <!-- Dropdown chọn loại hành động -->
                      <div class="form-group mb-3">
                        <label class="font-weight-bold">
                          <i class="fas fa-tags text-danger"></i> Loại hành động
                        </label>
                        <select
                          class="form-control form-control-lg"
                          id="actionTypeId"
                          required>
                          <option value="">-- Chọn loại hành động --</option>
                        </select>
                      </div>

                      <!-- Input mã vận đơn -->
                      <div class="scan-input-group mb-3">
                        <i class="fas fa-barcode scan-icon"></i>
                        <input
                          type="text"
                          class="form-control form-control-lg"
                          id="trackingCode"
                          placeholder="QUÉT HOẶC NHẬP MÃ VẬN ĐƠN"
                          autofocus
                          autocomplete="off" />
                      </div>

                      <!-- Nút tra cứu -->
                      <button
                        type="button"
                        class="btn btn-info btn-lg btn-block mb-3"
                        onclick="lookupOrder()">
                        <i class="fas fa-search"></i> TRA CỨU ĐƠN HÀNG
                      </button>

                      <!-- Dropdown chọn tuyến đường (ẩn mặc định) -->
                      <div
                        class="form-group mb-3"
                        id="routeSelectGroup"
                        style="display: none">
                        <label class="font-weight-bold">
                          <i class="fas fa-route text-success"></i> Chọn tuyến
                          đường <span class="text-danger">*</span>
                        </label>
                        <select
                          class="form-control form-control-lg"
                          id="routeId"
                          required>
                          <option value="">
                            -- Chọn tuyến đường (bắt buộc) --
                          </option>
                        </select>
                      </div>

                      <!-- Nút xác nhận bàn giao (ẩn mặc định) -->
                      <button
                        type="submit"
                        class="btn btn-danger btn-lg btn-block"
                        id="btnConfirm"
                        style="display: none">
                        <i class="fas fa-check-circle"></i> XÁC NHẬN BÀN GIAO
                      </button>
                    </form>

                    <!-- Kết quả -->
                    <div id="resultPanel" class="result-panel"></div>

                    <!-- Chi tiết đơn hàng sau khi lookup -->
                    <div id="lookupResult" class="lookup-result">
                      <h6 class="font-weight-bold text-info mb-3">
                        <i class="fas fa-info-circle"></i> Chi tiết đơn hàng
                      </h6>

                      <!-- Thông tin cơ bản -->
                      <div class="row mb-3">
                        <div class="col-md-6">
                          <div class="order-detail-row">
                            <span class="text-muted">Mã vận đơn:</span>
                            <strong id="lookupTrackingCode">-</strong>
                          </div>
                          <div class="order-detail-row">
                            <span class="text-muted">Trạng thái:</span>
                            <span class="badge badge-warning" id="lookupStatus"
                              >-</span
                            >
                          </div>
                          <div class="order-detail-row">
                            <span class="text-muted">Hàng hóa:</span>
                            <span id="lookupItemName">-</span>
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="order-detail-row">
                            <span class="text-muted">COD:</span>
                            <strong class="text-success" id="lookupCod"
                              >-</strong
                            >
                          </div>
                          <div class="order-detail-row">
                            <span class="text-muted">Phí ship:</span>
                            <span id="lookupShippingFee">-</span>
                          </div>
                          <div class="order-detail-row">
                            <span class="text-muted">Tổng thu:</span>
                            <strong class="text-danger" id="lookupTotal"
                              >-</strong
                            >
                          </div>
                        </div>
                      </div>

                      <!-- Địa chỉ người gửi -->
                      <div class="address-box">
                        <div class="font-weight-bold text-success mb-2">
                          <i class="fas fa-user"></i> NGƯỜI GỬI
                        </div>
                        <div id="lookupSenderName">-</div>
                        <div id="lookupSenderPhone" class="text-muted">-</div>
                        <div id="lookupSenderAddress" class="small text-muted">
                          -
                        </div>
                      </div>

                      <!-- Địa chỉ người nhận -->
                      <div class="address-box receiver">
                        <div class="font-weight-bold text-danger mb-2">
                          <i class="fas fa-user"></i> NGƯỜI NHẬN
                        </div>
                        <div id="lookupReceiverName">-</div>
                        <div id="lookupReceiverPhone" class="text-muted">-</div>
                        <div
                          id="lookupReceiverAddress"
                          class="small text-muted">
                          -
                        </div>
                      </div>

                      <input type="hidden" id="currentRequestId" />
                    </div>

                    <!-- Chi tiết đơn hàng sau khi bàn giao thành công -->
                    <div
                      id="orderDetail"
                      class="order-detail"
                      style="display: none">
                      <h6 class="font-weight-bold text-success mb-3">
                        <i class="fas fa-check-circle"></i> Đã bàn giao thành
                        công
                      </h6>
                      <div class="order-detail-row">
                        <span class="text-muted">Mã vận đơn:</span>
                        <strong id="detailTrackingCode">-</strong>
                      </div>
                      <div class="order-detail-row">
                        <span class="text-muted">Trạng thái mới:</span>
                        <span class="badge badge-success" id="detailStatus"
                          >-</span
                        >
                      </div>
                      <div class="mt-3 text-center">
                        <button
                          type="button"
                          class="btn btn-success btn-sm"
                          onclick="openPrintLabel()">
                          <i class="fas fa-print"></i> In Tem Vận Đơn
                        </button>
                        <button
                          type="button"
                          class="btn btn-secondary btn-sm"
                          onclick="resetForm()">
                          <i class="fas fa-redo"></i> Quét tiếp
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Cột phải - Danh sách đơn pending & Lịch sử -->
              <div class="col-lg-4">
                <!-- Thống kê hôm nay -->
                <div class="stats-box mb-4">
                  <div class="stats-number" id="todayCount">0</div>
                  <div>Đơn nhận hôm nay</div>
                  <small class="opacity-75">Từ Shipper bàn giao</small>
                </div>

                <!-- Danh sách đơn pending -->
                <div class="scan-card mb-4">
                  <div
                    class="scan-card-header"
                    style="
                      background: linear-gradient(
                        135deg,
                        #667eea 0%,
                        #764ba2 100%
                      );
                    ">
                    <div
                      class="card-icon"
                      style="background: rgba(255, 255, 255, 0.2); color: #fff">
                      <i class="fas fa-clock"></i>
                    </div>
                    <div>
                      <h6 class="mb-0">Đơn chờ bàn giao</h6>
                      <small class="opacity-75">Tại bưu cục này</small>
                    </div>
                  </div>
                  <div class="scan-card-body p-3">
                    <div class="pending-orders-table" id="pendingOrdersList">
                      <p class="text-muted text-center py-4">
                        <i class="fas fa-spinner fa-spin"></i> Đang tải...
                      </p>
                    </div>
                  </div>
                </div>

                <!-- Lịch sử quét gần đây -->
                <div class="scan-card">
                  <div class="scan-card-header" style="background: #f8f9fc">
                    <div
                      class="card-icon"
                      style="background: #f5576c; color: #fff">
                      <i class="fas fa-history"></i>
                    </div>
                    <div>
                      <h6 class="mb-0 text-gray-800">Lịch sử quét</h6>
                    </div>
                  </div>
                  <div class="scan-card-body p-3">
                    <div class="recent-scans" id="recentScans">
                      <p class="text-muted text-center py-3">
                        <i class="fas fa-inbox d-block mb-2"></i>
                        Chưa có lượt quét nào
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <%@ include file="/commons/manager/footer.jsp" %>
      </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

    <script>
      let currentHubId = null;
      let currentManagerId = null;
      let todayCount = 0;
      let recentScans = [];
      let currentLookupData = null;

      $(document).ready(function () {
        loadManagerInfo();
        loadActionTypes();
        $("#trackingCode").focus();
      });

      // Tải thông tin Manager và Hub
      function loadManagerInfo() {
        $.get(
          "${pageContext.request.contextPath}/api/manager/current-user",
          function (response) {
            if (response.userId) {
              currentManagerId = response.userId;
              currentHubId = response.hubId;
              $("#currentHubInfo").html(
                '<i class="fas fa-building"></i> Hub: ' +
                  (response.hubName || currentHubId)
              );
              loadAvailableRoutes(currentHubId);
              loadPendingOrders(currentHubId);
            }
          }
        ).fail(function () {
          $("#currentHubInfo").html(
            '<span class="text-danger">Không thể tải thông tin</span>'
          );
        });
      }

      // Tải danh sách ActionType
      function loadActionTypes() {
        $.get(
          "${pageContext.request.contextPath}/api/manager/inbound/action-types",
          function (response) {
            let options = '<option value="">-- Chọn loại hành động --</option>';
            if (Array.isArray(response)) {
              response.forEach(function (at) {
                options +=
                  '<option value="' +
                  at.actionTypeId +
                  '">' +
                  at.actionCode +
                  " - " +
                  at.description +
                  "</option>";
              });
            }
            $("#actionTypeId").html(options);
          }
        );
      }

      // Tải danh sách tuyến đường
      function loadAvailableRoutes(hubId) {
        $.get(
          "${pageContext.request.contextPath}/api/manager/inbound/available-routes/" +
            hubId,
          function (routes) {
            let options =
              '<option value="">-- Chọn tuyến đường (tùy chọn) --</option>';
            if (Array.isArray(routes)) {
              routes.forEach(function (r) {
                const toHubName = r.toHub ? r.toHub.hubName : "N/A";
                options +=
                  '<option value="' +
                  r.routeId +
                  '">' +
                  r.description +
                  " → " +
                  toHubName +
                  "</option>";
              });
            }
            $("#routeId").html(options);
          }
        );
      }

      // Tải danh sách đơn pending tại Hub
      function loadPendingOrders(hubId) {
        $.get(
          "${pageContext.request.contextPath}/api/manager/inbound/pending-orders/" +
            hubId,
          function (response) {
            if (response.success && response.data) {
              renderPendingOrders(response.data);
            } else {
              $("#pendingOrdersList").html(
                '<p class="text-muted text-center py-3">Không có đơn chờ</p>'
              );
            }
          }
        ).fail(function () {
          $("#pendingOrdersList").html(
            '<p class="text-danger text-center py-3">Lỗi tải dữ liệu</p>'
          );
        });
      }

      // Render danh sách đơn pending
      function renderPendingOrders(orders) {
        if (!orders || orders.length === 0) {
          $("#pendingOrdersList").html(
            '<p class="text-muted text-center py-3"><i class="fas fa-inbox d-block mb-2"></i>Không có đơn chờ bàn giao</p>'
          );
          return;
        }

        let html = "";
        orders.forEach(function (order) {
          const cod = order.codAmount ? formatCurrency(order.codAmount) : "-";
          const trackingCode = order.trackingCode || "N/A";
          html +=
            '<div class="pending-order-item" onclick="selectPendingOrder(\'' +
            trackingCode +
            "')\">";
          html +=
            '  <div class="d-flex justify-content-between align-items-center">';
          html += "    <div>";
          html +=
            '      <strong class="text-primary">' + trackingCode + "</strong>";
          html +=
            '      <div class="small text-muted">' +
            (order.senderName || "-") +
            "</div>";
          html += "    </div>";
          html += '    <div class="text-right">';
          html +=
            '      <div class="text-success font-weight-bold">' +
            cod +
            "</div>";
          html +=
            '      <div class="small">→ ' +
            (order.deliveryProvince || "-") +
            "</div>";
          html += "    </div>";
          html += "  </div>";
          html += "</div>";
        });
        $("#pendingOrdersList").html(html);
      }

      // Chọn đơn từ danh sách pending
      function selectPendingOrder(trackingCode) {
        $("#trackingCode").val(trackingCode);
        $(".pending-order-item").removeClass("selected");
        event.currentTarget.classList.add("selected");
        lookupOrder();
      }

      // Tra cứu đơn hàng
      function lookupOrder() {
        const trackingCode = $("#trackingCode").val().trim().toUpperCase();
        if (!trackingCode) {
          showResult(false, "Vui lòng nhập mã vận đơn!");
          return;
        }

        $.get(
          "${pageContext.request.contextPath}/api/manager/inbound/lookup",
          { trackingCode: trackingCode },
          function (response) {
            if (response.success && response.data) {
              currentLookupData = response.data;
              showLookupResult(response.data);
              $("#routeSelectGroup").slideDown();
              $("#btnConfirm").slideDown();
              $("#orderDetail").hide();
            } else {
              showResult(false, response.message || "Không tìm thấy đơn hàng");
              hideLookupResult();
            }
          }
        ).fail(function (xhr) {
          const msg = xhr.responseJSON
            ? xhr.responseJSON.message
            : "Lỗi tra cứu";
          showResult(false, msg);
          hideLookupResult();
        });
      }

      // Hiển thị kết quả tra cứu
      function showLookupResult(data) {
        $("#lookupTrackingCode").text(data.trackingCode || "-");
        $("#lookupStatus").text(getStatusLabel(data.status));
        $("#lookupItemName").text(data.itemName || "-");
        $("#lookupCod").text(formatCurrency(data.codAmount));
        $("#lookupShippingFee").text(formatCurrency(data.shippingFee));
        $("#lookupTotal").text(formatCurrency(data.receiverPayAmount));

        // Người gửi
        if (data.pickupAddress) {
          $("#lookupSenderName").text(data.pickupAddress.contactName || "-");
          $("#lookupSenderPhone").html(
            '<i class="fas fa-phone"></i> ' +
              (data.pickupAddress.contactPhone || "-")
          );
          $("#lookupSenderAddress").text(formatAddress(data.pickupAddress));
        }

        // Người nhận
        if (data.deliveryAddress) {
          $("#lookupReceiverName").text(
            data.deliveryAddress.contactName || "-"
          );
          $("#lookupReceiverPhone").html(
            '<i class="fas fa-phone"></i> ' +
              (data.deliveryAddress.contactPhone || "-")
          );
          $("#lookupReceiverAddress").text(formatAddress(data.deliveryAddress));
        }

        if (data.requestId) {
          $("#currentRequestId").val(data.requestId);
        }

        $("#lookupResult").slideDown();
        $("#resultPanel").hide();
      }

      function hideLookupResult() {
        $("#lookupResult").hide();
        $("#routeSelectGroup").hide();
        $("#btnConfirm").hide();
        currentLookupData = null;
      }

      // Xử lý bàn giao
      function processShipperInbound(event) {
        event.preventDefault();

        const trackingCode = $("#trackingCode").val().trim().toUpperCase();
        const actionTypeId = $("#actionTypeId").val();
        const routeId = $("#routeId").val();

        if (!actionTypeId) {
          showResult(false, "Vui lòng chọn loại hành động!");
          return false;
        }

        if (!trackingCode) {
          showResult(false, "Vui lòng nhập mã vận đơn!");
          return false;
        }

        // Bắt buộc chọn tuyến đường
        if (!routeId) {
          showResult(
            false,
            "Vui lòng chọn tuyến đường trước khi xác nhận bàn giao!"
          );
          $("#routeId").focus();
          return false;
        }

        if (!currentHubId || !currentManagerId) {
          showResult(false, "Không xác định được Hub hoặc Manager!");
          return false;
        }

        $.ajax({
          url: "${pageContext.request.contextPath}/api/manager/inbound/shipper-in",
          type: "POST",
          data: {
            trackingCode: trackingCode,
            currentHubId: currentHubId,
            managerId: currentManagerId,
            actionTypeId: actionTypeId,
            routeId: routeId,
          },
          beforeSend: function () {
            $("#btnConfirm")
              .prop("disabled", true)
              .html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');
          },
          success: function (response) {
            if (response.success) {
              showResult(true, response.message);
              showOrderDetail(trackingCode, response.data);
              addToRecentScans(trackingCode, true);
              todayCount++;
              $("#todayCount").text(todayCount);
              hideLookupResult();
              // Reload pending list
              loadPendingOrders(currentHubId);
            } else {
              showResult(false, response.message);
              addToRecentScans(trackingCode, false, response.message);
            }
          },
          error: function (xhr) {
            const msg = xhr.responseJSON
              ? xhr.responseJSON.message
              : "Lỗi không xác định";
            showResult(false, msg);
            addToRecentScans(trackingCode, false, msg);
          },
          complete: function () {
            $("#btnConfirm")
              .prop("disabled", false)
              .html('<i class="fas fa-check-circle"></i> XÁC NHẬN BÀN GIAO');
          },
        });

        return false;
      }

      function showResult(success, message) {
        const $result = $("#resultPanel");
        $result
          .removeClass("success error")
          .addClass(success ? "success" : "error")
          .html(
            '<i class="fas fa-' +
              (success ? "check-circle" : "times-circle") +
              ' mr-2"></i> ' +
              message
          )
          .slideDown();

        if (success) {
          setTimeout(function () {
            $result.slideUp();
          }, 5000);
        }
      }

      function showOrderDetail(trackingCode, data) {
        $("#detailTrackingCode").text(trackingCode);
        $("#detailStatus").text(getStatusLabel(data.status || "picked"));
        if (data.requestId) {
          $("#currentRequestId").val(data.requestId);
        }
        $("#orderDetail").slideDown();
      }

      function resetForm() {
        $("#trackingCode").val("").focus();
        $("#routeId").val("");
        $("#orderDetail").hide();
        $("#lookupResult").hide();
        $("#routeSelectGroup").hide();
        $("#btnConfirm").hide();
        $("#resultPanel").hide();
        currentLookupData = null;
      }

      function openPrintLabel() {
        const requestId = $("#currentRequestId").val();
        if (!requestId) {
          alert("Không tìm thấy mã đơn hàng!");
          return;
        }
        window.open(
          "${pageContext.request.contextPath}/manager/inbound/print-label/" +
            requestId,
          "_blank",
          "width=450,height=600"
        );
      }

      function addToRecentScans(trackingCode, success, errorMsg) {
        const scan = {
          code: trackingCode,
          success: success,
          error: errorMsg || null,
          time: new Date(),
        };
        recentScans.unshift(scan);
        if (recentScans.length > 15) recentScans.pop();
        renderRecentScans();
      }

      function renderRecentScans() {
        if (recentScans.length === 0) {
          $("#recentScans").html(
            '<p class="text-muted text-center py-3"><i class="fas fa-inbox d-block mb-2"></i>Chưa có lượt quét</p>'
          );
          return;
        }

        let html = "";
        recentScans.forEach(function (scan) {
          const icon = scan.success
            ? '<i class="fas fa-check-circle text-success"></i>'
            : '<i class="fas fa-times-circle text-danger"></i>';
          html +=
            '<div class="scan-item ' +
            (scan.success ? "success" : "error") +
            '">';
          html += '  <div style="flex:1;">';
          html += "    <strong>" + scan.code + "</strong>";
          html +=
            '    <div class="small text-muted">' +
            formatTime(scan.time) +
            "</div>";
          if (!scan.success && scan.error) {
            html += '    <small class="text-danger">' + scan.error + "</small>";
          }
          html += "  </div>";
          html += "  <div>" + icon + "</div>";
          html += "</div>";
        });
        $("#recentScans").html(html);
      }

      // Helper functions
      function formatCurrency(amount) {
        if (!amount) return "0 ₫";
        return new Intl.NumberFormat("vi-VN").format(amount) + " ₫";
      }

      function formatAddress(addr) {
        if (!addr) return "-";
        const parts = [
          addr.addressDetail,
          addr.ward,
          addr.district,
          addr.province,
        ].filter((p) => p);
        return parts.join(", ");
      }

      function getStatusLabel(status) {
        const statusMap = {
          pending: "Chờ lấy hàng",
          picked: "Đã lấy hàng",
          in_transit: "Đang vận chuyển",
          delivered: "Đã giao",
          failed: "Giao thất bại",
          cancelled: "Đã hủy",
        };
        return statusMap[status] || status;
      }

      function formatTime(date) {
        return date.toLocaleTimeString("vi-VN", {
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
        });
      }
    </script>
  </body>
</html>
