<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="<c:url value='/manager/dashboard'/>">
    <div class="sidebar-brand-icon rotate-n-15">
      <i class="fas fa-user-tie"></i>
    </div>
    <div class="sidebar-brand-text mx-3">Manager Portal</div>
  </a>

  <hr class="sidebar-divider my-0" />

  <li class="nav-item">
    <a class="nav-link" href="<c:url value='/manager/dashboard'/>">
      <i class="fas fa-fw fa-chart-line"></i>
      <span>Tổng quan (KPIs)</span>
    </a>
  </li>

  <li class="nav-item">
    <a class="nav-link" href="<c:url value='/manager/tracking'/>">
      <i class="fas fa-fw fa-search"></i>
      <span>Tra cứu vận đơn</span>
    </a>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Kho &amp; Vận chuyển</div>

  <li class="nav-item">
    <a class="nav-link" href="<c:url value='/manager/hub-orders'/>">
      <i class="fas fa-fw fa-boxes"></i>
      <span>Quản lý Đơn hàng</span>
    </a>
  </li>

  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseInbound" aria-expanded="true"
      aria-controls="collapseInbound">
      <i class="fas fa-fw fa-arrow-circle-down"></i>
      <span>1. Nhập kho (Inbound)</span>
    </a>
    <div id="collapseInbound" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Tác nghiệp:</h6>
        <a class="collapse-item" href="<c:url value='/manager/inbound/scan-in'/>">Quét nhập kho</a>
        <a class="collapse-item" href="<c:url value='/manager/inbound/drop-off'/>">Tạo đơn tại quầy</a>
        <a class="collapse-item" href="<c:url value='/manager/inbound/hub-in'/>">Nhập từ xe tải (Hub)</a>
        <a class="collapse-item" href="<c:url value='/manager/inbound/shipper-in'/>">Shipper bàn giao</a>
      </div>
    </div>
  </li>

  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseOutbound" aria-expanded="true"
      aria-controls="collapseOutbound">
      <i class="fas fa-fw fa-arrow-circle-up"></i>
      <span>2. Xuất kho (Outbound)</span>
    </a>
    <div id="collapseOutbound" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Tác nghiệp:</h6>
        <a class="collapse-item" href="<c:url value='/manager/outbound/consolidate'/>">Đóng bao (Consolidate)</a>
        <a class="collapse-item" href="<c:url value='/manager/outbound/loading'/>">Xếp bao vào xe (Loading)</a>
        <a class="collapse-item" href="<c:url value='/manager/outbound/trip-planning'/>">Điều phối xe (Trip)</a>
        <a class="collapse-item" href="<c:url value='/manager/outbound/gate-out'/>">Xuất bến (Gate Out)</a>
        <h6 class="collapse-header">Tra cứu:</h6>
        <a class="collapse-item" href="<c:url value='/manager/outbound/trip-management'/>">Quản lý Chuyến xe</a>
      </div>
    </div>
  </li>

  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseDelivery" aria-expanded="true"
      aria-controls="collapseDelivery">
      <i class="fas fa-fw fa-motorcycle"></i>
      <span>3. Điều phối Giao hàng</span>
    </a>
    <div id="collapseDelivery" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Quản lý Shipper:</h6>
        <a class="collapse-item" href="<c:url value='/manager/lastmile/assign-task'/>">Phân công Shipper</a>
        <a class="collapse-item" href="<c:url value='/manager/lastmile/confirm-delivery'/>">Cập nhật kết quả giao</a>
        <a class="collapse-item" href="<c:url value='/manager/lastmile/counter-pickup'/>">Khách nhận tại quầy</a>
      </div>
    </div>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Kiểm soát &amp; Tài chính</div>

  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseException" aria-expanded="true"
      aria-controls="collapseException">
      <i class="fas fa-fw fa-exclamation-triangle"></i>
      <span>Xử lý Ngoại lệ</span>
    </a>
    <div id="collapseException" class="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Các đơn lỗi:</h6>
        <a class="collapse-item" href="<c:url value='/manager/lastmile/return-goods'/>">Kích hoạt Hoàn hàng</a>
        <a class="collapse-item" href="<c:url value='/manager/lastmile/return-shop'/>">Xác nhận trả Shop</a>
      </div>
    </div>
  </li>

  <li class="nav-item">
    <a class="nav-link" href="<c:url value='/manager/finance/cod-settlement'/>">
      <i class="fas fa-fw fa-money-bill-wave"></i>
      <span>Quyết toán COD</span>
    </a>
  </li>

  <hr class="sidebar-divider" />

  <div class="sidebar-heading">Nhân sự &amp; Phương tiện</div>

  <li class="nav-item">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseResources" aria-expanded="true"
      aria-controls="collapseResources">
      <i class="fas fa-fw fa-users-cog"></i>
      <span>Quản trị Nguồn lực</span>
    </a>
    <div id="collapseResources" class="collapse" aria-labelledby="headingPages" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Quản lý:</h6>
        <a class="collapse-item" href="<c:url value='/manager/resource/management'/>">Tài xế &amp; Xe</a>
        <h6 class="collapse-header">Danh sách:</h6>
        <a class="collapse-item" href="<c:url value='/manager/shippers'/>">Đội ngũ Shipper</a>
        <a class="collapse-item" href="<c:url value='/manager/drivers'/>">Đội ngũ Tài xế</a>
        <a class="collapse-item" href="<c:url value='/manager/vehicles'/>">Phương tiện (Xe tải)</a>
      </div>
    </div>
  </li>

  <hr class="sidebar-divider d-none d-md-block" />

  <div class="text-center d-none d-md-inline">
    <button class="rounded-circle border-0" id="sidebarToggle"></button>
  </div>
</ul>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    var currentUrl = window.location.pathname;
    var links = document.querySelectorAll(
      "#accordionSidebar a.collapse-item, #accordionSidebar a.nav-link"
    );
    links.forEach(function (link) {
      var href = link.getAttribute("href");
      if (href && href !== "#" && currentUrl.indexOf(href) !== -1) {
        link.classList.add("active");
        var parentDiv = link.closest(".collapse");
        if (parentDiv) {
          parentDiv.classList.add("show");
          var parentNav = parentDiv.parentElement.querySelector(".nav-link");
          if (parentNav) parentNav.classList.remove("collapsed");
        }
        var parentLi = link.closest("li.nav-item");
        if (parentLi) parentLi.classList.add("active");
      }
    });
  });
</script>
