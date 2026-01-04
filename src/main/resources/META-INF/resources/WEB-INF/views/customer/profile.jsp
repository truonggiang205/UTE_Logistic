<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<form id="profileForm" action="/customer/profile/update-final"
	method="POST" enctype="multipart/form-data" class="space-y-8 pb-12">
	<div class="max-w-6xl mx-auto space-y-8 animate-fade-in">

		<div
			class="bg-white rounded-[40px] border border-gray-100 shadow-sm overflow-hidden">
			<div
				class="p-8 md:p-12 flex flex-col md:flex-row items-center gap-8 border-b border-gray-50">
				<div class="relative group cursor-pointer"
					onclick="document.getElementById('avatarInput').click()">
					<div id="avatarPreview"
						class="w-32 h-32 rounded-full border-4 border-white shadow-2xl overflow-hidden bg-gray-50 flex items-center justify-center">
						<c:choose>
							<c:when test="${not empty avatarUrl}">
								<img src="${avatarUrl}" class="w-full h-full object-cover">
							</c:when>
							<c:otherwise>
								<span class="text-4xl font-black text-nghv-green">${username.substring(0,2).toUpperCase()}</span>
							</c:otherwise>
						</c:choose>
					</div>
					<input type="file" id="avatarInput" name="avatarFile"
						class="hidden" accept="image/*" onchange="previewAvatar(this)">
					<div
						class="absolute bottom-1 right-1 w-10 h-10 bg-white rounded-full shadow-lg border border-gray-100 flex items-center justify-center text-nghv-green group-hover:scale-110 transition-all">
						<i class="fa-solid fa-camera"></i>
					</div>
				</div>

				<div class="text-center md:text-left flex-1">
					<h2
						class="text-3xl font-black text-gray-800 tracking-tighter uppercase">S${customer.customerId}
						/ ${customer.businessName}</h2>
					<div
						class="flex flex-wrap justify-center md:justify-start gap-4 mt-4">
						<span
							class="px-4 py-1.5 bg-green-50 text-nghv-green text-[10px] font-black uppercase rounded-full border border-green-100">
							<i class="fa-solid fa-medal mr-2"></i>Shop Tin Cậy
						</span>
					</div>
				</div>
			</div>

			<div
				class="grid grid-cols-2 md:grid-cols-4 divide-x divide-y md:divide-y-0 divide-gray-50 text-center text-[10px] font-black uppercase text-gray-400">
				<div class="p-8">
					<p class="text-xl text-gray-800">-</p>
					Thâm niên
				</div>
				<div class="p-8">
					<p class="text-xl text-gray-800">-</p>
					Khách quay lại
				</div>
				<div class="p-8">
					<p class="text-xl text-gray-800">-</p>
					Chuẩn bị hàng
				</div>
				<div class="p-8">
					<p class="text-xl text-gray-800">100%</p>
					Thành công
				</div>
			</div>
		</div>

		<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
			<div class="lg:col-span-2 space-y-8">
				<div
					class="bg-white p-10 rounded-[40px] border border-gray-100 shadow-sm space-y-8">
					<div class="flex items-center space-x-3">
						<span class="w-1.5 h-5 bg-nghv-green rounded-full"></span>
						<h3
							class="text-sm font-black text-gray-800 uppercase tracking-widest">Thông
							tin tài khoản</h3>
					</div>

					<input type="hidden" id="hiddenOtp" name="otp">

					<div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Tên
								shop</label> <input type="text" name="businessName"
								value="${customer.businessName}" required
								class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
						</div>
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Số
								điện thoại</label> <input type="text" name="phone" value="${user.phone}"
								required
								class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
						</div>
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Họ
								tên quản trị</label> <input type="text" name="fullName"
								value="${user.fullName}" required
								class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
						</div>
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Email
								xác thực</label> <input type="email" id="inputEmail" name="email"
								value="${user.email}" data-current="${user.email}" required
								class="w-full px-5 py-4 ${user.email.endsWith('@nghv.io') ? 'bg-orange-50 border border-orange-100 animate-pulse' : 'bg-gray-50'} border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
						</div>
					</div>

					<div class="pt-8 border-t border-gray-50 space-y-6">
						<div class="flex items-center justify-between">
							<div class="flex items-center space-x-3">
								<span class="w-1.5 h-5 bg-orange-500 rounded-full"></span>
								<h3
									class="text-sm font-black text-gray-800 uppercase tracking-widest">Thông
									tin ngân hàng</h3>
							</div>
							<span
								class="text-[10px] font-bold ${empty customer.bankName ? 'text-red-500' : 'text-green-500'} uppercase">
								${empty customer.bankName ? '/ Chưa liên kết' : '/ Đã liên kết'}
							</span>
						</div>

						<p class="text-[11px] text-gray-400 italic">Tài khoản ngân
							hàng shop điền dưới đây sẽ được sử dụng làm tài khoản đối soát
							với NGHV Logistics</p>

						<div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
							<div class="space-y-2">
								<label
									class="text-[10px] font-black text-gray-400 uppercase ml-2">Ngân
									hàng</label> <select name="bankName"
									class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
									<option value="">Chọn ngân hàng</option>

									<option value="VCB"
										${customer.bankName == 'VCB' ? 'selected' : ''}>VIETCOMBANK
										- TMCP Ngoại Thương VN</option>
									<option value="CTG"
										${customer.bankName == 'CTG' ? 'selected' : ''}>VIETINBANK
										- TMCP Công Thương VN</option>
									<option value="BID"
										${customer.bankName == 'BID' ? 'selected' : ''}>BIDV
										- Đầu tư và Phát triển VN</option>
									<option value="VAR"
										${customer.bankName == 'VAR' ? 'selected' : ''}>AGRIBANK
										- NN & PT Nông thôn VN</option>

									<option value="MB"
										${customer.bankName == 'MB' ? 'selected' : ''}>MBBANK
										- TMCP Quân Đội</option>
									<option value="TBC"
										${customer.bankName == 'TBC' ? 'selected' : ''}>TECHCOMBANK
										- TMCP Kỹ Thương</option>
									<option value="ACB"
										${customer.bankName == 'ACB' ? 'selected' : ''}>ACB -
										TMCP Á Châu</option>
									<option value="VPB"
										${customer.bankName == 'VPB' ? 'selected' : ''}>VPBANK
										- TMCP Việt Nam Thịnh Vượng</option>
									<option value="TPB"
										${customer.bankName == 'TPB' ? 'selected' : ''}>TPBANK
										- TMCP Tiên Phong</option>
									<option value="STB"
										${customer.bankName == 'STB' ? 'selected' : ''}>SACOMBANK
										- TMCP Sài Gòn Thương Tín</option>
									<option value="HDB"
										${customer.bankName == 'HDB' ? 'selected' : ''}>HDBANK
										- TMCP Phát triển TP.HCM</option>
									<option value="VIB"
										${customer.bankName == 'VIB' ? 'selected' : ''}>VIB -
										TMCP Quốc tế Việt Nam</option>
									<option value="MSB"
										${customer.bankName == 'MSB' ? 'selected' : ''}>MSB -
										TMCP Hàng Hải Việt Nam</option>
									<option value="SHB"
										${customer.bankName == 'SHB' ? 'selected' : ''}>SHB -
										TMCP Sài Gòn - Hà Nội</option>
									<option value="EIB"
										${customer.bankName == 'EIB' ? 'selected' : ''}>EXIMBANK
										- TMCP Xuất Nhập Khẩu</option>
									<option value="LPB"
										${customer.bankName == 'LPB' ? 'selected' : ''}>LPBANK
										- TMCP Lộc Phát Việt Nam</option>
								</select>
							</div>
							<div class="space-y-2">
								<label
									class="text-[10px] font-black text-gray-400 uppercase ml-2">Chi
									nhánh ngân hàng</label> <input type="text" name="bankBranch"
									value="${customer.bankBranch}" placeholder="Bấm chọn chi nhánh"
									class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
							</div>
							<div class="space-y-2">
								<label
									class="text-[10px] font-black text-gray-400 uppercase ml-2">Tên
									chủ tài khoản</label> <input type="text" id="bankAccountName"
									name="accountHolderName" value="${customer.accountHolderName}"
									placeholder="CHỦ TÀI KHOẢN NGÂN HÀNG"
									class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all uppercase">
							</div>
							<div class="space-y-2">
								<label
									class="text-[10px] font-black text-gray-400 uppercase ml-2">Số
									tài khoản</label> <input type="text" id="bankAccountNumber"
									name="accountNumber" value="${customer.accountNumber}"
									placeholder="SỐ TÀI KHOẢN NGÂN HÀNG"
									class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
							</div>
						</div>
					</div>

					<div class="pt-8 border-t border-gray-50 space-y-6">
						<h3
							class="text-[11px] font-black text-gray-800 uppercase tracking-widest">Chứng
							minh thư / CCCD</h3>
						<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
							<div
								class="aspect-video border-2 border-dashed border-gray-100 rounded-[32px] flex flex-col items-center justify-center p-6 bg-gray-50/30 hover:bg-gray-50 transition-all cursor-pointer group">
								<i
									class="fa-solid fa-image text-gray-200 group-hover:text-nghv-green text-3xl mb-3"></i>
								<span
									class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Mặt
									trước CCCD</span>
							</div>
							<div
								class="aspect-video border-2 border-dashed border-gray-100 rounded-[32px] flex flex-col items-center justify-center p-6 bg-gray-50/30 hover:bg-gray-50 transition-all cursor-pointer group">
								<i
									class="fa-solid fa-image text-gray-200 group-hover:text-nghv-green text-3xl mb-3"></i>
								<span
									class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Mặt
									sau CCCD</span>
							</div>
						</div>
					</div>

					<div class="pt-8 flex justify-end">
						<button type="button" onclick="validateAndSubmit()"
							class="bg-nghv-green text-white px-12 py-4 rounded-2xl text-xs font-black uppercase hover:bg-black transition-all shadow-xl shadow-green-100 active:scale-95">
							Lưu thay đổi hồ sơ</button>
					</div>
				</div>
			</div>

			<div class="space-y-6">
				<div
					class="bg-gray-900 text-white p-10 rounded-[40px] shadow-2xl relative overflow-hidden">
					<i
						class="fa-solid fa-user-shield absolute -right-4 -bottom-4 text-8xl opacity-10 rotate-12"></i>
					<h4 class="text-xs font-black uppercase tracking-widest mb-6">Bảo
						mật hệ thống</h4>
					<div class="space-y-5 text-[11px]">
						<div
							class="flex justify-between items-center pb-4 border-b border-white/5">
							<span class="font-bold text-white/50 uppercase">Username</span> <span
								class="font-black">${user.username}</span>
						</div>
						<div class="flex justify-between items-center">
							<span class="font-bold text-white/50 uppercase">Mật khẩu</span>
							<button type="button" onclick="openPasswordModal()"
								class="font-black text-nghv-green hover:underline">ĐỔI
								MẬT KHẨU</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div id="otpModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[100] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-md p-10 shadow-2xl animate-modal-up">
		<div class="text-center space-y-4">
			<div
				class="w-16 h-16 bg-green-50 text-nghv-green rounded-full flex items-center justify-center mx-auto">
				<i class="fa-solid fa-envelope-shield text-2xl"></i>
			</div>
			<h3
				class="text-lg font-black text-gray-800 uppercase tracking-tighter">Xác
				thực Email</h3>
			<p class="text-[11px] text-gray-400 font-medium leading-relaxed">Mã
				OTP đã được gửi đến email mới. Vui lòng nhập mã để hoàn tất cập
				nhật.</p>
			<input type="text" id="otpInput" maxlength="6" placeholder="000000"
				class="w-full text-center text-2xl font-black tracking-[1rem] py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-nghv-green">
			<div class="flex space-x-3 pt-4">
				<button type="button" onclick="closeOtpModal()"
					class="flex-1 py-3 text-[10px] font-black uppercase text-gray-400 hover:text-gray-600 transition-colors">Hủy</button>
				<button type="button" onclick="confirmOtp()"
					class="flex-[2] bg-gray-800 text-white py-3 rounded-2xl text-[10px] font-black uppercase hover:bg-black transition-all">Xác
					nhận</button>
			</div>
		</div>
	</div>
