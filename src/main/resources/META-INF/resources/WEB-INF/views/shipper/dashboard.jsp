<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
  <!-- Page Heading -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-tachometer-alt text-success"></i> Dashboard Shipper
    </h1>
    <span class="text-muted">
      <i class="fas fa-calendar-alt"></i>
      <fmt:formatDate value="${today}" pattern="dd/MM/yyyy" />
    </span>
  </div>

  <!-- Row 1: Statistics Cards -->
  <div class="row">
    <!-- Tổng đơn hôm nay -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                Tổng đơn hôm nay
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                ${todayOrdersCount != null ? todayOrdersCount : 0}
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Đang xử lý -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                Đang xử lý
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                ${deliveringCount != null ? deliveringCount : 0}
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-spinner fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Hoàn thành -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-success text-uppercase mb-1">
                Hoàn thành hôm nay
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                ${completedCount != null ? completedCount : 0}
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-check-circle fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- COD cần nộp -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-info text-uppercase mb-1">
                COD cần nộp
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${totalCodAmount != null ? totalCodAmount : 0}"
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

  <!-- Row 2: Pickup/Delivery Mini Stats -->
  <div class="row">
    <!-- Pickup Stats -->
    <div class="col-lg-6 mb-4">
      <div class="card shadow h-100">
        <div class="card-header py-3 bg-warning text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-hand-holding-box"></i> LẤY HÀNG (Pickup)
          </h6>
        </div>
        <div class="card-body">
          <div class="row text-center">
            <div class="col-4">
              <div class="border-right">
                <h3 class="text-warning mb-0">
                  ${todayPickupCount != null ? todayPickupCount : 0}
                </h3>
                <small class="text-muted">Cần lấy</small>
              </div>
            </div>
            <div class="col-4">
              <div class="border-right">
                <h3 class="text-info mb-0">
                  ${pickupInProgressCount != null ? pickupInProgressCount : 0}
                </h3>
                <small class="text-muted">Đang lấy</small>
              </div>
            </div>
            <div class="col-4">
              <h3 class="text-success mb-0">
                ${pickupCompletedCount != null ? pickupCompletedCount : 0}
              </h3>
              <small class="text-muted">Đã lấy</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delivery Stats -->
    <div class="col-lg-6 mb-4">
      <div class="card shadow h-100">
        <div class="card-header py-3 bg-success text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-shipping-fast"></i> GIAO HÀNG (Delivery)
          </h6>
        </div>
        <div class="card-body">
          <div class="row text-center">
            <div class="col-4">
              <div class="border-right">
                <h3 class="text-warning mb-0">
                  ${todayDeliveryCount != null ? todayDeliveryCount : 0}
                </h3>
                <small class="text-muted">Cần giao</small>
              </div>
            </div>
            <div class="col-4">
              <div class="border-right">
                <h3 class="text-info mb-0">
                  ${deliveryInProgressCount != null ? deliveryInProgressCount :
                  0}
                </h3>
                <small class="text-muted">Đang giao</small>
              </div>
            </div>
            <div class="col-4">
              <h3 class="text-success mb-0">
                ${deliveryCompletedCount != null ? deliveryCompletedCount : 0}
              </h3>
              <small class="text-muted">Đã giao</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Row 3: Bảng đơn cần lấy hàng (Pickup) -->
  <div class="row">
    <div class="col-12 mb-4">
      <div class="card shadow">
        <div
          class="card-header py-3 d-flex justify-content-between align-items-center bg-warning text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-hand-holding-box"></i> Đơn cần lấy hàng
          </h6>
          <span class="badge badge-light"
            >${todayPickupCount != null ? todayPickupCount : 0} đơn</span
          >
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered table-hover mb-0" width="100%">
              <thead class="thead-light">
                <tr>
                  <th width="5%">#</th>
                  <th width="15%">Mã đơn</th>
                  <th width="18%">Người gửi</th>
                  <th width="30%">Địa chỉ lấy hàng</th>
                  <th width="12%">Trạng thái</th>
                  <th width="20%">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty todayPickupOrders}">
                    <tr>
                      <td colspan="6" class="text-center text-muted py-5">
                        <i
                          class="fas fa-inbox fa-3x mb-3 d-block text-gray-300"></i>
                        <p class="mb-0">Không có đơn lấy hàng nào</p>
                      </td>
                    </tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach
                      var="order"
                      items="${todayPickupOrders}"
                      varStatus="loop">
                      <c:if test="${loop.index < 5}">
                        <tr>
                          <td class="text-center">${loop.index + 1}</td>
                          <td>
                            <strong class="text-primary"
                              >${order.trackingNumber}</strong
                            >
                          </td>
                          <td>${order.contactName}</td>
                          <td>
                            <span
                              class="d-inline-block text-truncate"
                              style="max-width: 250px"
                              title="${order.contactAddress}">
                              ${order.contactAddress}
                            </span>
                          </td>
                          <td class="text-center">
                            <span
                              class="badge badge-${order.statusBadge} px-2 py-1"
                              >${order.statusText}</span
                            >
                          </td>
                          <td class="text-center">
                            <div class="btn-group" role="group">
                              <button
                                type="button"
                                class="btn btn-sm btn-info btn-view-detail"
                                data-tracking="${order.trackingNumber}"
                                data-contact-name="${order.contactName}"
                                data-contact-phone="${order.contactPhone}"
                                data-contact-address="${order.contactAddress}"
                                data-cod="${order.codAmount}"
                                data-status="${order.status}"
                                data-status-text="${order.statusText}"
                                data-status-badge="${order.statusBadge}"
                                data-task-type="${order.taskType}"
                                title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                              </button>
                              <button
                                type="button"
                                class="btn btn-sm btn-warning btn-update-status"
                                data-task-id="${order.taskId}"
                                data-tracking="${order.trackingNumber}"
                                data-status="${order.status}"
                                title="Cập nhật trạng thái">
                                <i class="fas fa-edit"></i>
                              </button>
                            </div>
                          </td>
                        </tr>
                      </c:if>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Row 4: Bảng đơn cần giao hàng (Delivery) -->
  <div class="row">
    <div class="col-12 mb-4">
      <div class="card shadow">
        <div
          class="card-header py-3 d-flex justify-content-between align-items-center bg-success text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-shipping-fast"></i> Đơn cần giao hàng
          </h6>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered table-hover mb-0" width="100%">
              <thead class="thead-light">
                <tr>
                  <th width="5%">#</th>
                  <th width="12%">Mã đơn</th>
                  <th width="15%">Người nhận</th>
                  <th width="28%">Địa chỉ giao</th>
                  <th width="12%">COD</th>
                  <th width="12%">Trạng thái</th>
                  <th width="16%">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty todayDeliveryOrders}">
                    <tr>
                      <td colspan="7" class="text-center text-muted py-5">
                        <i
                          class="fas fa-inbox fa-3x mb-3 d-block text-gray-300"></i>
                        <p class="mb-0">Không có đơn giao hàng nào</p>
                      </td>
                    </tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach
                      var="order"
                      items="${todayDeliveryOrders}"
                      varStatus="loop">
                      <c:if test="${loop.index < 5}">
                        <tr>
                          <td class="text-center">${loop.index + 1}</td>
                          <td>
                            <strong class="text-primary"
                              >${order.trackingNumber}</strong
                            >
                          </td>
                          <td>${order.contactName}</td>
                          <td>
                            <span
                              class="d-inline-block text-truncate"
                              style="max-width: 220px"
                              title="${order.contactAddress}">
                              ${order.contactAddress}
                            </span>
                          </td>
                          <td class="text-right">
                            <span class="text-danger font-weight-bold">
                              <fmt:formatNumber
                                value="${order.codAmount}"
                                type="currency"
                                currencySymbol=""
                                maxFractionDigits="0" />đ
                            </span>
                          </td>
                          <td class="text-center">
                            <span
                              class="badge badge-${order.statusBadge} px-2 py-1"
                              >${order.statusText}</span
                            >
                          </td>
                          <td class="text-center">
                            <button
                              type="button"
                              class="btn btn-sm btn-info btn-view-detail"
                              data-tracking="${order.trackingNumber}"
                              data-contact-name="${order.contactName}"
                              data-contact-phone="${order.contactPhone}"
                              data-contact-address="${order.contactAddress}"
                              data-cod="${order.codAmount}"
                              data-status="${order.status}"
                              data-status-text="${order.statusText}"
                              data-status-badge="${order.statusBadge}"
                              data-task-type="${order.taskType}"
                              title="Xem chi tiết">
                              <i class="fas fa-eye"></i>
                            </button>
                          </td>
                        </tr>
                      </c:if>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Row 5: Widgets -->
  <div class="row">
    <!-- Quick Actions -->
    <div class="col-lg-4 mb-4">
      <div class="card shadow h-100">
        <div class="card-header py-3 bg-primary text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-bolt"></i> Thao tác nhanh
          </h6>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-6 mb-3">
              <a
                href="${pageContext.request.contextPath}/shipper/scan"
                class="btn btn-outline-primary btn-block py-3">
                <i class="fas fa-qrcode fa-2x mb-2 d-block"></i>
                Quét mã
              </a>
            </div>
            <div class="col-6 mb-3">
              <a
                href="${pageContext.request.contextPath}/shipper/delivering"
                class="btn btn-outline-warning btn-block py-3">
                <i class="fas fa-truck fa-2x mb-2 d-block"></i>
                Đang giao
              </a>
            </div>
            <div class="col-6 mb-3">
              <a
                href="${pageContext.request.contextPath}/shipper/cod"
                class="btn btn-outline-info btn-block py-3">
                <i class="fas fa-money-bill fa-2x mb-2 d-block"></i>
                Nộp COD
              </a>
            </div>
            <div class="col-6 mb-3">
              <a
                href="${pageContext.request.contextPath}/shipper/history"
                class="btn btn-outline-secondary btn-block py-3">
                <i class="fas fa-history fa-2x mb-2 d-block"></i>
                Lịch sử
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Rating Card -->
    <div class="col-lg-4 mb-4">
      <div class="card shadow h-100">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-warning">
            <i class="fas fa-star"></i> Đánh giá của bạn
          </h6>
        </div>
        <div
          class="card-body text-center d-flex flex-column justify-content-center">
          <div class="h1 mb-2 text-warning">
            <c:forEach begin="1" end="5" var="star">
              <c:choose>
                <c:when test="${star <= shipperRating}"
                  ><i class="fas fa-star"></i
                ></c:when>
                <c:when test="${star - 0.5 <= shipperRating}"
                  ><i class="fas fa-star-half-alt"></i
                ></c:when>
                <c:otherwise><i class="far fa-star"></i></c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
          <h4 class="text-gray-800">
            ${shipperRating != null ? shipperRating : '0'}/5.0
          </h4>
          <p class="text-muted mb-0">
            Dựa trên ${totalRatings != null ? totalRatings : 0} đánh giá
          </p>
        </div>
      </div>
    </div>

    <!-- Earnings Summary -->
    <div class="col-lg-4 mb-4">
      <div class="card shadow h-100">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-info">
            <i class="fas fa-wallet"></i> Thu nhập tháng này
          </h6>
        </div>
        <div class="card-body">
          <h4 class="text-center text-success mb-3">
            <fmt:formatNumber
              value="${monthlyEarnings != null ? monthlyEarnings : 0}"
              type="currency"
              currencySymbol=""
              maxFractionDigits="0" />đ
          </h4>
          <div class="row text-center mb-3">
            <div class="col-6">
              <small class="text-muted d-block">Đơn hoàn thành</small>
              <h5 class="mb-0">${monthlyOrders != null ? monthlyOrders : 0}</h5>
            </div>
            <div class="col-6">
              <small class="text-muted d-block">Tỷ lệ thành công</small>
              <h5 class="text-success mb-0">
                ${successRate != null ? successRate : 0}%
              </h5>
            </div>
          </div>
          <a
            href="${pageContext.request.contextPath}/shipper/earnings"
            class="btn btn-info btn-block">
            <i class="fas fa-chart-line"></i> Xem chi tiết
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Modal Cập nhật trạng thái Pickup -->
<div
  class="modal fade"
  id="updatePickupModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="pickupUpdateForm" method="POST" action="">
        <div class="modal-header bg-warning text-white">
          <h5 class="modal-title">
            <i class="fas fa-edit"></i> Cập nhật trạng thái lấy hàng
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
          <div class="form-group row mb-3">
            <label class="col-sm-4 col-form-label font-weight-bold"
              >Mã đơn:</label
            >
            <div class="col-sm-8">
              <span
                id="pickupTrackingNumber"
                class="form-control-plaintext text-primary font-weight-bold"></span>
            </div>
          </div>
          <div class="form-group row mb-3">
            <label class="col-sm-4 col-form-label font-weight-bold"
              >Trạng thái hiện tại:</label
            >
            <div class="col-sm-8">
              <span
                id="currentPickupStatus"
                class="badge badge-secondary px-3 py-2"></span>
            </div>
          </div>
          <div class="form-group">
            <label for="newPickupStatus" class="font-weight-bold"
              >Chọn trạng thái mới:</label
            >
            <select
              class="form-control form-control-lg"
              name="status"
              id="newPickupStatus"
              required>
              <option value="">-- Chọn trạng thái --</option>
              <option value="in_progress">🔄 Đang lấy hàng</option>
              <option value="completed">✅ Đã lấy hàng thành công</option>
              <option value="failed">❌ Lấy hàng thất bại</option>
            </select>
          </div>
          <div class="form-group" id="noteGroup" style="display: none">
            <label for="pickupNote" class="font-weight-bold"
              >Lý do thất bại:</label
            >
            <textarea
              class="form-control"
              name="note"
              id="pickupNote"
              rows="3"
              placeholder="Nhập lý do thất bại..."></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">
            <i class="fas fa-times"></i> Hủy
          </button>
          <button type="submit" class="btn btn-warning">
            <i class="fas fa-save"></i> Cập nhật
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Modal Xem chi tiết đơn hàng -->
<div
  class="modal fade"
  id="viewDetailModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title">
          <i class="fas fa-info-circle"></i> Chi tiết đơn hàng
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
          <!-- Cột trái -->
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-light">
                <strong><i class="fas fa-box"></i> Thông tin đơn hàng</strong>
              </div>
              <div class="card-body">
                <table class="table table-sm table-borderless mb-0">
                  <tr>
                    <td class="text-muted" width="40%">Mã đơn:</td>
                    <td>
                      <strong id="detailTracking" class="text-primary"></strong>
                    </td>
                  </tr>
                  <tr>
                    <td class="text-muted">Loại:</td>
                    <td><span id="detailTaskType" class="badge"></span></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Trạng thái:</td>
                    <td><span id="detailStatus" class="badge"></span></td>
                  </tr>
                  <tr>
                    <td class="text-muted">COD:</td>
                    <td>
                      <strong id="detailCod" class="text-danger"></strong>
                    </td>
                  </tr>
                </table>
              </div>
            </div>
          </div>

          <!-- Cột phải -->
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-light">
                <strong
                  ><i class="fas fa-user"></i>
                  <span id="detailContactLabel">Thông tin liên hệ</span></strong
                >
              </div>
              <div class="card-body">
                <table class="table table-sm table-borderless mb-0">
                  <tr>
                    <td class="text-muted" width="35%">Họ tên:</td>
                    <td><strong id="detailContactName"></strong></td>
                  </tr>
                  <tr>
                    <td class="text-muted">Điện thoại:</td>
                    <td>
                      <a id="detailContactPhoneLink" href="#">
                        <i class="fas fa-phone"></i>
                        <span id="detailContactPhone"></span>
                      </a>
                    </td>
                  </tr>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Địa chỉ -->
        <div class="card">
          <div class="card-header bg-light">
            <strong
              ><i class="fas fa-map-marker-alt"></i>
              <span id="detailAddressLabel">Địa chỉ</span></strong
            >
          </div>
          <div class="card-body">
            <p id="detailContactAddress" class="mb-0"></p>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">
          <i class="fas fa-times"></i> Đóng
        </button>
        <a id="detailMapLink" href="#" target="_blank" class="btn btn-success">
          <i class="fas fa-map"></i> Xem bản đồ
        </a>
        <a id="detailCallLink" href="#" class="btn btn-primary">
          <i class="fas fa-phone"></i> Gọi điện
        </a>
      </div>
    </div>
  </div>
