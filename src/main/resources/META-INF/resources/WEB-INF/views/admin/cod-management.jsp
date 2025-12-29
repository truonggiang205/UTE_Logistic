<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>Quản lý thu hộ (COD) - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .table-container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            .stats-card {
                background: #fff;
                border-left: 5px solid #0d6efd;
                border-radius: 8px;
                padding: 15px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            }

            .badge {
                min-width: 90px;
                text-transform: uppercase;
                font-size: 0.75rem;
            }

            .table thead th {
                background-color: #212529;
                color: white;
                border: none;
            }

            .text-money {
                font-weight: 600;
                color: #dc3545;
            }
        </style>
    </head>

    <body class="bg-light">
        <div class="container-fluid mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3><i class="fa-solid fa-hand-holding-dollar text-primary"></i> Quản lý thu hộ (COD)</h3>
                <div class="stats-card">
                    <small class="text-muted fw-bold">TỔNG TIỀN ĐANG GIỮ</small>
                    <h4 id="totalHoldingSys" class="mb-0 text-primary">0 ₫</h4>
                </div>
            </div>

            <div class="card mb-4 shadow-sm border-0">
                <div class="card-body">
                    <form id="filterForm" class="row g-3">
                        <div class="col-md-2">
                            <label class="form-label fw-bold small">Từ ngày</label>
                            <input type="datetime-local" class="form-control form-control-sm" id="from">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold small">Đến ngày</label>
                            <input type="datetime-local" class="form-control form-control-sm" id="to">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold small">Chi nhánh (Hub)</label>
                            <select class="form-select form-select-sm" id="hubId">
                                <option value="">-- Tất cả Hub --</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold small">Tên Shipper</label>
                            <input type="text" class="form-control form-control-sm" id="shipperName"
                                placeholder="Nhập tên tài xế...">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold small">Trạng thái</label>
                            <select class="form-select form-select-sm" id="status">
                                <option value="">-- Tất cả --</option>
                                <option value="collected">Đang giữ tiền</option>
                                <option value="settled">Đã nộp kho</option>
                                <option value="pending">Chờ thu</option>
                            </select>
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <button type="button" class="btn btn-primary btn-sm w-100" onclick="loadData(0)">
                                <i class="fa fa-filter"></i> Lọc
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Mã Đơn</th>
                                <th>Shipper</th>
                                <th>Chi nhánh</th>
                                <th class="text-end">Số tiền COD</th>
                                <th class="text-center">Trạng thái</th>
                                <th>Thời gian thu</th>
                                <th>Thời gian nộp</th>
                            </tr>
                        </thead>
                        <tbody id="codTableBody">
                        </tbody>
                    </table>
                </div>

                <nav class="mt-4">
                    <ul class="pagination pagination-sm justify-content-center" id="pagination"></ul>
                </nav>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

            // 1. Load danh sách Hub cho dropdown
            async function loadHubList() {
                try {
                    const response = await fetch('/api/admin/hubs/filter');
                    if (response.ok) {
                        const hubs = await response.json();
                        const hubSelect = $('#hubId');
                        hubs.forEach(hub => {
                            hubSelect.append(new Option(hub.hubName, hub.hubId));
                        });
                    }
                } catch (e) { console.error("Lỗi load hub:", e); }
            }

            // 2. Load tổng tiền đang giữ
            async function loadStats() {
                try {
                    const response = await fetch('/api/admin/cod/stats/holding');
                    const data = await response.json();
                    $('#totalHoldingSys').text(formatter.format(data.totalHoldingAmount || 0));
                } catch (e) { console.error("Lỗi load stats:", e); }
            }

            // 3. Load danh sách giao dịch chính
            async function loadData(page = 0) {
                const params = new URLSearchParams();
                params.append('page', page);
                params.append('size', 10);

                // Thu thập dữ liệu từ form
                const sName = $('#shipperName').val();
                const hId = $('#hubId').val();
                const sts = $('#status').val();
                const fDate = $('#from').val();
                const tDate = $('#to').val();

                if (sName) params.append('shipperName', sName.trim());
                if (hId) params.append('hubId', hId);
                if (sts) params.append('status', sts);
                if (fDate) params.append('from', fDate);
                if (tDate) params.append('to', tDate);

                try {
                    const response = await fetch(`/api/admin/cod?\${params.toString()}`);
                    const data = await response.json();
                    renderTable(data.content);
                    renderPagination(data.totalPages, data.number);
                } catch (error) {
                    console.error("Lỗi tải dữ liệu:", error);
                    $('#codTableBody').html('<tr><td colspan="8" class="text-center text-danger">Không thể kết nối đến máy chủ</td></tr>');
                }
            }

            // 4. Render bảng (Lưu ý dấu \ trước $)
            function renderTable(list) {
                const body = $('#codTableBody');
                if (!list || list.length === 0) {
                    body.html('<tr><td colspan="8" class="text-center py-4 text-muted">Không có dữ liệu phù hợp</td></tr>');
                    return;
                }

                const rows = list.map(item => `
                <tr>
                    <td><small class="text-muted">#\${item.codTxId}</small></td>
                    <td><span class="fw-bold text-dark">\${item.orderCode}</span></td>
                    <td>\${item.shipperName || 'N/A'}</td>
                    <td><span class="text-secondary">\${item.hubName || 'N/A'}</span></td>
                    <td class="text-end fw-bold text-danger">\${formatter.format(item.amount)}</td>
                    <td class="text-center">
                        <span class="badge \${getStatusClass(item.status)}">
                            \${(item.status || '').toUpperCase()}
                        </span>
                    </td>
                    <td><small>\${item.collectedAt ? new Date(item.collectedAt).toLocaleString('vi-VN') : '-'}</small></td>
                    <td><small>\${item.settledAt ? new Date(item.settledAt).toLocaleString('vi-VN') : '<i class="text-muted">Chưa nộp</i>'}</small></td>
                </tr>
            `).join('');
                body.html(rows);
            }

            function getStatusClass(status) {
                if (status === 'collected') return 'bg-warning text-dark';
                if (status === 'settled') return 'bg-success';
                if (status === 'pending') return 'bg-secondary';
                return 'bg-info';
            }

            function renderPagination(totalPages, current) {
                let html = '';
                for (let i = 0; i < totalPages; i++) {
                    html += `
                    <li class="page-item \${i === current ? 'active' : ''}">
                        <a class="page-link" href="javascript:void(0)" onclick="loadData(\${i})">\${i + 1}</a>
                    </li>`;
                }
                $('#pagination').html(html);
            }

            // Khởi tạo khi trang sẵn sàng
            $(document).ready(() => {
                loadHubList();
                loadStats();
                loadData(0);
            });
        </script>
    </body>

    </html>