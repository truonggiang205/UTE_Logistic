<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Trạng thái đơn"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Cấu hình Trạng thái đơn (Action Types)</h3>
  <a class="btn btn-primary" href="/admin/action-types/create"><i class="bi bi-plus-lg me-1"></i>Thêm</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-success">${message}</div>
</c:if>

<div class="table-responsive">
  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>Action Code</th>
        <th>Action Name</th>
        <th>Description</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${actionTypes}" var="a">
        <tr>
          <td>${a.actionCode}</td>
          <td>${a.actionName}</td>
          <td>${a.description}</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="/admin/action-types/${a.actionTypeId}/edit">Sửa</a>
            <form method="post" action="/admin/action-types/${a.actionTypeId}/delete" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-danger" type="submit">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
