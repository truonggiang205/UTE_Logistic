<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<div
	class="max-w-[1400px] mx-auto h-full flex flex-col overflow-hidden animate-fade-in">
	<div class="flex items-center justify-between mb-6 shrink-0">
		<div class="flex items-center space-x-8">
			<h1
				class="text-2xl font-black text-gray-800 uppercase tracking-tighter">Tạo
				đơn hàng</h1>
			<nav class="flex space-x-6 text-sm font-bold">
				<a href="#"
					class="text-nghv-green border-b-2 border-nghv-green pb-1">Đăng
					đơn lẻ</a>
				</a>
			</nav>
		</div>
	</div>

	<form id="orderForm" action="/customer/create-order/save" method="POST"
		enctype="multipart/form-data"
		class="flex flex-1 gap-8 overflow-y-auto pr-2 custom-scrollbar pb-10">

		<input type="hidden" name="pickupAddress.addressId"
			id="inputPickupAddressId" value="${defaultAddress.addressId}">

		<div class="flex-[1.5] space-y-8">
			<div
				class="bg-white p-8 rounded-[32px] shadow-sm border border-gray-100">
				<div class="flex justify-between items-center mb-6">
					<h3
						class="text-sm font-black text-gray-800 uppercase tracking-widest flex items-center">
						<i class="fa-solid fa-user-tag mr-3 text-nghv-green"></i> Người
						nhận
					</h3>
					<div class="relative w-64">
						<select id="savedReceivers"
							class="w-full py-2 px-4 bg-gray-50 border-none rounded-xl text-[10px] font-bold focus:ring-2 focus:ring-nghv-green cursor-pointer">
							<option value="">-- Danh sách đã lưu --</option>
							<c:forEach items="${savedAddresses}" var="addr">
								<option value="${addr.addressId}"
									data-name="${addr.contactName}"
									data-phone="${addr.contactPhone}"
									data-detail="${addr.addressDetail}"
									data-province="${addr.province}"
									data-district="${addr.district}" data-ward="${addr.ward}">
									${addr.contactName} - ${addr.contactPhone}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="space-y-4">
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
						<div class="relative">
							<i
								class="fa-solid fa-phone absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 text-xs"></i>
							<input type="text" id="recipientPhone" name="phone"
								placeholder="Số điện thoại khách hàng"
								class="w-full pl-10 pr-4 py-3 bg-gray-50 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-nghv-green">
						</div>
						<div class="relative">
							<i
								class="fa-solid fa-user absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 text-xs"></i>
							<input type="text" id="recipientName" name="fullName"
								placeholder="Tên khách hàng"
								class="w-full pl-10 pr-4 py-3 bg-gray-50 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-nghv-green">
						</div>
					</div>

					<textarea id="addressDetail" name="addressDetail"
						placeholder="Địa chỉ chi tiết (Tòa nhà/ Hẻm/ Đường)"
						class="w-full px-5 py-3 bg-gray-50 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-nghv-green h-20 resize-none"></textarea>

					<div class="grid grid-cols-3 gap-4">
						<select id="province" name="province"
							class="py-3 bg-gray-50 border-none rounded-xl text-[11px] font-bold focus:ring-2 focus:ring-nghv-green cursor-pointer">
							<option value="">Tỉnh/TP</option>
						</select> <select id="district" name="district"
							class="py-3 bg-gray-50 border-none rounded-xl text-[11px] font-bold focus:ring-2 focus:ring-nghv-green cursor-pointer">
							<option value="">Quận/Huyện</option>
						</select> <select id="ward" name="ward"
							class="py-3 bg-gray-50 border-none rounded-xl text-[11px] font-bold focus:ring-2 focus:ring-nghv-green cursor-pointer">
							<option value="">Phường/Xã</option>
						</select>
					</div>

					<div class="flex justify-end pt-2">
						<button type="button" onclick="saveNewReceiver()"
							class="text-[10px] font-black text-nghv-green uppercase border border-nghv-green px-4 py-2 rounded-xl hover:bg-green-50 transition-all">
							<i class="fa-solid fa-floppy-disk mr-2"></i> Lưu vào danh sách
							người nhận
						</button>
					</div>
				</div>
			</div>

			<div
				class="bg-white p-8 rounded-[32px] shadow-sm border border-gray-100">
				<h3
					class="text-sm font-black text-gray-800 uppercase tracking-widest mb-6">
					Dịch vụ vận chuyển</h3>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch">

					<label
						class="relative flex flex-col h-full p-6 border-2 rounded-[24px] cursor-pointer transition-all hover:border-nghv-green has-[:checked]:border-nghv-green has-[:checked]:bg-green-50/30 group">
						<input type="radio" name="serviceType.serviceTypeId" value="2"
						class="absolute top-5 right-5 text-nghv-green focus:ring-0"
						checked>

						<div class="flex items-center mb-5">
							<div
								class="w-12 h-12 flex-shrink-0 bg-green-100 text-nghv-green rounded-2xl flex items-center justify-center mr-3">
								<i class="fa-solid fa-bolt-lightning text-xl"></i>
							</div>
							<div class="flex-grow min-w-0">
								<span
									class="block text-sm font-black uppercase tracking-tight truncate">Express</span>
								<span class="text-[9px] font-bold text-nghv-green uppercase">Giao
									hỏa tốc (EXP)</span>
							</div>
							<div class="text-right flex-shrink-0 ml-2">
								<span
									class="block text-[9px] font-black text-gray-400 uppercase leading-none mb-1">Phí
									cơ bản</span> <span
									class="text-sm font-black text-nghv-orange leading-none">35.000đ</span>
							</div>
						</div>

						<div class="flex-grow space-y-3 border-t border-gray-100 pt-4">
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phù hợp:</b> Kiện hàng nhỏ < 20kg</span>
							</p>
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phụ phí:</b> +7.000đ/kg tiếp theo</span>
							</p>
						</div>
					</label> <label
						class="relative flex flex-col h-full p-6 border-2 rounded-[24px] cursor-pointer transition-all hover:border-nghv-green has-[:checked]:border-nghv-green has-[:checked]:bg-green-50/30 group">
						<input type="radio" name="serviceType.serviceTypeId" value="1"
						class="absolute top-5 right-5 text-nghv-green focus:ring-0">

						<div class="flex items-center mb-5">
							<div
								class="w-12 h-12 flex-shrink-0 bg-gray-100 text-gray-400 rounded-2xl flex items-center justify-center mr-3 group-hover:bg-green-100 group-hover:text-nghv-green transition-colors">
								<i class="fa-solid fa-truck text-xl"></i>
							</div>
							<div class="flex-grow min-w-0">
								<span
									class="block text-sm font-black uppercase tracking-tight truncate">Standard</span>
								<span
									class="text-[9px] font-bold text-gray-400 group-hover:text-nghv-green uppercase">Tiết
									kiệm (STD)</span>
							</div>
							<div class="text-right flex-shrink-0 ml-2">
								<span
									class="block text-[9px] font-black text-gray-400 uppercase leading-none mb-1">Phí
									cơ bản</span> <span
									class="text-sm font-black text-nghv-orange leading-none">20.000đ</span>
							</div>
						</div>

						<div class="flex-grow space-y-3 border-t border-gray-100 pt-4">
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phù hợp:</b> Kiện hàng nhỏ < 20kg</span>
							</p>
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phụ phí:</b> +5.000đ/kg tiếp theo</span>
							</p>
						</div>
					</label> <label
						class="relative flex flex-col h-full p-6 border-2 rounded-[24px] cursor-pointer transition-all hover:border-nghv-green has-[:checked]:border-nghv-green has-[:checked]:bg-green-50/30 group">
						<input type="radio" name="serviceType.serviceTypeId" value="3"
						class="absolute top-5 right-5 text-nghv-green focus:ring-0">

						<div class="flex items-center mb-5">
							<div
								class="w-12 h-12 flex-shrink-0 bg-orange-50 text-nghv-orange rounded-2xl flex items-center justify-center mr-3 group-hover:bg-green-100 group-hover:text-nghv-green transition-colors">
								<i class="fa-solid fa-truck-moving text-xl"></i>
							</div>
							<div class="flex-grow min-w-0">
								<span
									class="block text-sm font-black uppercase tracking-tight truncate">BBS
									Bulky</span> <span
									class="text-[9px] font-bold text-gray-400 group-hover:text-nghv-green uppercase">Hàng
									lớn (BBS)</span>
							</div>
							<div class="text-right flex-shrink-0 ml-2">
								<span
									class="block text-[9px] font-black text-gray-400 uppercase leading-none mb-1">Phí
									cơ bản</span> <span
									class="text-sm font-black text-nghv-orange leading-none">150.000đ</span>
							</div>
						</div>

						<div class="flex-grow space-y-3 border-t border-gray-100 pt-4">
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phù hợp:</b> Kiện hàng lớn >= 20kg</span>
							</p>
							<p class="text-[10px] font-bold text-gray-500 flex items-start">
								<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
								<span><b>Phụ phí:</b> +3.000đ/kg tiếp theo</span>
							</p>
						</div>
					</label>
				</div>
			</div>

			<div
				class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100">
				<h3 class="text-xl font-black text-gray-800 mb-6">Hình thức lấy
					hàng</h3>
				<div class="space-y-4">
					<div class="flex items-center">
						<div class="flex items-center min-w-[180px]">
							<input type="radio" name="pickupMethod" id="pickupAtStore"
								value="TẬN NƠI" checked
								class="w-5 h-5 text-nghv-green focus:ring-nghv-green border-gray-300 cursor-pointer">
							<label for="pickupAtStore"
								class="ml-3 text-sm font-bold text-gray-800 cursor-pointer">Lấy
								hàng tận nơi</label>
						</div>
						<div
							class="flex-1 ml-4 bg-white border border-gray-200 rounded-lg px-4 py-2.5 flex items-center justify-between cursor-pointer hover:border-nghv-green transition-all group">
							<span class="text-sm text-gray-600 truncate"> <c:choose>
									<c:when test="${not empty defaultAddress}">
										<c:out
											value="${defaultAddress.addressDetail}, ${defaultAddress.ward}, ${defaultAddress.district}, ${defaultAddress.province}" />
									</c:when>
									<c:otherwise>Chưa thiết lập địa chỉ mặc định</c:otherwise>
								</c:choose>
							</span>
							<div class="flex items-center space-x-2">
								<i
									class="fa-solid fa-map-location-dot text-red-500 hover:scale-125 transition-transform"
									onclick="showStoreLocation('${defaultAddress.contactName}', '${defaultAddress.addressDetail}, ${defaultAddress.ward}, ${defaultAddress.district}, ${defaultAddress.province}')"></i>
								<i
									class="fa-solid fa-chevron-down text-[10px] text-gray-400 group-hover:text-nghv-green"></i>
							</div>
						</div>
					</div>

					<div class="flex items-center">
						<div class="flex items-center min-w-[180px]">
							<input type="radio" name="pickupMethod" id="pickupAtHub"
								value="BƯU CỤC"
								class="w-5 h-5 text-nghv-green focus:ring-nghv-green border-gray-300 cursor-pointer">
							<label for="pickupAtHub"
								class="ml-3 text-sm font-bold text-gray-800 cursor-pointer">Gửi
								hàng bưu cục</label>
						</div>

						<div class="flex-1 ml-4 relative" id="hubDropupContainer">
							<div onclick="toggleHubDropup()"
								class="w-full bg-white border border-gray-200 rounded-lg px-4 py-2.5 flex items-center justify-between cursor-pointer hover:border-nghv-green transition-all group">
								<span id="selectedHubDisplay"
									class="text-sm text-gray-300 font-medium">Bấm chọn Bưu
									cục gần nhất</span>
								<div class="flex items-center space-x-2">
									<i class="fa-solid fa-location-dot text-nghv-green/50 text-xs"></i>
									<i id="hubArrowIcon"
										class="fa-solid fa-chevron-up text-[10px] text-gray-400 group-hover:text-nghv-green transition-transform"></i>
								</div>
							</div>

							<div id="hubDropupList"
								class="absolute bottom-full left-0 right-0 mb-2 bg-white border border-gray-100 rounded-[24px] shadow-2xl z-[80] hidden animate-modal-up overflow-hidden">
								<div class="max-h-60 overflow-y-auto custom-scrollbar">
									<c:forEach items="${nearbyHubs}" var="hub">
										<div
											onclick="selectHub('${hub.hubId}', '${hub.hubName}', '${hub.address}, ${hub.ward}, ${hub.district}, ${hub.province}')"
											class="px-5 py-4 hover:bg-green-50 cursor-pointer border-b border-gray-50 last:border-none transition-colors group">
											<p
												class="text-[11px] font-black text-gray-800 group-hover:text-nghv-green uppercase">${hub.hubName}</p>
											<p
												class="text-[10px] text-gray-400 font-bold mt-1 line-clamp-1">${hub.address}</p>
										</div>
									</c:forEach>
									<c:if test="${empty nearbyHubs}">
										<div class="p-5 text-center">
											<p class="text-[10px] font-bold text-gray-400">Không tìm
												thấy bưu cục nào ở khu vực này.</p>
										</div>
									</c:if>
								</div>
							</div>

							<input type="hidden" name="dropoffHubId" id="selectedHubId">
						</div>
					</div>
				</div>
			</div>

		</div>

		<div class="flex-1 space-y-6">
			<div
				class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100">
				<div class="flex items-center justify-between mb-4">
					<h3
						class="text-sm font-black text-gray-800 uppercase tracking-widest">Sản
						phẩm</h3>
				</div>

				<div class="flex gap-4 p-4 bg-gray-50 rounded-[24px] mb-6">
					<div
						class="w-14 h-14 bg-white border-2 border-dashed border-gray-200 rounded-xl flex items-center justify-center cursor-pointer overflow-hidden group"
						onclick="document.getElementById('imageFile').click()">
						<i id="imgPlaceholderIcon"
							class="fa-solid fa-camera text-gray-300 group-hover:text-nghv-green transition-colors"></i>
						<img id="orderImgPreview"
							class="hidden w-full h-full object-cover"> <input
							type="file" id="imageFile" name="imageFile" class="hidden"
							accept="image/*" onchange="previewOrderImg(this)">
					</div>

					<div class="flex-1 min-w-0">
						<input type="text" name="itemName" placeholder="Nhập tên sản phẩm"
							required
							class="w-full bg-transparent border-b border-gray-200 text-xs font-bold py-1 focus:ring-0 mb-3">

						<div class="flex items-center gap-3">
							<div class="flex items-center">
								<span class="text-[9px] text-gray-400 mr-1.5 font-black">KL</span>
								<div class="flex items-center">
									<div class="relative">
										<input type="number" id="weightInput" name="weight"
											value="1.0" min="0.1" max="100" step="0.1"
											class="w-16 bg-white border border-gray-200 rounded-lg px-2 py-1.5 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green focus:border-nghv-green outline-none transition-all">
									</div>
								</div>
							</div>

							<div class="flex items-center ml-2">
								<span class="text-[9px] text-gray-400 mr-1.5 font-black">SL</span>
								<input type="number" id="quantityInput" name="quantity"
									value="1" min="1"
									class="w-8 bg-white border border-gray-200 rounded-lg px-1 py-1 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green">
							</div>
						</div>
					</div>
				</div>

				<div
					class="space-y-3 pt-2 border-t border-gray-50 text-[11px] font-bold text-gray-500">
					<div class="flex justify-between items-center">
						<span>Giá trị hàng hóa</span>
						<div class="flex items-center border-b border-gray-100">
							<input type="number" id="itemValueInput" name="itemValue"
								value="0" step="10000"
								class="w-24 text-right bg-transparent border-none p-0 focus:ring-0 font-black text-gray-800">
							<span class="ml-1 text-gray-400 text-[9px]">đ</span>
						</div>
					</div>

					<div class="flex justify-between items-center">
						<span>Hình thức thanh toán</span> <select name="paymentMethod"
							class="bg-gray-100 border-none rounded-lg py-1 px-2 text-[10px] font-bold focus:ring-0 cursor-pointer">
							<option value="PREPAID">Tiền hàng trả trước</option>
							<option value="COD">Thanh toán khi nhận (COD)</option>
						</select>
					</div>

					<div class="flex justify-between items-center">
						<span>Tiền thu hộ (COD)</span>
						<div class="flex items-center border-b border-gray-100">
							<input type="number" id="codInput" name="codAmount" value="0"
								step="1000"
								class="w-24 text-right bg-transparent border-none p-0 focus:ring-0 font-black text-gray-800">
							<span class="ml-1 text-gray-400 text-[9px]">đ</span>
						</div>
					</div>

					<div class="flex justify-between text-gray-400 italic">
						<span>Phí bảo hiểm (0.5%)</span> <span><span
							id="displayInsuranceFee">0</span>đ</span>
					</div>

					<div class="flex justify-between">
						<span>Tổng KL thực tế</span> <span class="text-gray-800"><span
							id="displayTotalKL">1.0</span> kg</span>
					</div>

					<div class="flex justify-between items-center">
						<span>Phí ship dự kiến</span> <span class="text-nghv-orange"><span
							id="displayShippingFee">20.000</span>đ</span>
					</div>
				</div>

				<div class="mt-6 pt-4 border-t border-gray-50">
					<div
						class="flex justify-between items-center bg-green-50 p-4 rounded-2xl">
						<span
							class="text-[10px] font-black uppercase text-gray-500 tracking-wider">Tổng
							phí dự kiến</span> <span class="text-xl font-black text-nghv-green"><span
							id="displayTotalPrice">20.000</span>đ</span>
					</div>
				</div>
			</div>

			<div class="mt-6 pt-4 border-t border-gray-50">
				<div class="bg-green-50 p-4 rounded-2xl space-y-2">
					<div
						class="flex justify-between items-center pt-2 border-t border-green-100/50">
						<span class="text-[10px] font-black uppercase text-orange-500">Shipper
							sẽ thu hộ</span> <span class="text-lg font-black text-orange-600"><span
							id="displayAmountToCollect">0</span>đ</span>
					</div>
				</div>
			</div>

			<div
				class="bg-white p-8 rounded-[32px] shadow-sm border border-gray-100 space-y-6">
				<h3
					class="text-sm font-black text-gray-800 uppercase tracking-widest mb-4">Dịch
					vụ giải pháp</h3>
				<div class="space-y-4">
					<div class="flex justify-between text-xs font-bold">
						<span class="text-gray-400">Hoàn hàng</span> <span
							class="text-nghv-green">Miễn phí</span>
					</div>
				</div>
				<button type="button" onclick="showInvoiceModal()"
					class="w-full bg-gradient-to-r from-nghv-orange to-[#ff7e47] text-white py-5 rounded-2xl font-black uppercase text-sm shadow-xl shadow-orange-100 hover:scale-[1.02] active:scale-95 transition-all">
					Tạo đơn hàng</button>
			</div>
		</div>
	</form>
