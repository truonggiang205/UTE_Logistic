<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<div class="w-full space-y-8 animate-fade-in">
	<div
		class="flex flex-col md:flex-row md:items-center justify-between gap-6">
		<div>
			<h2
				class="text-2xl font-black text-gray-800 uppercase tracking-tighter">Trung
				tâm mạng lưới</h2>
			<p class="text-[11px] text-gray-400 font-medium">Quản lý điểm lấy
				hàng và tra cứu hệ thống bưu cục toàn quốc</p>
		</div>
		<div class="flex bg-gray-100 p-1.5 rounded-[22px] w-fit shadow-inner">
			<button onclick="switchTab('my-addresses')" id="tab-btn-addresses"
				class="px-8 py-2.5 text-[10px] font-black uppercase rounded-[18px] transition-all bg-white shadow-sm text-gray-800">
				<i class="fa-solid fa-house-user mr-2"></i>Kho của tôi
			</button>
			<button onclick="switchTab('hubs')" id="tab-btn-hubs"
				class="px-8 py-2.5 text-[10px] font-black uppercase rounded-[18px] transition-all text-gray-400 hover:text-gray-600">
				<i class="fa-solid fa-map-location-dot mr-2"></i>Điểm gửi hàng
			</button>
		</div>
	</div>

	<div id="tab-my-addresses"
		class="grid grid-cols-1 md:grid-cols-3 gap-6 animate-fade-in">
		<button onclick="openModal()"
			class="group border-2 border-dashed border-gray-200 p-8 rounded-[40px] flex flex-col items-center justify-center hover:border-[#00B14F] hover:bg-green-50/30 transition-all duration-500">
			<div
				class="w-14 h-14 bg-gray-50 rounded-full flex items-center justify-center group-hover:bg-[#00B14F] group-hover:rotate-90 transition-all duration-500">
				<i
					class="fa-solid fa-plus text-gray-400 group-hover:text-white text-xl"></i>
			</div>
			<span
				class="text-[10px] font-black uppercase tracking-widest text-gray-400 mt-4 group-hover:text-[#00B14F]">Thêm
				kho hàng mới</span>
		</button>

		<c:forEach items="${addresses}" var="addr">
			<div
				class="bg-white p-8 rounded-[40px] border border-gray-100 shadow-sm relative group overflow-hidden hover:shadow-xl hover:shadow-green-100/50 transition-all duration-500">
				<div class="flex items-center justify-between relative z-10">
					<span
						class="px-3 py-1 bg-green-50 text-[#00B14F] text-[9px] font-black uppercase rounded-lg border border-green-100">Cơ
						sở lấy hàng</span> <a
						href="/customer/addressbook/delete?id=${addr.addressId}"
						class="w-8 h-8 flex items-center justify-center rounded-full bg-red-50 text-red-400 hover:bg-red-500 hover:text-white transition-all shadow-sm">
						<i class="fa-solid fa-trash-can text-[10px]"></i>
					</a>
				</div>
				<div class="mt-8 relative z-10">
					<h4 class="text-base font-black text-gray-800">${addr.contactName}</h4>
					<p class="text-xs font-bold text-gray-400 mt-1">
						<i class="fa-solid fa-phone mr-2 text-[10px]"></i>${addr.contactPhone}</p>
					<p
						class="text-[11px] text-gray-500 mt-4 leading-relaxed line-clamp-2">${addr.addressDetail}</p>
				</div>
				<i
					class="fa-solid fa-warehouse absolute -right-4 -bottom-4 text-8xl text-gray-50 opacity-50 group-hover:text-green-50 group-hover:scale-110 transition-all duration-700"></i>
			</div>
		</c:forEach>
	</div>

	<div id="tab-hubs"
		class="hidden grid grid-cols-1 lg:grid-cols-2 gap-6 animate-fade-in">
		<c:forEach items="${hubs}" var="hub">
			<div
				class="bg-white p-8 rounded-[40px] border border-gray-100 shadow-sm flex flex-col md:flex-row items-center md:items-start space-y-6 md:space-y-0 md:space-x-8 hover:border-[#00B14F]/30 transition-all duration-500 relative group overflow-hidden">
				<div class="relative flex-shrink-0">
					<div
						class="w-20 h-20 bg-gradient-to-br from-orange-50 to-orange-100 rounded-[30px] flex items-center justify-center text-orange-500 group-hover:from-orange-500 group-hover:to-orange-600 group-hover:text-white transition-all duration-500 shadow-inner">
						<i class="fa-solid fa-store text-3xl"></i>
					</div>
					<span
						class="absolute -top-2 -right-2 px-2 py-1 bg-white border border-orange-100 text-[8px] font-black text-orange-600 uppercase rounded-lg shadow-sm">
						${hub.province == 'Ho Chi Minh' || hub.province == 'Ha Noi' ? 'Central Hub' : 'Branch'}
					</span>
				</div>

				<div class="flex-1 space-y-4 text-center md:text-left">
					<div>
						<h4
							class="text-lg font-black text-gray-800 uppercase tracking-tight">${hub.hubName}</h4>
						<div
							class="flex flex-wrap justify-center md:justify-start gap-2 mt-2">
							<span
								class="px-2 py-0.5 bg-gray-50 text-gray-400 text-[9px] font-bold rounded-md border border-gray-100">Phường
								${hub.ward}</span> <span
								class="px-2 py-0.5 bg-gray-50 text-gray-400 text-[9px] font-bold rounded-md border border-gray-100">${hub.district}</span>
						</div>
					</div>

					<p class="text-[11px] text-gray-500 leading-relaxed font-medium">
						<i class="fa-solid fa-location-arrow mr-2 text-orange-400"></i>${hub.address}
					</p>

					<div
						class="pt-4 border-t border-gray-50 flex flex-col sm:flex-row items-center justify-between gap-4">
						<div class="flex items-center space-x-4">
							<span class="text-[10px] font-black text-gray-400"><i
								class="fa-solid fa-clock mr-2 text-green-500"></i>08:00 - 21:00</span>
						</div>
						<button
							onclick="openMapModal('${hub.hubName}', '${hub.address}', '${hub.ward}', '${hub.district}', '${hub.province}')"
							class="px-6 py-2.5 bg-gray-800 text-white text-[10px] font-black uppercase rounded-2xl hover:bg-[#00B14F] hover:shadow-lg hover:shadow-green-100 transition-all active:scale-95">
							<i class="fa-solid fa-map mr-2"></i>Định vị bưu cục
						</button>
					</div>
				</div>
				<div
					class="absolute -top-10 -right-10 w-32 h-32 bg-gray-50 rounded-full opacity-20 group-hover:scale-150 transition-transform duration-1000"></div>
			</div>
		</c:forEach>
	</div>
