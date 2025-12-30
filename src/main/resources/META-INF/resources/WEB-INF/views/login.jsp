<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập - UTE Logistic</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
      body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }
      .login-container {
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        overflow: hidden;
        max-width: 450px;
        width: 100%;
      }
      .login-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 40px 30px;
        text-align: center;
      }
      .login-header h1 {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 10px;
      }
      .login-header p {
        font-size: 14px;
        opacity: 0.9;
      }
      .login-body {
        padding: 40px 30px;
      }
      .form-group {
        margin-bottom: 25px;
      }
      .form-label {
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
        font-size: 14px;
      }
      .form-control {
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        padding: 12px 15px;
        font-size: 14px;
        transition: all 0.3s;
      }
      .form-control:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
      }
      .input-group-text {
        background: #f8f9fa;
        border: 2px solid #e0e0e0;
        border-right: none;
        border-radius: 8px 0 0 8px;
      }
      .input-group .form-control {
        border-left: none;
        border-radius: 0 8px 8px 0;
      }
      .btn-login {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        padding: 12px;
        font-weight: 600;
        font-size: 16px;
        border-radius: 8px;
        width: 100%;
        transition: transform 0.2s;
      }
      .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        color: white;
      }
      .alert {
        border-radius: 8px;
        padding: 12px 15px;
        font-size: 14px;
      }
      .forgot-password {
        text-align: center;
        margin-top: 20px;
      }
      .forgot-password a {
        color: #667eea;
        text-decoration: none;
        font-size: 14px;
      }
      .forgot-password a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="login-container">
      <div class="login-header">
        <h1><i class="fas fa-truck"></i> UTE Logistic</h1>
        <p>Đăng nhập để tiếp tục</p>
      </div>

      <div class="login-body">
        <!-- Thông báo lỗi đăng nhập -->
        <c:if test="${param.error != null}">
          <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> Email hoặc mật khẩu không
            đúng!
          </div>
        </c:if>

        <!-- Thông báo đăng xuất thành công -->
        <c:if test="${param.logout != null}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> Đăng xuất thành công!
          </div>
        </c:if>

        <!-- Form đăng nhập sử dụng Spring Security -->
        <form action="/do-login" method="POST">
          <div class="form-group">
            <label for="email" class="form-label">Email</label>
            <div class="input-group">
              <span class="input-group-text">
                <i class="fas fa-envelope"></i>
              </span>
              <input
                type="email"
                class="form-control"
                id="email"
                name="email"
                placeholder="Nhập địa chỉ email"
                required />
            </div>
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Mật khẩu</label>
            <div class="input-group">
              <span class="input-group-text">
                <i class="fas fa-lock"></i>
              </span>
              <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                placeholder="Nhập mật khẩu"
                required />
            </div>
          </div>

          <button type="submit" class="btn btn-login">
            <i class="fas fa-sign-in-alt"></i> Đăng nhập
          </button>
        </form>

        <div class="forgot-password">
          <a href="#"><i class="fas fa-question-circle"></i> Quên mật khẩu?</a>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
