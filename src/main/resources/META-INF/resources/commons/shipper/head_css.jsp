<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%-- CSS-only fragment: DO NOT output <head>/<title>/<meta> here (SiteMesh decorator owns those) --%>

<!-- Font Awesome -->
<link
  href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
  rel="stylesheet"
  type="text/css" />

<!-- Google Fonts -->
<link
  href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
  rel="stylesheet" />

<!-- SB Admin 2 CSS -->
<link
  href="${pageContext.request.contextPath}/css/sb-admin-2.min.css"
  rel="stylesheet" />

<!-- Custom Shipper Styles -->
<style>
    .bg-gradient-shipper {
      background: linear-gradient(180deg, #1cc88a 10%, #13855c 100%);
      background-size: cover;
    }
    .sidebar.bg-gradient-shipper .nav-item .nav-link {
      color: rgba(255, 255, 255, 0.8);
    }
    .sidebar.bg-gradient-shipper .nav-item .nav-link:hover,
    .sidebar.bg-gradient-shipper .nav-item .nav-link:active {
      color: #fff;
    }
    .sidebar.bg-gradient-shipper .sidebar-brand {
      color: #fff;
    }
    .sidebar.bg-gradient-shipper hr.sidebar-divider {
      border-top: 1px solid rgba(255, 255, 255, 0.15);
    }
    .sidebar.bg-gradient-shipper .sidebar-heading {
      color: rgba(255, 255, 255, 0.4);
    }
  </style>
