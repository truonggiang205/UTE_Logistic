<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Flash Messages -->
<c:if test="${not empty success}">
  <div class="alert alert-success alert-dismissible fade show mx-3 mt-3" role="alert">
    <i class="fas fa-check-circle"></i> ${success}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
  </div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-danger alert-dismissible fade show mx-3 mt-3" role="alert">
    <i class="fas fa-exclamation-circle"></i> ${error}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
  </div>
</c:if>

<div class="container-fluid">
  <!-- Page Heading -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-box text-primary"></i> Đơn hàng của tôi
    </h1>
    <span class="badge badge-primary px-3 py-2">
      <i class="fas fa-list"></i> Tổng: ${allOrdersCount != null ? allOrdersCount : 0} đơn
    </span>
  </div>

  <!-- Statistics Cards -->
  <div class="row mb-4">
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng cộng</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${allOrdersCount != null ? allOrdersCount : 0}</div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pickup</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${pickupCount != null ? pickupCount : 0}</div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Delivery</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${deliveryCount != null ? deliveryCount : 0}</div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Đang xử lý</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${inProgressCount != null ? inProgressCount : 0}</div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Hoàn thành</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${completedCount != null ? completedCount : 0}</div>
        </div>
      </div>
    </div>
    <div class="col-xl-2 col-md-4 col-6 mb-3">
      <div class="card border-left-danger shadow h-100 py-2">
        <div class="card-body py-2">
          <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Thất bại</div>
          <div class="h5 mb-0 font-weight-bold text-gray-800">${failedCount != null ? failedCount : 0}</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Filter Form -->
  <div class="card shadow mb-4">
    <div class="card-header py-3 bg-light">
      <h6 class="m-0 font-weight-bold text-primary">
        <i class="fas fa-filter"></i> Bộ lọc & Tìm kiếm
      </h6>
    </div>
    <div class="card-body">
      <form method="GET" action="${pageContext.request.contextPath}/shipper/orders" id="filterForm">
        <div class="row">
          <!-- Tìm kiếm -->
          <div class="col-md-4 mb-3">
            <label for="search" class="font-weight-bold small">Tìm kiếm:</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="fas fa-search"></i></span>
              </div>
              <input type="text" name="search" id="search" class="form-control" 
                     placeholder="Mã đơn, SĐT, tên khách..." value="${search}">
            </div>
          </div>
          <!-- Loại đơn -->
          <div class="col-md-3 mb-3">
            <label for="taskType" class="font-weight-bold small">Loại đơn:</label>
            <select name="taskType" id="taskType" class="form-control">
              <option value="all" ${selectedTaskType == 'all' ? 'selected' : ''}>Tất cả</option>
              <option value="pickup" ${selectedTaskType == 'pickup' ? 'selected' : ''}>Lấy hàng</option>
              <option value="delivery" ${selectedTaskType == 'delivery' ? 'selected' : ''}>Giao hàng</option>
            </select>
          </div>
          <!-- Trạng thái -->
          <div class="col-md-3 mb-3">
            <label for="status" class="font-weight-bold small">Trạng thái:</label>
            <select name="status" id="status" class="form-control">
              <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>Tất cả</option>
              <option value="assigned" ${selectedStatus == 'assigned' ? 'selected' : ''}>Chờ xử lý</option>
              <option value="in_progress" ${selectedStatus == 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
              <option value="completed" ${selectedStatus == 'completed' ? 'selected' : ''}>Hoàn thành</option>
              <option value="failed" ${selectedStatus == 'failed' ? 'selected' : ''}>Thất bại</option>
            </select>
          </div>
          <!-- Buttons -->
          <div class="col-md-2 mb-3">
            <label class="d-block small">&nbsp;</label>
            <button type="submit" class="btn btn-primary btn-block">
              <i class="fas fa-search"></i> Tìm
            </button>
          </div>
        </div>
        <c:if test="${not empty search || selectedTaskType != 'all' || selectedStatus != 'all'}">
          <div class="mt-2">
            <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-outline-secondary btn-sm">
              <i class="fas fa-times"></i> Xóa bộ lọc
            </a>
            <span class="text-muted ml-2 small">
              Tìm thấy <strong>${totalOrders}</strong> kết quả
            </span>
          </div>
        </c:if>
      </form>
    </div>
  </div>

  <!-- Orders Table -->
  <div class="card shadow mb-4">
    <div class="card-header py-3 d-flex justify-content-between align-items-center">
      <h6 class="m-0 font-weight-bold text-primary">
        <i class="fas fa-list"></i> Danh sách đơn hàng
        <span class="badge badge-secondary ml-2">${totalOrders != null ? totalOrders : 0} đơn</span>
      </h6>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-bordered table-hover" id="ordersTable" width="100%">
          <thead class="thead-dark">
            <tr>
              <th width="5%">#</th>
              <th width="12%">Mã đơn</th>
              <th width="10%">Loại</th>
              <th width="15%">Liên hệ</th>
              <th width="25%">Địa chỉ</th>
              <th width="10%">COD</th>
              <th width="10%">Trạng thái</th>
              <th width="13%">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty orders}">
                <tr>
                  <td colspan="8" class="text-center text-muted py-5">
                    <i class="fas fa-inbox fa-3x mb-3 d-block text-gray-300"></i>
                    <h5>Không có đơn hàng nào</h5>
                    <p class="mb-0">Thử thay đổi bộ lọc để xem thêm đơn hàng</p>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="order" items="${orders}" varStatus="loop">
                  <tr>
                    <td class="text-center">${loop.index + 1}</td>
                    <td><strong class="text-primary">${order.trackingNumber}</strong></td>
                    <td class="text-center">
                      <c:choose>
                        <c:when test="${order.taskType == 'pickup'}">
                          <span class="badge badge-warning px-2 py-1">
                            <i class="fas fa-hand-holding-box"></i> Lấy hàng
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-success px-2 py-1">
                            <i class="fas fa-shipping-fast"></i> Giao hàng
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <strong>${order.contactName}</strong><br>
                      <small class="text-muted">
                        <a href="tel:${order.contactPhone}">
                          <i class="fas fa-phone"></i> ${order.contactPhone}
                        </a>
                      </small>
                    </td>
                    <td>
                      <span class="d-inline-block text-truncate" style="max-width: 250px;" title="${order.contactAddress}">
                        ${order.contactAddress}
                      </span>
                    </td>
                    <td class="text-right">
                      <span class="text-danger font-weight-bold">
                        <fmt:formatNumber value="${order.codAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                      </span>
                    </td>
                    <td class="text-center">
                      <span class="badge badge-${order.statusBadge} px-2 py-1">${order.statusText}</span>
                    </td>
                    <td class="text-center">
                      <div class="btn-group" role="group">
                        <button type="button" class="btn btn-sm btn-info btn-view-detail"
                                data-task-id="${order.taskId}"
                                data-tracking="${order.trackingNumber}"
                                data-item-name="${order.itemName}"
                                data-contact-name="${order.contactName}"
                                data-contact-phone="${order.contactPhone}"
                                data-contact-address="${order.contactAddress}"
                                data-cod="${order.codAmount}"
                                data-status="${order.status}"
                                data-status-text="${order.statusText}"
                                data-status-badge="${order.statusBadge}"
                                data-task-type="${order.taskType}"
                                data-task-type-text="${order.taskTypeText}"
                                title="Xem chi tiết">
                          <i class="fas fa-eye"></i>
                        </button>
                        <c:if test="${order.status != 'completed' && order.status != 'failed'}">
                          <button type="button" class="btn btn-sm btn-warning btn-update-status"
                                  data-task-id="${order.taskId}"
                                  data-tracking="${order.trackingNumber}"
                                  data-status="${order.status}"
                                  data-task-type="${order.taskType}"
                                  title="Cập nhật trạng thái">
                            <i class="fas fa-edit"></i>
                          </button>
                        </c:if>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
      
      <!-- Pagination -->
      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-4">
          <div class="text-muted small">
            Hiển thị ${pageNumber * pageSize + 1} - ${pageNumber * pageSize + orders.size()} / ${totalOrders} đơn
          </div>
          <nav aria-label="Page navigation">
            <ul class="pagination pagination-sm mb-0">
              <!-- First Page -->
              <li class="page-item ${pageNumber == 0 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/shipper/orders?page=0&taskType=${selectedTaskType}&status=${selectedStatus}&search=${search}">
                  <i class="fas fa-angle-double-left"></i>
                </a>
              </li>
              <!-- Previous Page -->
              <li class="page-item ${pageNumber == 0 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/shipper/orders?page=${pageNumber - 1}&taskType=${selectedTaskType}&status=${selectedStatus}&search=${search}">
                  <i class="fas fa-angle-left"></i>
                </a>
              </li>
              
              <!-- Page Numbers -->
              <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <c:if test="${i == pageNumber || i == pageNumber - 1 || i == pageNumber + 1 || i == 0 || i == totalPages - 1}">
                  <c:if test="${i == pageNumber - 1 && pageNumber > 2}">
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                  </c:if>
                  <li class="page-item ${pageNumber == i ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/shipper/orders?page=${i}&taskType=${selectedTaskType}&status=${selectedStatus}&search=${search}">
                      ${i + 1}
                    </a>
                  </li>
                  <c:if test="${i == pageNumber + 1 && pageNumber < totalPages - 3}">
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                  </c:if>
                </c:if>
              </c:forEach>
              
              <!-- Next Page -->
              <li class="page-item ${pageNumber == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/shipper/orders?page=${pageNumber + 1}&taskType=${selectedTaskType}&status=${selectedStatus}&search=${search}">
                  <i class="fas fa-angle-right"></i>
                </a>
              </li>
              <!-- Last Page -->
              <li class="page-item ${pageNumber == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}/shipper/orders?page=${totalPages - 1}&taskType=${selectedTaskType}&status=${selectedStatus}&search=${search}">
                  <i class="fas fa-angle-double-right"></i>
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </c:if>
      
    </div>
  </div>
