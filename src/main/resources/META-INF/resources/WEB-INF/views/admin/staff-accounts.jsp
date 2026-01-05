<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Tài khoản nhân viên</h1>
            <div class="small text-muted">Quản lý danh sách user có vai trò STAFF trong hệ thống.</div>
        </div>
        <button class="btn btn-sm btn-primary shadow-sm" onclick="loadStaffAccounts()">
            <i class="fas fa-sync-alt fa-sm"></i> Làm mới
        </button>
    </div>

    <div id="staffAlert" class="alert alert-danger d-none" role="alert"></div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách nhân viên</h6>
            <span class="badge badge-pill badge-info" id="staffCountBadge">0</span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead class="bg-light">
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th style="width: 140px;">Username</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th style="width: 140px;">SĐT</th>
                            <th style="width: 130px;">Trạng thái</th>
                            <th style="width: 180px;">Vai trò</th>
                            <th style="width: 180px;">Đăng nhập gần nhất</th>
                        </tr>
                    </thead>
                    <tbody id="staffTableBody"></tbody>
                </table>
            </div>

            <div id="staffEmptyState" class="alert alert-info d-none mb-0">
                Chưa có tài khoản nhân viên nào.
            </div>
        </div>
    </div>
</div>

<script>
    var STAFF_API = '${pageContext.request.contextPath}/api/admin/users?role=STAFF';

    function escapeHtml(value) {
        if (value === null || value === undefined) return '';
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function formatDateTime(value) {
        if (!value) return '';
        // ISO string -> local display
        try {
            var d = new Date(value);
            if (isNaN(d.getTime())) return escapeHtml(value);
            return d.toLocaleString('vi-VN');
        } catch (e) {
            return escapeHtml(value);
        }
    }

    function statusBadge(status) {
        var s = (status || '').toLowerCase();
        if (s === 'active') return '<span class="badge badge-success">Active</span>';
        if (s === 'inactive') return '<span class="badge badge-secondary">Inactive</span>';
        if (s === 'banned') return '<span class="badge badge-danger">Banned</span>';
        return '<span class="badge badge-light">' + escapeHtml(status) + '</span>';
    }

    function rolesBadges(roles) {
        if (!roles || roles.length === 0) return '<span class="text-muted">(trống)</span>';
        var html = '';
        for (var i = 0; i < roles.length; i++) {
            html += '<span class="badge badge-pill badge-primary mr-1">' + escapeHtml(roles[i]) + '</span>';
        }
        return html;
    }

    function setAlert(message) {
        var alertBox = document.getElementById('staffAlert');
        if (!message) {
            alertBox.classList.add('d-none');
            alertBox.textContent = '';
            return;
        }
        alertBox.textContent = message;
        alertBox.classList.remove('d-none');
    }

    function loadStaffAccounts() {
        var tbody = document.getElementById('staffTableBody');
        var emptyState = document.getElementById('staffEmptyState');
        var countBadge = document.getElementById('staffCountBadge');

        setAlert(null);
        tbody.innerHTML = '';
        emptyState.classList.add('d-none');
        countBadge.textContent = '...';

        fetch(STAFF_API)
            .then(function (res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function (data) {
                if (!data || data.length === 0) {
                    countBadge.textContent = '0';
                    emptyState.classList.remove('d-none');
                    return;
                }

                countBadge.textContent = String(data.length);
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    var u = data[i] || {};
                    html += '<tr>'
                        + '<td>' + escapeHtml(u.userId) + '</td>'
                        + '<td class="font-weight-bold">' + escapeHtml(u.username) + '</td>'
                        + '<td>' + escapeHtml(u.fullName) + '</td>'
                        + '<td>' + escapeHtml(u.email) + '</td>'
                        + '<td>' + escapeHtml(u.phone) + '</td>'
                        + '<td>' + statusBadge(u.status) + '</td>'
                        + '<td>' + rolesBadges(u.roles) + '</td>'
                        + '<td>' + formatDateTime(u.lastLoginAt) + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
            })
            .catch(function (err) {
                console.error('Load staff accounts failed:', err);
                countBadge.textContent = '0';
                emptyState.classList.remove('d-none');
                setAlert('Không thể tải danh sách nhân viên. Vui lòng thử lại.');
            });
    }

    loadStaffAccounts();
</script>
