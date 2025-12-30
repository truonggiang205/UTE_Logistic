<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<ul
  class="navbar-nav bg-gradient-shipper sidebar sidebar-dark accordion"
  id="accordionSidebar">
  <!-- Sidebar - Brand -->
  <a
    class="sidebar-brand d-flex align-items-center justify-content-center"
    href="${pageContext.request.contextPath}/shipper/dashboard">
    <div class="sidebar-brand-icon">
      <i class="fas fa-motorcycle fa-2x"></i>
    </div>
    <div class="sidebar-brand-text mx-3">Shipper Portal</div>
  </a>

  <hr class="sidebar-divider my-0" />

  <!-- Nav Item - Dashboard -->
  <li class="nav-item ${currentPage == 'dashboard' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/dashboard">
      <i class="fas fa-fw fa-tachometer-alt"></i>
      <span>Dashboard</span>
    </a>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Công việc</div>

  <!-- Nav Item - Đơn hàng được giao -->
  <li class="nav-item ${currentPage == 'orders' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/orders">
      <i class="fas fa-fw fa-box"></i>
      <span>Đơn hàng của tôi</span>
    </a>
  </li>

  <!-- Nav Item - Đơn hàng đang giao -->
  <li class="nav-item ${currentPage == 'delivering' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/delivering">
      <i class="fas fa-fw fa-shipping-fast"></i>
      <span>Đang giao hàng</span>
    </a>
  </li>

  <!-- Nav Item - Lịch sử giao hàng -->
  <li class="nav-item ${currentPage == 'history' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/history">
      <i class="fas fa-fw fa-history"></i>
      <span>Lịch sử giao hàng</span>
    </a>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Tài chính</div>

  <!-- Nav Item - COD -->
  <li class="nav-item ${currentPage == 'cod' ? 'active' : ''}">
    <a class="nav-link" href="${pageContext.request.contextPath}/shipper/cod">
      <i class="fas fa-fw fa-money-bill-wave"></i>
      <span>Tiền thu hộ (COD)</span>
    </a>
  </li>

  <!-- Nav Item - Thu nhập -->
  <li class="nav-item ${currentPage == 'earnings' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/earnings">
      <i class="fas fa-fw fa-wallet"></i>
      <span>Thu nhập</span>
    </a>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Cá nhân</div>

  <!-- Nav Item - Thông tin cá nhân -->
  <li class="nav-item ${currentPage == 'profile' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/profile">
      <i class="fas fa-fw fa-user"></i>
      <span>Thông tin cá nhân</span>
    </a>
  </li>

  <!-- Nav Item - Phương tiện -->
  <li class="nav-item ${currentPage == 'vehicle' ? 'active' : ''}">
    <a
      class="nav-link"
      href="${pageContext.request.contextPath}/shipper/vehicle">
      <i class="fas fa-fw fa-motorcycle"></i>
      <span>Phương tiện</span>
    </a>
  </li>

  <hr class="sidebar-divider d-none d-md-block" />

  <!-- Sidebar Toggler -->
  <div class="text-center d-none d-md-inline">
    <button class="rounded-circle border-0" id="sidebarToggle"></button>
  </div>
</ul>
