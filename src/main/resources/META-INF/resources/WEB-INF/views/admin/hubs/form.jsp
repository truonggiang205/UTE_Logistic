<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:choose>
  <c:when test="${not empty hub}">
    <sitemesh:page title="Sửa Hub"/>
    <c:set var="actionUrl" value="/admin/hubs/${hub.hubId}/edit"/>
  </c:when>
  <c:otherwise>
    <sitemesh:page title="Thêm Hub"/>
    <c:set var="actionUrl" value="/admin/hubs/create"/>
  </c:otherwise>
</c:choose>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">
    <c:choose>
      <c:when test="${not empty hub}">Sửa Hub</c:when>
      <c:otherwise>Thêm Hub</c:otherwise>
    </c:choose>
  </h3>
  <a class="btn btn-outline-secondary" href="/admin/hubs">Quay lại</a>
</div>

<form:form method="post" modelAttribute="hubForm" action="${actionUrl}">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Tên Hub</label>
      <form:input path="hubName" cssClass="form-control"/>
      <form:errors path="hubName" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Loại</label>
      <form:select path="hubLevel" cssClass="form-select">
        <option value="central">Tổng</option>
        <option value="regional">Con</option>
        <option value="local">Con</option>
      </form:select>
      <form:errors path="hubLevel" cssClass="text-danger"/>
    </div>

    <div class="col-12">
      <label class="form-label">Địa chỉ</label>
      <form:input path="address" cssClass="form-control"/>
      <form:errors path="address" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">SĐT</label>
      <form:input path="contactPhone" cssClass="form-control"/>
      <form:errors path="contactPhone" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Email</label>
      <form:input path="email" cssClass="form-control"/>
      <form:errors path="email" cssClass="text-danger"/>
    </div>

    <div class="col-12">
      <button class="btn btn-primary" type="submit">Lưu</button>
      <a class="btn btn-secondary" href="/admin/hubs">Hủy</a>
    </div>
  </div>
</form:form>
