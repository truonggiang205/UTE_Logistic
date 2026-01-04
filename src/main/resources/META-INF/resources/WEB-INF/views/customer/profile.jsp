<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="defaultAvatar" value="${pageContext.request.contextPath}/img/undraw_profile.svg" />

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-user"></i> Hồ sơ</h1>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Thông tin cá nhân</h6>
    </div>
    <div class="card-body">
        <div class="mb-4">
            <h6 class="font-weight-bold text-secondary mb-3">Ảnh đại diện</h6>
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty currentUserAvatarUrl}">
                        <img id="customerAvatarImg" src="${currentUserAvatarUrl}" alt="Avatar" class="rounded-circle" style="width: 80px; height: 80px; object-fit: cover;">
                    </c:when>
                    <c:otherwise>
                        <img id="customerAvatarImg" src="${defaultAvatar}" alt="Avatar" class="rounded-circle" style="width: 80px; height: 80px; object-fit: cover;">
                    </c:otherwise>
                </c:choose>

                <div class="ml-3">
                    <input type="file" id="customerAvatarFile" accept="image/*" class="form-control-file" />
                    <button type="button" id="btnUploadCustomerAvatar" class="btn btn-sm btn-primary mt-2">
                        <i class="fas fa-upload"></i> Cập nhật avatar
                    </button>
                    <div class="small text-muted mt-1">PNG/JPG/WebP, tối đa 5MB</div>
                </div>
            </div>
        </div>

        <form method="post" action="<c:url value='/customer/profile'/>">
            <div class="form-group">
                <label>Họ và tên</label>
                <input class="form-control" name="fullName" value="${form.fullName}" required />
            </div>

            <div class="form-group">
                <label>Email</label>
                <input class="form-control" name="email" value="${form.email}" type="email" />
                <small class="text-muted">Nếu thay email, hệ thống sẽ dùng email mới để đăng nhập (nếu không trùng).</small>
            </div>

            <div class="form-group">
                <label>Số điện thoại</label>
                <input class="form-control" name="phone" value="${form.phone}" required />
            </div>

            <button class="btn btn-primary" type="submit"><i class="fas fa-save"></i> Lưu thay đổi</button>
        </form>
    </div>
</div>

<script>
    (function () {
        var btn = document.getElementById('btnUploadCustomerAvatar');
        var fileInput = document.getElementById('customerAvatarFile');
        var img = document.getElementById('customerAvatarImg');

        if (!btn || !fileInput || !img) return;

        btn.addEventListener('click', function () {
            if (!fileInput.files || fileInput.files.length === 0) {
                alert('Vui lòng chọn ảnh trước khi cập nhật');
                return;
            }

            var formData = new FormData();
            formData.append('avatar', fileInput.files[0]);

            fetch('${pageContext.request.contextPath}/customer/update-avatar', {
                method: 'POST',
                body: formData
            })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data && data.success) {
                    img.src = data.avatarUrl + '?t=' + new Date().getTime();
                    alert(data.message || 'Cập nhật ảnh đại diện thành công');
                } else {
                    alert((data && data.message) ? data.message : 'Cập nhật ảnh đại diện thất bại');
                }
            })
            .catch(function () {
                alert('Có lỗi xảy ra khi upload ảnh');
            });
        });
    })();
</script>