</div>

<div id="mapModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[70] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-2xl shadow-2xl animate-modal-up overflow-hidden">

		<div
			class="p-5 border-b border-gray-50 flex justify-between items-center bg-white">
			<div class="flex items-center">
				<div
					class="w-9 h-9 bg-green-50 text-nghv-green rounded-xl flex items-center justify-center mr-3">
					<i class="fa-solid fa-map-location-dot text-sm"></i>
				</div>
				<div>
					<h3 id="mapTitle"
						class="text-xs font-black text-gray-800 uppercase tracking-widest">Định
						vị</h3>
					<p id="mapSubtitle"
						class="text-[9px] text-gray-400 font-bold uppercase mt-0.5">Vị
						trí thực tế</p>
				</div>
			</div>
			<button onclick="closeMapModal()"
				class="w-8 h-8 flex items-center justify-center bg-gray-50 rounded-full text-gray-400 hover:text-red-500 transition-all">
				<i class="fa-solid fa-xmark text-sm"></i>
			</button>
		</div>

		<div class="h-[400px] w-full bg-gray-100">
			<iframe id="mapFrame" width="100%" height="100%" style="border: 0;"
				allowfullscreen="" loading="lazy"></iframe>
		</div>

		<div class="p-5 bg-gray-50 flex flex-col gap-3">
			<p id="mapFullAddress"
				class="text-[10px] font-bold text-gray-500 italic line-clamp-1"></p>
			<button onclick="closeMapModal()"
				class="w-full py-3 bg-gray-800 text-white text-[10px] font-black uppercase rounded-2xl hover:bg-black transition-all">
				Xác nhận vị trí</button>
		</div>
	</div>
