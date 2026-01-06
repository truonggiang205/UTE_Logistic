<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

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

				<div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch" id="serviceTypeContainer">
					<c:forEach items="${serviceTypes}" var="st" varStatus="status">
						<label
							class="relative flex flex-col h-full p-6 border-2 rounded-[24px] cursor-pointer transition-all hover:border-nghv-green has-[:checked]:border-nghv-green has-[:checked]:bg-green-50/30 group">
							<input type="radio" name="serviceType.serviceTypeId" value="${st.serviceTypeId}"
								class="absolute top-5 right-5 text-nghv-green focus:ring-0 service-type-radio"
								data-base-fee="${st.baseFee}"
								data-extra-price="${st.extraPricePerKg}"
								${status.first ? 'checked' : ''}>

							<div class="flex items-center mb-5">
								<div
									class="w-12 h-12 flex-shrink-0 ${status.first ? 'bg-green-100 text-nghv-green' : 'bg-gray-100 text-gray-400 group-hover:bg-green-100 group-hover:text-nghv-green'} rounded-2xl flex items-center justify-center mr-3 transition-colors">
									<i class="fa-solid ${st.serviceCode == 'EXP' ? 'fa-bolt-lightning' : (st.serviceCode == 'STD' ? 'fa-truck' : 'fa-truck-moving')} text-xl"></i>
								</div>
								<div class="flex-grow min-w-0">
									<span
										class="block text-sm font-black uppercase tracking-tight truncate">${st.serviceName}</span>
									<span class="text-[9px] font-bold ${status.first ? 'text-nghv-green' : 'text-gray-400 group-hover:text-nghv-green'} uppercase">${st.serviceCode}</span>
								</div>
								<div class="text-right flex-shrink-0 ml-2">
									<span
										class="block text-[9px] font-black text-gray-400 uppercase leading-none mb-1">Phí
										cơ bản</span>
									<span class="text-sm font-black text-nghv-orange leading-none">
										<fmt:formatNumber value="${st.baseFee}" type="number" groupingUsed="true"/>đ
									</span>
								</div>
							</div>

							<div class="flex-grow space-y-3 border-t border-gray-100 pt-4">
								<p class="text-[10px] font-bold text-gray-500 flex items-start">
									<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
									<span><b>Mô tả:</b> ${st.description != null ? st.description : 'Dịch vụ vận chuyển'}</span>
								</p>
								<p class="text-[10px] font-bold text-gray-500 flex items-start">
									<i class="fa-solid fa-circle-check mt-0.5 mr-2 text-nghv-green"></i>
									<span><b>Phụ phí:</b> +<fmt:formatNumber value="${st.extraPricePerKg}" type="number" groupingUsed="true"/>đ/kg tiếp theo</span>
								</p>
							</div>
						</label>
					</c:forEach>
				</div>
			</div>

			<div
				class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100">
				<h3 class="text-xl font-black text-gray-800 mb-6">Chọn bưu cục gửi hàng</h3>
				<div class="space-y-4">
					<div class="relative" id="hubDropupContainer">
						<div onclick="toggleHubDropup()"
							class="w-full bg-white border border-gray-200 rounded-lg px-4 py-3 flex items-center justify-between cursor-pointer hover:border-nghv-green transition-all group">
							<span id="selectedHubDisplay"
								class="text-sm text-gray-300 font-medium">Bấm chọn Bưu cục gần nhất</span>
							<div class="flex items-center space-x-2">
								<i class="fa-solid fa-location-dot text-nghv-green/50 text-xs"></i>
								<i id="hubArrowIcon"
									class="fa-solid fa-chevron-up text-[10px] text-gray-400 group-hover:text-nghv-green transition-transform"></i>
							</div>
						</div>

						<div id="hubDropupList"
							class="absolute bottom-full left-0 right-0 mb-2 bg-white border border-gray-100 rounded-[24px] shadow-2xl z-[80] hidden animate-modal-up overflow-hidden">
							
							<!-- Thanh tìm kiếm Hub -->
							<div class="p-3 border-b border-gray-100">
								<div class="relative">
									<i class="fa-solid fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-300 text-xs"></i>
									<input type="text" id="hubSearchInput" placeholder="Tìm theo tên hoặc địa chỉ..."
										class="w-full pl-9 pr-4 py-2 bg-gray-50 border-none rounded-xl text-xs font-medium focus:ring-2 focus:ring-nghv-green"
										onkeyup="filterHubs()">
								</div>
							</div>
							
							<div class="max-h-60 overflow-y-auto custom-scrollbar" id="hubListContainer">
								<c:forEach items="${allHubs}" var="hub">
									<div class="hub-item"
										data-name="${hub.hubName}"
										data-address="${hub.address} ${hub.ward} ${hub.district} ${hub.province}"
										onclick="selectHub('${hub.hubId}', '${hub.hubName}', '${hub.address}, ${hub.ward}, ${hub.district}, ${hub.province}')"
										class="px-5 py-4 hover:bg-green-50 cursor-pointer border-b border-gray-50 last:border-none transition-colors group">
										<p class="text-[11px] font-black text-gray-800 group-hover:text-nghv-green uppercase">${hub.hubName}</p>
										<p class="text-[10px] text-gray-400 font-bold mt-1 line-clamp-1">${hub.address}, ${hub.district}, ${hub.province}</p>
									</div>
								</c:forEach>
								<c:if test="${empty allHubs}">
									<div class="p-5 text-center">
										<p class="text-[10px] font-bold text-gray-400">Không có bưu cục nào trong hệ thống.</p>
									</div>
								</c:if>
								<!-- No results message -->
								<div id="noHubResults" class="p-5 text-center hidden">
									<p class="text-[10px] font-bold text-gray-400">Không tìm thấy bưu cục phù hợp.</p>
								</div>
							</div>
						</div>

						<input type="hidden" name="hubId" id="selectedHubId" required>
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

						<div class="flex items-center gap-3 flex-wrap">
							<div class="flex items-center">
								<span class="text-[9px] text-gray-400 mr-1.5 font-black">KL</span>
								<div class="flex items-center">
									<div class="relative">
										<input type="number" id="weightInput" name="weight"
											value="1.0" min="0.1" max="100" step="0.1"
											class="w-16 bg-white border border-gray-200 rounded-lg px-2 py-1.5 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green focus:border-nghv-green outline-none transition-all">
									</div>
									<span class="text-[9px] text-gray-400 ml-1">kg</span>
								</div>
							</div>

							<div class="flex items-center ml-2">
								<span class="text-[9px] text-gray-400 mr-1.5 font-black">SL</span>
								<input type="number" id="quantityInput" name="quantity"
									value="1" min="1"
									class="w-8 bg-white border border-gray-200 rounded-lg px-1 py-1 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green">
							</div>
						</div>
						
						<!-- Kích thước (D x R x C) -->
						<div class="flex items-center gap-2 mt-3">
							<span class="text-[9px] text-gray-400 font-black">KT</span>
							<input type="number" id="lengthInput" name="length" value="10" min="1" max="200" step="1"
								class="w-12 bg-white border border-gray-200 rounded-lg px-1 py-1 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green"
								placeholder="D">
							<span class="text-[9px] text-gray-400">x</span>
							<input type="number" id="widthInput" name="width" value="10" min="1" max="200" step="1"
								class="w-12 bg-white border border-gray-200 rounded-lg px-1 py-1 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green"
								placeholder="R">
							<span class="text-[9px] text-gray-400">x</span>
							<input type="number" id="heightInput" name="height" value="10" min="1" max="200" step="1"
								class="w-12 bg-white border border-gray-200 rounded-lg px-1 py-1 text-[10px] font-black text-center focus:ring-1 focus:ring-nghv-green"
								placeholder="C">
							<span class="text-[9px] text-gray-400">cm</span>
						</div>
						
						<!-- Ghi chú -->
						<div class="mt-3">
							<textarea name="note" id="noteInput" rows="2" 
								placeholder="Ghi chú cho shipper (VD: Hàng dễ vỡ, gọi trước khi giao...)"
								class="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2 text-[10px] font-medium focus:ring-1 focus:ring-nghv-green focus:border-nghv-green resize-none"></textarea>
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
						<span>Hình thức thanh toán</span> <select name="paymentMethod" id="paymentMethodSelect"
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
    
    // Clear search khi mở dropdown
    if (isHidden) {
        const searchInput = document.getElementById('hubSearchInput');
        if (searchInput) {
            searchInput.value = '';
            filterHubs(); // Reset filter
        }
    }
    
    list.classList.toggle('hidden');
    arrow.style.transform = isHidden ? 'rotate(180deg)' : 'rotate(0deg)';
}

