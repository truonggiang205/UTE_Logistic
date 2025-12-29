<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:choose>
  <c:when test="${not empty actionType}">
    <sitemesh:page title="Sửa trạng thái"/>
    <c:set var="actionUrl" value="/admin/action-types/${actionType.actionTypeId}/edit"/>
  </c:when>
  <c:otherwise>
    <sitemesh:page title="Thêm trạng thái"/>
    <c:set var="actionUrl" value="/admin/action-types/create"/>
  </c:otherwise>
</c:choose>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">
    <c:choose>
      <c:when test="${not empty actionType}">Sửa trạng thái</c:when>
      <c:otherwise>Thêm trạng thái</c:otherwise>
    </c:choose>
  </h3>
  <a class="btn btn-outline-secondary" href="/admin/action-types">Quay lại</a>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<form:form method="post" modelAttribute="actionTypeForm" action="${actionUrl}">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Code</label>
      <form:input path="actionCode" cssClass="form-control"/>
      <form:errors path="actionCode" cssClass="text-danger"/>
    </div>
    <div class="col-md-6">
      <label class="form-label">Name</label>
      <form:input path="actionName" cssClass="form-control"/>
      <form:errors path="actionName" cssClass="text-danger"/>
    </div>
    <div class="col-12">
      <label class="form-label">Mô tả</label>
      <form:textarea path="description" cssClass="form-control" rows="3"/>
    </div>

    <div class="col-12">
      <button class="btn btn-primary" type="submit">Lưu</button>
      <a class="btn btn-secondary" href="/admin/action-types">Hủy</a>
    </div>
  </div>
</form:form>