</div>

<div id="invoiceModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[100] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-2xl shadow-2xl overflow-hidden animate-modal-up">
		<div class="p-8 border-b-2 border-dashed border-gray-100 relative">
			<div class="flex justify-between items-start">
				<div>
					<h2
						class="text-2xl font-black text-nghv-green uppercase tracking-tighter">Hóa
						Đơn Dịch Vụ</h2>
					<p class="text-[10px] text-gray-400 font-bold uppercase mt-1">
						Mã vận đơn: <span class="text-gray-800">NGHV-${System.currentTimeMillis()}</span>
					</p>
				</div>
				<div class="text-right">
					<p class="text-[10px] font-black uppercase text-gray-400">Ngày
						tạo</p>
					<p class="text-xs font-bold text-gray-800" id="invDate"></p>
				</div>
			</div>
			<div
				class="absolute -bottom-3 -left-3 w-6 h-6 bg-gray-900/60 rounded-full"></div>
			<div
				class="absolute -bottom-3 -right-3 w-6 h-6 bg-gray-900/60 rounded-full"></div>
		</div>

		<div
			class="p-8 space-y-6 overflow-y-auto max-h-[60vh] custom-scrollbar">
			<div class="grid grid-cols-2 gap-8 text-xs">
				<div>
					<p class="text-[9px] font-black text-gray-400 uppercase mb-2">Người
						gửi</p>
					<p class="font-black text-gray-800">${defaultAddress.contactName}</p>
					<p class="text-gray-500 font-medium">${defaultAddress.addressDetail},
						${defaultAddress.ward}</p>
				</div>
				<div>
					<p class="text-[9px] font-black text-gray-400 uppercase mb-2">Người
						nhận</p>
					<p class="font-black text-gray-800" id="invReceiverName"></p>
					<p class="text-gray-500 font-medium" id="invReceiverAddr"></p>
				</div>
			</div>

			<div class="bg-gray-50 rounded-2xl p-4">
				<table class="w-full text-[11px]">
					<thead>
						<tr
							class="text-gray-400 uppercase font-black border-b border-gray-200">
							<th class="text-left pb-2">Dịch vụ/Sản phẩm</th>
							<th class="text-center pb-2">KL</th>
							<th class="text-right pb-2">Thành tiền</th>
						</tr>
					</thead>
					<tbody class="text-gray-800 font-bold">
						<tr>
							<td class="pt-3" id="invItemName"></td>
							<td class="pt-3 text-center"><span id="invWeight"></span> kg</td>
							<td class="pt-3 text-right"><span id="invShippingFee"></span>đ</td>
						</tr>
						<tr id="invInsuranceRow">
							<td class="pt-2 text-gray-500 font-medium italic">Phí bảo
								hiểm (0.5%)</td>
							<td></td>
							<td class="pt-2 text-right"><span id="invInsuranceFee"></span>đ</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div
				class="flex justify-between items-center bg-gray-800 p-5 rounded-2xl text-white">
				<div>
					<p class="text-[9px] font-black uppercase text-gray-400">
						Hình thức: <span id="invPaymentMethod" class="text-nghv-green"></span>
					</p>
					<p class="text-sm font-black mt-1 uppercase">Tổng phí dự kiến</p>
				</div>
				<div class="text-2xl font-black text-nghv-green">
					<span id="invTotalAmount"></span>đ
				</div>
			</div>
		</div>

		<div class="p-8 bg-gray-50 flex gap-4">
			<button type="button" onclick="closeInvoice()"
				class="flex-1 py-4 text-[10px] font-black uppercase text-gray-400 hover:text-gray-600">Quay
				lại</button>
			<button type="button" onclick="handlePaymentStep()"
				class="flex-[2] bg-nghv-green text-white py-4 rounded-2xl font-black uppercase text-xs shadow-lg shadow-green-100 hover:scale-105 transition-all">
				Tiến hành thanh toán</button>
		</div>
	</div>
