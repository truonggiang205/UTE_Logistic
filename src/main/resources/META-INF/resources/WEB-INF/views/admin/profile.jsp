<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Profile"/>

<h3 class="mb-3">Profile</h3>

<c:if test="${not empty message}">
  <div class="alert alert-info">${message}</div>
</c:if>

<div class="card">
  <div class="card-body">
    <c:choose>
      <c:when test="${not empty me}">
        <div><strong>Username:</strong> ${me.username}</div>
        <div><strong>Họ tên:</strong> ${me.fullName}</div>
        <div><strong>Email:</strong> ${me.email}</div>
        <div><strong>SĐT:</strong> ${me.phone}</div>
        <div><strong>Status:</strong> ${me.status}</div>
      </c:when>
      <c:otherwise>
        <div class="text-muted">Không tải được thông tin tài khoản.</div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<div class="mt-3">
  <a class="btn btn-outline-primary" href="/admin/change-password">Đổi mật khẩu</a>
</div>