// 2. Hàm chọn bưu cục từ danh sách
function selectHub(id, name, fullAddr) {
    // Cập nhật giao diện hiển thị
    document.getElementById('selectedHubDisplay').innerText = name;
    document.getElementById('selectedHubDisplay').classList.remove('text-gray-300');
    document.getElementById('selectedHubDisplay').classList.add('text-gray-800', 'font-black');
    
    // Cập nhật giá trị vào input ẩn
    document.getElementById('selectedHubId').value = id;
    
    // Lưu địa chỉ đầy đủ để dùng cho việc định vị/xem map sau này
    document.getElementById('selectedHubId').setAttribute('data-full-addr', fullAddr);
    
    // Đóng list
    toggleHubDropup();
}

// 3. Hàm tìm kiếm Hub theo tên hoặc địa chỉ
function filterHubs() {
    const searchInput = document.getElementById('hubSearchInput');
    const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
    const hubItems = document.querySelectorAll('.hub-item');
    const noResults = document.getElementById('noHubResults');
    let visibleCount = 0;
    
    hubItems.forEach(item => {
        const name = (item.getAttribute('data-name') || '').toLowerCase();
        const address = (item.getAttribute('data-address') || '').toLowerCase();
        
        if (keyword === '' || name.includes(keyword) || address.includes(keyword)) {
            item.classList.remove('hidden');
            visibleCount++;
        } else {
            item.classList.add('hidden');
        }
    });
    
    // Hiển thị thông báo nếu không có kết quả
    if (noResults) {
        if (visibleCount === 0 && keyword !== '') {
            noResults.classList.remove('hidden');
        } else {
            noResults.classList.add('hidden');
        }
    }
}

