<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="w-full space-y-6">
	<div
		class="flex items-center space-x-2 bg-white p-1 rounded-2xl border border-gray-100 w-fit shadow-sm">
		<a href="?tab=all"
			class="px-6 py-2.5 rounded-xl text-xs font-black transition-all ${activeTab == 'all' ? 'bg-gray-800 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}">TẤT
			CẢ</a> <a href="?tab=pending"
			class="px-6 py-2.5 rounded-xl text-xs font-black transition-all ${activeTab == 'pending' ? 'bg-blue-600 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}">CHỜ
			LẤY</a> <a href="?tab=delivering"
			class="px-6 py-2.5 rounded-xl text-xs font-black transition-all ${activeTab == 'delivering' ? 'bg-orange-500 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}">ĐANG
			GIAO</a> <a href="?tab=delivered"
			class="px-6 py-2.5 rounded-xl text-xs font-black transition-all ${activeTab == 'delivered' ? 'bg-green-600 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}">HOÀN
			TẤT</a> <a href="?tab=failed"
			class="px-6 py-2.5 rounded-xl text-xs font-black transition-all ${activeTab == 'failed' ? 'bg-red-600 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}">ĐƠN
			LỖI</a>
	</div>

	<div
		class="bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden">
		<table class="w-full text-left">
			<thead class="bg-gray-50/50 border-b border-gray-50">
				<tr
					class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
					<th class="px-6 py-4">Thông tin đơn</th>
					<th class="px-6 py-4">Lộ trình / Shipper</th>
					<th class="px-6 py-4">Người nhận</th>
					<th class="px-6 py-4">Trạng thái</th>
					<th class="px-6 py-4 text-right">Tài chính</th>
					<th class="px-6 py-4 text-center">Chi tiết</th>
				</tr>
			</thead>
			<tbody class="divide-y divide-gray-50">
				<c:forEach items="${orders}" var="order">
					<tr class="hover:bg-gray-50/30 transition-colors">
						<td class="px-6 py-5"><span
							class="text-sm font-black text-gray-800 block">#${order.requestId}</span>
							<span class="text-[10px] font-bold text-gray-400 uppercase">${order.serviceType.serviceName}</span>
							<span class="text-[10px] text-gray-300 block italic">${order.formattedCreatedAt}</span>
						</td>
						<td class="px-6 py-5">
							<div class="flex items-center space-x-2">
								<i class="fa-solid fa-warehouse text-gray-300 text-xs"></i> <span
									class="text-xs font-bold text-gray-600">${order.currentHub.hubName}</span>
							</div>
							<div class="flex items-center space-x-2 mt-1">
								<i class="fa-solid fa-user-tag text-gray-300 text-[10px]"></i> <span
									class="text-[10px] font-medium text-gray-500">Shipper:
									${order.imageOrder != null ? 'Nguyễn Văn A' : 'Đang điều phối'}</span>
							</div>
						</td>
						<td class="px-6 py-5">
							<p class="text-xs font-black text-gray-700">${order.deliveryAddress.contactName}</p>
							<p class="text-[10px] text-gray-400">${order.deliveryAddress.contactPhone}</p>
							<p class="text-[10px] text-gray-400 truncate w-32">${order.deliveryAddress.addressDetail}</p>
						</td>
						<td class="px-6 py-5"><span
							class="px-3 py-1 rounded-full text-[9px] font-black uppercase shadow-sm
                                ${order.status == 'delivered' ? 'bg-green-100 text-green-600' : 
                                  order.status == 'failed' ? 'bg-red-100 text-red-600' : 
                                  order.status == 'pending' ? 'bg-blue-100 text-blue-600' : 'bg-orange-100 text-orange-600'}">
								${order.status} </span></td>
						<td class="px-6 py-5 text-right">
							<p class="text-sm font-black text-nghv-green">
								<fmt:formatNumber value="${order.codAmount}" type="number" />
								đ
							</p>
							<p class="text-[10px] font-bold text-gray-400">
								Phí:
								<fmt:formatNumber value="${order.totalPrice}" type="number" />
								đ
							</p>
						</td>
						<td class="px-6 py-5 text-center">
							<button onclick="openTrackingModal(${order.requestId})"
								class="p-2 hover:bg-gray-100 rounded-xl transition-all">
								<i class="fa-solid fa-route text-gray-400"></i>
							</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<div id="trackingModal"
	class="fixed inset-0 bg-gray-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-3xl w-full max-w-md shadow-2xl overflow-hidden">
		<div
			class="p-6 border-b border-gray-50 flex justify-between items-center">
			<h3
				class="text-sm font-black text-gray-800 uppercase tracking-widest">Lộ
				trình đơn hàng</h3>
			<button onclick="closeModal()"
				class="text-gray-400 hover:text-gray-600">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>
		<div id="trackingContent" class="p-8 max-h-[500px] overflow-y-auto">
		</div>
	</div>