</div>

<!-- Modal Xem chi tiết -->
<div class="modal fade" id="viewDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title"><i class="fas fa-info-circle"></i> Chi tiết đơn hàng</h5>
        <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-light"><strong><i class="fas fa-box"></i> Thông tin đơn hàng</strong></div>
              <div class="card-body">
                <table class="table table-sm table-borderless mb-0">
                  <tr><td class="text-muted" width="40%">Mã đơn:</td><td><strong id="detailTracking" class="text-primary"></strong></td></tr>
                  <tr><td class="text-muted">Loại:</td><td><span id="detailTaskType" class="badge"></span></td></tr>
                  <tr><td class="text-muted">Trạng thái:</td><td><span id="detailStatus" class="badge"></span></td></tr>
                  <tr><td class="text-muted">COD:</td><td><strong id="detailCod" class="text-danger"></strong></td></tr>
                </table>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-light"><strong><i class="fas fa-user"></i> <span id="detailContactLabel">Thông tin liên hệ</span></strong></div>
              <div class="card-body">
                <table class="table table-sm table-borderless mb-0">
                  <tr><td class="text-muted" width="35%">Họ tên:</td><td><strong id="detailContactName"></strong></td></tr>
                  <tr><td class="text-muted">Điện thoại:</td><td><a id="detailContactPhoneLink" href="#"><i class="fas fa-phone"></i> <span id="detailContactPhone"></span></a></td></tr>
                </table>
              </div>
            </div>
          </div>
        </div>
        <div class="card">
          <div class="card-header bg-light"><strong><i class="fas fa-map-marker-alt"></i> <span id="detailAddressLabel">Địa chỉ</span></strong></div>
          <div class="card-body"><p id="detailContactAddress" class="mb-0"></p></div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Đóng</button>
        <a id="detailMapLink" href="#" target="_blank" class="btn btn-success"><i class="fas fa-map"></i> Xem bản đồ</a>
        <a id="detailCallLink" href="#" class="btn btn-primary"><i class="fas fa-phone"></i> Gọi điện</a>
      </div>
    </div>
  </div>
