<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<head>
<title>Tổng quan</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
.floating-label {
	position: absolute;
	top: -12px;
	left: 16px;
	background: white;
	padding: 2px 10px;
	border: 1px solid #e5e7eb;
	border-radius: 6px;
	font-size: 10px;
	font-weight: 800;
	color: #6b7280;
	text-transform: uppercase;
}
/* Tùy chỉnh kích thước canvas cho biểu đồ */
.chart-container {
	position: relative;
	margin: auto;
	height: 200px;
	width: 200px;
	display: block
}
</style>
</head>

<div class="w-full space-y-8 overflow-x-hidden">
	<div class="flex items-center space-x-3">
		<h1 class="text-2xl font-black text-gray-800 tracking-tight">Tổng
			quan</h1>
		<div
			class="flex items-center bg-white px-4 py-1.5 rounded-full border border-gray-100 text-[12px] font-bold text-gray-400 shadow-sm">
			<span class="w-2.5 h-2.5 bg-red-500 rounded-full mr-2 animate-pulse"></span>
			Live - <span id="live-clock">00:00:00</span>
		</div>
	</div>

	<div class="grid grid-cols-1 xl:grid-cols-2 gap-8">

		<div
			class="bg-white border border-gray-100 rounded-2xl p-7 relative shadow-sm hover:shadow-md transition-all">
			<div class="floating-label">Phát sinh</div>
			<div class="grid grid-cols-1 gap-4 mt-2">
				<div
					class="flex items-center justify-between border-b border-gray-50 pb-2">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">Đơn
						hàng mới</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-gray-800">${pendingCount}</span>
						<span
							class="text-[10px] font-black text-gray-400 ml-1.5 uppercase">ĐH</span>
					</div>
				</div>
				<div class="flex items-center justify-between">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">COD
						Dự kiến</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-nghv-green"> <fmt:formatNumber
								value="${pendingCod}" type="number" /> đ
						</span>
					</div>
				</div>
			</div>
		</div>

		<div
			class="bg-white border border-gray-100 rounded-2xl p-7 relative shadow-sm hover:shadow-md transition-all">
			<div class="floating-label">Thành công</div>
			<div class="grid grid-cols-1 gap-4 mt-2">
				<div
					class="flex items-center justify-between border-b border-gray-50 pb-2">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">Đơn
						đã giao</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-blue-600">${successCount}</span>
						<span
							class="text-[10px] font-black text-gray-400 ml-1.5 uppercase">ĐH</span>
					</div>
				</div>
				<div class="flex items-center justify-between">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">COD
						Thực nhận</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-nghv-green"> <fmt:formatNumber
								value="${successCod}" type="number" /> đ
						</span>
					</div>
				</div>
			</div>
		</div>

		<div
			class="bg-white border border-gray-100 rounded-2xl p-7 relative shadow-sm hover:shadow-md transition-all">
			<div class="floating-label">Đang giao</div>
			<div class="grid grid-cols-1 gap-4 mt-2">
				<div
					class="flex items-center justify-between border-b border-gray-50 pb-2">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">Đơn
						trên đường</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-orange-500">${deliveringCount}</span>
						<span
							class="text-[10px] font-black text-gray-400 ml-1.5 uppercase">ĐH</span>
					</div>
				</div>
				<div class="flex items-center justify-between">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">COD
						Đang treo</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-nghv-green"> <fmt:formatNumber
								value="${deliveringCod}" type="number" /> đ
						</span>
					</div>
				</div>
			</div>
		</div>

		<div
			class="bg-white border border-gray-100 rounded-2xl p-7 relative shadow-sm hover:shadow-md transition-all">
			<div class="floating-label">Phí vận chuyển</div>
			<div class="grid grid-cols-1 gap-4 mt-2">
				<div class="flex items-center justify-between">
					<span
						class="text-gray-400 font-bold text-xs uppercase tracking-widest">Tổng
						phí dịch vụ</span>
					<div class="flex items-baseline">
						<span class="text-2xl font-black text-gray-800"> <fmt:formatNumber
								value="${totalShippingFee}" type="number" /> đ
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
		<div
			class="bg-white rounded-3xl p-8 border border-gray-100 shadow-sm flex flex-col items-center relative">
			<p
				class="text-[11px] font-black text-gray-400 uppercase self-start mb-6 tracking-widest">Tỷ
				lệ đơn hoàn</p>
			<div class="chart-container">
				<canvas id="returnRateChart"></canvas>
				<div
					class="absolute inset-0 flex flex-col items-center justify-center pt-4">
					<span class="text-[10px] font-bold text-gray-400 uppercase">Tỷ
						lệ hoàn</span> <span class="text-2xl font-black text-gray-800">${returnRate}%</span>
				</div>
			</div>
			<div class="mt-6 flex space-x-6">
				<div
					class="flex items-center text-[10px] font-bold text-gray-500 uppercase">
					<span class="w-3 h-3 bg-[#00B14F] rounded-full mr-2"></span> Giao
					đi
				</div>
				<div
					class="flex items-center text-[10px] font-bold text-gray-500 uppercase">
					<span class="w-3 h-3 bg-[#F26522] rounded-full mr-2"></span> Bị
					hoàn
				</div>
			</div>
		</div>

		<div
			class="lg:col-span-2 bg-white rounded-3xl p-8 border border-gray-100 shadow-sm">
			<p
				class="text-[11px] font-black text-gray-400 uppercase mb-6 tracking-widest">Xu
				hướng hàng - tiền (7 ngày)</p>
			<div class="h-64 w-full">
				<canvas id="trendChart"></canvas>
			</div>
		</div>
	</div>
