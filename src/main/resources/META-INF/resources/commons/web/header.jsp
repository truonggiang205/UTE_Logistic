<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="/">
      <i class="bi bi-play-circle-fill me-2"></i>Video Website
    </a>
    <button
      class="navbar-toggler"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link" href="/">
            <i class="bi bi-house-door me-1"></i>Trang Chủ
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/category">
            <i class="bi bi-collection-play me-1"></i>Sản phẩm
          </a>
        </li>
        
        <c:choose>
          <c:when test="${not empty sessionScope.currentUser}">
            <!-- User đã đăng nhập -->
            <c:if test="${sessionScope.currentUser.admin}">
              <li class="nav-item">
                <a class="nav-link" href="/admin">
                  <i class="bi bi-gear me-1"></i>Trang quản trị
                </a>
              </li>
            </c:if>
            
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                 data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.fullName}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li>
                  <a class="dropdown-item" href="/profile">
                    <i class="bi bi-person me-2"></i>Thông tin cá nhân
                  </a>
                </li>
                <li>
                  <a class="dropdown-item" href="/my-videos">
                    <i class="bi bi-collection-play me-2"></i>Video của tôi
                  </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                  <a class="dropdown-item text-danger" href="/auth/logout">
                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                  </a>
                </li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <!-- User chưa đăng nhập -->
            <li class="nav-item">
              <a class="nav-link" href="/auth/login">
                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
