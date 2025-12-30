<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Topbar -->
<nav
  class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
  <!-- Sidebar Toggle (Topbar) -->
  <button
    id="sidebarToggleTop"
    class="btn btn-link d-md-none rounded-circle mr-3">
    <i class="fa fa-bars"></i>
  </button>

  <!-- Topbar Title -->
  <div class="d-none d-sm-inline-block">
    <h5 class="m-0 text-success font-weight-bold">
      <i class="fas fa-motorcycle mr-2"></i>Shipper Portal
    </h5>
  </div>

  <!-- Topbar Navbar -->
  <ul class="navbar-nav ml-auto">
    <!-- Nav Item - Notifications -->
    <li class="nav-item dropdown no-arrow mx-1">
      <a
        class="nav-link dropdown-toggle"
        href="#"
        id="alertsDropdown"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false">
        <i class="fas fa-bell fa-fw"></i>
        <!-- Counter - Alerts -->
        <span class="badge badge-danger badge-counter" id="notificationCount"
          >0</span
        >
      </a>
      <!-- Dropdown - Alerts -->
      <div
        class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
        aria-labelledby="alertsDropdown">
        <h6 class="dropdown-header bg-success">Thông báo đơn hàng</h6>
        <div id="notificationList">
          <a class="dropdown-item d-flex align-items-center" href="#">
            <div class="mr-3">
              <div class="icon-circle bg-primary">
                <i class="fas fa-box text-white"></i>
              </div>
            </div>
            <div>
              <div class="small text-gray-500">Hôm nay</div>
              <span>Bạn có đơn hàng mới cần giao!</span>
            </div>
          </a>
        </div>
        <a
          class="dropdown-item text-center small text-gray-500"
          href="${pageContext.request.contextPath}/shipper/notifications">
          Xem tất cả thông báo
        </a>
      </div>
    </li>

    <!-- Nav Item - Quick Actions -->
    <li class="nav-item dropdown no-arrow mx-1">
      <a
        class="nav-link dropdown-toggle"
        href="#"
        id="quickActionsDropdown"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false">
        <i class="fas fa-bolt fa-fw"></i>
      </a>
      <!-- Dropdown - Quick Actions -->
      <div
        class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
        aria-labelledby="quickActionsDropdown">
        <h6 class="dropdown-header bg-success">Thao tác nhanh</h6>
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/scan">
          <i class="fas fa-qrcode fa-sm fa-fw mr-2 text-gray-400"></i>
          Quét mã đơn hàng
        </a>
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/delivering">
          <i class="fas fa-shipping-fast fa-sm fa-fw mr-2 text-gray-400"></i>
          Đơn đang giao
        </a>
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/cod">
          <i class="fas fa-money-bill-wave fa-sm fa-fw mr-2 text-gray-400"></i>
          Nộp tiền COD
        </a>
      </div>
    </li>

    <div class="topbar-divider d-none d-sm-block"></div>

    <!-- Nav Item - User Information -->
    <li class="nav-item dropdown no-arrow">
      <a
        class="nav-link dropdown-toggle"
        href="#"
        id="userDropdown"
        role="button"
        data-toggle="dropdown"
        aria-haspopup="true"
        aria-expanded="false">
        <span class="mr-2 d-none d-lg-inline text-gray-600 small">
          <sec:authentication property="principal.username" var="username" />
          ${username}
        </span>
        <img
          class="img-profile rounded-circle"
          src="${pageContext.request.contextPath}/static/img/undraw_profile.svg" />
      </a>
      <!-- Dropdown - User Information -->
      <div
        class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
        aria-labelledby="userDropdown">
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/profile">
          <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
          Thông tin cá nhân
        </a>
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/vehicle">
          <i class="fas fa-motorcycle fa-sm fa-fw mr-2 text-gray-400"></i>
          Phương tiện
        </a>
        <a
          class="dropdown-item"
          href="${pageContext.request.contextPath}/shipper/earnings">
          <i class="fas fa-wallet fa-sm fa-fw mr-2 text-gray-400"></i>
          Thu nhập
        </a>
        <div class="dropdown-divider"></div>
        <a
          class="dropdown-item"
          href="#"
          data-toggle="modal"
          data-target="#logoutModal">
          <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
          Đăng xuất
        </a>
      </div>
    </li>
  </ul>
</nav>
<!-- End of Topbar -->

<!-- Logout Modal-->
<div
  class="modal fade"
  id="logoutModal"
  tabindex="-1"
  role="dialog"
  aria-labelledby="exampleModalLabel"
  aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Bạn muốn đăng xuất?</h5>
        <button
          class="close"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">Chọn "Đăng xuất" để kết thúc phiên làm việc.</div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">
          Hủy
        </button>
        <a
          class="btn btn-success"
          href="${pageContext.request.contextPath}/logout"
          >Đăng xuất</a
        >
      </div>
    </div>
  </div>
</div>
