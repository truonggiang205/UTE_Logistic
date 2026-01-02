<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Đăng nhập - UTE Logistic</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
      <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
      <style>
        :root {
          --primary: #4361ee;
          --primary-dark: #3a56d4;
          --accent: #7209b7;
          --success: #06d6a0;
          --warning: #ffc107;
          --danger: #ef476f;
          --dark: #1a1a2e;
          --light: #f8f9fa;
        }

        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        body {
          font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
          background: linear-gradient(135deg,
              #1a1a2e 0%,
              #16213e 50%,
              #0f3460 100%);
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
        }

        .login-container {
          width: 100%;
          max-width: 420px;
        }

        .login-card {
          background: rgba(255, 255, 255, 0.95);
          border-radius: 24px;
          box-shadow: 0 25px 80px rgba(0, 0, 0, 0.4);
          overflow: hidden;
          animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }

          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        .login-header {
          background: linear-gradient(135deg, var(--primary), var(--accent));
          padding: 40px 30px;
          text-align: center;
          color: white;
        }

        .login-header .logo {
          width: 80px;
          height: 80px;
          background: rgba(255, 255, 255, 0.2);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 20px;
          font-size: 36px;
        }

        .login-header h1 {
          font-size: 28px;
          font-weight: 700;
          margin-bottom: 5px;
        }

        .login-header p {
          opacity: 0.9;
          font-size: 14px;
        }

        .login-body {
          padding: 40px 30px;
        }

        .form-floating {
          margin-bottom: 20px;
        }

        .form-floating .form-control {
          border: 2px solid #e9ecef;
          border-radius: 12px;
          padding: 16px 16px 16px 50px;
          height: 58px;
          font-size: 15px;
          transition: all 0.3s ease;
        }

        .form-floating .form-control:focus {
          border-color: var(--primary);
          box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.15);
        }

        .form-floating label {
          padding-left: 50px;
          color: #6c757d;
        }

        .input-icon {
          position: absolute;
          left: 18px;
          top: 50%;
          transform: translateY(-50%);
          color: var(--primary);
          font-size: 18px;
          z-index: 5;
        }

        .form-floating-wrapper {
          position: relative;
        }

        .btn-login {
          width: 100%;
          padding: 16px;
          background: linear-gradient(135deg, var(--primary), var(--accent));
          border: none;
          border-radius: 12px;
          color: white;
          font-size: 16px;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.3s ease;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 10px;
        }

        .btn-login:hover {
          transform: translateY(-2px);
          box-shadow: 0 10px 30px rgba(67, 97, 238, 0.4);
        }

        .btn-login:active {
          transform: translateY(0);
        }

        .alert {
          border-radius: 12px;
          padding: 15px 20px;
          margin-bottom: 20px;
          display: flex;
          align-items: center;
          gap: 12px;
          font-size: 14px;
        }

        .alert-danger {
          background: rgba(239, 71, 111, 0.1);
          border: 1px solid rgba(239, 71, 111, 0.3);
          color: var(--danger);
        }

        .alert-success {
          background: rgba(6, 214, 160, 0.1);
          border: 1px solid rgba(6, 214, 160, 0.3);
          color: var(--success);
        }

        .divider {
          display: flex;
          align-items: center;
          margin: 25px 0;
          color: #adb5bd;
          font-size: 13px;
        }

        .divider::before,
        .divider::after {
          content: "";
          flex: 1;
          height: 1px;
          background: #e9ecef;
        }

        .divider span {
          padding: 0 15px;
        }

        .demo-accounts {
          background: #f8f9fa;
          border-radius: 12px;
          padding: 20px;
        }

        .demo-accounts h6 {
          font-size: 13px;
          color: #6c757d;
          margin-bottom: 15px;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        .demo-btn {
          display: block;
          width: 100%;
          padding: 12px 15px;
          margin-bottom: 10px;
          background: white;
          border: 1px solid #e9ecef;
          border-radius: 10px;
          text-align: left;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .demo-btn:last-child {
          margin-bottom: 0;
        }

        .demo-btn:hover {
          border-color: var(--primary);
          background: rgba(67, 97, 238, 0.05);
          transform: translateX(5px);
        }

        .demo-btn .role {
          font-weight: 600;
          color: var(--dark);
          font-size: 14px;
        }

        .demo-btn .email {
          font-size: 12px;
          color: #6c757d;
          margin-top: 2px;
        }

        .demo-btn .badge {
          float: right;
          margin-top: 5px;
        }

        .password-toggle {
          position: absolute;
          right: 15px;
          top: 50%;
          transform: translateY(-50%);
          background: none;
          border: none;
          color: #6c757d;
          cursor: pointer;
          z-index: 5;
          padding: 5px;
        }

        .password-toggle:hover {
          color: var(--primary);
        }

        .remember-forgot {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 25px;
          font-size: 14px;
        }

        .remember-forgot a {
          color: var(--primary);
          text-decoration: none;
        }

        .remember-forgot a:hover {
          text-decoration: underline;
        }

        .form-check-input:checked {
          background-color: var(--primary);
          border-color: var(--primary);
        }
      </style>
    </head>

    <body>
      <div class="login-container">
        <div class="login-card">
          <div class="login-header">
            <div class="logo">
              <i class="fas fa-shipping-fast"></i>
            </div>
            <h1>UTE Logistic</h1>
            <p>Hệ thống quản lý vận chuyển hàng hóa</p>
          </div>

          <div class="login-body">
            <c:if test="${not empty error}">
              <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
              </div>
            </c:if>

            <c:if test="${not empty message}">
              <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
              </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/do-login" method="post">
              <div class="form-floating-wrapper">
                <i class="fas fa-envelope input-icon"></i>
                <div class="form-floating">
                  <input type="email" class="form-control" id="email" name="email" placeholder="Email" required
                    autofocus />
                  <label for="email">Email đăng nhập</label>
                </div>
              </div>

              <div class="form-floating-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <div class="form-floating">
                  <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu"
                    required />
                  <label for="password">Mật khẩu</label>
                </div>
                <button type="button" class="password-toggle" onclick="togglePassword()">
                  <i class="fas fa-eye" id="toggleIcon"></i>
                </button>
              </div>

              <div class="remember-forgot">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="remember" name="remember" />
                  <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                </div>
                <a href="#">Quên mật khẩu?</a>
              </div>

              <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i>
                Đăng nhập
              </button>
            </form>

            <div class="divider">
              <span>Tài khoản demo</span>
            </div>

            <div class="demo-accounts">
              <h6><i class="fas fa-user-circle me-2"></i>Đăng nhập nhanh</h6>

              <button type="button" class="demo-btn" onclick="fillLogin('admin@logistic.local', 'admin123')">
                <div class="role">
                  <i class="fas fa-user-shield me-2 text-danger"></i>Admin
                </div>
                <div class="email">admin@logistic.local</div>
                <span class="badge bg-danger">ADMIN</span>
              </button>

              <button type="button" class="demo-btn" onclick="fillLogin('staff01@logistic.local', 'staff123')">
                <div class="role">
                  <i class="fas fa-user-tie me-2 text-primary"></i>Staff / Manager
                </div>
                <div class="email">staff01@logistic.local</div>
                <span class="badge bg-primary">STAFF</span>
              </button>

              <button type="button" class="demo-btn" onclick="fillLogin('shipper01@logistic.local', 'shipper123')">
                <div class="role">
                  <i class="fas fa-motorcycle me-2 text-success"></i>Shipper
                </div>
                <div class="email">shipper01@logistic.local</div>
                <span class="badge bg-success">SHIPPER</span>
              </button>

              <button type="button" class="demo-btn" onclick="fillLogin('cust01@logistic.local', 'cust123')">
                <div class="role">
                  <i class="fas fa-user me-2 text-info"></i>Customer
                </div>
                <div class="email">cust01@logistic.local</div>
                <span class="badge bg-info">CUSTOMER</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <script>
        function togglePassword() {
          const passwordInput = document.getElementById("password");
          const toggleIcon = document.getElementById("toggleIcon");

          if (passwordInput.type === "password") {
            passwordInput.type = "text";
            toggleIcon.classList.remove("fa-eye");
            toggleIcon.classList.add("fa-eye-slash");
          } else {
            passwordInput.type = "password";
            toggleIcon.classList.remove("fa-eye-slash");
            toggleIcon.classList.add("fa-eye");
          }
        }

        function fillLogin(email, password) {
          document.getElementById("email").value = email;
          document.getElementById("password").value = password;
          document.getElementById("email").focus();
        }
      </script>
    </body>

    </html>