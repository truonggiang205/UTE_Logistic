<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Quản lý Roles"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Quản lý Roles</h3>
  <a class="btn btn-primary" href="/admin/roles/create"><i class="bi bi-plus-lg me-1"></i>Tạo mới</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-success">${message}</div>
</c:if>

<div class="table-responsive">
  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>Role Name</th>
        <th>Description</th>
        <th>Status</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${roles}" var="r">
        <tr>
          <td>${r.roleName}</td>
          <td>${r.description}</td>
          <td>
            <c:choose>
              <c:when test="${r.status == 'active'}"><span class="badge bg-success">Active</span></c:when>
              <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
            </c:choose>
          </td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="/admin/roles/${r.roleId}/edit">Sửa</a>
            <form method="post" action="/admin/roles/${r.roleId}/delete" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-danger" type="submit">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
