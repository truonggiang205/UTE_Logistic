<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-search"></i> Tra cứu vận đơn</h1>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>
<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Nhập mã vận đơn</h6>
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
