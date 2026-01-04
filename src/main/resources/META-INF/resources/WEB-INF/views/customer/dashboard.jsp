<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
        <i class="fas fa-home"></i> Tổng quan khách hàng
    </h1>
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

<div class="row">
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng đơn</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${totalOrders}</div>
                    </div>
                    <div class="col-auto"><i class="fas fa-box fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Chờ lấy hàng</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingCount}</div>
                    </div>
                    <div class="col-auto"><i class="fas fa-clock fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Đang vận chuyển</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${inTransitCount}</div>
                    </div>
                    <div class="col-auto"><i class="fas fa-truck fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Đã giao</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${deliveredCount}</div>
                    </div>
                    <div class="col-auto"><i class="fas fa-check-circle fa-2x text-gray-300"></i></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-search"></i> Tra cứu vận đơn</h6>
            </div>
            <div class="card-body">
                <form method="post" action="<c:url value='/customer/tracking'/>">
                    <div class="form-group">
                        <label>Mã vận đơn</label>
                        <input class="form-control" name="code" placeholder="VD: LOG260104-XXXX-123" />
                    </div>
                    <button class="btn btn-primary" type="submit"><i class="fas fa-search"></i> Tra cứu</button>
                </form>
            </div>
        </div>
    </div>

    <div class="col-lg-6 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-history"></i> Đơn gần đây</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="text-muted">Chưa có đơn nào. Hãy tạo đơn đầu tiên!</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-sm table-hover">
                                <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Trạng thái</th>
                                    <th class="text-right">Tổng phí</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td>
                                            <a href="<c:url value='/customer/orders/${o.requestId}'/>">#${o.requestId}</a>
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
                                        <td class="text-right">
                                            <fmt:formatNumber value="${o.totalPrice}" type="number" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <a class="btn btn-link p-0" href="<c:url value='/customer/orders'/>">Xem tất cả</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
