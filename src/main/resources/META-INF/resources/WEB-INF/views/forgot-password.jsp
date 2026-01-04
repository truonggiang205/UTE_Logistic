<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Quên mật khẩu - UTE Logistic</title>
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
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 6px;
    }

    .login-header p {
      opacity: 0.9;
      font-size: 14px;
      margin: 0;
    }

    .login-body {
      padding: 34px 30px 30px;
    }

    .form-floating {
      margin-bottom: 16px;
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

    .alert {
      border-radius: 12px;
      padding: 14px 18px;
      margin-bottom: 16px;
      display: flex;
      align-items: flex-start;
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

    .helper {
      font-size: 13px;
      color: #6c757d;
      margin-bottom: 18px;
      line-height: 1.45;
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--primary);
      text-decoration: none;
      font-size: 14px;
      margin-top: 14px;
    }

    .back-link:hover {
      text-decoration: underline;
    }

    .dev-link {
      word-break: break-all;
    }
  </style>
</head>

<body>
  <div class="login-container">
    <div class="login-card">
      <div class="login-header">
        <div class="logo">
          <i class="fas fa-key"></i>
        </div>
        <h1>Quên mật khẩu</h1>
        <p>Tạo link đặt lại mật khẩu</p>
      </div>

      <div class="login-body">
        <c:if test="${not empty error}">
          <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <div>${error}</div>
          </div>
        </c:if>

        <c:if test="${not empty message}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <div>
              ${message}
              <c:if test="${not empty resetLink}">
                <div class="mt-2 small text-muted">(Dev) Link đặt lại:</div>
                <a class="dev-link d-block" href="${resetLink}">${resetLink}</a>
              </c:if>
            </div>
          </div>
        </c:if>

        <div class="helper">
          Nhập email tài khoản của bạn. Nếu email tồn tại, hệ thống sẽ tạo link đặt lại mật khẩu.
        </div>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
          <div class="form-floating-wrapper">
            <i class="fas fa-envelope input-icon"></i>
            <div class="form-floating">
              <input type="email" class="form-control" id="email" name="email" placeholder="Email" required autofocus />
              <label for="email">Email tài khoản</label>
            </div>
          </div>

          <button type="submit" class="btn-login">
            <i class="fas fa-paper-plane"></i>
            Tạo link đặt lại
          </button>
        </form>

        <a class="back-link" href="${pageContext.request.contextPath}/login">
          <i class="fas fa-arrow-left"></i>
          Quay lại đăng nhập
        </a>
      </div>
    </div>
  </div>
</body>

</html>
