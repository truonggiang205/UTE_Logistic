<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">
            <i class="fas fa-user-circle text-primary"></i> Thông tin cá nhân
        </h1>
    </div>

    <div class="row">
        <!-- Profile Card -->
        <div class="col-xl-4 col-lg-5">
            <!-- Avatar & Basic Info -->
            <div class="card shadow mb-4">
                <div class="card-body text-center">
                    <div class="mb-3 position-relative d-inline-block">
                        <c:choose>
                            <c:when test="${not empty profile.avatarUrl}">
                                <img src="${profile.avatarUrl}" alt="Avatar" id="profileAvatar"
                                     class="rounded-circle img-thumbnail" 
                                     style="width: 150px; height: 150px; object-fit: cover; cursor: pointer;"
                                     onclick="document.getElementById('avatarInput').click()">
                            </c:when>
                            <c:otherwise>
                                <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center" 
                                     style="width: 150px; height: 150px; cursor: pointer;"
                                     onclick="document.getElementById('avatarInput').click()">
                                    <i class="fas fa-user fa-4x text-white"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <!-- Camera icon overlay -->
                        <div class="position-absolute" style="bottom: 5px; right: 5px;">
                            <span class="btn btn-sm btn-primary rounded-circle" onclick="document.getElementById('avatarInput').click()">
                                <i class="fas fa-camera"></i>
                            </span>
                        </div>
                        <!-- Hidden file input -->
                        <input type="file" id="avatarInput" accept="image/*" style="display: none;">
                    </div>
                    <h4 class="font-weight-bold mb-1" id="displayFullName">${profile.fullName}</h4>
                    <p class="text-muted mb-2">@${profile.username}</p>
                    
                    <!-- Status Badge -->
                    <c:choose>
                        <c:when test="${profile.shipperStatus == 'active'}">
                            <span class="badge badge-success px-3 py-2">
                                <i class="fas fa-check-circle"></i> Đang hoạt động
                            </span>
                        </c:when>
                        <c:when test="${profile.shipperStatus == 'busy'}">
                            <span class="badge badge-warning px-3 py-2">
                                <i class="fas fa-clock"></i> Đang bận
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-secondary px-3 py-2">
                                <i class="fas fa-pause-circle"></i> Không hoạt động
                            </span>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Rating -->
                    <div class="mt-3">
                        <div class="h4 mb-0">
                            <span class="text-warning">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= profile.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                        </div>
                        <small class="text-muted">
                            <fmt:formatNumber value="${profile.rating}" maxFractionDigits="1"/>/5
                            (${profile.totalRatings} đánh giá)
                        </small>
                    </div>
                </div>
                <div class="card-footer bg-light">
                    <div class="row text-center">
                        <div class="col-4 border-right">
                            <h5 class="font-weight-bold text-primary mb-0">${profile.totalOrders}</h5>
                            <small class="text-muted">Tổng đơn</small>
                        </div>
                        <div class="col-4 border-right">
                            <h5 class="font-weight-bold text-success mb-0">${profile.completedOrders}</h5>
                            <small class="text-muted">Thành công</small>
                        </div>
                        <div class="col-4">
                            <h5 class="font-weight-bold text-danger mb-0">${profile.failedOrders}</h5>
                            <small class="text-muted">Thất bại</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="card shadow mb-4 border-left-success">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Tổng thu nhập</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <fmt:formatNumber value="${profile.totalEarnings != null ? profile.totalEarnings : 0}" 
                                    type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                            </div>
                        </div>
                        <i class="fas fa-wallet fa-2x text-success"></i>
                    </div>
                </div>
            </div>

            <!-- Success Rate -->
            <div class="card shadow mb-4">
                <div class="card-body">
                    <h6 class="font-weight-bold text-primary">
                        <i class="fas fa-chart-pie"></i> Tỷ lệ giao thành công
                    </h6>
                    <div class="text-center py-3">
                        <div class="h2 font-weight-bold text-success mb-0">
                            <fmt:formatNumber value="${profile.successRate}" maxFractionDigits="0"/>%
                        </div>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-success" role="progressbar" 
                             style="width: ${profile.successRate}%"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Details -->
        <div class="col-xl-8 col-lg-7">
            <!-- Contact Info -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-address-card"></i> Thông tin liên hệ
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Email</label>
                            <div class="font-weight-bold">
                                <i class="fas fa-envelope text-primary"></i>
                                ${not empty profile.email ? profile.email : 'Chưa cập nhật'}
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Số điện thoại</label>
                            <div class="font-weight-bold">
                                <i class="fas fa-phone text-primary"></i>
                                ${not empty profile.phone ? profile.phone : 'Chưa cập nhật'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Shipper Info -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-motorcycle"></i> Thông tin Shipper
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Mã Shipper</label>
                            <div class="font-weight-bold text-primary">
                                #SHP${String.format("%05d", profile.shipperId)}
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Loại hình</label>
                            <div>
                                <c:choose>
                                    <c:when test="${profile.shipperType == 'fulltime'}">
                                        <span class="badge badge-primary px-3 py-2">
                                            <i class="fas fa-briefcase"></i> Full-time
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-info px-3 py-2">
                                            <i class="fas fa-user-clock"></i> Part-time
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Phương tiện</label>
                            <div class="font-weight-bold">
                                <c:choose>
                                    <c:when test="${profile.vehicleType == 'motorbike'}">
                                        <i class="fas fa-motorcycle text-warning"></i> Xe máy
                                    </c:when>
                                    <c:when test="${profile.vehicleType == 'bicycle'}">
                                        <i class="fas fa-bicycle text-info"></i> Xe đạp
                                    </c:when>
                                    <c:when test="${profile.vehicleType == 'car'}">
                                        <i class="fas fa-car text-success"></i> Ô tô
                                    </c:when>
                                    <c:otherwise>
                                        ${not empty profile.vehicleType ? profile.vehicleType : 'Chưa cập nhật'}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Ngày tham gia</label>
                            <div class="font-weight-bold">
                                <i class="fas fa-calendar-alt text-primary"></i>
                                ${profile.joinedAt}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hub Info -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-info text-white">
                    <h6 class="m-0 font-weight-bold">
                        <i class="fas fa-warehouse"></i> Hub được phân bổ
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Tên Hub</label>
                            <div class="font-weight-bold text-info">${profile.hubName}</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Địa chỉ</label>
                            <div class="font-weight-bold">${profile.hubAddress}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Account Info -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-shield-alt"></i> Thông tin tài khoản
                    </h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Tên đăng nhập</label>
                            <div class="font-weight-bold">@${profile.username}</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Trạng thái tài khoản</label>
                            <div>
                                <c:choose>
                                    <c:when test="${profile.userStatus == 'active'}">
                                        <span class="badge badge-success">Hoạt động</span>
                                    </c:when>
                                    <c:when test="${profile.userStatus == 'inactive'}">
                                        <span class="badge badge-warning">Tạm khóa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Bị cấm</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Lần đăng nhập cuối</label>
                            <div class="font-weight-bold">
                                <i class="fas fa-clock text-muted"></i> ${profile.lastLoginAt}
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="text-muted small">Ngày tạo tài khoản</label>
                            <div class="font-weight-bold">
                                <i class="fas fa-calendar-plus text-muted"></i> ${profile.createdAt}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-center">
                    <a href="#" class="btn btn-outline-warning btn-sm" data-toggle="modal" data-target="#changePasswordModal">
                        <i class="fas fa-key"></i> Đổi mật khẩu
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Đổi mật khẩu -->
<div class="modal fade" id="changePasswordModal" tabindex="-1" role="dialog" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title" id="changePasswordModalLabel">
                    <i class="fas fa-key"></i> Đổi mật khẩu
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="changePasswordForm">
                    <div class="form-group">
                        <label for="currentPassword">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            </div>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                                   placeholder="Nhập mật khẩu hiện tại" required>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary toggle-password" type="button" data-target="currentPassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-key"></i></span>
                            </div>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                   placeholder="Nhập mật khẩu mới (tối thiểu 8 ký tự)" required minlength="8">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary toggle-password" type="button" data-target="newPassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <small class="form-text text-muted">Mật khẩu phải có ít nhất 8 ký tự</small>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-check-circle"></i></span>
                            </div>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới" required minlength="8">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary toggle-password" type="button" data-target="confirmPassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div id="passwordError" class="alert alert-danger d-none"></div>
                    <div id="passwordSuccess" class="alert alert-success d-none"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="button" class="btn btn-warning" id="btnChangePassword">
                    <i class="fas fa-save"></i> Đổi mật khẩu
                </button>
            </div>
        </div>
    </div>
</div>


<script>
// Wait for jQuery to be loaded (since scripts_js.jsp loads after this content)
document.addEventListener('DOMContentLoaded', function() {
    // Check if jQuery is ready, if not wait for it
    var checkJQuery = setInterval(function() {
        if (typeof $ !== 'undefined') {
            clearInterval(checkJQuery);
            initChangePassword();
        }
    }, 50);
});

function initChangePassword() {
    // Toggle password visibility
    $('.toggle-password').click(function() {
        var targetId = $(this).data('target');
        var input = $('#' + targetId);
        var icon = $(this).find('i');
        
        if (input.attr('type') === 'password') {
            input.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            input.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });

    // Xử lý đổi mật khẩu
    $('#btnChangePassword').click(function() {
        var currentPassword = $('#currentPassword').val();
        var newPassword = $('#newPassword').val();
        var confirmPassword = $('#confirmPassword').val();

        // Reset messages
        $('#passwordError').addClass('d-none').text('');
        $('#passwordSuccess').addClass('d-none').text('');

        // Validate
        if (!currentPassword || !newPassword || !confirmPassword) {
            $('#passwordError').removeClass('d-none').text('Vui lòng điền đầy đủ thông tin');
            return;
        }

        if (newPassword.length < 8) {
            $('#passwordError').removeClass('d-none').text('Mật khẩu mới phải có ít nhất 8 ký tự');
            return;
        }

        if (newPassword !== confirmPassword) {
            $('#passwordError').removeClass('d-none').text('Mật khẩu mới và xác nhận không khớp');
            return;
        }

        // Disable button
        var btn = $(this);
        btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');

        // Send AJAX request
        $.ajax({
            url: '${pageContext.request.contextPath}/shipper/change-password',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                currentPassword: currentPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            }),
            success: function(response) {
                if (response.success) {
                    $('#passwordSuccess').removeClass('d-none').text(response.message);
                    $('#changePasswordForm')[0].reset();
                    
                    // Close modal after 2 seconds
                    setTimeout(function() {
                        $('#changePasswordModal').modal('hide');
                        $('#passwordSuccess').addClass('d-none');
                    }, 2000);
                } else {
                    $('#passwordError').removeClass('d-none').text(response.message);
                }
            },
            error: function(xhr) {
                var errorMsg = 'Có lỗi xảy ra. Vui lòng thử lại!';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                }
                $('#passwordError').removeClass('d-none').text(errorMsg);
            },
            complete: function() {
                btn.prop('disabled', false).html('<i class="fas fa-save"></i> Đổi mật khẩu');
            }
        });
    });

    // Reset form when modal is closed
    $('#changePasswordModal').on('hidden.bs.modal', function() {
        $('#changePasswordForm')[0].reset();
        $('#passwordError').addClass('d-none');
        $('#passwordSuccess').addClass('d-none');
    });

    // ===== AVATAR UPLOAD =====
    
    // Handle avatar upload
    $('#avatarInput').change(function() {
        var file = this.files[0];
        if (!file) return;

        // Validate file type
        if (!file.type.startsWith('image/')) {
            alert('Vui lòng chọn file ảnh (JPG, PNG, GIF)');
            return;
        }

        // Validate file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('Kích thước ảnh không được vượt quá 5MB');
            return;
        }

        // Create FormData
        var formData = new FormData();
        formData.append('avatar', file);

        // Show loading
        var avatarContainer = $(this).closest('.mb-3');
        avatarContainer.css('opacity', '0.5');

        // Send AJAX request
        $.ajax({
            url: '${pageContext.request.contextPath}/shipper/update-avatar',
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                if (response.success) {
                    // Update avatar image
                    var img = $('#profileAvatar');
                    if (img.length) {
                        img.attr('src', response.avatarUrl + '?t=' + new Date().getTime());
                    } else {
                        // If using placeholder, reload page
                        location.reload();
                    }
                    alert('Cập nhật ảnh đại diện thành công!');
                } else {
                    alert('Lỗi: ' + response.message);
                }
            },
            error: function(xhr) {
                var errorMsg = 'Có lỗi xảy ra. Vui lòng thử lại!';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                }
                alert('Lỗi: ' + errorMsg);
            },
            complete: function() {
                avatarContainer.css('opacity', '1');
            }
        });
    });
}
</script>


