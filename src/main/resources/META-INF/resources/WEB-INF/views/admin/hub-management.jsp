<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Quản lý Hub</h1>
        <button class="btn btn-sm btn-primary shadow-sm" onclick="loadHubs()">
            <i class="fas fa-sync-alt fa-sm"></i> Làm mới
        </button>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách Hub (đang hoạt động)</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                    <thead class="bg-light">
                        <tr>
                            <th style="width: 120px;">ID</th>
                            <th>Tên Hub</th>
                        </tr>
                    </thead>
                    <tbody id="hubTableBody"></tbody>
                </table>
            </div>
            <div id="hubEmptyState" class="alert alert-info d-none mb-0">Chưa có dữ liệu hub.</div>
        </div>
    </div>
</div>

<script>
    var HUB_API = '${pageContext.request.contextPath}/api/admin/hubs/filter';

    function escapeHtml(value) {
        if (value === null || value === undefined) return '';
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function loadHubs() {
        var tbody = document.getElementById('hubTableBody');
        var emptyState = document.getElementById('hubEmptyState');

        fetch(HUB_API)
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
                    html += '<tr>'
                        + '<td>' + escapeHtml(data[i].hubId) + '</td>'
                        + '<td>' + escapeHtml(data[i].hubName) + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
            })
            .catch(function (err) {
                console.error('Load hubs failed:', err);
                tbody.innerHTML = '';
                emptyState.classList.remove('d-none');
                emptyState.textContent = 'Không thể tải dữ liệu hub. Vui lòng thử lại.';
            });
    }

    // Auto load
    loadHubs();
</script>