</div>

<div id="vnpayModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[110] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-sm shadow-2xl p-8 text-center animate-modal-up">
		<img
			src="https://vnpay.vn/wp-content/uploads/2020/07/Logo-VNPAYQR-1.png"
			class="h-8 mx-auto mb-6">
		<p class="text-xs font-bold text-gray-500 mb-6">Sử dụng ứng dụng
			Ngân hàng hoặc Ví VNPAY để quét mã</p>

		<div
			class="bg-white p-4 border-2 border-gray-100 rounded-3xl inline-block mb-6">
			<img id="vnpayQR" src="" class="w-48 h-48 mx-auto">
		</div>

		<div class="mb-8">
			<p class="text-[10px] font-black uppercase text-gray-400">Số tiền
				cần thanh toán</p>
			<p class="text-2xl font-black text-gray-800">
				<span id="vnpayAmount"></span>đ
			</p>
		</div>

		<button type="button" onclick="completeOrderWithPayment()"
			class="w-full bg-blue-600 text-white py-4 rounded-2xl font-black uppercase text-xs hover:bg-blue-700 transition-all">
			Tôi đã thanh toán xong</button>
		<button type="button" onclick="closeVNPay()"
			class="mt-4 text-[9px] font-black text-gray-400 uppercase tracking-widest">Hủy
			giao dịch</button>
	</div>
