<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%@ taglib prefix="sec"
uri="http://www.springframework.org/security/tags" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-user text-success"></i> Thông tin cá nhân
    </h1>
  </div>

  <div class="row">
    <div class="col-lg-4">
      <div class="card shadow mb-4">
        <div class="card-body text-center">
          <img
            class="img-profile rounded-circle mb-3"
            style="width: 150px; height: 150px; object-fit: cover"
            src="${shipper.avatarUrl != null ? shipper.avatarUrl : pageContext.request.contextPath.concat('/static/img/undraw_profile.svg')}" />
          <h4 class="font-weight-bold">${shipper.fullName}</h4>
          <p class="text-muted">${shipper.email}</p>
          <div class="mb-3">
            <c:forEach begin="1" end="5" var="star">
              <c:choose>
                <c:when test="${star <= shipper.rating}">
                  <i class="fas fa-star text-warning"></i>
                </c:when>
                <c:otherwise>
                  <i class="far fa-star text-warning"></i>
                </c:otherwise>
              </c:choose>
            </c:forEach>
            <span class="ml-2">${shipper.rating}/5.0</span>
          </div>
          <span
            class="badge badge-${shipper.status == 'active' ? 'success' : 'secondary'} p-2">
            ${shipper.status == 'active' ? 'Đang hoạt động' : 'Không hoạt động'}
          </span>
        </div>
      </div>

      <div class="card shadow mb-4">
        <div class="card-header py-3 bg-success text-white">
          <h6 class="m-0 font-weight-bold">Thống kê</h6>
        </div>
        <div class="card-body">
          <div class="row text-center">
            <div class="col-6 mb-3">
              <div class="h4 text-success">
                ${totalDelivered != null ? totalDelivered : 0}
              </div>
              <small class="text-muted">Đơn đã giao</small>
            </div>
            <div class="col-6 mb-3">
              <div class="h4 text-info">
                ${successRate != null ? successRate : 0}%
              </div>
              <small class="text-muted">Tỷ lệ thành công</small>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-success">Thông tin chi tiết</h6>
        </div>
        <div class="card-body">
          <form
            method="POST"
            action="${pageContext.request.contextPath}/shipper/profile/update">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Họ và tên</label>
                  <input
                    type="text"
                    class="form-control"
                    name="fullName"
                    value="${shipper.fullName}" />
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>Email</label>
                  <input
                    type="email"
                    class="form-control"
                    value="${shipper.email}"
                    disabled />
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>Số điện thoại</label>
                  <input
                    type="tel"
                    class="form-control"
                    name="phone"
                    value="${shipper.phone}" />
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>CCCD/CMND</label>
                  <input
                    type="text"
                    class="form-control"
                    name="idNumber"
                    value="${shipper.idNumber}" />
                </div>
              </div>
              <div class="col-12">
                <div class="form-group">
                  <label>Địa chỉ</label>
                  <textarea class="form-control" name="address" rows="2">
${shipper.address}</textarea
                  >
                </div>
              </div>
            </div>
            <button type="submit" class="btn btn-success">
              <i class="fas fa-save"></i> Cập nhật
            </button>
          </form>
        </div>
      </div>

      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-warning">Đổi mật khẩu</h6>
        </div>
        <div class="card-body">
          <form
            method="POST"
            action="${pageContext.request.contextPath}/shipper/profile/password">
            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label>Mật khẩu hiện tại</label>
                  <input
                    type="password"
                    class="form-control"
                    name="currentPassword"
                    required />
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label>Mật khẩu mới</label>
                  <input
                    type="password"
                    class="form-control"
                    name="newPassword"
                    required />
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label>Xác nhận mật khẩu</label>
                  <input
                    type="password"
                    class="form-control"
                    name="confirmPassword"
                    required />
                </div>
              </div>
            </div>
            <button type="submit" class="btn btn-warning">
              <i class="fas fa-key"></i> Đổi mật khẩu
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
