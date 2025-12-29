<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Đổi mật khẩu"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Đổi mật khẩu</h3>
  <a class="btn btn-outline-secondary" href="/admin/profile">Quay lại</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-warning">${message}</div>
</c:if>

<form method="post" action="/admin/change-password" class="card">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
  <div class="card-body">
    <div class="mb-3">
      <label class="form-label">Mật khẩu hiện tại</label>
      <input class="form-control" type="password" name="currentPassword" required />
    </div>
    <div class="mb-3">
      <label class="form-label">Mật khẩu mới</label>
      <input class="form-control" type="password" name="newPassword" required />
    </div>
    <div class="mb-3">
      <label class="form-label">Xác nhận mật khẩu mới</label>
      <input class="form-control" type="password" name="confirmPassword" required />
    </div>
    <button class="btn btn-primary" type="submit">Cập nhật</button>
  </div>
</form>