</div>

<div id="passwordModal"
	class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm z-[100] hidden flex items-center justify-center p-4">
	<div
		class="bg-white rounded-[40px] w-full max-w-md p-10 shadow-2xl animate-modal-up">
		<form action="/customer/profile/change-password" method="POST"
			id="passwordForm" class="space-y-6">
			<div class="text-center mb-6">
				<div
					class="w-16 h-16 bg-orange-50 text-orange-500 rounded-full flex items-center justify-center mx-auto mb-4">
					<i class="fa-solid fa-key text-2xl"></i>
				</div>
				<h3
					class="text-lg font-black text-gray-800 uppercase tracking-tighter">Thiết
					lập mật khẩu mới</h3>
			</div>
			<div class="space-y-4">
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Mật
						khẩu hiện tại</label><input type="password" name="currentPassword"
						required
						class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
				</div>
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Mật
						khẩu mới</label><input type="password" id="newPassword" name="newPassword"
						required
						class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
				</div>
				<div>
					<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Xác
						nhận mật khẩu mới</label><input type="password" id="confirmPassword"
						required
						class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-nghv-green transition-all">
				</div>
			</div>
			<div class="flex space-x-3 pt-4">
				<button type="button" onclick="closePasswordModal()"
					class="flex-1 py-3 text-[10px] font-black uppercase text-gray-400 hover:text-gray-600 transition-colors">Hủy
					bỏ</button>
				<button type="submit"
					class="flex-[2] bg-gray-800 text-white py-3 rounded-2xl text-[10px] font-black uppercase hover:bg-black transition-all shadow-lg active:scale-95">Cập
					nhật ngay</button>
			</div>
		</form>
	</div>
