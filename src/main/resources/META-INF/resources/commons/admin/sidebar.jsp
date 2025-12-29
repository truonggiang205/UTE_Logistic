<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <a class="sidebar-brand d-flex align-items-center justify-content-center"
        href="${pageContext.request.contextPath}/admin/dashboard">
        <div class="sidebar-brand-icon">
            <img src="${pageContext.request.contextPath}/static/img/logo.png" width="40" height="40" alt="Logo">
        </div>
        <div class="sidebar-brand-text mx-3">NGHV Logistics</div>
    </a>

    <hr class="sidebar-divider my-0">

    <li class="nav-item active">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
    </li>

    <hr class="sidebar-divider">

    <div class="sidebar-heading">Quản lý hệ thống</div>

    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/shippers">
            <i class="fas fa-fw fa-truck"></i>
            <span>Quản lý Shipper</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
            <i class="fas fa-fw fa-table"></i>
            <span>Quản lý đơn hàng</span>
        </a>
    </li>

    <hr class="sidebar-divider d-none d-md-block">

    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>
</ul>