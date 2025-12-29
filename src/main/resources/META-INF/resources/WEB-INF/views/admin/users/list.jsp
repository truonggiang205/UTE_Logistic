<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Quản lý Users"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Quản lý Users</h3>
  <a class="btn btn-primary" href="/admin/users/create"><i class="bi bi-plus-lg me-1"></i>Thêm User</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-success">${message}</div>
</c:if>

<div class="table-responsive">
  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>Username</th>
        <th>Full Name</th>
        <th>Role</th>
        <th>Hub</th>
        <th>Status</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${users}" var="u">
        <tr>
          <td>${u.username}</td>
          <td>${u.fullName}</td>
          <td>
            <c:forEach items="${u.roles}" var="r">${r.roleName}</c:forEach>
          </td>
          <td>
            <c:choose>
              <c:when test="${u.staff != null && u.staff.hub != null}">${u.staff.hub.hubName}</c:when>
              <c:when test="${u.shipper != null && u.shipper.hub != null}">${u.shipper.hub.hubName}</c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:choose>
              <c:when test="${u.status == 'active'}"><span class="badge bg-success">Active</span></c:when>
              <c:otherwise><span class="badge bg-secondary">Locked</span></c:otherwise>
            </c:choose>
          </td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="/admin/users/${u.userId}/edit">Sửa</a>
            <form method="post" action="/admin/users/${u.userId}/toggle-lock" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-warning" type="submit">
                <c:choose>
                  <c:when test="${u.status == 'active'}">Khóa</c:when>
                  <c:otherwise>Mở</c:otherwise>
                </c:choose>
              </button>
            </form>
            <form method="post" action="/admin/users/${u.userId}/reset-password" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-danger" type="submit">Reset Pass</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
