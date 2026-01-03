<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <!-- Back Button & Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-sm btn-outline-secondary mr-2">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <span class="h4 mb-0 text-gray-800">
                <i class="fas fa-box text-primary"></i> Chi tiết đơn hàng
            </span>
        </div>
        <div>
            <span class="badge badge-${order.statusBadge} px-3 py-2" style="font-size: 1rem;">
                ${order.statusText}
            </span>
        </div>
    </div>

    <div class="row">
        <!-- Left Column -->
        <div class="col-lg-8">
            <!-- Order Info Card -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white">
                    <h6 class="m-0 font-weight-bold">
                        <i class="fas fa-info-circle"></i> Thông tin đơn hàng
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-borderless table-sm">
                                <tr>
                                    <td class="text-muted" width="40%">Mã vận đơn:</td>
                                    <td><strong class="text-primary">${order.trackingNumber}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Tên hàng:</td>
                                    <td><strong>${order.itemName}</strong></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Loại dịch vụ:</td>
                                    <td>${order.serviceTypeName != null ? order.serviceTypeName : 'Tiêu chuẩn'}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Nhiệm vụ:</td>
                                    <td>
                                        <span class="badge badge-${order.taskType == 'pickup' ? 'warning' : 'info'}">
                                            ${order.taskTypeText}
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-borderless table-sm">
                                <tr>
                                    <td class="text-muted" width="40%">Trạng thái task:</td>
                                    <td><span class="badge badge-${order.statusBadge}">${order.taskStatusText}</span></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Ngày tạo:</td>
                                    <td>${order.createdAt}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Ngày giao:</td>
                                    <td>${order.assignedAt}</td>
                                </tr>
                                <c:if test="${order.completedAt != null}">
                                <tr>
                                    <td class="text-muted">Hoàn thành:</td>
                                    <td>${order.completedAt}</td>
                                </tr>
                                </c:if>
                            </table>
                        </div>
                    </div>
                    <c:if test="${order.note != null && !order.note.isEmpty()}">
                        <div class="alert alert-info mt-2 mb-0">
                            <i class="fas fa-sticky-note"></i> <strong>Ghi chú:</strong> ${order.note}
                        </div>
                    </c:if>
                    <c:if test="${order.resultNote != null && !order.resultNote.isEmpty()}">
                        <div class="alert alert-secondary mt-2 mb-0">
                            <i class="fas fa-comment-dots"></i> <strong>Kết quả:</strong> ${order.resultNote}
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Sender & Receiver -->
            <div class="row">
                <!-- Người gửi -->
                <div class="col-md-6">
                    <div class="card shadow mb-4 border-left-warning">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-warning">
                                <i class="fas fa-user-tag"></i> Người gửi
                            </h6>
                        </div>
                        <div class="card-body">
                            <p class="mb-2">
                                <i class="fas fa-user text-muted"></i>
                                <strong>${order.senderName}</strong>
                            </p>
                            <p class="mb-2">
                                <i class="fas fa-phone text-muted"></i>
                                <a href="tel:${order.senderPhone}">${order.senderPhone}</a>
                            </p>
                            <p class="mb-0 small text-muted">
                                <i class="fas fa-map-marker-alt"></i>
                                ${order.senderAddress}
                            </p>
                            <c:if test="${order.taskType == 'pickup'}">
                                <hr>
                                <div class="d-flex">
                                    <a href="tel:${order.senderPhone}" class="btn btn-sm btn-outline-primary mr-2">
                                        <i class="fas fa-phone"></i> Gọi
                                    </a>
                                    <a href="https://www.google.com/maps/search/?api=1&query=${order.senderAddress}" 
                                       target="_blank" class="btn btn-sm btn-outline-info">
                                        <i class="fas fa-map-marked-alt"></i> Bản đồ
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Người nhận -->
                <div class="col-md-6">
                    <div class="card shadow mb-4 border-left-success">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-success">
                                <i class="fas fa-user-check"></i> Người nhận
                            </h6>
                        </div>
                        <div class="card-body">
                            <p class="mb-2">
                                <i class="fas fa-user text-muted"></i>
                                <strong>${order.receiverName}</strong>
                            </p>
                            <p class="mb-2">
                                <i class="fas fa-phone text-muted"></i>
                                <a href="tel:${order.receiverPhone}">${order.receiverPhone}</a>
                            </p>
                            <p class="mb-0 small text-muted">
                                <i class="fas fa-map-marker-alt"></i>
                                ${order.receiverAddress}
                            </p>
                            <c:if test="${order.taskType == 'delivery'}">
                                <hr>
                                <div class="d-flex">
                                    <a href="tel:${order.receiverPhone}" class="btn btn-sm btn-outline-primary mr-2">
                                        <i class="fas fa-phone"></i> Gọi
                                    </a>
                                    <a href="https://www.google.com/maps/search/?api=1&query=${order.receiverAddress}" 
                                       target="_blank" class="btn btn-sm btn-outline-info">
                                        <i class="fas fa-map-marked-alt"></i> Bản đồ
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Package Size -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-gray-800">
                        <i class="fas fa-box-open"></i> Kích thước & Trọng lượng
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col">
                            <div class="border rounded p-3">
                                <div class="text-muted small">Khối lượng</div>
                                <div class="h5 mb-0">
                                    <fmt:formatNumber value="${order.weight}" maxFractionDigits="2"/> kg
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="border rounded p-3">
                                <div class="text-muted small">Dài × Rộng × Cao</div>
                                <div class="h5 mb-0">
                                    <fmt:formatNumber value="${order.length}" maxFractionDigits="0"/> × 
                                    <fmt:formatNumber value="${order.width}" maxFractionDigits="0"/> × 
                                    <fmt:formatNumber value="${order.height}" maxFractionDigits="0"/> cm
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <div class="border rounded p-3">
                                <div class="text-muted small">KL quy đổi</div>
                                <div class="h5 mb-0">
                                    <fmt:formatNumber value="${order.chargeableWeight}" maxFractionDigits="2"/> kg
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Fees & Actions -->
        <div class="col-lg-4">
            <!-- COD Card -->
            <div class="card shadow mb-4 border-left-danger">
                <div class="card-header py-3 bg-danger text-white">
                    <h6 class="m-0 font-weight-bold">
                        <i class="fas fa-money-bill-wave"></i> Thu hộ (COD)
                    </h6>
                </div>
                <div class="card-body text-center">
                    <div class="h2 mb-0 font-weight-bold text-danger">
                        <fmt:formatNumber value="${order.codAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                    </div>
                    <div class="text-muted small mt-2">
                        <span class="badge badge-${order.paymentStatus == 'paid' ? 'success' : 'warning'}">
                            ${order.paymentStatusText}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Fee Breakdown -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-gray-800">
                        <i class="fas fa-receipt"></i> Chi phí
                    </h6>
                </div>
                <div class="card-body">
                    <table class="table table-borderless table-sm mb-0">
                        <tr>
                            <td class="text-muted">Phí vận chuyển:</td>
                            <td class="text-right">
                                <fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Phí COD:</td>
                            <td class="text-right">
                                <fmt:formatNumber value="${order.codFee}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Phí bảo hiểm:</td>
                            <td class="text-right">
                                <fmt:formatNumber value="${order.insuranceFee}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </td>
                        </tr>
                        <tr class="border-top">
                            <td class="font-weight-bold">Tổng cước:</td>
                            <td class="text-right font-weight-bold text-primary">
                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </td>
                        </tr>
                        <tr class="bg-light">
                            <td class="font-weight-bold">Người nhận trả:</td>
                            <td class="text-right font-weight-bold text-success">
                                <fmt:formatNumber value="${order.receiverPayAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- Actions -->
            <c:if test="${order.taskStatus == 'assigned' || order.taskStatus == 'in_progress'}">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-gray-800">
                            <i class="fas fa-cogs"></i> Thao tác
                        </h6>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${order.taskType == 'pickup'}">
                                <form method="POST" action="${pageContext.request.contextPath}/shipper/pickup/${order.taskId}/update">
                                    <input type="hidden" name="from" value="orders/${order.taskId}">
                                    <c:if test="${order.taskStatus == 'assigned'}">
                                        <button type="submit" name="status" value="in_progress" class="btn btn-warning btn-block mb-2">
                                            <i class="fas fa-play"></i> Bắt đầu lấy hàng
                                        </button>
                                    </c:if>
                                    <c:if test="${order.taskStatus == 'in_progress'}">
                                        <button type="submit" name="status" value="completed" class="btn btn-success btn-block mb-2">
                                            <i class="fas fa-check"></i> Đã lấy xong
                                        </button>
                                    </c:if>
                                    <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#failModal">
                                        <i class="fas fa-times"></i> Lấy hàng thất bại
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form method="POST" action="${pageContext.request.contextPath}/shipper/delivery/${order.taskId}/update">
                                    <input type="hidden" name="from" value="orders/${order.taskId}">
                                    <c:if test="${order.taskStatus == 'assigned'}">
                                        <button type="submit" name="status" value="in_progress" class="btn btn-info btn-block mb-2">
                                            <i class="fas fa-truck"></i> Bắt đầu giao hàng
                                        </button>
                                    </c:if>
                                    <c:if test="${order.taskStatus == 'in_progress'}">
                                        <button type="submit" name="status" value="completed" class="btn btn-success btn-block mb-2">
                                            <i class="fas fa-check-circle"></i> Đã giao thành công
                                        </button>
                                    </c:if>
                                    <button type="button" class="btn btn-danger btn-block" data-toggle="modal" data-target="#failModal">
                                        <i class="fas fa-times"></i> Giao hàng thất bại
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <!-- Customer Info -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-gray-800">
                        <i class="fas fa-user-tie"></i> Khách hàng
                    </h6>
                </div>
                <div class="card-body">
                    <p class="mb-1"><strong>${order.customerName}</strong></p>
                    <p class="mb-1 text-muted small">${order.customerPhone}</p>
                    <p class="mb-0 text-muted small">${order.customerEmail}</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Thất bại -->
<div class="modal fade" id="failModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <form method="POST" action="${pageContext.request.contextPath}/shipper/${order.taskType}/${order.taskId}/update">
                <input type="hidden" name="status" value="failed">
                <input type="hidden" name="from" value="orders">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-times-circle"></i> Báo thất bại</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="font-weight-bold">Lý do thất bại <span class="text-danger">*</span>:</label>
                        <textarea class="form-control" name="note" rows="3" required 
                                  placeholder="VD: Khách không nghe máy, Sai địa chỉ..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="fas fa-times"></i> Xác nhận thất bại</button>
                </div>
            </form>
        </div>
    </div>
</div>