</div>

<style>
.animate-modal-up {
	animation: modalUp 0.5s cubic-bezier(0.165, 0.84, 0.44, 1) forwards;
}

@
keyframes modalUp {from { opacity:0;
	transform: translateY(50px) scale(0.95);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}
}
</style>

<script>
// Biến toàn cục lưu trữ dữ liệu địa chỉ để dùng chung
let locationData = [];

// 1. Khởi tạo: Load dữ liệu Tỉnh/Thành phố ngay khi trang tải xong
document.addEventListener('DOMContentLoaded', function() {
    fetch('https://provinces.open-api.vn/api/?depth=3')
        .then(res => res.json())
        .then(data => {
            locationData = data;
            const provinceSelect = document.getElementById('province');
            
            // Đổ dữ liệu vào Tỉnh/TP
            data.forEach(p => {
                provinceSelect.add(new Option(p.name, p.name));
            });
        })
        .catch(err => console.error("Lỗi load API địa chính:", err));
});

// 2. Logic xử lý thay đổi Dropdown Tỉnh -> Huyện -> Xã
document.getElementById('province').onchange = function() {
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');
    
    districtSelect.innerHTML = '<option value="">Quận/Huyện</option>';
    wardSelect.innerHTML = '<option value="">Phường/Xã</option>';
    
    const selectedProvince = locationData.find(p => p.name === this.value);
    if (selectedProvince) {
        selectedProvince.districts.forEach(d => {
            districtSelect.add(new Option(d.name, d.name));
        });
    }
};

document.getElementById('district').onchange = function() {
    const wardSelect = document.getElementById('ward');
    wardSelect.innerHTML = '<option value="">Phường/Xã</option>';
    
    const provinceName = document.getElementById('province').value;
    const selectedProvince = locationData.find(p => p.name === provinceName);
    if (selectedProvince) {
        const selectedDistrict = selectedProvince.districts.find(d => d.name === this.value);
        if (selectedDistrict) {
            selectedDistrict.wards.forEach(w => {
                wardSelect.add(new Option(w.name, w.name));
            });
        }
    }
};

