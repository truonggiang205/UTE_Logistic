<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <a class="sidebar-brand d-flex align-items-center justify-content-center"
            href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="sidebar-brand-icon">
                <img src="${pageContext.request.contextPath}/img/logo.png" width="40" height="40" alt="Logo">
            </div>
            <div class="sidebar-brand-text mx-3">NGHV Logistics</div>
        </a>

        <hr class="sidebar-divider my-0">

        <li class="nav-item active">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Bảng điều khiển</span>
            </a>
        </li>

        <hr class="sidebar-divider">

        <div class="sidebar-heading">Quản trị hệ thống</div>

        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseNetwork">
                <i class="fas fa-fw fa-network-wired"></i>
                <span>Mạng lưới bưu cục</span>
            </a>
            <div id="collapseNetwork" class="collapse" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <a class="collapse-item" href="##">Quản lý Hub</a>
                    <a class="collapse-item" href="##">Tuyến vận chuyển</a>
                </div>
            </div>
        </li>

        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseFinance">
                <i class="fas fa-fw fa-money-bill-wave"></i>
                <span>Dịch vụ & Tài chính</span>
            </a>
            <div id="collapseFinance" class="collapse" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/service-type-config">Cấu
                        hình Giá cước</a>
                    <a class="collapse-item"
                        href="${pageContext.request.contextPath}/admin/transactions-reconciliation">Tra soát VNPay</a>
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/cod-management">Đối soát
                        COD</a>
                </div>
            </div>
        </li>

        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUsers">
                <i class="fas fa-fw fa-users-cog"></i>
                <span>Nhân sự & Quyền</span>
            </a>
            <div id="collapseUsers" class="collapse" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <a class="collapse-item" href="##">Tài khoản nhân viên</a>
                    <a class="collapse-item" href="##">Phân quyền Role</a>
                    <a class="collapse-item" href="##">Gửi thông báo</a>
                </div>
            </div>
        </li>

        <hr class="sidebar-divider">

        <div class="sidebar-heading">Số liệu & Báo cáo</div>

        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseReport"
                aria-expanded="true" aria-controls="collapseReport">
                <i class="fas fa-fw fa-chart-area"></i>
                <span>Giám sát & Báo cáo</span>
            </a>
            <div id="collapseReport" class="collapse" aria-labelledby="headingReport" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/system-monitoring">System
                        Log</a>
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/risk-alerts">Cảnh báo rủi
                        ro</a>
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/export-reports">Xuất báo
                        cáo</a>
                </div>
            </div>
        </li>

        <div class="sidebar-heading mt-2">Cấu hình chung</div>

        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseConfig"
                aria-expanded="true" aria-controls="collapseConfig">
                <i class="fas fa-fw fa-cogs"></i>
                <span>Cấu hình hệ thống</span>
            </a>
            <div id="collapseConfig" class="collapse" aria-labelledby="headingConfig" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <a class="collapse-item" href="${pageContext.request.contextPath}/admin/order-status-config">Trạng
                        thái đơn</a>
                </div>
            </div>
        </li>

        <hr class="sidebar-divider d-none d-md-block">

        <div class="text-center d-none d-md-inline">
            <button class="rounded-circle border-0" id="sidebarToggle"></button>
        </div>

    </ul>