// 4. Đóng drop-up khi click ra ngoài
window.addEventListener('click', function(e) {
    const container = document.getElementById('hubDropupContainer');
    if (!container.contains(e.target)) {
        document.getElementById('hubDropupList').classList.add('hidden');
        document.getElementById('hubArrowIcon').style.transform = 'rotate(0deg)';
    }
});

//--- LOGIC TÍNH PHÍ ĐỘNG TỪ DATABASE ---

function calculateOrderFees() {
    const serviceRadio = document.querySelector('input[name="serviceType.serviceTypeId"]:checked');
    if (!serviceRadio) return;
    
    // Đọc giá từ data attributes của radio button (lấy từ database)
    const baseFee = parseFloat(serviceRadio.getAttribute('data-base-fee')) || 0;
    const extraPrice = parseFloat(serviceRadio.getAttribute('data-extra-price')) || 0;
    
    const weight = parseFloat(document.getElementById('weightInput').value) || 0;
    const quantity = parseInt(document.getElementById('quantityInput').value) || 1;
    const codAmount = parseFloat(document.getElementById('codInput').value) || 0;
    
    // Lấy kích thước (D x R x C) để tính trọng lượng quy đổi
    const length = parseFloat(document.getElementById('lengthInput').value) || 10;
    const width = parseFloat(document.getElementById('widthInput').value) || 10;
    const height = parseFloat(document.getElementById('heightInput').value) || 10;
    
    // Tính trọng lượng quy đổi (Volumetric Weight) = D × R × C / 6000
    const volumetricWeight = (length * width * height) / 6000;
    
    // Trọng lượng tính phí = MAX(trọng lượng thực, trọng lượng quy đổi)
    const chargeableWeight = Math.max(weight, volumetricWeight) * quantity;
    
    // Hiển thị trọng lượng tính phí (làm tròn 2 chữ số thập phân)
    document.getElementById('displayTotalKL').innerText = chargeableWeight.toFixed(2);

    // 1. Phí vận chuyển: Tính theo từng KG tiếp theo
    let shippingFee = baseFee;
    if (chargeableWeight > 1) {
        shippingFee += Math.ceil(chargeableWeight - 1) * extraPrice;
    }

    // 2. Phí bảo hiểm: Đã loại bỏ (luôn bằng 0)
    let insuranceFee = 0;
    const insuranceEl = document.getElementById('displayInsuranceFee');
    if (insuranceEl) insuranceEl.innerText = "0";

    // 3. Phí dịch vụ COD (0.5%)
    let codServiceFee = Math.round(codAmount * 0.005);

    // 4. Tổng chi phí dịch vụ
    const totalFee = shippingFee + insuranceFee + codServiceFee;

    const formatter = new Intl.NumberFormat('vi-VN');
    document.getElementById('displayShippingFee').innerText = formatter.format(shippingFee);
    document.getElementById('displayTotalPrice').innerText = formatter.format(totalFee);

    // Tính số tiền Shipper sẽ thu
    const paymentSelect = document.querySelector('select[name="paymentMethod"]');
    let amountToCollect = codAmount;
    if (paymentSelect && paymentSelect.value === "COD") { 
        amountToCollect += totalFee;
    }
    document.getElementById('displayAmountToCollect').innerText = formatter.format(amountToCollect);
}

