<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%>

<head>
  <title>Đăng ký dịch vụ - NGHV Logistics</title>
  <link rel="stylesheet" href="<c:url value='/css/auth.css'/>" />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>

<body>
  <div class="auth-ghtk-container">
    <div
      class="auth-banner"
      style="
        background-image: url('<c:url value='/images/auth-banner-reg-bg.png'/>');
      ">
      <h1>TOP supplier kiểm soát hàng tốt nhất</h1>
      <div class="banner-info-grid">
        <div class="info-card">
          <i class="fa-regular fa-calendar-check"></i>
          <p>Yêu cầu bưu tá thực hiện giao nhiều ca.</p>
        </div>
        <div class="info-card">
          <i class="fa-solid fa-chart-line"></i>
          <p>Hệ thống đánh giá để thúc đẩy tỷ lệ thành công.</p>
        </div>
      </div>
    </div>

    <div class="auth-form-container">
      <div class="auth-form-box">
        <h2>Đăng ký dịch vụ</h2>
        <div class="auth-switch">
          <p>
            Bạn đã có tài khoản NGHV?
            <a href="<c:url value='/auth/login'/>">Đăng nhập</a>
          </p>
        </div>

        <form id="registerForm">
          <div class="form-group">
            <input
              type="text"
              name="businessName"
              class="ghtk-input"
              placeholder="Tên cửa hàng"
              required />
          </div>
          <div class="form-group">
            <input
              type="text"
              name="phone"
              class="ghtk-input"
              placeholder="Điện thoại liên hệ"
              required />
          </div>

          <div class="form-group address-grid">
            <input
              type="text"
              name="province"
              class="ghtk-input"
              placeholder="Tỉnh/TP"
              required />
            <input
              type="text"
              name="district"
              class="ghtk-input"
              placeholder="Quận/Huyện"
              required />
            <input
              type="text"
              name="ward"
              class="ghtk-input"
              placeholder="Phường/Xã"
              required />
          </div>
          <div class="form-group">
            <input
              type="text"
              name="addressDetail"
              class="ghtk-input"
              placeholder="Số nhà, tên đường..."
              required />
          </div>

          <div class="form-group">
            <input
              type="password"
              name="password"
              id="password"
              class="ghtk-input"
              placeholder="Mật khẩu"
              required />
          </div>
          <div class="form-group">
            <input
              type="password"
              name="confirmPassword"
              id="confirmPassword"
              class="ghtk-input"
              placeholder="Nhập lại mật khẩu"
              required />
          </div>

          <div class="policy-check">
            <input type="checkbox" id="policy" required />
            <label for="policy"
              >Tôi đồng ý với <a href="#">Điều khoản & Chính sách</a></label
            >
          </div>

          <button
            type="button"
            onclick="handleRegisterRequest()"
            class="btn-ghtk-auth">
            Đăng ký ngay
          </button>
        </form>
      </div>
    </div>

    <div id="otpModal" class="ghtk-modal-overlay" style="display: none">
      <div class="ghtk-modal-content">
        <div class="modal-header-green">
          <span>Xác thực số điện thoại</span>
          <button class="close-btn" onclick="closeOtpModal()">&times;</button>
        </div>
        <div class="modal-body">
          <p>
            Mã OTP đã gửi về SĐT: <strong id="displayPhone"></strong>. Vui lòng
            nhập mã:
          </p>
          <div class="otp-inputs">
            <input
              type="text"
              id="otpCode"
              maxlength="6"
              placeholder="000 000" />
          </div>
          <p class="timer-text">
            Yêu cầu gửi lại sau <span id="timer">60</span>s
          </p>
          <button onclick="confirmOtpVerify()" class="btn-verify-otp">
            Xác thực
          </button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="<c:url value='/js/register.js'/>"></script>
</body>
