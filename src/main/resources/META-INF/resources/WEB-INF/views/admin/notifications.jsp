<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Gửi thông báo</h1>
            <div class="small text-muted">Gửi thông báo nội bộ theo vai trò (Admin/Staff/Shipper/Customer) hoặc tất cả.</div>
        </div>
    </div>

    <div id="notifySuccess" class="alert alert-success d-none" role="alert"></div>
    <div id="notifyError" class="alert alert-danger d-none" role="alert"></div>

    <div class="row">
        <div class="col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Soạn thông báo</h6>
                </div>
                <div class="card-body">
                    <form id="notifyForm">
                        <div class="form-group">
                            <label class="font-weight-bold">Tiêu đề</label>
                            <input type="text" class="form-control" id="notifyTitle" maxlength="120" placeholder="Ví dụ: Bảo trì hệ thống lúc 22:00" required>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold">Gửi đến</label>
                            <select class="form-control" id="notifyTarget" required>
                                <option value="ALL">Tất cả người dùng</option>
                                <option value="ADMIN">Chỉ Admin</option>
                                <option value="STAFF">Chỉ Staff</option>
                                <option value="SHIPPER">Chỉ Shipper</option>
                                <option value="CUSTOMER">Chỉ Customer</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold">Nội dung</label>
                            <textarea class="form-control" id="notifyBody" rows="6" maxlength="2000" placeholder="Nhập nội dung thông báo..." required></textarea>
                            <div class="small text-muted mt-1">Tối đa 2000 ký tự.</div>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Gửi thông báo
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Gợi ý hiển thị</h6>
                </div>
                <div class="card-body">
                    <div class="alert alert-info mb-0">
                        <div class="font-weight-bold mb-1"><i class="fas fa-info-circle"></i> Mẹo</div>
                        <ul class="mb-0 pl-3">
                            <li>Tiêu đề ngắn gọn, rõ hành động.</li>
                            <li>Nội dung nêu thời gian/ảnh hưởng cụ thể.</li>
                            <li>Chọn đúng nhóm người nhận để tránh spam.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var NOTIFY_API = '${pageContext.request.contextPath}/api/admin/notifications/send';

    function showBox(id, message) {
        var el = document.getElementById(id);
        if (!message) {
            el.classList.add('d-none');
            el.textContent = '';
            return;
        }
        el.textContent = message;
        el.classList.remove('d-none');
    }

    document.getElementById('notifyForm').addEventListener('submit', function (e) {
        e.preventDefault();

        showBox('notifySuccess', null);
        showBox('notifyError', null);

        var title = document.getElementById('notifyTitle').value.trim();
        var target = document.getElementById('notifyTarget').value;
        var body = document.getElementById('notifyBody').value.trim();

        if (!title || !body) {
            showBox('notifyError', 'Vui lòng nhập đầy đủ tiêu đề và nội dung.');
            return;
        }

        fetch(NOTIFY_API, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title: title, target: target, body: body })
        })
            .then(function (res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function (data) {
                if (data && data.ok) {
                    showBox('notifySuccess', data && data.message ? data.message : 'Gửi thông báo thành công.');
                    document.getElementById('notifyBody').value = '';
                } else {
                    showBox('notifyError', data && data.message ? data.message : 'Không thể gửi thông báo. Vui lòng thử lại.');
                }
            })
            .catch(function (err) {
                console.error('Send notification failed:', err);
                showBox('notifyError', 'Không thể gửi thông báo. Vui lòng thử lại.');
            });
    });
</script>
