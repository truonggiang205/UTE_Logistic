<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%>

<head>
  <title>Đặt lại mật khẩu - NGHV Logistics</title>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>" />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>

<body>
  <div class="auth-ghtk-container">
    <div class="auth-banner">
      <h1>ĐẶT LẠI MẬT KHẨU MỚI</h1>
      <div class="banner-info-grid">
        <div class="info-card">
          <i class="fa-solid fa-key"></i>
          <p>Nhập mật khẩu mới cho tài khoản.</p>
        </div>
        <div class="info-card">
          <i class="fa-solid fa-lock"></i>
          <p>Mật khẩu tối thiểu 6 ký tự.</p>
        </div>
        <div class="info-card">
          <i class="fa-solid fa-check-double"></i>
          <p>Xác nhận mật khẩu để đảm bảo chính xác.</p>
        </div>
      </div>
    </div>

    <div class="auth-form-container">
      <div class="auth-form-box">
        <h2>Đặt lại mật khẩu</h2>
        <div class="auth-switch">
          <p>Tạo mật khẩu mới để đăng nhập vào tài khoản của bạn</p>
        </div>

        <c:if test="${not empty error}">
          <div
            class="alert alert-danger"
            style="
              color: red;
              margin-bottom: 15px;
              padding: 10px;
              background: #ffe6e6;
              border-radius: 5px;
            ">
            <i class="fa-solid fa-circle-xmark"></i> ${error}
          </div>
        </c:if>

        <form
          action="<c:url value='/auth/reset-password'/>"
          method="POST"
          id="resetForm">
          <input type="hidden" name="token" value="${token}" />

          <div class="form-group">
            <input
              type="password"
              name="newPassword"
              id="newPassword"
              class="ghtk-input"
              placeholder="Mật khẩu mới (tối thiểu 6 ký tự)"
              minlength="6"
              required />
          </div>

          <div class="form-group">
            <input
              type="password"
              name="confirmPassword"
              id="confirmPassword"
              class="ghtk-input"
              placeholder="Nhập lại mật khẩu mới"
              minlength="6"
              required />
          </div>

          <div
            id="passwordError"
            style="color: red; margin-bottom: 15px; display: none">
            <i class="fa-solid fa-exclamation-triangle"></i> Mật khẩu nhập lại
            không khớp!
          </div>

          <button type="submit" class="btn-ghtk-auth">
            <i class="fa-solid fa-check"></i> Xác nhận đổi mật khẩu
          </button>
        </form>

        <div style="margin-top: 20px; text-align: center">
          <a href="<c:url value='/auth/login'/>" style="color: #00b14f">
            <i class="fa-solid fa-arrow-left"></i> Quay lại trang đăng nhập
          </a>
        </div>
      </div>
    </div>
  </div>

  <script>
    document
      .getElementById("resetForm")
      .addEventListener("submit", function (e) {
        var newPass = document.getElementById("newPassword").value;
        var confirmPass = document.getElementById("confirmPassword").value;
        var errorDiv = document.getElementById("passwordError");

        if (newPass !== confirmPass) {
          e.preventDefault();
          errorDiv.style.display = "block";
          return false;
        } else {
          errorDiv.style.display = "none";
        }
      });

    document
      .getElementById("confirmPassword")
      .addEventListener("input", function () {
        var newPass = document.getElementById("newPassword").value;
        var confirmPass = this.value;
        var errorDiv = document.getElementById("passwordError");

        if (confirmPass.length > 0 && newPass !== confirmPass) {
          errorDiv.style.display = "block";
        } else {
          errorDiv.style.display = "none";
        }
      });
  </script>
</body>