</div>

<!-- Modal Cập nhật trạng thái -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="statusUpdateForm" method="POST" action="">
        <div class="modal-header bg-warning text-white">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Cập nhật trạng thái</h5>
          <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
        </div>
        <div class="modal-body">
          <div class="form-group row mb-3">
            <label class="col-sm-4 col-form-label font-weight-bold">Mã đơn:</label>
            <div class="col-sm-8"><span id="updateTracking" class="form-control-plaintext text-primary font-weight-bold"></span></div>
          </div>
          <div class="form-group">
            <label for="newStatus" class="font-weight-bold">Chọn trạng thái mới:</label>
            <select class="form-control form-control-lg" name="status" id="newStatus" required>
              <option value="">-- Chọn trạng thái --</option>
              <option value="in_progress">Đang xử lý</option>
              <option value="completed">Hoàn thành</option>
              <option value="failed">Thất bại</option>
            </select>
          </div>
          <div class="form-group" id="noteGroup" style="display: none">
            <label for="updateNote" class="font-weight-bold">Lý do thất bại:</label>
            <textarea class="form-control" name="note" id="updateNote" rows="3" placeholder="Nhập lý do..."></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Hủy</button>
          <button type="submit" class="btn btn-warning"><i class="fas fa-save"></i> Cập nhật</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
