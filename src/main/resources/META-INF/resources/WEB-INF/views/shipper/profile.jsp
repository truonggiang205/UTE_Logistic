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
                    <div class="mb-3">
                        <c:choose>
                            <c:when test="${not empty profile.avatarUrl}">
                                <img src="${profile.avatarUrl}" alt="Avatar" 
                                     class="rounded-circle img-thumbnail" 
                                     style="width: 150px; height: 150px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center" 
                                     style="width: 150px; height: 150px;">
                                    <i class="fas fa-user fa-4x text-white"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h4 class="font-weight-bold mb-1">${profile.fullName}</h4>
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
                    <a href="#" class="btn btn-outline-primary btn-sm mr-2" onclick="alert('Chức năng đang phát triển!')">
                        <i class="fas fa-edit"></i> Sửa thông tin
                    </a>
                    <a href="#" class="btn btn-outline-warning btn-sm" onclick="alert('Chức năng đang phát triển!')">
                        <i class="fas fa-key"></i> Đổi mật khẩu
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
