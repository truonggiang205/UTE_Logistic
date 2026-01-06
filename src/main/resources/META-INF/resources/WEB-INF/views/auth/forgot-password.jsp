<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%>

<head>
  <title>Quên mật khẩu - NGHV Logistics</title>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>" />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>

<body>
  <div class="auth-ghtk-container">
    <div class="auth-banner">
      <h1>KHÔI PHỤC TÀI KHOẢN</h1>
      <div class="banner-info-grid">
        <div class="info-card">
          <i class="fa-solid fa-envelope"></i>
          <p>Nhập email đã đăng ký tài khoản.</p>
        </div>
        <div class="info-card">
          <i class="fa-solid fa-link"></i>
          <p>Hệ thống sẽ gửi link đặt lại mật khẩu.</p>
        </div>
        <div class="info-card">
          <i class="fa-solid fa-shield-halved"></i>
          <p>Bảo mật thông tin an toàn tuyệt đối.</p>
        </div>
      </div>
    </div>

    <div class="auth-form-container">
      <div class="auth-form-box">
        <h2>Quên mật khẩu</h2>
        <div class="auth-switch">
          <p>
            Bạn đã nhớ mật khẩu?
            <a href="<c:url value='/auth/login'/>">Đăng nhập ngay</a>
          </p>
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

        <c:if test="${not empty message}">
          <div
            class="alert alert-success"
            style="
              color: #00b14f;
              margin-bottom: 15px;
              padding: 10px;
              background: #e6ffe6;
              border-radius: 5px;
            ">
            <i class="fa-solid fa-circle-check"></i> ${message}
          </div>
        </c:if>

        <!-- Dev/Demo: Hiển thị link reset nếu có -->
        <c:if test="${not empty resetLink}">
          <div
            class="alert alert-info"
            style="
              color: #0066cc;
              margin-bottom: 15px;
              padding: 10px;
              background: #e6f3ff;
              border-radius: 5px;
              word-break: break-all;
            ">
            <i class="fa-solid fa-info-circle"></i>
            <strong>[DEV MODE]</strong> Link đặt lại:<br />
            <a href="${resetLink}" style="color: #0066cc">${resetLink}</a>
          </div>
        </c:if>

        <form action="<c:url value='/auth/forgot-password'/>" method="POST">
          <div class="form-group">
            <input
              type="email"
              name="email"
              class="ghtk-input"
              placeholder="Nhập email đã đăng ký"
              required />
          </div>
          <button type="submit" class="btn-ghtk-auth">
            <i class="fa-solid fa-paper-plane"></i> Gửi yêu cầu
          </button>
        </form>

        <div style="margin-top: 20px; text-align: center">
          <a href="<c:url value='/auth/register'/>" style="color: #00b14f">
            <i class="fa-solid fa-user-plus"></i> Chưa có tài khoản? Đăng ký
            ngay
          </a>
        </div>
      </div>
    </div>
  </div>
</body>