//3.Hàm bổ trợ: Tìm và chọn option phù hợp nhất (Fuzzy Match)
function setSelectValue(selectElement, targetText) {
    if (!targetText) return;
    const options = selectElement.options;
    for (let i = 0; i < options.length; i++) {
        // So khớp không phân biệt hoa thường và kiểm tra chứa chuỗi
        // Ví dụ: "Ho Chi Minh" sẽ khớp với "Thành phố Hồ Chí Minh"
        if (options[i].text.toLowerCase().includes(targetText.toLowerCase()) || 
            options[i].value.toLowerCase().includes(targetText.toLowerCase())) {
            selectElement.selectedIndex = i;
            return true;
        }
    }
    return false;
}

function updateLocationSelects(pName, dName, wName) {
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');

    // 1. Chọn Tỉnh/TP
    if (setSelectValue(provinceSelect, pName)) {
        provinceSelect.dispatchEvent(new Event('change'));

        // 2. Đợi Quận/Huyện load xong
        setTimeout(() => {
            if (setSelectValue(districtSelect, dName)) {
                districtSelect.dispatchEvent(new Event('change'));
                
                // 3. Đợi Phường/Xã load xong
                setTimeout(() => {
                    setSelectValue(wardSelect, wName);
                }, 300); // Tăng thời gian chờ để đảm bảo DOM đã render
            }
        }, 300);
    }
}

// 4. Xử lý Auto-fill từ danh sách đã lưu
document.getElementById('savedReceivers').addEventListener('change', function() {
    const selectedOption = this.options[this.selectedIndex];
    if (selectedOption.value !== "") {
        // Điền các thông tin văn bản
        document.getElementById('recipientName').value = selectedOption.getAttribute('data-name');
        document.getElementById('recipientPhone').value = selectedOption.getAttribute('data-phone');
        document.getElementById('addressDetail').value = selectedOption.getAttribute('data-detail');
        
        // Cập nhật các dropdown địa chính
        const p = selectedOption.getAttribute('data-province');
        const d = selectedOption.getAttribute('data-district');
        const w = selectedOption.getAttribute('data-ward');
        updateLocationSelects(p, d, w);
    }
});

//5. Hàm Lưu thông tin người nhận mới
function saveNewReceiver() {
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');

    const data = {
        contactName: document.getElementById('recipientName').value,
        contactPhone: document.getElementById('recipientPhone').value,
        addressDetail: document.getElementById('addressDetail').value,
        // Lấy .text của option đang được chọn
        province: provinceSelect.options[provinceSelect.selectedIndex]?.text || "",
        district: districtSelect.options[districtSelect.selectedIndex]?.text || "",
        ward: wardSelect.options[wardSelect.selectedIndex]?.text || ""
    };

    // Kiểm tra dữ liệu đầu vào
    if (!data.contactName || !data.contactPhone || !data.addressDetail || provinceSelect.value === "") {
        Swal.fire({
            icon: 'warning',
            title: 'Thiếu thông tin',
            text: 'Vui lòng chọn đầy đủ Tỉnh/Thành, Quận/Huyện và Phường/Xã',
            customClass: { popup: 'rounded-[30px]' }
        });
        return;
    }

    Swal.fire({ title: 'Đang lưu...', didOpen: () => Swal.showLoading() });

    fetch('/customer/api/addresses/save', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(res => res.ok ? res.json() : Promise.reject())
    .then(savedAddr => {
        Swal.fire({
            icon: 'success',
            title: 'Thành công',
            text: 'Đã thêm vào danh sách người nhận!',
            timer: 2000,
            showConfirmButton: false,
            customClass: { popup: 'rounded-[30px]' }
        });

        // Cập nhật Dropdown ngay lập tức với dữ liệu TEXT chuẩn từ DB
        const select = document.getElementById('savedReceivers');
        const newOpt = new Option(`${savedAddr.contactName} - ${savedAddr.contactPhone}`, savedAddr.addressId);
        newOpt.setAttribute('data-name', savedAddr.contactName);
        newOpt.setAttribute('data-phone', savedAddr.contactPhone);
        newOpt.setAttribute('data-detail', savedAddr.addressDetail);
        newOpt.setAttribute('data-province', savedAddr.province);
        newOpt.setAttribute('data-district', savedAddr.district);
        newOpt.setAttribute('data-ward', savedAddr.ward);
        
        select.add(newOpt);
        select.value = savedAddr.addressId; 
    })
    .catch(() => Swal.fire('Lỗi', 'Không thể kết nối máy chủ', 'error'));
}

// 6. Xử lý xem trước ảnh đơn hàng (PNG/JPG)
// Cập nhật lại hàm xem trước ảnh để khớp với ID mới
function previewOrderImg(input) {
    const preview = document.getElementById('orderImgPreview');
    const icon = document.getElementById('imgPlaceholderIcon'); // Đã đổi ID cho khớp HTML trước
    
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.classList.remove('hidden');
            if (icon) icon.classList.add('hidden');
        };
        reader.readAsDataURL(input.files[0]);
    }
}

//Hàm hiển thị vị trí cửa hàng khi bấm vào icon fa-map-location-dot
function generateMapUrl(fullAddress) {
    // Chuẩn hóa địa chỉ: thêm Vietnam để Google tìm chính xác hơn
    var query = encodeURIComponent(fullAddress + ", Vietnam");
    // Sử dụng URL nhúng chính thức của Google Maps (output=embed)
    return "https://maps.google.com/maps?q=" + query + "&t=&z=16&ie=UTF8&iwloc=&output=embed";
}