</div>

<script>
function openTrackingModal(id) {
    const modal = document.getElementById('trackingModal');
    const content = document.getElementById('trackingContent');
    
    modal.classList.remove('hidden');
    content.innerHTML = '<div class="text-center py-10"><i class="fa-solid fa-spinner animate-spin text-2xl text-gray-200"></i></div>';

    fetch('/customer/api/tracking/' + id)
        .then(response => response.json())
        .then(data => {
            console.log("Dữ liệu thực tế từ Server:", data); // Dòng này để bạn kiểm tra F12 xem phím là gì

            if (!data || data.length === 0) {
                content.innerHTML = '<p class="text-center text-xs text-gray-400 py-10">Chưa có dữ liệu lộ trình cho đơn hàng này.</p>';
                return;
            }
            
            let html = '<div class="relative space-y-8 before:absolute before:inset-0 before:left-3 before:w-0.5 before:bg-gray-100">';
            
            data.forEach((item, index) => {
                // 1. Kiểm tra phím đa hình (CreatedAt hoặc created_at)
                const rawDate = item.createdAt || item.created_at;
                const statusValue = item.status || "N/A";
                const codeValue = item.code || "Đang cập nhật...";

                let date = new Date();
                if (Array.isArray(rawDate)) {
                    // Xử lý nếu LocalDateTime trả về dạng mảng [2026, 1, 2, 21, 30]
                    date = new Date(rawDate[0], rawDate[1] - 1, rawDate[2], rawDate[3], rawDate[4]);
                } else if (rawDate) {
                    // Xử lý nếu trả về dạng chuỗi ISO
                    date = new Date(rawDate);
                }

                let timeStr = "??:??";
                let dateStr = "??/??";
                
                if (!isNaN(date.getTime())) {
                    timeStr = date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0');
                    dateStr = date.getDate().toString().padStart(2, '0') + '/' + (date.getMonth() + 1).toString().padStart(2, '0');
                }

                // Điểm cuối cùng trong danh sách (mới nhất) sẽ nhấp nháy màu xanh
                const isLast = (index === data.length - 1);
                
                html += `
                    <div class="relative pl-10">
                        <span class="absolute left-0 top-1 w-6 h-6 rounded-full border-4 border-white shadow-sm \${isLast ? 'bg-green-500 animate-pulse' : 'bg-gray-200'}"></span>
                        <div class="flex flex-col">
                            <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">\${dateStr} - \${timeStr}</span>
                            <span class="text-xs font-black text-gray-800 mt-1 uppercase">\${statusValue}</span>
                            <span class="text-[11px] text-gray-500 mt-1 bg-gray-50 p-2.5 rounded-xl border border-gray-100">\${codeValue}</span>
                        </div>
                    </div>`;
            });
            html += '</div>';
            content.innerHTML = html;
        })
        .catch(err => {
            console.error("Lỗi:", err);
            content.innerHTML = '<p class="text-center text-xs text-red-500">Lỗi kết nối Server.</p>';
        });
}

function closeModal() {
    document.getElementById('trackingModal').classList.add('hidden');
}
</script>