var contextPath = '${pageContext.request.contextPath}';

// View Detail Modal
function openDetailModal(data) {
  document.getElementById('detailTracking').textContent = data.tracking;
  var taskTypeText = data.taskType === 'pickup' ? 'Lấy hàng' : 'Giao hàng';
  var taskTypeBadge = data.taskType === 'pickup' ? 'warning' : 'success';
  document.getElementById('detailTaskType').textContent = taskTypeText;
  document.getElementById('detailTaskType').className = 'badge badge-' + taskTypeBadge;
  document.getElementById('detailStatus').textContent = data.statusText;
  document.getElementById('detailStatus').className = 'badge badge-' + data.statusBadge;
  var codAmount = parseFloat(data.cod) || 0;
  document.getElementById('detailCod').textContent = codAmount.toLocaleString('vi-VN') + 'đ';
  var contactLabel = data.taskType === 'pickup' ? 'Người gửi' : 'Người nhận';
  var addressLabel = data.taskType === 'pickup' ? 'Địa chỉ lấy hàng' : 'Địa chỉ giao hàng';
  document.getElementById('detailContactLabel').textContent = contactLabel;
  document.getElementById('detailAddressLabel').textContent = addressLabel;
  document.getElementById('detailContactName').textContent = data.contactName || '-';
  document.getElementById('detailContactPhone').textContent = data.contactPhone || '-';
  document.getElementById('detailContactPhoneLink').href = 'tel:' + (data.contactPhone || '');
  document.getElementById('detailContactAddress').textContent = data.contactAddress || '-';
  document.getElementById('detailCallLink').href = 'tel:' + (data.contactPhone || '');
  document.getElementById('detailMapLink').href = 'https://www.google.com/maps/search/?api=1&query=' + encodeURIComponent(data.contactAddress || '');
  $('#viewDetailModal').modal('show');
}

// Update Status Modal
function openUpdateModal(taskId, tracking, taskType) {
  document.getElementById('updateTracking').textContent = tracking;
  document.getElementById('newStatus').value = '';
  document.getElementById('updateNote').value = '';
  document.getElementById('noteGroup').style.display = 'none';
  // Chọn endpoint dựa trên taskType
  var endpoint = taskType === 'pickup' ? '/shipper/pickup/' : '/shipper/delivery/';
  document.getElementById('statusUpdateForm').action = contextPath + endpoint + taskId + '/update';
  $('#updateStatusModal').modal('show');
}

document.getElementById('newStatus').addEventListener('change', function() {
  document.getElementById('noteGroup').style.display = this.value === 'failed' ? 'block' : 'none';
});

document.getElementById('statusUpdateForm').addEventListener('submit', function(e) {
  var status = document.getElementById('newStatus').value;
  var note = document.getElementById('updateNote').value;
  if (!status) { e.preventDefault(); alert('Vui lòng chọn trạng thái!'); return; }
  if (status === 'failed' && !note.trim()) { e.preventDefault(); alert('Vui lòng nhập lý do thất bại!'); return; }
});

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.btn-view-detail').forEach(function(btn) {
    btn.addEventListener('click', function() {
      openDetailModal({
        tracking: this.getAttribute('data-tracking'),
        contactName: this.getAttribute('data-contact-name'),
        contactPhone: this.getAttribute('data-contact-phone'),
        contactAddress: this.getAttribute('data-contact-address'),
        cod: this.getAttribute('data-cod'),
        status: this.getAttribute('data-status'),
        statusText: this.getAttribute('data-status-text'),
        statusBadge: this.getAttribute('data-status-badge'),
        taskType: this.getAttribute('data-task-type')
      });
    });
  });
  
  document.querySelectorAll('.btn-update-status').forEach(function(btn) {
    btn.addEventListener('click', function() {
      openUpdateModal(
        this.getAttribute('data-task-id'),
        this.getAttribute('data-tracking'),
        this.getAttribute('data-task-type')
      );
    });
  });
});
</script>
