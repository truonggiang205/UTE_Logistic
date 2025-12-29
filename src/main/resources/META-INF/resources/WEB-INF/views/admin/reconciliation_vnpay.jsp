<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>Tra soát giao dịch VNPay</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

        <style>
            .table-container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            .text-money {
                font-weight: 600;
            }

            .badge {
                min-width: 100px;
            }

            .select2-container .select2-selection--single {
                height: 38px !important;
                border: 1px solid #dee2e6 !important;
            }

            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 36px !important;
            }
        </style>
    </head>

    <body class="bg-light">
        <div class="container-fluid mt-4">
            <h3 class="mb-4"><i class="fa-solid fa-file-invoice-dollar text-primary"></i> Đối soát giao dịch VNPay</h3>

            <div class="card mb-4 shadow-sm">
                <div class="card-body">
                    <form id="filterForm" class="row g-3">
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Từ ngày</label>
                            <input type="datetime-local" class="form-control" id="from">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Đến ngày</label>
                            <input type="datetime-local" class="form-control" id="to">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold text-primary">Chi nhánh (Hub)</label>
                            <select class="form-select" id="hubId">
                                <option value="">-- Tất cả chi nhánh --</option>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label fw-bold">Khách hàng</label>
                            <input type="text" class="form-control" id="customerName" placeholder="Tên khách hàng...">
                        </div>

                        <div class="col-md-3 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-primary w-100" onclick="loadData(0)">
                                <i class="fa fa-search"></i> Lọc
                            </button>
                            <button type="button" class="btn btn-success w-100" onclick="exportExcel()">
                                <i class="fa fa-file-excel"></i> Excel
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Mã VNPAY</th>
                                <th>Mã Đơn</th>
                                <th>Khách Hàng</th>
                                <th>Hub</th>
                                <th class="text-end">Giá Đơn</th>
                                <th class="text-end">Thực Nhận</th>
                                <th class="text-end">Chênh Lệch</th>
                                <th class="text-center">Đối Soát</th>
                                <th>Ngày Giao Dịch</th>
                            </tr>
                        </thead>
                        <tbody id="transactionTableBody"></tbody>
                    </table>
                </div>
                <nav class="mt-4">
                    <ul class="pagination justify-content-center" id="pagination"></ul>
                </nav>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
            let currentPage = 0;
            const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

            // 1. Tải danh sách Hub - ĐÃ SỬA URL THEO CONTROLLER CỦA BẠN
            async function loadHubList() {
                try {
                    // Controller của bạn là /api/admin/hubs/filter
                    const response = await fetch('/api/admin/hubs/filter');
                    const hubs = await response.json();
                    const $hubSelect = $('#hubId');

                    hubs.forEach(hub => {
                        const option = new Option(`[\${hub.hubId}] - \${hub.hubName}`, hub.hubId, false, false);
                        $hubSelect.append(option);
                    });

                    $hubSelect.select2({ theme: 'default', width: '100%' });
                } catch (error) {
                    console.error("Lỗi load Hub:", error);
                }
            }

            // 2. Tải dữ liệu giao dịch - ĐÃ SỬA URL THEO CONTROLLER CỦA BẠN
            async function loadData(page) {
                currentPage = page;
                const from = $('#from').val();
                const to = $('#to').val();
                const hubId = $('#hubId').val();
                const customerName = $('#customerName').val();

                // Controller của bạn là /api/admin/transactions
                let url = `/api/admin/transactions?page=\${page}&size=10`;
                if (from) url += `&from=\${from}:00`;
                if (to) url += `&to=\${to}:00`;
                if (hubId) url += `&hubId=\${hubId}`;
                if (customerName) url += `&customerName=\${encodeURIComponent(customerName)}`;

                try {
                    const response = await fetch(url);
                    if (!response.ok) throw new Error("Server error");
                    const data = await response.json();
                    renderTable(data.content);
                    renderPagination(data.totalPages, data.number);
                } catch (error) {
                    console.error("Lỗi:", error);
                    alert("Lỗi khi tải dữ liệu. Hãy kiểm tra Console (F12)!");
                }
            }

            function renderTable(list) {
                const body = document.getElementById('transactionTableBody');
                if (!list || list.length === 0) {
                    body.innerHTML = '<tr><td colspan="9" class="text-center">Không có dữ liệu</td></tr>';
                    return;
                }

                body.innerHTML = list.map(item => `
                <tr>
                    <td><small class="text-muted">\${item.vnpTxnRef || 'N/A'}</small></td>
                    <td><span class="fw-bold">\${item.orderCode}</span></td>
                    <td>\${item.customerName || 'Khách lẻ'}</td>
                    <td><span class="badge bg-secondary">\${item.hubName || 'N/A'}</span></td>
                    <td class="text-end">\${formatter.format(item.orderValue)}</td>
                    <td class="text-end text-success">\${formatter.format(item.paidAmount)}</td>
                    <td class="text-end \${item.discrepancy < 0 ? 'text-danger' : 'text-primary'}">
                        \${formatter.format(item.discrepancy)}
                    </td>
                    <td class="text-center">
                        <span class="badge \${getStatusClass(item.reconciliationStatus)}">
                            \${item.reconciliationStatus}
                        </span>
                    </td>
                    <td>\${item.paidAt ? new Date(item.paidAt).toLocaleString('vi-VN') : ''}</td>
                </tr>
            `).join('');
            }

            function getStatusClass(status) {
                if (status === 'MATCHED') return 'bg-success';
                if (status === 'OVER_PAID') return 'bg-primary';
                return 'bg-danger';
            }

            function renderPagination(totalPages, current) {
                let html = '';
                for (let i = 0; i < totalPages; i++) {
                    html += `<li class="page-item \${i === current ? 'active' : ''}">
                            <a class="page-link" style="cursor:pointer" onclick="loadData(\${i})">\${i + 1}</a>
                         </li>`;
                }
                $('#pagination').html(html);
            }

            function exportExcel() {
                const params = new URLSearchParams({
                    from: $('#from').val() ? $('#from').val() + ":00" : "",
                    to: $('#to').val() ? $('#to').val() + ":00" : "",
                    hubId: $('#hubId').val() || "",
                    customerName: $('#customerName').val() || ""
                });
                // Đường dẫn export của bạn: /api/admin/transactions/export
                window.location.href = `/api/admin/transactions/export?\${params.toString()}`;
            }

            $(document).ready(async () => {
                await loadHubList();
                loadData(0);
            });
        </script>
    </body>

    </html>