<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:choose>
  <c:when test="${not empty role}">
    <sitemesh:page title="Sửa Role"/>
    <c:set var="actionUrl" value="/admin/roles/${role.roleId}/edit"/>
  </c:when>
  <c:otherwise>
    <sitemesh:page title="Tạo Role"/>
    <c:set var="actionUrl" value="/admin/roles/create"/>
  </c:otherwise>
</c:choose>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">
    <c:choose>
      <c:when test="${not empty role}">Sửa Role</c:when>
      <c:otherwise>Tạo Role</c:otherwise>
    </c:choose>
  </h3>
  <a class="btn btn-outline-secondary" href="/admin/roles">Quay lại</a>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<form:form method="post" modelAttribute="roleForm" action="${actionUrl}">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Role Name</label>
      <form:input path="roleName" cssClass="form-control"/>
      <form:errors path="roleName" cssClass="text-danger"/>
    </div>
    <div class="col-12">
      <label class="form-label">Mô tả</label>
      <form:textarea path="description" cssClass="form-control" rows="3"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Status</label>
      <form:select path="status" cssClass="form-select">
        <c:forEach items="${roleStatuses}" var="s">
          <option value="${s}">${s}</option>
        </c:forEach>
      </form:select>
    </div>
    <div class="col-12">
      <button class="btn btn-primary" type="submit">Lưu</button>
      <a class="btn btn-secondary" href="/admin/roles">Hủy</a>
    </div>
  </div>
</form:form>
