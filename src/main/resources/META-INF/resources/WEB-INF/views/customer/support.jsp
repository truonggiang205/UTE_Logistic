<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="w-full space-y-8 animate-fade-in">
	<div
		class="flex flex-col md:flex-row md:items-center justify-between gap-6">
		<div>
			<h2
				class="text-xl font-black text-gray-800 uppercase tracking-tighter">Trung
				tâm hỗ trợ</h2>
			<p class="text-[11px] text-gray-400 font-medium">Giải quyết khiếu
				nại và tra cứu quy định nghiệp vụ</p>
		</div>
		<div class="flex bg-gray-100 p-1.5 rounded-[20px]">
			<button onclick="switchTab('faq')" id="btn-faq"
				class="px-8 py-2.5 text-[10px] font-black uppercase rounded-2xl transition-all bg-white shadow-sm text-gray-800">Quy
				định NGHV</button>
			<button onclick="switchTab('ticket')" id="btn-ticket"
				class="px-8 py-2.5 text-[10px] font-black uppercase rounded-2xl transition-all text-gray-400">Gửi
				khiếu nại</button>
		</div>
	</div>

	<div id="section-faq" class="space-y-6 animate-fade-in">
		<div
			class="bg-white p-8 rounded-[40px] border border-gray-100 shadow-sm relative overflow-hidden">
			<div class="absolute top-0 right-0 p-6 opacity-10">
				<i class="fa-solid fa-file-shield text-8xl"></i>
			</div>

			<div class="relative z-10">
				<div class="flex items-center space-x-3 mb-6">
					<span class="w-1.5 h-6 bg-red-500 rounded-full"></span>
					<h3
						class="text-sm font-black text-gray-800 uppercase tracking-widest">Quy
						định an toàn & Kiểm soát hàng hóa</h3>
				</div>

				<p class="text-[11px] text-gray-400 mb-8 italic">Căn cứ theo
					Luật Bưu chính và quy định an ninh vận tải hàng không/đường bộ hiện
					hành.</p>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
					<div class="space-y-4">
						<div class="flex items-center space-x-2 text-red-600">
							<i class="fa-solid fa-ban text-xs"></i> <span
								class="text-[10px] font-black uppercase tracking-wider">Cấm
								vận chuyển tuyệt đối</span>
						</div>
						<div class="space-y-2">
							<div
								class="p-4 bg-red-50/50 rounded-2xl border border-red-100/50 text-[11px] text-gray-600 leading-relaxed">
								<ul class="list-disc pl-4 space-y-2 font-medium">
									<li>Chất ma túy, chất kích thích thần kinh, tiền chất.</li>
									<li>Vũ khí đạn dược, trang thiết bị kỹ thuật quân sự
										(súng, đao, kiếm...).</li>
									<li>Vật liệu nổ, chất dễ cháy, kíp nổ, pháo hoa.</li>
									<li>Văn hóa phẩm đồi trụy, tài liệu phản động, phá hoại
										trật tự công cộng.</li>
									<li>Sinh vật sống, động vật hoang dã quý hiếm.</li>
								</ul>
							</div>
						</div>
					</div>

					<div class="space-y-4">
						<div class="flex items-center space-x-2 text-orange-500">
							<i class="fa-solid fa-circle-exclamation text-xs"></i> <span
								class="text-[10px] font-black uppercase tracking-wider">Vận
								chuyển có điều kiện (Cần khai báo)</span>
						</div>
						<div class="space-y-2">
							<div
								class="p-4 bg-orange-50/50 rounded-2xl border border-orange-100/50 text-[11px] text-gray-600 leading-relaxed">
								<ul class="list-disc pl-4 space-y-2 font-medium">
									<li>Chất lỏng, hóa chất (Cần bảng chỉ dẫn an toàn hóa chất
										MSDS).</li>
									<li>Hàng điện tử chứa pin, nam châm (Chỉ đi đường bộ).</li>
									<li>Thực phẩm tươi sống, hàng đông lạnh (Cần đóng gói
										chuyên dụng).</li>
									<li>Vàng bạc, đá quý, tiền tệ, các loại giấy tờ có giá trị
										như tiền.</li>
									<li>Mỹ phẩm dạng xịt, bình nén khí.</li>
								</ul>
							</div>
						</div>
					</div>
				</div>

				<div class="mt-8 pt-6 border-t border-gray-50">
					<div class="flex items-start space-x-4">
						<div
							class="w-10 h-10 bg-gray-50 rounded-full flex items-center justify-center flex-shrink-0">
							<i class="fa-solid fa-gavel text-gray-400 text-xs"></i>
						</div>
						<div class="space-y-1">
							<p class="text-[10px] font-black text-gray-800 uppercase">Trách
								nhiệm người gửi (Shop)</p>
							<p class="text-[10px] text-gray-400 font-medium">Người gửi
								chịu hoàn toàn trách nhiệm trước pháp luật nếu cố tình gửi hàng
								cấm. Hệ thống có quyền từ chối phục vụ và bàn giao tang vật cho
								cơ quan chức năng khi phát hiện vi phạm.</p>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div
			class="bg-[#00B14F] p-8 rounded-[40px] text-white shadow-lg shadow-green-100 relative overflow-hidden">
			<i
				class="fa-solid fa-box-archive absolute -right-4 -bottom-4 text-8xl opacity-10 rotate-12"></i>
			<h4 class="text-xs font-black uppercase tracking-widest mb-4">Hướng
				dẫn đóng gói NGHV</h4>
			<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
				<div class="space-y-2">
					<p class="text-[10px] font-black opacity-80 uppercase">Hàng dễ
						vỡ</p>
					<p class="text-[10px] leading-relaxed">Quấn tối thiểu 3 lớp xốp
						khí, chèn kín các khe hở trong thùng carton.</p>
				</div>
				<div class="space-y-2">
					<p class="text-[10px] font-black opacity-80 uppercase">Hàng
						chất lỏng</p>
					<p class="text-[10px] leading-relaxed">Bọc kín miệng bằng
						nilon, để đứng sản phẩm và có nhãn cảnh báo hướng quay lên.</p>
				</div>
				<div class="space-y-2">
					<p class="text-[10px] font-black opacity-80 uppercase">Hàng
						điện tử</p>
					<p class="text-[10px] leading-relaxed">Sử dụng màng bọc nilon
						chống ẩm và chống tĩnh điện trước khi đóng hộp.</p>
				</div>
			</div>
		</div>
	</div>

	<div id="section-ticket" class="hidden animate-fade-in space-y-6">
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

			<div class="lg:col-span-2 space-y-6">
				<div
					class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm">
					<p
						class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4 ml-2">Gợi
						ý khiếu nại nhanh</p>
					<div class="flex flex-wrap gap-2">
						<button
							onclick="applySuggestion('Giao hàng chậm', 'Đơn hàng của tôi đã quá hạn giao dự kiến nhưng vẫn chưa nhận được. Vui lòng kiểm tra lộ trình.')"
							class="px-4 py-2 bg-gray-50 text-[10px] font-bold text-gray-600 rounded-full hover:bg-[#00B14F] hover:text-white transition-all">🕒
							Giao chậm</button>
						<button
							onclick="applySuggestion('Hàng hóa hư hỏng', 'Khi nhận hàng tôi phát hiện kiện hàng bị móp méo và sản phẩm bên trong bị vỡ. Cần hỗ trợ bồi thường.')"
							class="px-4 py-2 bg-gray-50 text-[10px] font-bold text-gray-600 rounded-full hover:bg-red-500 hover:text-white transition-all">📦
							Hàng hỏng</button>
						<button
							onclick="applySuggestion('Sai tiền thu hộ (COD)', 'Số tiền Shipper thu của khách không khớp với số tiền tôi đã ghi trên đơn hàng. Vui lòng đối soát lại.')"
							class="px-4 py-2 bg-gray-50 text-[10px] font-bold text-gray-600 rounded-full hover:bg-orange-500 hover:text-white transition-all">💰
							Sai tiền COD</button>
					</div>
				</div>

				<form action="/customer/support/ticket/add" method="POST"
					class="bg-white p-10 rounded-[40px] border border-gray-100 shadow-sm space-y-6">
					<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Đơn
								hàng liên quan</label> <select name="requestId" required
								class="w-full px-4 py-3.5 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]">
								<c:forEach items="${orders}" var="o">
									<option value="${o.requestId}">#${o.requestId} -
										${o.status}</option>
								</c:forEach>
							</select>
						</div>
						<div class="space-y-2">
							<label
								class="text-[10px] font-black text-gray-400 uppercase ml-2">Chủ
								đề khiếu nại</label> <input type="text" id="ticketSubject"
								name="subject" required
								class="w-full px-4 py-3.5 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]">
						</div>
					</div>
					<div class="space-y-2">
						<label class="text-[10px] font-black text-gray-400 uppercase ml-2">Nội
							dung chi tiết</label>
						<textarea id="ticketMessage" name="message" rows="5" required
							class="w-full px-4 py-3.5 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F]"></textarea>
					</div>
					<button type="submit"
						class="w-full bg-gray-800 text-white py-4 rounded-2xl text-xs font-black uppercase hover:bg-black transition-all shadow-lg shadow-gray-200">
						<i class="fa-solid fa-paper-plane mr-2"></i> Gửi yêu cầu hỗ trợ
						ngay
					</button>
				</form>
			</div>

			<div class="space-y-4">
				<p
					class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-2">Yêu
					cầu đã gửi (${myTickets.size()})</p>
				<div
					class="space-y-4 overflow-y-auto max-h-[650px] pr-2 custom-scrollbar">
					<c:forEach items="${myTickets}" var="t">
						<div
							class="bg-white p-6 rounded-[32px] border border-gray-50 shadow-sm hover:border-[#00B14F]/30 transition-all group">
							<div class="flex justify-between items-start mb-3">
								<span
									class="text-[8px] font-black uppercase px-2 py-1 rounded-lg 
                                    ${t.status == 'pending' ? 'bg-orange-100 text-orange-600' : 
                                      t.status == 'processing' ? 'bg-blue-100 text-blue-600' : 'bg-green-100 text-green-600'}">
									${t.status} </span> <span class="text-[8px] text-gray-300 font-bold">${t.createdAt}</span>
							</div>
							<h4
								class="text-xs font-black text-gray-800 uppercase leading-tight group-hover:text-[#00B14F] transition-colors">${t.subject}</h4>
							<p
								class="text-[10px] text-gray-400 mt-2 line-clamp-2 italic border-l-2 border-gray-100 pl-3">${t.message}</p>
							<div
								class="mt-4 pt-4 border-t border-gray-50 flex items-center text-[9px] font-black text-gray-400">
								<i class="fa-solid fa-box mr-1.5 opacity-50"></i> ĐƠN
								#${t.serviceRequest.requestId}
							</div>
						</div>
					</c:forEach>
					<c:if test="${empty myTickets}">
						<div
							class="bg-gray-50 border-2 border-dashed border-gray-100 p-10 rounded-[32px] text-center">
							<i
								class="fa-solid fa-comment-slash text-2xl text-gray-200 mb-3 block"></i>
							<span class="text-[10px] font-black text-gray-300 uppercase">Chưa
								có khiếu nại nào</span>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
    function switchTab(tab) {
        document.getElementById('section-faq').classList.add('hidden');
        document.getElementById('section-ticket').classList.add('hidden');
        
        const buttons = ['btn-faq', 'btn-ticket'];
        buttons.forEach(b => {
            document.getElementById(b).classList.remove('bg-white', 'shadow-sm', 'text-gray-800');
            document.getElementById(b).classList.add('text-gray-400');
        });

        document.getElementById('section-' + tab).classList.remove('hidden');
        document.getElementById('btn-' + tab).classList.add('bg-white', 'shadow-sm', 'text-gray-800');
        document.getElementById('btn-' + tab).classList.remove('text-gray-400');
    }

    function applySuggestion(subject, message) {
        document.getElementById('ticketSubject').value = subject;
        document.getElementById('ticketMessage').value = message;
        // Hiệu ứng focus để người dùng nhận biết
        document.getElementById('ticketSubject').classList.add('ring-2', 'ring-[#00B14F]');
        setTimeout(() => {
            document.getElementById('ticketSubject').classList.remove('ring-2', 'ring-[#00B14F]');
        }, 1000);
    }
</script>