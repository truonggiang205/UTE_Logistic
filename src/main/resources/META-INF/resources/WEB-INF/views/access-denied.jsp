<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Truy cập bị từ chối - UTE Logistic</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet" />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
      rel="stylesheet" />
    <style>
      body {
        background: linear-gradient(
          135deg,
          #1a1a2e 0%,
          #16213e 50%,
          #0f3460 100%
        );
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: "Segoe UI", system-ui, sans-serif;
      }

      .error-container {
        text-align: center;
        padding: 40px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 24px;
        box-shadow: 0 25px 80px rgba(0, 0, 0, 0.4);
        max-width: 500px;
      }

      .error-icon {
        width: 120px;
        height: 120px;
        background: linear-gradient(135deg, #ef476f, #f77f00);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 30px;
        font-size: 50px;
        color: white;
      }

      h1 {
        font-size: 32px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 15px;
      }

      p {
        color: #6c757d;
        margin-bottom: 30px;
      }

      .btn-back {
        padding: 14px 30px;
        background: linear-gradient(135deg, #4361ee, #7209b7);
        border: none;
        border-radius: 12px;
        color: white;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        transition: all 0.3s ease;
      }

      .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 30px rgba(67, 97, 238, 0.4);
        color: white;
      }
    </style>
  </head>
  <body>
    <div class="error-container">
      <div class="error-icon">
        <i class="fas fa-ban"></i>
      </div>
      <h1>Truy cập bị từ chối</h1>
      <p>
        ${message != null ? message : 'Bạn không có quyền truy cập trang này.
        Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là lỗi.'}
      </p>
      <a href="${pageContext.request.contextPath}/login" class="btn-back">
        <i class="fas fa-arrow-left"></i>
        Quay lại đăng nhập
      </a>
    </div>
  </body>
</html>
