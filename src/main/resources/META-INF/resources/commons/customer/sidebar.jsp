<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="<c:url value='/customer/dashboard'/>">
        <div class="sidebar-brand-icon rotate-n-15">
            <i class="fas fa-shipping-fast"></i>
        </div>
        <div class="sidebar-brand-text mx-3">Customer Portal</div>
    </a>

    <hr class="sidebar-divider my-0"/>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/dashboard'/>">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Tổng quan</span>
        </a>
    </li>

    <hr class="sidebar-divider"/>

    <div class="sidebar-heading">Đơn hàng</div>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/orders/new'/>">
            <i class="fas fa-fw fa-plus-circle"></i>
            <span>Tạo đơn giao hàng</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/orders'/>">
            <i class="fas fa-fw fa-list"></i>
            <span>Đơn của tôi</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/tracking'/>">
            <i class="fas fa-fw fa-search"></i>
            <span>Tra cứu vận đơn</span>
        </a>
    </li>

    <hr class="sidebar-divider"/>

    <div class="sidebar-heading">Tài khoản</div>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/addresses'/>">
            <i class="fas fa-fw fa-map-marked-alt"></i>
            <span>Sổ địa chỉ</span>
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/customer/profile'/>">
            <i class="fas fa-fw fa-user"></i>
            <span>Hồ sơ</span>
        </a>
    </li>

    <hr class="sidebar-divider d-none d-md-block"/>

    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

</ul>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var currentUrl = window.location.pathname;
        var links = document.querySelectorAll("#accordionSidebar a.nav-link");
        links.forEach(function (link) {
            var href = link.getAttribute("href");
            if (href && href !== "#" && currentUrl.indexOf(href) !== -1) {
                link.classList.add("active");
                var parentLi = link.closest("li.nav-item");
                if (parentLi) parentLi.classList.add("active");
            }
        });
    });
</script>
