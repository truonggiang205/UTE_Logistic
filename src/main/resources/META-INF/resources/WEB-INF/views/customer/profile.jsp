<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-user"></i> Hồ sơ</h1>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Thông tin cá nhân</h6>
    </div>
    <div class="card-body">
        <form method="post" action="<c:url value='/customer/profile'/>">
            <div class="form-group">
                <label>Họ và tên</label>
                <input class="form-control" name="fullName" value="${form.fullName}" required />
            </div>

            <div class="form-group">
                <label>Email</label>
                <input class="form-control" name="email" value="${form.email}" type="email" />
                <small class="text-muted">Nếu thay email, hệ thống sẽ dùng email mới để đăng nhập (nếu không trùng).</small>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input class="form-control" name="phone" value="${form.phone}" required />
            </div>

            <button class="btn btn-primary" type="submit"><i class="fas fa-save"></i> Lưu thay đổi</button>
        </form>
    </div>
</div>
