<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<head>
<title>Đăng nhập - NGHV Logistics</title>
<link rel="stylesheet" href="<c:url value='/css/auth.css'/>">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
	<div class="auth-ghtk-container">
		<div class="auth-banner">
			<h1>ĐÒN BẨY TĂNG TRƯỞNG DÀNH RIÊNG CHO DOANH NGHIỆP</h1>
			<div class="banner-info-grid">
				<div class="info-card">
					<i class="fa-solid fa-hand-holding-dollar"></i>
					<p>Tối ưu chi phí vận hành, gia tăng lợi nhuận.</p>
				</div>
				<div class="info-card">
					<i class="fa-solid fa-users-gear"></i>
					<p>Tinh gọn quy trình, quản lý dễ dàng.</p>
				</div>
				<div class="info-card">
					<i class="fa-solid fa-rocket"></i>
					<p>Mượt mà mọi điểm chạm, nâng cao trải nghiệm.</p>
				</div>
			</div>
		</div>

		<div class="auth-form-container">
			<div class="auth-form-box">
				<h2>Đăng nhập</h2>
				<div class="auth-switch">
					<p>
						Bạn chưa có tài khoản? <a href="<c:url value='/auth/register'/>">Đăng
							ký ngay</a>
					</p>
				</div>

				<c:if test="${not empty error}">
					<div class="alert alert-danger"
						style="color: red; margin-bottom: 15px;">${error}</div>
				</c:if>
				<c:if test="${param.success != null}">
					<div class="alert alert-success"
						style="color: green; margin-bottom: 15px;">Đăng ký thành
						công! Hãy đăng nhập.</div>
				</c:if>
				<c:if test="${param.logout != null}">
					<div class="alert alert-info"
						style="color: #00B14F; font-weight: bold; margin-bottom: 15px;">
						<i class="fa-solid fa-circle-check"></i> Đăng xuất thành công! Hẹn
						gặp lại bạn.
					</div>
				</c:if>

				<form action="<c:url value='/auth/login'/>" method="POST">
					<div class="form-group">
						<input type="text" name="identifier" class="ghtk-input"
							placeholder="Email hoặc số điện thoại" required>
					</div>
					<div class="form-group">
						<input type="password" name="password" class="ghtk-input"
							placeholder="Mật khẩu" required>
					</div>
					<a href="#" class="forgot-password">Quên mật khẩu?</a>
					<button type="submit" class="btn-ghtk-auth">Đăng nhập</button>
				</form>
			</div>
		</div>
	</div>
</body>