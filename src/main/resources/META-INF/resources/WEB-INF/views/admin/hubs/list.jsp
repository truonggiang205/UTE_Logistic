<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Quản lý Hub"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Quản lý Hub</h3>
  <a class="btn btn-primary" href="/admin/hubs/create"><i class="bi bi-plus-lg me-1"></i>Thêm mới</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-success">${message}</div>
</c:if>

<div class="table-responsive">
  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>Hub Name</th>
        <th>Hub Level</th>
        <th>Address</th>
        <th>Status</th>
        <th>Contact Phone</th>
        <th>Email</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${hubs}" var="h">
        <tr>
          <td>${h.hubName}</td>
          <td>
            <c:choose>
              <c:when test="${h.hubLevel == 'central'}">Tổng</c:when>
              <c:otherwise>Con</c:otherwise>
            </c:choose>
          </td>
          <td>${h.address}</td>
          <td>
            <c:choose>
              <c:when test="${h.status == 'active'}"><span class="badge bg-success">Active</span></c:when>
              <c:otherwise><span class="badge bg-secondary">Locked</span></c:otherwise>
            </c:choose>
          </td>
          <td>${h.contactPhone}</td>
          <td>${h.email}</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="/admin/hubs/${h.hubId}/edit">Sửa</a>
            <form method="post" action="/admin/hubs/${h.hubId}/toggle-lock" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-warning" type="submit">
                <c:choose>
                  <c:when test="${h.status == 'active'}">Khóa</c:when>
                  <c:otherwise>Mở</c:otherwise>
                </c:choose>
              </button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