</div>

<div id="addressModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-lg shadow-2xl animate-modal-up overflow-hidden">
		<form action="/customer/addressbook/add" method="POST"
			class="p-10 space-y-6">
			<h3
				class="text-sm font-black text-gray-800 uppercase tracking-widest text-center">Thêm
				địa chỉ kho hàng</h3>
			<div class="space-y-4">
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Tên
						người liên hệ/Kho</label> <input type="text" name="contactName" required
						class="w-full mt-1 px-4 py-3 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]">
				</div>
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Số
						điện thoại</label> <input type="text" name="contactPhone" required
						class="w-full mt-1 px-4 py-3 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]">
				</div>
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Địa
						chỉ chi tiết</label>
					<textarea name="addressDetail" required rows="3"
						class="w-full mt-1 px-4 py-3 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]"></textarea>
				</div>
			</div>
			<div class="flex space-x-3 pt-4">
				<button type="button" onclick="closeModal()"
					class="flex-1 py-3 text-[10px] font-black uppercase text-gray-400">Hủy
					bỏ</button>
				<button type="submit"
					class="flex-[2] bg-gray-800 text-white py-3 rounded-2xl text-[10px] font-black uppercase hover:bg-black transition-all">Lưu
					địa chỉ</button>
			</div>
		</form>
	</div>