</div>

<script>
	// 1. Cập nhật đồng hồ Live
	function updateClock() {
		const now = new Date();
		const clock = document.getElementById('live-clock');
		if (clock)
			clock.innerText = now.toLocaleTimeString('vi-VN', {
				hour12 : false
			});
	}
	setInterval(updateClock, 1000);
	updateClock();

	// 2. Khởi tạo biểu đồ Chart.js cho Đơn hoàn
	document.addEventListener("DOMContentLoaded", function() {
		const ctx = document.getElementById('returnRateChart').getContext('2d');
		
		// Xử lý trường hợp chưa có dữ liệu để biểu đồ không bị trắng xóa
		const successData = ${successCount} || 0;
		const failedData = ${failedCount} || 0;
		const hasData = (successData + failedData) > 0;

		new Chart(ctx, {
			type : 'doughnut',
			data: {
			    labels: ['Thành công', 'Bị hoàn'],
			    datasets: [{
			        data: hasData ? [successData, failedData] : [1, 0], // Nếu không có dữ liệu, hiện 100% xanh
			        backgroundColor: hasData ? ['#00B14F', '#F26522'] : ['#E5E7EB', '#E5E7EB'],
			        borderWidth: 0,
			        cutout: '80%'
			    }]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false,
				plugins : {
					legend : { display : false },
					tooltip: { enabled: hasData } // Chỉ bật tooltip khi có dữ liệu thật
				}
			}
		});
	});
	
	document.addEventListener("DOMContentLoaded", function() {
	    const trendCtx = document.getElementById('trendChart').getContext('2d');
	    
	    new Chart(trendCtx, {
	        type: 'line', // Biểu đồ đường thể hiện xu hướng
	        data: {
	            // Gọi trực tiếp chuỗi JSON đã được Controller chuẩn bị sẵn
	            labels: [${trendLabelsJson}], 
	            datasets: [
	                {
	                    label: 'Số đơn hàng',
	                    data: [${trendOrderCountsJson}], // Không dùng .join() ở đây nữa
	                    borderColor: '#3b82f6',
	                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
	                    yAxisID: 'y',
	                    tension: 0.4
	                },
	                {
	                    label: 'Tiền COD (đ)',
	                    data: [${trendCodAmountsJson}], // Không dùng .join() ở đây nữa
	                    borderColor: '#00B14F',
	                    backgroundColor: 'rgba(0, 177, 79, 0.1)',
	                    yAxisID: 'y1',
	                    tension: 0.4,
	                    fill: true
	                }
	            ]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            scales: {
	                y: { type: 'linear', display: true, position: 'left', title: { display: true, text: 'Đơn hàng' } },
	                y1: { type: 'linear', display: true, position: 'right', grid: { drawOnChartArea: false }, title: { display: true, text: 'Tiền COD (đ)' } }
	            }
	        }
	    });
	});
</script>