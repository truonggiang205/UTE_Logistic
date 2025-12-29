<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<sitemesh:page title="Đăng nhập"/>

<div class="row justify-content-center">
  <div class="col-md-6 col-lg-5">
    <div class="card">
      <div class="card-body">
        <h4 class="card-title mb-3">Đăng nhập</h4>

        <c:if test="${param.error != null}">
          <div class="alert alert-danger">Sai tài khoản hoặc mật khẩu</div>
        </c:if>
        <c:if test="${param.logout != null}">
          <div class="alert alert-success">Đã đăng xuất</div>
        </c:if>

        <form method="post" action="/auth/login">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

          <div class="mb-3">
            <label class="form-label">Username</label>
            <input class="form-control" name="username" autocomplete="username" required />
          </div>
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input class="form-control" type="password" name="password" autocomplete="current-password" required />
          </div>

          <button class="btn btn-primary w-100" type="submit">Login</button>
        </form>
      </div>
    </div>
  </div>
</div>