// 1. Xử lý hiển thị vị trí STORE (Kho hàng - dùng trong trang Tạo đơn)
function showStoreLocation(storeName, fullAddress) {
    var modal = document.getElementById('mapModal');
    var frame = document.getElementById('mapFrame');
    var title = document.getElementById('mapTitle');
    
    if (!fullAddress || fullAddress.includes('Chưa thiết lập')) {
        Swal.fire({ icon: 'warning', title: 'Thiếu địa chỉ', text: 'Vui lòng cập nhật địa chỉ kho hàng.' });
        return;
    }

    title.innerText = storeName || "Vị trí kho hàng";
    frame.src = generateMapUrl(fullAddress);
    modal.classList.remove('hidden');
}

// 2. Xử lý hiển thị vị trí HUB (Bưu cục - dùng trong trang Mạng lưới)
function openMapModal(hubName, address, ward, district, province) {
    var modal = document.getElementById('mapModal');
    var frame = document.getElementById('mapFrame');
    var title = document.getElementById('mapTitle');

    title.innerText = hubName;
    // Gộp các thành phần địa chỉ thành chuỗi hoàn chỉnh
    var fullAddress = address + ", " + ward + ", " + district + ", " + province;
    
    frame.src = generateMapUrl(fullAddress);
    modal.classList.remove('hidden');
}

// Hàm đóng Modal dùng chung
function closeMapModal() {
    document.getElementById('mapModal').classList.add('hidden');
    document.getElementById('mapFrame').src = '';
}

//1. Hàm đóng/mở Drop-up
function toggleHubDropup() {
    const list = document.getElementById('hubDropupList');
    const arrow = document.getElementById('hubArrowIcon');
    const isHidden = list.classList.contains('hidden');
    
    // Đóng các dropdown khác nếu cần
    list.classList.toggle('hidden');
    arrow.style.transform = isHidden ? 'rotate(180deg)' : 'rotate(0deg)';
}

// 2. Hàm chọn bưu cục từ danh sách
function selectHub(id, name, fullAddr) {
    // Cập nhật giao diện hiển thị
    document.getElementById('selectedHubDisplay').innerText = name;
    document.getElementById('selectedHubDisplay').classList.remove('text-gray-300');
    document.getElementById('selectedHubDisplay').classList.add('text-gray-800', 'font-black');
    
    // Cập nhật giá trị vào input ẩn và chọn radio
    document.getElementById('selectedHubId').value = id;
    document.getElementById('pickupAtHub').checked = true;
    
    // Lưu địa chỉ đầy đủ để dùng cho việc định vị/xem map sau này
    document.getElementById('selectedHubId').setAttribute('data-full-addr', fullAddr);
    
    // Đóng list
    toggleHubDropup();
}

// 3. Đóng drop-up khi click ra ngoài
window.addEventListener('click', function(e) {
    const container = document.getElementById('hubDropupContainer');
    if (!container.contains(e.target)) {
        document.getElementById('hubDropupList').classList.add('hidden');
        document.getElementById('hubArrowIcon').style.transform = 'rotate(0deg)';
    }
});

//--- BỔ SUNG HOẶC THAY THẾ TOÀN BỘ LOGIC TÍNH PHÍ VÀ DROPDOWN KL ---

// 1. Bảng giá chuẩn
const SHIPPING_RATES = {
    "1": { base: 20000, extra: 5000 }, // Standard
    "2": { base: 35000, extra: 7000 }, // Express
    "3": { base: 150000, extra: 3000 } // BBS
};

function calculateOrderFees() {
    const serviceRadio = document.querySelector('input[name="serviceType.serviceTypeId"]:checked');
    if (!serviceRadio) return;
    
    const rate = SHIPPING_RATES[serviceRadio.value];
    
    // Lấy dữ liệu
    const weight = parseFloat(document.getElementById('weightInput').value) || 0;
    const quantity = parseInt(document.getElementById('quantityInput').value) || 1;
    const itemValue = parseFloat(document.getElementById('itemValueInput').value) || 0;
    const codAmount = parseFloat(document.getElementById('codInput').value) || 0;
    
    // LOGIC 1: Phí vận chuyển
    const totalWeight = weight * quantity;
    document.getElementById('displayTotalKL').innerText = totalWeight.toFixed(1);

    let shippingFee = rate.base;
    if (totalWeight > 1) {
        shippingFee += Math.ceil(totalWeight - 1) * rate.extra;
    }

    // LOGIC 2: Phí bảo hiểm (0.5% nếu >= 1 triệu)
    let insuranceFee = (itemValue >= 1000000) ? Math.round(itemValue * 0.005) : 0;

    // LOGIC 3: Phí dịch vụ COD (5.000đ khi có thu hộ)
    let codServiceFee = (codAmount > 0) ? 5000 : 0;

    // LOGIC 4: Tổng chi phí dịch vụ
    const totalFee = shippingFee + insuranceFee + codServiceFee;

    const formatter = new Intl.NumberFormat('vi-VN');
    
    // Cập nhật giao diện phí lẻ
    document.getElementById('displayShippingFee').innerText = formatter.format(shippingFee);
    const insuranceEl = document.getElementById('displayInsuranceFee');
    if (insuranceEl) insuranceEl.innerText = formatter.format(insuranceFee);
    document.getElementById('displayTotalPrice').innerText = formatter.format(totalFee);

    // --- LOGIC QUAN TRỌNG: SỐ TIỀN SHIPPER THU HỘ ---
    const paymentSelect = document.querySelector('select[name="paymentMethod"]');
    if (paymentSelect) {
        const paymentType = paymentSelect.value;
        let amountToCollect = codAmount; // Mặc định luôn thu tiền hàng (COD)

        // Nếu chọn "Thanh toán khi nhận" (COD), cộng thêm phí dịch vụ vào tiền thu khách
        if (paymentType === "COD") { 
            amountToCollect += totalFee;
        }

        const collectEl = document.getElementById('displayAmountToCollect');
        if (collectEl) collectEl.innerText = formatter.format(amountToCollect);
    }
}