// 2. Khởi tạo sự kiện
document.addEventListener('DOMContentLoaded', function() {
    // Lắng nghe các ô nhập số (bao gồm cả kích thước D x R x C)
    ['weightInput', 'quantityInput', 'codInput', 'itemValueInput', 'lengthInput', 'widthInput', 'heightInput'].forEach(id => {
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
    const chargeableWeight = document.getElementById('displayTotalKL').innerText; // Trọng lượng tính phí (đã quy đổi)
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
    document.getElementById('invWeight').innerText = chargeableWeight; // Hiển thị trọng lượng tính phí
    document.getElementById('invShippingFee').innerText = document.getElementById('displayShippingFee').innerText;
    document.getElementById('invInsuranceFee').innerText = document.getElementById('displayInsuranceFee').innerText;
    document.getElementById('invPaymentMethod').innerText = paymentMethod === 'COD' ? 'Thanh toán khi nhận' : 'Tiền hàng trả trước';
    document.getElementById('invTotalAmount').innerText = totalFee;
    document.getElementById('invDate').innerText = new Date().toLocaleDateString('vi-VN');

    // 3. Hiển thị Modal
    document.getElementById('invoiceModal').classList.remove('hidden');
}

//--- HÀM XỬ LÝ THANH TOÁN 2 BƯỚC HOÀN CHỈNH (ĐÃ FIX LƯU DATA) ---
async function handlePaymentStep() {
    const paymentMethod = document.querySelector('select[name="paymentMethod"]').value;
    const form = document.getElementById('orderForm');
    
    // Kiểm tra tính hợp lệ cơ bản của form trước khi xử lý
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    if (paymentMethod === 'COD') {
        // TRƯỜNG HỢP 1: THANH TOÁN KHI NHẬN (Lưu đơn và chuyển hướng trực tiếp)
        Swal.fire({
            title: 'Xác nhận đơn hàng',
            text: "Tạo đơn hàng hình thức Thu hộ (COD).",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#00B14F',
            confirmButtonText: 'Đồng ý',
            cancelButtonText: 'Quay lại'
        }).then((result) => {
            if (result.isConfirmed) form.submit();
        });
    } else {
        // TRƯỜNG HỢP 2: THANH TOÁN VNPAY (Lưu đơn nháp -> Lấy URL thanh toán)
        document.getElementById('invoiceModal').classList.add('hidden');
        
        Swal.fire({ 
            title: 'Đang khởi tạo đơn hàng...', 
            text: 'Dữ liệu đang được lưu vào hệ thống',
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading() 
        });

        try {
            // Lấy toàn bộ dữ liệu từ Form (bao gồm cả Image file)
            const formData = new FormData(form);

            // Gửi dữ liệu qua POST để Controller lưu vào db service_request
            const response = await fetch('/customer/api/payment/create-vnpay', {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.message || "Lỗi lưu đơn hàng");
            }
            
            const data = await response.json();

            // data.url là link thanh toán được tạo dựa trên ID đơn hàng vừa lưu
            if (data.url) {
                window.location.href = data.url; 
            } else {
                throw new Error("Không nhận được liên kết thanh toán");
            }

        } catch (err) {
            console.error("Lỗi:", err);
            Swal.fire({
                icon: 'error',
                title: 'Lỗi khởi tạo',
                text: err.message || 'Không thể kết nối với cổng thanh toán. Vui lòng thử lại!'
            });
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

document.addEventListener("DOMContentLoaded", function () {
    const paymentSelect = document.getElementById("paymentMethodSelect");
    const codInput = document.getElementById("codInput");

    function toggleCodInput() {
        if (paymentSelect.value === "PREPAID") {
            codInput.value = 0;
            codInput.setAttribute("readonly", true);
            codInput.classList.add("text-gray-400", "cursor-not-allowed");
        } else {
            codInput.removeAttribute("readonly");
            codInput.classList.remove("text-gray-400", "cursor-not-allowed");
        }
    }

    // Khi load trang
    toggleCodInput();

    // Khi đổi hình thức thanh toán
    paymentSelect.addEventListener("change", toggleCodInput);
});
</script>