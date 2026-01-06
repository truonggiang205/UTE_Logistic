<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><sitemesh:write property='title' /> - NGHV Logistics</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					nghv : {
						green : '#00B14F',
						orange : '#F26522',
						dark : '#0F172A'
					}
				}
			}
		}
	}
</script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="<c:url value='/css/customer_dashboard.css'/>">
<sitemesh:write property="head" />
</head>
<body class="bg-[var(--bg-main)] h-screen flex flex-col overflow-hidden">

	<header
		class="h-24 bg-[#00B14F] text-white flex items-center justify-between px-10 shrink-0 shadow-xl z-50 relative">

		<div class="flex items-center h-full">
			<a href="/customer/overview"
				class="hover:scale-105 transition-all mr-6"> <img
				src="<c:url value='/img/logo_nghv1.png'/>" alt="NGHV"
				class="h-20 w-auto">
			</a>

			<div class="h-10 w-px bg-white/20 mr-6"></div>

			<div class="relative dropdown-container">
				<div id="shopDropdownBtn"
					class="flex items-center space-x-4 bg-white/10 pl-2 pr-5 py-2 rounded-2xl border border-white/10 cursor-pointer hover:bg-white/20 transition-all group">
					<div
						class="w-12 h-12 bg-white text-nghv-green rounded-full flex items-center justify-center text-sm font-black shadow-lg overflow-hidden">
						<c:choose>
							<c:when test="${not empty avatarUrl}">
								<img src="${avatarUrl}" class="w-full h-full object-cover">
							</c:when>
							<c:otherwise>
								<c:out
									value="${not empty username ? (username.length() > 1 ? username.substring(0, 2).toUpperCase() : username.toUpperCase()) : 'US'}" />
							</c:otherwise>
						</c:choose>
					</div>
					<div class="text-[14px] flex flex-col justify-center">
						<span
							class="font-extrabold uppercase text-white/95 tracking-tight">
							<c:out value="${businessName}" />
						</span> <span class="opacity-80 font-bold text-[11px]">Quản trị -
							<c:out value="${username}" />
						</span>
					</div>
					<i
						class="fa-solid fa-chevron-down text-[12px] ml-2 opacity-70 group-hover:translate-y-0.5 transition-all"></i>
				</div>

				<div id="shopDropdownMenu"
					class="absolute left-0 top-[calc(100%+20px)] w-80
           bg-white text-gray-800
           rounded-3xl shadow-3xl
           hidden border border-gray-100 z-50 overflow-hidden">

					<!-- ===== ACCOUNT INFO ===== -->
					<div class="px-6 py-4 bg-gray-50/70 border-b border-gray-100">
						<p
							class="text-[10px] text-gray-400 font-black uppercase tracking-widest">
							Tài khoản</p>
						<p class="font-black text-sm text-nghv-green truncate mt-1">
							${email}</p>
						<p class="text-[11px] font-bold text-gray-500 mt-0.5">
							${username}</p>
					</div>

					<!-- ===== WALLET / SHOP ===== -->
					<div class="py-4">
						<a href="/customer/profile"
							class="px-6 py-3 hover:bg-gray-50 flex items-center text-sm font-bold">
							<i class="fa-solid fa-id-card-clip mr-4 text-gray-400 w-5"></i>
							Hồ sơ Shop
						</a>
					</div>

					<!-- ===== LOGOUT ===== -->
					<div class="border-t border-gray-100">
						<a href="javascript:void(0)" onclick="handleLogout()"
							class="px-6 py-3 flex items-center
                  text-sm font-black text-red-600
                  hover:bg-red-50 transition">
							<i class="fa-solid fa-power-off mr-4 w-5"></i> Đăng xuất
						</a>
					</div>
				</div>

			</div>
		</div>

		<nav
			class="flex h-full items-center gap-8 absolute left-1/3 -translate-x-[10%]">
			<a href="/customer/overview"
				class="nav-icon-btn group transition-all duration-300 hover:scale-105 ${currentPage == 'overview' ? 'active' : ''}"
				title="Tổng quan"> <i class="fa-solid fa-chart-pie text-4xl"></i>
			</a> <a href="/customer/operation"
				class="nav-icon-btn group transition-all duration-300 hover:scale-105 ${currentPage == 'operation' ? 'active' : ''}"
				title="Vận hành"> <i class="fa-solid fa-truck-fast text-4xl"></i>
			</a> <a href="/customer/cashflow"
				class="nav-icon-btn group transition-all duration-300 hover:scale-105 ${currentPage == 'cashflow' ? 'active' : ''}"
				title="Dòng tiền"> <i class="fa-solid fa-coins text-4xl"></i>
			</a>

		</nav>


		<div class="flex items-center space-x-4">
			<div class="relative dropdown-container">
				<div id="chatDropdownBtn"
					class="w-16 h-14 px-4 rounded-2xl 
	       bg-white/10 hover:bg-white/20 
	       inline-flex items-center justify-center 
	       transition-transform duration-300 hover:scale-105
	       border border-white/10 cursor-pointer 
	       backdrop-blur-sm relative">

					<i class="fa-solid fa-comment-dots fa-2x leading-none"></i> <span
						class="absolute -top-1 -right-2 w-5 h-5 bg-red-500 
		       border-2 border-[#00B14F] rounded-full text-[11px] 
		       flex items-center justify-center font-bold">
						3 </span>
				</div>

				<div id="chatDropdownMenu"
					class="absolute right-0 top-[calc(100%+8px)] w-80 bg-white text-gray-800 rounded-3xl shadow-3xl hidden border border-gray-100 z-50 overflow-hidden">
					<div
						class="p-4 border-b border-gray-50 bg-gray-50/50 flex justify-between items-center">
						<span class="font-black text-sm uppercase text-gray-700">Thông
							báo & Chat</span> <span
							class="text-[10px] bg-nghv-green text-white px-2 py-0.5 rounded-full">${notificationCount}
							Mới</span>
					</div>
					<div class="max-h-[400px] overflow-y-auto custom-scrollbar">
						<c:forEach var="noti" items="${notifications}">
							<div
								class="p-4 flex items-start space-x-4 border-b border-gray-50 hover:bg-gray-50 transition cursor-pointer">
								<div
									class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center shrink-0">
									<i class="fa-solid fa-bell text-xl text-nghv-green"></i>
								</div>
								<div>
									<p class="text-xs font-bold text-gray-800">${noti.title}</p>
									<p class="text-[11px] text-gray-500 line-clamp-2">${noti.body}</p>
								</div>
							</div>
						</c:forEach>
					</div>
					<a href="#"
						class="p-3 text-center text-xs font-bold text-nghv-green block hover:bg-green-50">Xem
						tất cả tin nhắn</a>
				</div>
			</div>

			<button onclick="window.location.href='/customer/create-order'"
				class="bg-gradient-to-r from-[#F26522] to-[#ff7e47]
           hover:brightness-110
           px-9 py-4
           rounded-2xl
           font-black text-sm
           flex items-center
           shadow-xl
           transition-all duration-300 hover:scale-105
           active:scale-95
           uppercase tracking-wider">

				<i class="fa-solid fa-plus mr-2 text-lg"></i> Tạo đơn
			</button>


		</div>
	</header>

	<c:if test="${email.endsWith('@nghv.io')}">
		<div
			class="bg-gradient-to-r from-orange-600 to-orange-400 text-white py-3 px-10 flex items-center justify-between shadow-lg z-40 relative animate-pulse">
			<div class="flex items-center space-x-3">
				<div
					class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
					<i class="fa-solid fa-triangle-exclamation text-sm"></i>
				</div>
				<div class="text-[12px]">
					<p class="font-black uppercase tracking-tight">Cảnh báo bảo
						mật: Email tạm thời</p>
					<p class="opacity-90 font-medium">Tài khoản của bạn đang sử
						dụng email hệ thống (${email}). Vui lòng cập nhật email cá nhân để
						không bị mất quyền truy cập.</p>
				</div>
			</div>
			<a href="/customer/profile"
				class="bg-white text-orange-600 px-6 py-2 rounded-xl text-[10px] font-black uppercase hover:bg-orange-50 transition-all shadow-md">
				Cập nhật ngay </a>
		</div>
	</c:if>

	<div class="flex flex-1 overflow-hidden relative z-0">
		<main
			class="flex-1 overflow-y-auto custom-scrollbar p-8 bg-[#f8fafc] flex justify-center">
			<div class="w-full max-w-[1200px]">
				<sitemesh:write property="body" />
			</div>
		</main>

		<aside id="rightSidebar"
			class="w-20 bg-white border-l border-gray-100
           flex flex-col py-4 shrink-0
           shadow-[-10px_0_30px_-15px_rgba(0,0,0,0.05)]
           z-20 transition-all duration-300 ease-in-out">
			<button id="toggleSidebarBtn"
				class="mb-8 w-12 h-12 mx-auto
           rounded-2xl bg-gray-50 text-gray-500
           hover:bg-gray-100
           flex items-center justify-center
           transition-all duration-300 hover:scale-105">

				<i id="sidebarIcon"
					class="fa-solid fa-chevron-left text-lg transition-transform duration-300"></i>
			</button>


			<div class="flex flex-col space-y-6">
				<a href="/customer/orders"
					class="sidebar-item flex items-center gap-6 px-6 py-4 rounded-xl
              hover:bg-gray-50
              transition-all duration-300 hover:scale-105
              ${currentPage == 'orders' ? 'active' : ''}">
					<i class="fa-solid fa-box-open text-3xl w-8 text-center"></i> <span
					class="sidebar-text text-lg font-bold tracking-wide hidden">Đơn
						hàng</span>
				</a> <a href="/customer/addressbook"
				class="sidebar-item flex items-center gap-6 px-6 py-4 rounded-xl
              hover:bg-gray-50
              transition-all duration-300 hover:scale-105
              ${currentPage == 'addressbook' ? 'active' : ''}">
					<i class="fa-solid fa-boxes-stacked text-3xl w-8 text-center"></i>
					<span class="sidebar-text text-lg font-bold tracking-wide hidden">Kho bãi</span>
			</a> <a href="/customer/addresses"
					class="sidebar-item flex items-center gap-6 px-6 py-4 rounded-xl
              hover:bg-gray-50
              transition-all duration-300 hover:scale-105
              ${currentPage == 'addresses' ? 'active' : ''}">
					<i class="fa-solid fa-location-dot text-3xl w-8 text-center"></i>
					<span class="sidebar-text text-lg font-bold tracking-wide hidden">Địa chỉ</span>
				</a> <a href="/customer/support"
					class="sidebar-item flex items-center gap-6 px-6 py-4 rounded-xl
              hover:bg-gray-50
              transition-all duration-300 hover:scale-105
              ${currentPage == 'support' ? 'active' : ''}">
					<i class="fa-solid fa-headset text-3xl w-8 text-center"></i> <span
					class="sidebar-text text-lg font-bold tracking-wide hidden">Hỗ
						trợ</span>
				</a>
			</div>


		</aside>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="<c:url value='/js/customer_dashboard.js'/>"></script>
</body>
</html>