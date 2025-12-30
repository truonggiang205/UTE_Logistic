<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Truy cập bị từ chối - UTE Logistic</title>
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
      .error-container {
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        overflow: hidden;
        max-width: 500px;
        width: 100%;
        text-align: center;
        padding: 50px 40px;
      }
      .error-icon {
        font-size: 80px;
        color: #dc3545;
        margin-bottom: 20px;
      }
      .error-title {
        font-size: 28px;
        font-weight: 700;
        color: #333;
        margin-bottom: 15px;
      }
      .error-message {
        font-size: 16px;
        color: #666;
        margin-bottom: 30px;
      }
      .btn-back {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        padding: 12px 30px;
        font-weight: 600;
        font-size: 16px;
        border-radius: 8px;
        text-decoration: none;
        display: inline-block;
        transition: transform 0.2s;
      }
      .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        color: white;
      }
    </style>
  </head>
  <body>
    <div class="error-container">
      <div class="error-icon">
        <i class="fas fa-ban"></i>
      </div>
      <h1 class="error-title">403 - Truy cập bị từ chối</h1>
      <p class="error-message">
        Bạn không có quyền truy cập trang này.<br />
        Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là lỗi.
      </p>
      <a href="/" class="btn-back">
        <i class="fas fa-home"></i> Về trang chủ
      </a>
      <a
        href="/login"
        class="btn-back"
        style="margin-left: 10px; background: #6c757d">
        <i class="fas fa-sign-in-alt"></i> Đăng nhập lại
      </a>
    </div>
  </body>
</html>
