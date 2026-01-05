<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-list"></i> Đơn của tôi</h1>
    <a class="btn btn-primary btn-sm shadow-sm" href="<c:url value='/customer/orders/new'/>">
        <i class="fas fa-plus fa-sm text-white-50"></i> Tạo đơn mới
    </a>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Danh sách đơn</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Người nhận</th>
                    <th>Trạng thái</th>
                    <th class="text-right">Tổng phí</th>
                    <th class="text-center">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>#${o.requestId}</td>
                        <td>
                            <c:out value="${o.deliveryAddress.contactName}"/>
                            (<c:out value="${o.deliveryAddress.contactPhone}"/>)
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status == 'pending'}"><span class="badge badge-warning">Chờ lấy hàng</span></c:when>
                                <c:when test="${o.status == 'picked'}"><span class="badge badge-info">Đã lấy hàng</span></c:when>
                                <c:when test="${o.status == 'in_transit'}"><span class="badge badge-primary">Đang vận chuyển</span></c:when>
                                <c:when test="${o.status == 'delivered'}"><span class="badge badge-success">Đã giao</span></c:when>
                                <c:when test="${o.status == 'cancelled'}"><span class="badge badge-danger">Đã hủy</span></c:when>
                                <c:when test="${o.status == 'failed'}"><span class="badge badge-danger">Thất bại</span></c:when>
                                <c:otherwise><span class="badge badge-secondary"><c:out value="${o.status}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-right"><fmt:formatNumber value="${o.totalPrice}" type="number" maxFractionDigits="0"/></td>
                        <td class="text-center">
                            <a class="btn btn-sm btn-outline-primary" href="<c:url value='/customer/orders/${o.requestId}'/>">
                                <i class="fas fa-eye"></i> Xem
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5" class="text-center text-muted">Chưa có đơn nào</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
