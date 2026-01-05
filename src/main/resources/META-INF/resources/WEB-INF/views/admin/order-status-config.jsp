<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Trạng thái đơn</h1>
            <div class="small text-muted">Bảng tham chiếu các trạng thái trong luồng vận hành.</div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Danh mục trạng thái</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead class="bg-light">
                                <tr>
                                    <th style="width: 180px;">Mã</th>
                                    <th style="width: 220px;">Hiển thị</th>
                                    <th>Ý nghĩa</th>
                                </tr>
                            </thead>
                            <tbody id="statusTableBody"></tbody>
                        </table>
                    </div>
                    <div class="alert alert-info mb-0">
                        Trạng thái đang dùng theo enum <span class="font-weight-bold">ServiceRequest.RequestStatus</span>.
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Quy tắc nhanh</h6>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning mb-0">
                        <div class="font-weight-bold mb-1"><i class="fas fa-exclamation-triangle"></i> Lưu ý</div>
                        <ul class="mb-0 pl-3">
                            <li>Luồng thường: pending → picked → in_transit → delivered.</li>
                            <li>cancelled/failed là trạng thái kết thúc.</li>
                            <li>Tuỳ nghiệp vụ, admin có thể cần đồng bộ hiển thị UI.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function escapeHtml(value) {
        if (value === null || value === undefined) return '';
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function badge(code) {
        var c = (code || '').toLowerCase();
        if (c === 'pending') return '<span class="badge badge-warning">pending</span>';
        if (c === 'picked') return '<span class="badge badge-info">picked</span>';
        if (c === 'in_transit') return '<span class="badge badge-primary">in_transit</span>';
        if (c === 'delivered') return '<span class="badge badge-success">delivered</span>';
        if (c === 'cancelled') return '<span class="badge badge-secondary">cancelled</span>';
        if (c === 'failed') return '<span class="badge badge-danger">failed</span>';
        return '<span class="badge badge-light">' + escapeHtml(code) + '</span>';
    }

    var STATUSES = [
        { code: 'pending', label: 'Chờ lấy hàng', desc: 'Đơn mới tạo, chờ pickup/nhập luồng xử lý.' },
        { code: 'picked', label: 'Đã lấy hàng', desc: 'Đơn đã được lấy/nhận tại hub và sẵn sàng trung chuyển.' },
        { code: 'in_transit', label: 'Đang vận chuyển', desc: 'Đơn đang di chuyển giữa các hub hoặc ra tuyến giao.' },
        { code: 'delivered', label: 'Giao thành công', desc: 'Đơn đã giao cho người nhận.' },
        { code: 'cancelled', label: 'Đã hủy', desc: 'Đơn bị hủy trước khi hoàn tất.' },
        { code: 'failed', label: 'Thất bại', desc: 'Giao thất bại/ngoại lệ và kết thúc luồng.' }
    ];

    (function render() {
        var tbody = document.getElementById('statusTableBody');
        var html = '';
        for (var i = 0; i < STATUSES.length; i++) {
            var s = STATUSES[i];
            html += '<tr>'
                + '<td>' + badge(s.code) + '</td>'
                + '<td class="font-weight-bold">' + escapeHtml(s.label) + '</td>'
                + '<td>' + escapeHtml(s.desc) + '</td>'
                + '</tr>';
        }
        tbody.innerHTML = html;
    })();
</script>
