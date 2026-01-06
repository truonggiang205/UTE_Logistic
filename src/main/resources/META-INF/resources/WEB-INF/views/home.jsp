<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="homepage-wrapper">
  <section class="hero-banner-section">
    <div class="banner-image-container">
      <img
        src="<c:url value='/img/banner_home2.png'/>"
        alt="NGHV Logistics Banner" />
    </div>

    <div class="floating-actions-bar">
      <a
        href="<c:url value='/auth/register'/>"
        class="action-item item-green-1">
        <span>Đăng ký / Đăng nhập</span>
        <i class="fa-solid fa-chevron-right"></i>
      </a>

      <a href="#" class="action-item item-green-2">
        <span>Tra cứu bưu cục</span>
        <i class="fa-solid fa-chevron-right"></i>
      </a>

      <a href="#" class="action-item item-green-3">
        <span>Tra cứu đơn hàng</span>
        <i class="fa-solid fa-chevron-right"></i>
      </a>

      <a href="#" class="action-item item-green-4">
        <span>Tra cứu cước phí</span>
        <i class="fa-solid fa-chevron-right"></i>
      </a>
    </div>
  </section>

  <section class="other-content" style="padding: 50px; text-align: center">
    <h2>Chào mừng đến với NGHV Logistics</h2>
    <p>Giải pháp vận chuyển tối ưu cho doanh nghiệp của bạn.</p>
  </section>
</div>
