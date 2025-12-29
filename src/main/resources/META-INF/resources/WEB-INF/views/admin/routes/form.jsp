<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:choose>
  <c:when test="${not empty route}">
    <sitemesh:page title="Sửa tuyến"/>
    <c:set var="actionUrl" value="/admin/routes/${route.routeId}/edit"/>
  </c:when>
  <c:otherwise>
    <sitemesh:page title="Thêm tuyến"/>
    <c:set var="actionUrl" value="/admin/routes/create"/>
  </c:otherwise>
</c:choose>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">
    <c:choose>
      <c:when test="${not empty route}">Sửa tuyến</c:when>
      <c:otherwise>Thêm tuyến</c:otherwise>
    </c:choose>
  </h3>
  <a class="btn btn-outline-secondary" href="/admin/routes">Quay lại</a>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<form:form method="post" modelAttribute="routeForm" action="${actionUrl}">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Hub xuất phát (From Hub)</label>
      <form:select path="fromHubId" cssClass="form-select">
        <form:options items="${activeHubs}" itemValue="hubId" itemLabel="hubName"/>
      </form:select>
      <form:errors path="fromHubId" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Hub nhận (To Hub)</label>
      <form:select path="toHubId" cssClass="form-select">
        <form:options items="${activeHubs}" itemValue="hubId" itemLabel="hubName"/>
      </form:select>
      <form:errors path="toHubId" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Thời gian dự kiến (Estimated Time)</label>
      <form:input path="leadTime" cssClass="form-control" type="number"/>
      <div class="form-text">Đơn vị: ngày</div>
      <form:errors path="leadTime" cssClass="text-danger"/>
    </div>

    <div class="col-12">
      <label class="form-label">Mô tả</label>
      <form:textarea path="description" cssClass="form-control" rows="3"/>
    </div>

    <div class="col-12">
      <button class="btn btn-primary" type="submit">Lưu</button>
      <a class="btn btn-secondary" href="/admin/routes">Hủy</a>
    </div>
  </div>
</form:form>