</div>

<!-- Flash Messages -->
<c:if test="${not empty success}">
  <script>
    alert("${success}");
  </script>
</c:if>
<c:if test="${not empty error}">
  <script>
    alert("${error}");
  </script>
</c:if>

<script>
  var contextPath = "${pageContext.request.contextPath}";

  // Mở modal cập nhật trạng thái
  function openPickupModal(taskId, trackingNumber, currentStatus) {
    document.getElementById("pickupTrackingNumber").textContent =
      trackingNumber;
    document.getElementById("currentPickupStatus").textContent =
      getStatusText(currentStatus);
    document.getElementById("currentPickupStatus").className =
      "badge badge-" + getStatusBadge(currentStatus) + " px-3 py-2";
    document.getElementById("newPickupStatus").value = "";
    document.getElementById("pickupNote").value = "";
    document.getElementById("noteGroup").style.display = "none";
    document.getElementById("pickupUpdateForm").action =
      contextPath + "/shipper/pickup/" + taskId + "/update";
    $("#updatePickupModal").modal("show");
  }

  // Mở modal xem chi tiết
  function openDetailModal(data) {
    // Thông tin đơn hàng
    document.getElementById("detailTracking").textContent = data.tracking;

    // Loại task
    var taskTypeText = data.taskType === "pickup" ? "Lấy hàng" : "Giao hàng";
    var taskTypeBadge = data.taskType === "pickup" ? "warning" : "success";
    document.getElementById("detailTaskType").textContent = taskTypeText;
    document.getElementById("detailTaskType").className =
      "badge badge-" + taskTypeBadge;

    // Trạng thái
    document.getElementById("detailStatus").textContent = data.statusText;
    document.getElementById("detailStatus").className =
      "badge badge-" + data.statusBadge;

    // COD
    var codAmount = parseFloat(data.cod) || 0;
    document.getElementById("detailCod").textContent =
      formatCurrency(codAmount) + "đ";

    // Contact labels
    var contactLabel = data.taskType === "pickup" ? "Người gửi" : "Người nhận";
    var addressLabel =
      data.taskType === "pickup" ? "Địa chỉ lấy hàng" : "Địa chỉ giao hàng";
    document.getElementById("detailContactLabel").textContent = contactLabel;
    document.getElementById("detailAddressLabel").textContent = addressLabel;

    // Thông tin liên hệ
    document.getElementById("detailContactName").textContent =
      data.contactName || "-";
    document.getElementById("detailContactPhone").textContent =
      data.contactPhone || "-";
    document.getElementById("detailContactPhoneLink").href =
      "tel:" + (data.contactPhone || "");
    document.getElementById("detailContactAddress").textContent =
      data.contactAddress || "-";

    // Links
    document.getElementById("detailCallLink").href =
      "tel:" + (data.contactPhone || "");
    document.getElementById("detailMapLink").href =
      "https://www.google.com/maps/search/?api=1&query=" +
      encodeURIComponent(data.contactAddress || "");

    $("#viewDetailModal").modal("show");
  }

  function formatCurrency(amount) {
    return amount.toLocaleString("vi-VN");
  }

  function getStatusText(status) {
    switch (status) {
      case "assigned":
        return "Chờ xử lý";
      case "in_progress":
        return "Đang xử lý";
      case "completed":
        return "Hoàn thành";
      case "failed":
        return "Thất bại";
      default:
        return status;
    }
  }

  function getStatusBadge(status) {
    switch (status) {
      case "assigned":
        return "warning";
      case "in_progress":
        return "info";
      case "completed":
        return "success";
      case "failed":
        return "danger";
      default:
        return "secondary";
    }
  }

  // Event listeners
  document
    .getElementById("newPickupStatus")
    .addEventListener("change", function () {
      document.getElementById("noteGroup").style.display =
        this.value === "failed" ? "block" : "none";
    });

  document
    .getElementById("pickupUpdateForm")
    .addEventListener("submit", function (e) {
      var status = document.getElementById("newPickupStatus").value;
      var note = document.getElementById("pickupNote").value;

      if (!status) {
        e.preventDefault();
        alert("Vui lòng chọn trạng thái mới!");
        return false;
      }

      if (status === "failed" && !note.trim()) {
        e.preventDefault();
        alert("Vui lòng nhập lý do thất bại!");
        return false;
      }
    });

  document.addEventListener("DOMContentLoaded", function () {
    // Nút cập nhật trạng thái
    document.querySelectorAll(".btn-update-status").forEach(function (btn) {
      btn.addEventListener("click", function () {
        var taskId = this.getAttribute("data-task-id");
        var trackingNumber = this.getAttribute("data-tracking");
        var currentStatus = this.getAttribute("data-status");
        openPickupModal(taskId, trackingNumber, currentStatus);
      });
    });

    // Nút xem chi tiết
    document.querySelectorAll(".btn-view-detail").forEach(function (btn) {
      btn.addEventListener("click", function () {
        var data = {
          tracking: this.getAttribute("data-tracking"),
          contactName: this.getAttribute("data-contact-name"),
          contactPhone: this.getAttribute("data-contact-phone"),
          contactAddress: this.getAttribute("data-contact-address"),
          cod: this.getAttribute("data-cod"),
          status: this.getAttribute("data-status"),
          statusText: this.getAttribute("data-status-text"),
          statusBadge: this.getAttribute("data-status-badge"),
          taskType: this.getAttribute("data-task-type"),
        };
        openDetailModal(data);
      });
    });
  });
</script>
