<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><sitemesh:write property='title'>NGHV - Giao Hàng Tiết Kiệm</sitemesh:write></title>

<link rel="stylesheet" href="/css/ghtk-layout.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<sitemesh:write property="head" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
	<header class="ghtk-header">
		<div class="header-container">
			<div class="logo">
				<a href="/"> <img src="<c:url value='/img/logo_nghv1.png'/>"
					alt="NGHV Logo">
				</a>
			</div>

			<nav class="main-nav">
				<ul>
					<li><a href="/" class="active">Trang chủ</a></li>
					<li><a href="#">Về chúng tôi</a></li>
					<li><a href="#">For Business <i
							class="fa-solid fa-chevron-down"></i></a></li>
					<li><a href="#">For E-Commerce <i
							class="fa-solid fa-chevron-down"></i></a></li>
					<li><a href="#">Tuyển dụng</a></li>
					<li><a href="#">Tin tức <i
							class="fa-solid fa-chevron-down"></i></a></li>
					<li><a href="#">Hỏi đáp</a></li>
					<li><a href="#">Liên hệ</a></li>
				</ul>
			</nav>

			<div class="header-actions">
				<div class="lang-switch">
					<i class="fa-solid fa-globe"></i> VI <i
						class="fa-solid fa-chevron-down"></i>
				</div>
				<button class="btn-consult">Tư vấn Doanh nghiệp</button>
			</div>
		</div>
	</header>

	<main>
		<sitemesh:write property="body" />
	</main>

<c:if test="${empty hideFooter or not hideFooter}">
<footer class="ghtk-footer-custom">
    <div class="footer-container">
        <div class="footer-top-row">
            <div class="social-links">
                <span class="social-label">Kết nối với NGHV</span>
                <div class="social-icons">
                    <a href="#" title="Facebook"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#" title="LinkedIn"><i class="fa-brands fa-linkedin"></i></a>
                    <a href="#" title="Youtube"><i class="fa-brands fa-youtube"></i></a>
                    <a href="#" title="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                </div>
            </div>
        </div>

        <div class="footer-body">
            <div class="footer-col">
                <h4>Giới thiệu</h4>
                <ul>
                    <li><a href="#">Về chúng tôi</a></li>
                    <li><a href="#">Tuyển dụng</a></li>
                    <li><a href="#">Điều khoản bảo mật</a></li>
                    <li><a href="#">Chính sách sử dụng</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Dịch vụ</h4>
                <ul>
                    <li><a href="#">Tra cứu đơn hàng</a></li>
                    <li><a href="#">Tra cứu cước phí</a></li>
                    <li><a href="#">Tra cứu bưu cục</a></li>
                    <li><a href="#">Kết nối API</a></li>
                </ul>
            </div>
            <div class="footer-col contact-info">
                <h4>Liên hệ</h4>
                <p><i class="fa-solid fa-phone"></i> Hotline: <span class="highlight">1900-6092</span></p>
                <p><i class="fa-solid fa-comment-dots"></i> Cần hỗ trợ? <span class="highlight-link">Chat ngay</span></p>
                <p><i class="fa-solid fa-envelope"></i> info@nghv.vn</p>
                <p><i class="fa-solid fa-location-dot"></i> Tòa nhà UTE, số 1 Võ Văn Ngân, TP.Hồ Chí Minh</p>
            </div>
            <div class="footer-col app-download">
                <h4>Tải ứng dụng trên điện thoại</h4>
                <div class="download-wrapper">
                    <div class="qr-box">
                        <img src="<c:url value='/img/qr-code.png'/>" alt="QR Code">
                    </div>
                    <div class="store-buttons">
                        <a href="#"><img src="<c:url value='/img/app-store.png'/>" alt="App Store"></a>
                        <a href="#"><img src="<c:url value='/img/google-play.png'/>" alt="Google Play"></a>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="legal-info">
                <p class="company-name">CÔNG TY CỔ PHẦN NGHV LOGISTICS © 2025</p>
                <p>Giấy CNĐKKD: 0106181807 - Ngày cấp 21/05/2013 - Sở Kế hoạch và Đầu tư TP Hồ Chí Minh</p>
                <p>Giấy phép bưu chính số 346/GP-BTTTT do Bộ TT&TT cấp ngày 30/12/2025</p>
            </div>
        </div>
    </div>
</footer>
</c:if>
</body>
</html>