</div>

<div id="mapModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[60] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-4xl shadow-2xl animate-modal-up overflow-hidden">
		<div
			class="p-6 border-b border-gray-50 flex justify-between items-center">
			<h3 id="mapTitle"
				class="text-sm font-black text-gray-800 uppercase tracking-widest">Vị
				trí bưu cục</h3>
			<button onclick="closeMapModal()"
				class="w-10 h-10 flex items-center justify-center bg-gray-50 rounded-full text-gray-400 hover:text-red-500 transition-all">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>
		<div class="aspect-video w-full bg-gray-100">
			<iframe id="mapFrame" width="100%" height="100%" style="border: 0;"
				allowfullscreen="" loading="lazy"></iframe>
		</div>
	</div>
</div>

<style>
/* Hiệu ứng scrollbar cho Modal bản đồ */
.animate-modal-up {
	animation: modalUp 0.5s cubic-bezier(0.165, 0.84, 0.44, 1) forwards;
}

@
keyframes modalUp {from { opacity:0;
	transform: translateY(50px) scale(0.9);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}

}
.animate-fade-in {
	animation: fadeIn 0.6s ease-out;
}

@
keyframes fadeIn {from { opacity:0;
	
}

to {
	opacity: 1;
}
}
</style>

<script>
	// Toàn bộ logic JS được đóng gói an toàn
	function switchTab(tab) {
		const addrTab = document.getElementById('tab-my-addresses');
		const hubTab = document.getElementById('tab-hubs');
		const addrBtn = document.getElementById('tab-btn-addresses');
		const hubBtn = document.getElementById('tab-btn-hubs');

		if (tab === 'my-addresses') {
			addrTab.classList.remove('hidden');
			addrTab.classList.add('grid');
			hubTab.classList.add('hidden');
			addrBtn.classList.add('bg-white', 'shadow-sm', 'text-gray-800');
			addrBtn.classList.remove('text-gray-400');
			hubBtn.classList.remove('bg-white', 'shadow-sm', 'text-gray-800');
			hubBtn.classList.add('text-gray-400');
		} else {
			addrTab.classList.add('hidden');
			addrTab.classList.remove('grid');
			hubTab.classList.remove('hidden');
			hubTab.classList.add('grid');
			hubBtn.classList.add('bg-white', 'shadow-sm', 'text-gray-800');
			hubBtn.classList.remove('text-gray-400');
			addrBtn.classList.remove('bg-white', 'shadow-sm', 'text-gray-800');
			addrBtn.classList.add('text-gray-400');
		}
	}

	function openModal() {
		document.getElementById('addressModal').classList.remove('hidden');
	}
	function closeModal() {
		document.getElementById('addressModal').classList.add('hidden');
	}

	function openMapModal(hubName, address, ward, district, province) {
		const modal = document.getElementById('mapModal');
		const frame = document.getElementById('mapFrame');
		const title = document.getElementById('mapTitle');

		title.innerText = hubName;
		// Xử lý chuỗi địa chỉ đầy đủ để Google Maps tìm chính xác 100%
		var fullAddress = address + ", " + ward + ", " + district + ", "
				+ province + ", Vietnam";
		var searchQuery = encodeURIComponent(fullAddress);
		var freeMapUrl = "https://maps.google.com/maps?q=" + searchQuery
				+ "&t=&z=15&ie=UTF8&iwloc=&output=embed";

		frame.src = freeMapUrl;
		modal.classList.remove('hidden');
	}

	function closeMapModal() {
		document.getElementById('mapModal').classList.add('hidden');
		document.getElementById('mapFrame').src = '';
	}

	window.onclick = function(event) {
		const addrModal = document.getElementById('addressModal');
		const mapModal = document.getElementById('mapModal');
		if (event.target == addrModal)
			closeModal();
		if (event.target == mapModal)
			closeMapModal();
	}
</script>