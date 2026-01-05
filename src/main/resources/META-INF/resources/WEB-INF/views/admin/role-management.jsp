<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Phân quyền Role</h1>
            <div class="small text-muted">Danh sách role và trạng thái kích hoạt.</div>
        </div>
        <button class="btn btn-sm btn-primary shadow-sm" onclick="loadRoles()">
            <i class="fas fa-sync-alt fa-sm"></i> Làm mới
        </button>
    </div>

    <div id="roleAlert" class="alert alert-danger d-none" role="alert"></div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách Role</h6>
            <span class="badge badge-pill badge-info" id="roleCountBadge">0</span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead class="bg-light">
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th style="width: 160px;">Role</th>
                            <th>Mô tả</th>
                            <th style="width: 140px;">Trạng thái</th>
                            <th style="width: 130px;" class="text-center">Số user</th>
                        </tr>
                    </thead>
                    <tbody id="roleTableBody"></tbody>
                </table>
            </div>

            <div id="roleEmptyState" class="alert alert-info d-none mb-0">
                Chưa có role nào.
            </div>
        </div>
    </div>
</div>

<script>
    var ROLE_API = '${pageContext.request.contextPath}/api/admin/roles';

    function escapeHtml(value) {
        if (value === null || value === undefined) return '';
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function statusBadge(status) {
        var s = (status || '').toLowerCase();
        if (s === 'active') return '<span class="badge badge-success">Active</span>';
        if (s === 'inactive') return '<span class="badge badge-secondary">Inactive</span>';
        return '<span class="badge badge-light">' + escapeHtml(status) + '</span>';
    }

    function setAlert(message) {
        var alertBox = document.getElementById('roleAlert');
        if (!message) {
            alertBox.classList.add('d-none');
            alertBox.textContent = '';
            return;
        }
        alertBox.textContent = message;
        alertBox.classList.remove('d-none');
    }

    function loadRoles() {
        var tbody = document.getElementById('roleTableBody');
        var emptyState = document.getElementById('roleEmptyState');
        var countBadge = document.getElementById('roleCountBadge');

        setAlert(null);
        tbody.innerHTML = '';
        emptyState.classList.add('d-none');
        countBadge.textContent = '...';

        fetch(ROLE_API)
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
                    var r = data[i] || {};
                    html += '<tr>'
                        + '<td>' + escapeHtml(r.roleId) + '</td>'
                        + '<td class="font-weight-bold text-primary">' + escapeHtml(r.roleName) + '</td>'
                        + '<td>' + escapeHtml(r.description) + '</td>'
                        + '<td>' + statusBadge(r.status) + '</td>'
                        + '<td class="text-center">' + escapeHtml(r.userCount) + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
            })
            .catch(function (err) {
                console.error('Load roles failed:', err);
                countBadge.textContent = '0';
                emptyState.classList.remove('d-none');
                setAlert('Không thể tải danh sách role. Vui lòng thử lại.');
            });
    }

    loadRoles();
</script>
