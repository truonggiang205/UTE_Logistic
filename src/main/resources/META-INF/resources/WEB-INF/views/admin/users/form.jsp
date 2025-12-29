<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<c:choose>
  <c:when test="${not empty user}">
    <sitemesh:page title="Sửa User"/>
    <c:set var="actionUrl" value="/admin/users/${user.userId}/edit"/>
  </c:when>
  <c:otherwise>
    <sitemesh:page title="Thêm User"/>
    <c:set var="actionUrl" value="/admin/users/create"/>
  </c:otherwise>
</c:choose>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">
    <c:choose>
      <c:when test="${not empty user}">Sửa User</c:when>
      <c:otherwise>Thêm User</c:otherwise>
    </c:choose>
  </h3>
  <a class="btn btn-outline-secondary" href="/admin/users">Quay lại</a>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>

<form:form method="post" modelAttribute="userForm" action="${actionUrl}">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

  <div class="row g-3">
    <div class="col-md-6">
      <label class="form-label">Username</label>
      <form:input path="username" cssClass="form-control"/>
      <form:errors path="username" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Password (bỏ trống nếu không đổi)</label>
      <form:input path="password" cssClass="form-control" type="password"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Họ tên</label>
      <form:input path="fullName" cssClass="form-control"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">SĐT</label>
      <form:input path="phone" cssClass="form-control"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Email</label>
      <form:input path="email" cssClass="form-control"/>
      <form:errors path="email" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Role</label>
      <form:select path="roleName" cssClass="form-select">
        <c:forEach items="${roles}" var="r">
          <option value="${r.roleName}">${r.roleName}</option>
        </c:forEach>
      </form:select>
      <form:errors path="roleName" cssClass="text-danger"/>
    </div>

    <div class="col-md-6">
      <label class="form-label">Status</label>
      <form:select path="status" cssClass="form-select">
        <c:forEach items="${userStatuses}" var="s">
          <option value="${s}">${s}</option>
        </c:forEach>
      </form:select>
    </div>

    <div class="col-12">
      <div class="alert alert-info mb-0">
        Nếu chọn role STAFF, có thể gán Hub + vị trí.
      </div>
    </div>

    <div class="col-md-6">
      <label class="form-label">Hub (chỉ cho STAFF)</label>
      <form:select path="hubId" cssClass="form-select">
        <option value="">-- Không chọn --</option>
        <form:options items="${activeHubs}" itemValue="hubId" itemLabel="hubName"/>
      </form:select>
    </div>

    <div class="col-md-6">
      <label class="form-label">Vị trí (chỉ cho STAFF)</label>
      <form:input path="staffPosition" cssClass="form-control"/>
    </div>

    <div class="col-12">
      <button class="btn btn-primary" type="submit">Lưu</button>
      <a class="btn btn-secondary" href="/admin/users">Hủy</a>
    </div>
  </div>
</form:form>
