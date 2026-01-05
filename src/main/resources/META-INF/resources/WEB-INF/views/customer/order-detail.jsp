<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-receipt"></i> Chi tiết đơn #${order.requestId}</h1>
    <div>
        <c:if test="${order.status == 'pending'}">
            <form method="post" action="<c:url value='/customer/orders/${order.requestId}/cancel'/>" class="d-inline"
                onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn này?');">
                <button type="submit" class="btn btn-danger btn-sm">
                    <i class="fas fa-times"></i> Hủy đơn
                </button>
            </form>
        </c:if>
        <a class="btn btn-secondary btn-sm" href="<c:url value='/customer/orders'/>">
            <i class="fas fa-arrow-left"></i> Danh sách đơn
        </a>
    </div>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="row">
    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-info-circle"></i> Thông tin đơn</h6>
            </div>
            <div class="card-body">
                <p>
                    <strong>Trạng thái:</strong>
                    <c:choose>
                        <c:when test="${order.status == 'pending'}"><span class="badge badge-warning">Chờ lấy hàng</span></c:when>
                        <c:when test="${order.status == 'picked'}"><span class="badge badge-info">Đã lấy hàng</span></c:when>
                        <c:when test="${order.status == 'in_transit'}"><span class="badge badge-primary">Đang vận chuyển</span></c:when>
                        <c:when test="${order.status == 'delivered'}"><span class="badge badge-success">Đã giao</span></c:when>
                        <c:when test="${order.status == 'cancelled'}"><span class="badge badge-danger">Đã hủy</span></c:when>
                        <c:when test="${order.status == 'failed'}"><span class="badge badge-danger">Thất bại</span></c:when>
                        <c:otherwise><span class="badge badge-secondary"><c:out value="${order.status}"/></span></c:otherwise>
                    </c:choose>
                </p>
                <p><strong>Mã vận đơn:</strong>
                    <c:choose>
                        <c:when test="${tracking != null}"><span class="badge badge-primary">${tracking.code}</span></c:when>
                        <c:otherwise><span class="text-muted">Chưa có</span></c:otherwise>
                    </c:choose>
                </p>
                <p><strong>Loại dịch vụ:</strong> <c:out value="${order.serviceType.serviceName}"/></p>
                <p><strong>Tên hàng:</strong> <c:out value="${order.itemName}"/></p>
                <p><strong>Ghi chú:</strong> <c:out value="${order.note}"/></p>
                <c:if test="${not empty createdAtText}">
                    <p><strong>Tạo lúc:</strong> <c:out value="${createdAtText}"/></p>
                </c:if>
            </div>
        </div>
    </div>

    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-money-check-alt"></i> Chi phí</h6>
            </div>
            <div class="card-body">
                <p><strong>Phí vận chuyển:</strong> <fmt:formatNumber value="${order.shippingFee}" type="number" maxFractionDigits="0"/></p>
                <p><strong>Phí COD:</strong> <fmt:formatNumber value="${order.codFee}" type="number" maxFractionDigits="0"/></p>
                <p><strong>Phí bảo hiểm:</strong> <fmt:formatNumber value="${order.insuranceFee}" type="number" maxFractionDigits="0"/></p>
                <hr />
                <p class="h5"><strong>Tổng phí:</strong> <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/></p>
                <p><strong>COD:</strong> <fmt:formatNumber value="${order.codAmount}" type="number" maxFractionDigits="0"/></p>
                <p><strong>Người nhận trả:</strong> <fmt:formatNumber value="${order.receiverPayAmount}" type="number" maxFractionDigits="0"/></p>
                <p><strong>Thanh toán:</strong> <span class="badge badge-secondary">${order.paymentStatus}</span></p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-upload"></i> Lấy hàng</h6>
            </div>
            <div class="card-body">
                <p><strong>Liên hệ:</strong> <c:out value="${order.pickupAddress.contactName}"/> (<c:out value="${order.pickupAddress.contactPhone}"/>)</p>
                <p><strong>Địa chỉ:</strong>
                    <c:out value="${order.pickupAddress.addressDetail}"/>,
                    <c:out value="${order.pickupAddress.ward}"/>,
                    <c:out value="${order.pickupAddress.district}"/>,
                    <c:out value="${order.pickupAddress.province}"/>
                </p>
            </div>
        </div>
    </div>

    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-download"></i> Giao hàng</h6>
            </div>
            <div class="card-body">
                <p><strong>Liên hệ:</strong> <c:out value="${order.deliveryAddress.contactName}"/> (<c:out value="${order.deliveryAddress.contactPhone}"/>)</p>
                <p><strong>Địa chỉ:</strong>
                    <c:out value="${order.deliveryAddress.addressDetail}"/>,
                    <c:out value="${order.deliveryAddress.ward}"/>,
                    <c:out value="${order.deliveryAddress.district}"/>,
                    <c:out value="${order.deliveryAddress.province}"/>
                </p>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-12 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-stream"></i> Lịch sử xử lý</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty actionViews}">
                        <div class="text-muted">Chưa có lịch sử cập nhật.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group">
                            <c:forEach var="a" items="${actionViews}">
                                <div class="list-group-item list-group-item-action flex-column align-items-start">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-1">
                                            <c:out value="${a.actionName}"/>
                                            <c:if test="${not empty a.fromHubName || not empty a.toHubName}">
                                                <small class="text-muted">
                                                    (
                                                    <c:out value="${not empty a.fromHubName ? a.fromHubName : 'N/A'}"/>
                                                    →
                                                    <c:out value="${not empty a.toHubName ? a.toHubName : 'N/A'}"/>
                                                    )
                                                </small>
                                            </c:if>
                                        </h6>
                                        <small class="text-muted"><c:out value="${a.timeText}"/></small>
                                    </div>
                                    <c:if test="${not empty a.actorName}">
                                        <div class="small text-gray-600">Thực hiện bởi: <c:out value="${a.actorName}"/></div>
                                    </c:if>
                                    <c:if test="${not empty a.note}">
                                        <div class="mt-1"><c:out value="${a.note}"/></div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