</div>

<script>
	//Tự động hiển thị thông báo từ Server (Flash Attributes) khi trang load lại
	document.addEventListener('DOMContentLoaded', function() {
	    // Kiểm tra thông báo thành công
	    <c:if test="${not empty message}">
	        Swal.fire({
	            icon: 'success',
	            title: 'Thành công!',
	            text: '${message}',
	            timer: 3000,
	            showConfirmButton: false,
	            customClass: {
	                popup: 'rounded-[30px]'
	            }
	        });
	    </c:if>
	
	    // Kiểm tra thông báo lỗi (nếu có)
	    <c:if test="${not empty error}">
	        Swal.fire({
	            icon: 'error',
	            title: 'Thất bại!',
	            text: '${error}',
	            customClass: {
	                popup: 'rounded-[30px]'
	            }
	        });
	    </c:if>
	});

    // 1. Hàm xem trước ảnh ngay lập tức (Preview)
	function previewAvatar(input) {
	    if (input.files && input.files[0]) {
	        const file = input.files[0];
	        
	        // Kiểm tra dung lượng (800x804 thường nhẹ, nhưng cứ để 2MB cho chắc)
	        if (file.size > 2 * 1024 * 1024) {
	            Swal.fire('Lỗi', 'Dung lượng ảnh quá lớn (>2MB)', 'error');
	            input.value = "";
	            return;
	        }
	
	        const reader = new FileReader();
	        reader.onload = function(e) {
	            const previewContainer = document.getElementById('avatarPreview');
	            // QUAN TRỌNG: Xóa sạch nội dung cũ (chữ cái hoặc ảnh cũ) trước khi chèn ảnh mới
	            previewContainer.innerHTML = ''; 
	            
	            const img = document.createElement('img');
	            img.src = e.target.result;
	            img.className = "w-full h-full object-cover animate-fade-in";
	            previewContainer.appendChild(img);
	        };
	        reader.readAsDataURL(file);
	    }
	}

    // 2. Các biến và hàm xử lý Form
    const emailInput = document.getElementById('inputEmail');
    const currentEmail = emailInput ? emailInput.getAttribute('data-current') : '';

    function validateAndSubmit() {
        const newEmail = emailInput.value;
        if (newEmail !== currentEmail) {
            Swal.fire({ title: 'Đang gửi mã xác thực...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });
            fetch('/customer/profile/send-otp?newEmail=' + encodeURIComponent(newEmail), { method: 'POST' })
            .then(response => {
                Swal.close();
                if (response.ok) {
                    document.getElementById('otpModal').classList.remove('hidden');
                } else {
                    response.text().then(text => Swal.fire('Thông báo', text, 'error'));
                }
            })
            .catch(() => Swal.fire('Lỗi', 'Không thể kết nối máy chủ', 'error'));
        } else {
        	// Hiện hiệu ứng Loading trước khi submit form chính
            Swal.fire({
                title: 'Đang lưu thay đổi...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            document.getElementById('profileForm').submit();
        }
    }

    function confirmOtp() {
        const otp = document.getElementById('otpInput').value;
        if (otp.length === 6) {
            document.getElementById('hiddenOtp').value = otp;
            document.getElementById('profileForm').submit();
        } else {
            Swal.fire('Chú ý', 'Vui lòng nhập đủ 6 số OTP', 'warning');
        }
    }

    function closeOtpModal() { document.getElementById('otpModal').classList.add('hidden'); }
    function openPasswordModal() { document.getElementById('passwordModal').classList.remove('hidden'); }
    function closePasswordModal() { document.getElementById('passwordModal').classList.add('hidden'); }

    // 3. Hợp nhất window.onclick (QUAN TRỌNG: Chỉ khai báo 1 lần duy nhất)
    window.onclick = function(event) {
        const otpModal = document.getElementById('otpModal');
        const passModal = document.getElementById('passwordModal');
        if (event.target == otpModal) closeOtpModal();
        if (event.target == passModal) closePasswordModal();
    };
    
 	// 4. Hỗ trợ nhập liệu thông tin ngân hàng
    const bankNameInput = document.getElementById('bankAccountName');
    const bankNumberInput = document.getElementById('bankAccountNumber');

    if (bankNameInput) {
        bankNameInput.addEventListener('input', function() {
            // Tự động viết hoa toàn bộ tên chủ tài khoản
            this.value = this.value.toUpperCase();
        });
    }

    if (bankNumberInput) {
        bankNumberInput.addEventListener('input', function() {
            // Loại bỏ mọi ký tự không phải là số
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
</script>