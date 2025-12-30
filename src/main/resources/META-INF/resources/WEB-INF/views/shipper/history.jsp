<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">
            <i class="fas fa-history text-secondary"></i> Lịch sử giao hàng
        </h1>
    </div>

    <!-- Filter -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form class="row" method="GET" action="${pageContext.request.contextPath}/shipper/history">
                <div class="col-md-3 mb-2">
                    <label class="small">Từ ngày</label>
                    <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                </div>
                <div class="col-md-3 mb-2">
                    <label class="small">Đến ngày</label>
                    <input type="date" class="form-control" name="toDate" value="${toDate}">
                </div>
                <div class="col-md-3 mb-2">
                    <label class="small">Trạng thái</label>
                    <select class="form-control" name="status">
                        <option value="">Tất cả</option>
                        <option value="delivered" ${status == 'delivered' ? 'selected' : ''}>Đã giao</option>
                        <option value="failed" ${status == 'failed' ? 'selected' : ''}>Thất bại</option>
                        <option value="returned" ${status == 'returned' ? 'selected' : ''}>Hoàn hàng</option>
                    </select>
                </div>
                <div class="col-md-3 mb-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-success mr-2">
                        <i class="fas fa-search"></i> Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/shipper/history" class="btn btn-secondary">
                        <i class="fas fa-redo"></i> Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Statistics -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Đã giao</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${deliveredCount != null ? deliveredCount : 0}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Thất bại</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${failedCount != null ? failedCount : 0}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-times-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Hoàn hàng</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${returnedCount != null ? returnedCount : 0}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-undo fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- History Table -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Mã đơn</th>
                            <th>Người nhận</th>
                            <th>Địa chỉ</th>
                            <th>COD</th>
                            <th>Trạng thái</th>
                            <th>Thời gian</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="fas fa-history fa-3x text-gray-300 mb-3"></i>
                                        <p class="text-muted">Chưa có lịch sử giao hàng</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>
                                            <strong class="text-primary">${order.trackingNumber}</strong>
                                            <br><small class="text-muted">${order.taskTypeText}</small>
                                        </td>
                                        <td>
                                            ${order.contactName}<br>
                                            <small class="text-muted">${order.contactPhone}</small>
                                        </td>
                                        <td class="text-truncate" style="max-width: 150px;" title="${order.contactAddress}">
                                            ${order.contactAddress}
                                        </td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${order.codAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'completed'}">
                                                    <span class="badge badge-success">✅ Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${order.status == 'failed'}">
                                                    <span class="badge badge-danger">❌ Thất bại</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary">${order.statusText}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <small>${order.statusText}</small>
                                        </td>
                                        <td class="text-truncate" style="max-width: 100px;">
                                            -
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
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPageNum == 0 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPageNum - 1}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">Trước</a>
                        </li>
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <li class="page-item ${currentPageNum == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">${i + 1}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPageNum == totalPages - 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPageNum + 1}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">Sau</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>
