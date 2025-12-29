<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="navbar navbar-dark bg-dark border-bottom border-secondary">
  <div class="container-fluid">
    <a class="navbar-brand d-flex align-items-center" href="/admin">
      <i class="bi bi-buildings me-2"></i>
      <span class="fw-semibold">Company Logo</span>
    </a>

    <div class="d-flex align-items-center gap-2">
      <div class="dropdown">
        <button class="btn btn-dark" type="button" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="bi bi-bell"></i>
          <span class="badge text-bg-danger ms-1">0</span>
        </button>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><h6 class="dropdown-header">Thông báo</h6></li>
          <li><span class="dropdown-item-text text-muted">Không có thông báo mới</span></li>
        </ul>
      </div>

      <a class="btn btn-dark" href="/admin/profile" title="Profile"><i class="bi bi-person"></i></a>
      <a class="btn btn-dark" href="/admin/settings" title="Settings"><i class="bi bi-gear"></i></a>
      <a class="btn btn-dark" href="/auth/logout" title="Logout"><i class="bi bi-box-arrow-right"></i></a>

      <div class="dropdown">
        <button class="btn btn-dark d-flex align-items-center" type="button" data-bs-toggle="dropdown" aria-expanded="false">
          <span class="me-2">
            <c:out value="${pageContext.request.userPrincipal != null ? pageContext.request.userPrincipal.name : 'Admin'}"/>
          </span>
          <span class="rounded-circle bg-secondary d-inline-flex align-items-center justify-content-center" style="width:32px;height:32px;">
            <i class="bi bi-person-fill"></i>
          </span>
        </button>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item" href="/admin/profile">Profile</a></li>
          <li><a class="dropdown-item" href="/admin/change-password">Đổi mật khẩu</a></li>
          <li><hr class="dropdown-divider" /></li>
          <li><a class="dropdown-item" href="/auth/logout">Đăng xuất</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>
