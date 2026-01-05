<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <!-- Flash Messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> ${success}
            <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> ${error}
            <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
        </div>
    </c:if>

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">
            <i class="fas fa-money-bill-wave text-info"></i> Quản lý tiền thu hộ (COD + Cước)
        </h1>
    </div>

    <!-- COD Summary -->
    <div class="row mb-4">
        <div class="col-lg-4">
            <div class="card bg-danger text-white shadow h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-uppercase mb-1 font-weight-bold">Tổng tiền cần nộp (COD+Cước)</div>
                            <div class="h3 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${totalUnpaidCod != null ? totalUnpaidCod : 0}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card bg-success text-white shadow h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-uppercase mb-1 font-weight-bold">Đã nộp hôm nay</div>
                            <div class="h3 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${todayPaidCod != null ? todayPaidCod : 0}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card bg-info text-white shadow h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-uppercase mb-1 font-weight-bold">Số đơn chờ nộp</div>
                            <div class="h3 mb-0 font-weight-bold">
                                ${unpaidOrdersCount != null ? unpaidOrdersCount : 0} đơn
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clipboard-list fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Unpaid COD Orders -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center bg-danger text-white">
            <h6 class="m-0 font-weight-bold">
                <i class="fas fa-money-bill"></i> Danh sách COD chưa nộp
            </h6>
            <button class="btn btn-light btn-sm" data-toggle="modal" data-target="#submitCodModal">
                <i class="fas fa-hand-holding-usd"></i> Nộp COD
            </button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th><input type="checkbox" id="selectAllCod"></th>
                            <th>Mã đơn</th>
                            <th>Người nhận</th>
                            <th>Số tiền COD</th>
                            <th>Ngày giao</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty unpaidOrders}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                        <p class="text-success font-weight-bold">Không có COD nào cần nộp!</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="order" items="${unpaidOrders}">
                                    <tr>
                                        <td><input type="checkbox" name="codOrderId" value="${order.id}" data-amount="${order.codAmount}"></td>
                                        <td><strong>${order.trackingNumber}</strong></td>
                                        <td>${order.contactName}</td>
                                        <td class="text-right text-danger font-weight-bold">
                                            <fmt:formatNumber value="${order.codAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                        </td>
                                        <td>
                                            ${order.statusText}
                                        </td>
                                        <td><span class="badge badge-warning">Chờ nộp</span></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                    <c:if test="${not empty unpaidOrders}">
                        <tfoot class="bg-light">
                            <tr>
                                <td colspan="3" class="text-right font-weight-bold">Tổng đã chọn:</td>
                                <td class="text-right text-danger font-weight-bold" id="selectedTotal">0đ</td>
                                <td colspan="2"></td>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
            </div>
        </div>
    </div>

    <!-- COD History -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 bg-success text-white d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold">
                <i class="fas fa-history"></i> Lịch sử nộp COD
            </h6>
            <span class="badge badge-light">
                Tổng: ${historyTotalElements != null ? historyTotalElements : 0} giao dịch
            </span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="thead-light">
                        <tr>
                            <th>Mã giao dịch</th>
                            <th>Số tiền</th>
                            <th>Số đơn</th>
                            <th>Thời gian nộp</th>
                            <th>Người nhận</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty codHistory}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Chưa có lịch sử nộp COD
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="transaction" items="${codHistory}">
                                    <tr>
                                        <td><strong>${transaction.transactionCode}</strong></td>
                                        <td class="text-right text-success font-weight-bold">
                                            <fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                                        </td>
                                        <td class="text-center">${transaction.orderCount}</td>
                                        <td>
                                            ${transaction.submittedAt}
                                        </td>
                                        <td>${transaction.receiverName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${transaction.status == 'collected'}">
                                                    <span class="badge badge-warning">Chờ duyệt</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-success">Đã xác nhận</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            
            <!-- Phân trang lịch sử -->
            <c:if test="${historyTotalPages > 1}">
                <nav aria-label="Phân trang lịch sử COD">
                    <ul class="pagination justify-content-center mb-0">
                        <!-- Previous -->
                        <li class="page-item ${historyPage == 0 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/shipper/cod?page=${historyPage - 1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        
                        <!-- Page numbers -->
                        <c:forEach begin="0" end="${historyTotalPages - 1}" var="i">
                            <c:if test="${i >= historyPage - 2 && i <= historyPage + 2}">
                                <li class="page-item ${i == historyPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/shipper/cod?page=${i}">
                                        ${i + 1}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                        
                        <!-- Next -->
                        <li class="page-item ${historyPage >= historyTotalPages - 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/shipper/cod?page=${historyPage + 1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p class="text-center text-muted small mt-2 mb-0">
                    Trang ${historyPage + 1} / ${historyTotalPages}
                </p>
            </c:if>
        </div>
    </div>
</div>

<!-- Submit COD Modal -->
<div class="modal fade" id="submitCodModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">Nộp tiền COD</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form id="submitCodForm" method="POST" action="${pageContext.request.contextPath}/shipper/cod/submit">
                <div class="modal-body">
                    <div class="alert alert-info">
                        <strong>Tổng tiền cần nộp:</strong>
                        <span id="modalTotalAmount" class="float-right font-weight-bold">0đ</span>
                    </div>
                    
                    <input type="hidden" name="orderIds" id="selectedOrderIds">
                    <input type="hidden" name="totalAmount" id="totalAmountInput">
                    
                    <div class="form-group">
                        <label>Phương thức nộp</label>
                        <select class="form-control" name="paymentMethod" required>
                            <option value="cash">Tiền mặt</option>
                            <option value="transfer">Chuyển khoản</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea class="form-control" name="note" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-info">
                        <i class="fas fa-hand-holding-usd"></i> Xác nhận nộp
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Calculate selected COD total
    function updateSelectedTotal() {
        var checkboxes = document.querySelectorAll('input[name="codOrderId"]:checked');
        var total = 0;
        var orderIds = [];
        
        checkboxes.forEach(function(cb) {
            total += parseFloat(cb.dataset.amount);
            orderIds.push(cb.value);
        });
        
        var formattedTotal = new Intl.NumberFormat('vi-VN').format(total) + 'đ';
        document.getElementById('selectedTotal').innerText = formattedTotal;
        document.getElementById('modalTotalAmount').innerText = formattedTotal;
        document.getElementById('selectedOrderIds').value = orderIds.join(',');
        document.getElementById('totalAmountInput').value = total;
    }
    
    // Select all checkbox
    document.getElementById('selectAllCod').addEventListener('change', function() {
        var checkboxes = document.querySelectorAll('input[name="codOrderId"]');
        checkboxes.forEach(function(cb) {
            cb.checked = this.checked;
        }, this);
        updateSelectedTotal();
    });
    
    // Individual checkbox change
    document.querySelectorAll('input[name="codOrderId"]').forEach(function(cb) {
        cb.addEventListener('change', updateSelectedTotal);
    });
</script>
