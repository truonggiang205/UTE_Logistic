<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Tuyến vận chuyển</h1>
        <button class="btn btn-sm btn-primary shadow-sm" onclick="loadRoutes()">
            <i class="fas fa-sync-alt fa-sm"></i> Làm mới
        </button>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách tuyến</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead class="bg-light">
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th>Hub đi</th>
                            <th>Hub đến</th>
                            <th style="width: 140px;">Thời gian (phút)</th>
                            <th>Mô tả</th>
                        </tr>
                    </thead>
                    <tbody id="routeTableBody"></tbody>
                </table>
            </div>
            <div id="routeEmptyState" class="alert alert-info d-none mb-0">Chưa có dữ liệu tuyến vận chuyển.</div>
        </div>
    </div>
</div>

<script>
    var ROUTE_API = '${pageContext.request.contextPath}/api/admin/routes';

    function escapeHtml(value) {
        if (value === null || value === undefined) return '';
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function loadRoutes() {
        var tbody = document.getElementById('routeTableBody');
        var emptyState = document.getElementById('routeEmptyState');

        fetch(ROUTE_API)
            .then(function (res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function (data) {
                var html = '';
                if (!data || data.length === 0) {
                    tbody.innerHTML = '';
                    emptyState.classList.remove('d-none');
                    return;
                }

                emptyState.classList.add('d-none');
                for (var i = 0; i < data.length; i++) {
                    var r = data[i];
                    html += '<tr>'
                        + '<td>' + escapeHtml(r.routeId) + '</td>'
                        + '<td>' + escapeHtml(r.fromHubName) + '</td>'
                        + '<td>' + escapeHtml(r.toHubName) + '</td>'
                        + '<td>' + escapeHtml(r.estimatedTime) + '</td>'
                        + '<td>' + escapeHtml(r.description) + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
            })
            .catch(function (err) {
                console.error('Load routes failed:', err);
                tbody.innerHTML = '';
                emptyState.classList.remove('d-none');
                emptyState.textContent = 'Không thể tải dữ liệu tuyến. Vui lòng thử lại.';
            });
    }

    // Auto load
    loadRoutes();
</script>
