<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">
            <i class="fas fa-eye text-primary"></i> Chi tiết đơn hàng (Cảnh báo rủi ro)
        </h1>
        <a class="btn btn-sm btn-secondary shadow-sm" href="${pageContext.request.contextPath}/admin/risk-alerts">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Quay lại
        </a>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            <i class="fas fa-times-circle"></i> ${errorMessage}
        </div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="row">
            <div class="col-lg-6 mb-4">
                <div class="card shadow">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Thông tin đơn</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-2"><b>Mã đơn:</b> #${order.requestId}</div>
                        <div class="mb-2"><b>Mã vận đơn:</b> <c:out value="${order.trackingCode}"/></div>
                        <div class="mb-2"><b>Trạng thái:</b> <c:out value="${order.statusDisplay}"/></div>
                        <div class="mb-2"><b>Loại dịch vụ:</b> <c:out value="${order.serviceTypeName}"/></div>
                        <div class="mb-2"><b>Ngày tạo:</b> <span class="dt" data-dt="${order.createdAt}">${order.createdAt}</span></div>
                        <div class="mb-2"><b>Dự kiến lấy hàng:</b> <span class="dt" data-dt="${order.expectedPickupTime}">${order.expectedPickupTime}</span></div>
                        <div class="mb-2"><b>ETA dự kiến:</b> <span class="dt" data-dt="${order.estimatedDeliveryTime}">${order.estimatedDeliveryTime}</span></div>
                        <div class="mb-2"><b>Ghi chú:</b> <c:out value="${order.note}"/></div>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 mb-4">
                <div class="card shadow">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Người gửi / Người nhận</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-2"><b>Người gửi:</b> <c:out value="${order.senderName}"/> — <c:out value="${order.senderPhone}"/></div>
                        <div class="mb-2"><b>Địa chỉ lấy:</b> <c:out value="${order.pickupAddress}"/></div>
                        <hr/>
                        <div class="mb-2"><b>Người nhận:</b> <c:out value="${order.receiverName}"/> — <c:out value="${order.receiverPhone}"/></div>
                        <div class="mb-2"><b>Địa chỉ giao:</b> <c:out value="${order.deliveryAddress}"/></div>
                        <hr/>
                        <div class="mb-2"><b>Hub hiện tại:</b> <c:out value="${order.currentHubName}"/></div>
                        <div class="mb-2"><b>Địa chỉ hub:</b> <c:out value="${order.currentHubAddress}"/></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12 mb-4">
                <div class="card shadow">
                    <div class="card-header py-3 d-flex align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Lịch sử hành trình</h6>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty order.actionHistory}">
                            <div class="text-muted">Chưa có lịch sử hành trình.</div>
                        </c:if>
                        <c:if test="${not empty order.actionHistory}">
                            <div class="table-responsive">
                                <table class="table table-sm table-hover">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Thời gian</th>
                                            <th>Hành động</th>
                                            <th>Từ hub</th>
                                            <th>Đến hub</th>
                                            <th>Thực hiện bởi</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${order.actionHistory}" var="a">
                                            <tr>
                                                <td><span class="dt" data-dt="${a.actionTime}">${a.actionTime}</span></td>
                                                <td><c:out value="${a.actionName}"/></td>
                                                <td><c:out value="${a.fromHubName}"/></td>
                                                <td><c:out value="${a.toHubName}"/></td>
                                                <td>
                                                    <c:out value="${a.actorName}"/>
                                                    <c:if test="${not empty a.actorPhone}">
                                                        <small class="text-muted">(<c:out value="${a.actorPhone}"/>)</small>
                                                    </c:if>
                                                </td>
                                                <td><c:out value="${a.note}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script>
    (function () {
        function formatDateTime(iso) {
            if (!iso) return '';
            var d = new Date(iso);
            if (isNaN(d.getTime())) return iso;
            return d.toLocaleString('vi-VN');
        }

        var nodes = document.querySelectorAll('.dt');
        nodes.forEach(function (el) {
            var v = el.getAttribute('data-dt');
            if (!v || v === 'null') {
                el.textContent = '-';
                return;
            }
            el.textContent = formatDateTime(v);
        });
    })();
</script>
