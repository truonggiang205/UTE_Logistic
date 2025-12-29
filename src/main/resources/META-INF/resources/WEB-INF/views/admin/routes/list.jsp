<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Quản lý Tuyến"/>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Quản lý Tuyến đường</h3>
  <a class="btn btn-primary" href="/admin/routes/create"><i class="bi bi-plus-lg me-1"></i>Thêm tuyến</a>
</div>

<c:if test="${not empty message}">
  <div class="alert alert-success">${message}</div>
</c:if>

<div class="table-responsive">
  <table class="table table-striped align-middle">
    <thead>
      <tr>
        <th>From Hub</th>
        <th>To Hub</th>
        <th>Estimated Time</th>
        <th>Description</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${routes}" var="r">
        <tr>
          <td>${r.fromHub.hubName}</td>
          <td>${r.toHub.hubName}</td>
          <td>${r.estimatedTime}</td>
          <td>${r.description}</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="/admin/routes/${r.routeId}/edit">Sửa</a>
            <form method="post" action="/admin/routes/${r.routeId}/toggle" style="display:inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
              <button class="btn btn-sm btn-outline-warning" type="submit">
                <c:choose>
                  <c:when test="${r.status == 'active'}">Tạm dừng</c:when>
                  <c:otherwise>Kích hoạt</c:otherwise>
                </c:choose>
              </button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
