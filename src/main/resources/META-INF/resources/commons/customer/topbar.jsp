<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
        <i class="fa fa-bars"></i>
    </button>

    <!-- Topbar Title -->
    <div class="d-none d-sm-inline-block">
        <h5 class="m-0 text-info font-weight-bold">
            <i class="fas fa-shipping-fast mr-2"></i>Customer Portal
        </h5>
    </div>

    <ul class="navbar-nav ml-auto">

        <!-- Nav Item - Notifications -->
        <li class="nav-item dropdown no-arrow mx-1">
            <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-bell fa-fw"></i>
                <!-- Counter - Alerts -->
                <span class="badge badge-danger badge-counter" id="notificationCount">0</span>
            </a>
            <!-- Dropdown - Alerts -->
            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                 aria-labelledby="alertsDropdown">
                <h6 class="dropdown-header bg-info">Thông báo</h6>
                <div id="notificationList"></div>
                <a class="dropdown-item text-center small text-gray-500"
                   href="${pageContext.request.contextPath}/customer/notifications">
                    Xem tất cả thông báo
                </a>
            </div>
        </li>

        <div class="topbar-divider d-none d-sm-block"></div>

        <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown"
               aria-haspopup="true" aria-expanded="false">
                <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                    <sec:authentication property="principal.username" var="username" />
                    ${username}
                </span>
                <c:choose>
                    <c:when test="${not empty currentUserAvatarUrl}">
                        <img class="img-profile rounded-circle" src="${currentUserAvatarUrl}">
                    </c:when>
                    <c:otherwise>
                        <img class="img-profile rounded-circle" src="${pageContext.request.contextPath}/img/undraw_profile.svg">
                    </c:otherwise>
                </c:choose>
            </a>

            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <a class="dropdown-item" href="<c:url value='/customer/profile'/>">
                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                    Hồ sơ
                </a>
                <a class="dropdown-item" href="<c:url value='/customer/orders'/>">
                    <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                    Đơn hàng của tôi
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                    Đăng xuất
                </a>
            </div>
        </li>

    </ul>

</nav>

<script>
(function() {
    var ctx = '${pageContext.request.contextPath}';
    var API = ctx + '/api/customer/notifications/recent';
    var pageLink = ctx + '/customer/notifications';

    function escapeHtml(s) {
        return (s || '').replace(/[&<>"']/g, function(c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
        });
    }

    function fmtTime(iso) {
        if (!iso) return 'Gần đây';
        try {
            var d = new Date(iso);
            return d.toLocaleString('vi-VN');
        } catch (e) {
            return iso;
        }
    }

    function setCount(n) {
        var badge = document.getElementById('notificationCount');
        if (!badge) return;
        if (!n || n <= 0) {
            badge.textContent = '0';
            badge.style.display = 'none';
            return;
        }
        badge.textContent = n > 9 ? '9+' : String(n);
        badge.style.display = 'inline-block';
    }

    function render(items) {
        var list = document.getElementById('notificationList');
        if (!list) return;

        items = items || [];
        setCount(items.length);

        if (!items.length) {
            list.innerHTML = '<div class="dropdown-item text-center small text-gray-500">Không có thông báo mới</div>';
            return;
        }

        list.innerHTML = items.slice(0, 5).map(function(n) {
            var title = escapeHtml(n.title);
            var body = escapeHtml(n.body);
            var time = escapeHtml(fmtTime(n.createdAt));
            return (
                '<a class="dropdown-item d-flex align-items-center" href="' + pageLink + '">' +
                    '<div class="mr-3">' +
                        '<div class="icon-circle bg-info">' +
                            '<i class="fas fa-bell text-white"></i>' +
                        '</div>' +
                    '</div>' +
                    '<div class="w-100">' +
                        '<div class="small text-gray-500">' + time + '</div>' +
                        '<span class="font-weight-bold d-block text-truncate" style="max-width: 260px;">' + title + '</span>' +
                        '<div class="small text-gray-700 text-truncate" style="max-width: 260px;">' + body + '</div>' +
                    '</div>' +
                '</a>'
            );
        }).join('');
    }

    function load() {
        fetch(API, { method: 'GET' })
            .then(function(r) { return r.ok ? r.json() : []; })
            .then(render)
            .catch(function() {
                setCount(0);
                var list = document.getElementById('notificationList');
                if (list) {
                    list.innerHTML = '<div class="dropdown-item text-center small text-gray-500">Không thể tải thông báo</div>';
                }
            });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', load);
    } else {
        load();
    }
})();
</script>