// 2. Khởi tạo sự kiện
document.addEventListener('DOMContentLoaded', function() {
    // Lắng nghe các ô nhập số
    ['weightInput', 'quantityInput', 'codInput', 'itemValueInput'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('input', calculateOrderFees);
    });

    // Lắng nghe đổi Dịch vụ (STD/EXP/BBS)
    document.querySelectorAll('input[name="serviceType.serviceTypeId"]').forEach(radio => {
        radio.addEventListener('change', calculateOrderFees);
    });
    
    // Lắng nghe đổi Hình thức thanh toán
    const paymentSelect = document.querySelector('select[name="paymentMethod"]');
    if (paymentSelect) {
        paymentSelect.addEventListener('change', calculateOrderFees);
    }

    calculateOrderFees();
});


//--- LOGIC XỬ LÝ THANH TOÁN 2 BƯỚC ---

function showInvoiceModal() {
    // 1. Lấy dữ liệu từ form
    const receiverName = document.getElementById('recipientName').value;
    const receiverPhone = document.getElementById('recipientPhone').value;
    const addr = document.getElementById('addressDetail').value;
    const province = document.getElementById('province').value;
    const itemName = document.querySelector('input[name="itemName"]').value;
    const weight = document.getElementById('weightInput').value;
    const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
    const totalFee = document.getElementById('displayTotalPrice').innerText;

    // Kiểm tra dữ liệu cơ bản
    if(!receiverName || !addr || !itemName) {
        Swal.fire({ icon: 'error', title: 'Thiếu thông tin', text: 'Vui lòng điền đầy đủ thông tin đơn hàng!' });
        return;
    }

    // 2. Đổ dữ liệu vào Hóa đơn
    document.getElementById('invReceiverName').innerText = receiverName + " - " + receiverPhone;
    document.getElementById('invReceiverAddr').innerText = addr + ", " + province;
    document.getElementById('invItemName').innerText = itemName;
    document.getElementById('invWeight').innerText = weight;
    document.getElementById('invShippingFee').innerText = document.getElementById('displayShippingFee').innerText;
    document.getElementById('invInsuranceFee').innerText = document.getElementById('displayInsuranceFee').innerText;
    document.getElementById('invPaymentMethod').innerText = paymentMethod === 'COD' ? 'Thanh toán khi nhận' : 'Tiền hàng trả trước';
    document.getElementById('invTotalAmount').innerText = totalFee;
    document.getElementById('invDate').innerText = new Date().toLocaleDateString('vi-VN');

    // 3. Hiển thị Modal
    document.getElementById('invoiceModal').classList.remove('hidden');
}

//--- HÀM XỬ LÝ THANH TOÁN 2 BƯỚC HOÀN CHỈNH ---
async function handlePaymentStep() {
    const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
    const totalFeeStr = document.getElementById('displayTotalPrice').innerText;
    
    // Làm sạch số tiền (giữ lại 129000 từ chuỗi 129.000đ)
    const amount = parseInt(totalFeeStr.replace(/\D/g, ''));

    if (isNaN(amount) || amount <= 0) {
        Swal.fire('Lỗi', 'Số tiền thanh toán không hợp lệ!', 'error');
        return;
    }

    if (paymentMethod === 'COD') {
        Swal.fire({
            title: 'Xác nhận đơn hàng',
            text: "Tạo đơn hàng hình thức Thu hộ (COD).",
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Đồng ý'
        }).then((result) => {
            if (result.isConfirmed) document.getElementById('orderForm').submit();
        });
    } else {
        // TRƯỜNG HỢP VNPAY: CHUYỂN HƯỚNG TRỰC TIẾP
        document.getElementById('invoiceModal').classList.add('hidden');
        
        Swal.fire({ 
            title: 'Đang chuyển hướng...', 
            text: 'Vui lòng chờ trong giây lát để kết nối cổng VNPay',
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading() 
        });

        try {
            const tempOrderId = "NGHV" + Date.now();
            // Sử dụng phép cộng chuỗi để tránh xung đột JSP EL
            const apiUrl = "/customer/api/payment/create-vnpay?amount=" + amount + "&orderId=" + tempOrderId;
            
            const response = await fetch(apiUrl);
            if (!response.ok) throw new Error("Lỗi khởi tạo thanh toán");
            
            const data = await response.json();

            // THAY THẾ IFRAME BẰNG CHUYỂN HƯỚNG
            // data.url là link Sandbox đã được Backend băm chữ ký bảo mật
            window.location.href = data.url; 

        } catch (err) {
            Swal.fire('Lỗi kết nối', 'Không thể mở cổng thanh toán. Vui lòng thử lại!', 'error');
        }
    }
}

function completeOrderWithPayment() {
    Swal.fire({
        title: 'Đang xác thực giao dịch...',
        timer: 2000,
        didOpen: () => Swal.showLoading()
    }).then(() => {
        document.getElementById('orderForm').submit();
    });
}

function closeInvoice() { document.getElementById('invoiceModal').classList.add('hidden'); }
function closeVNPay() { document.getElementById('vnpayModal').classList.add('hidden'); }
</script>