<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán thất bại - NGHV</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-50 min-h-screen flex items-center justify-center p-6">
    <div class="max-w-md w-full bg-white rounded-[40px] shadow-2xl overflow-hidden border border-orange-50">
        <div class="bg-gradient-to-br from-[#F26522] to-[#d44d15] p-10 text-center text-white">
            <div class="w-20 h-20 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center mx-auto mb-4 border border-white/30">
                <i class="fa-solid fa-xmark text-4xl"></i>
            </div>
            <h1 class="text-xl font-black uppercase tracking-widest">Tạo đơn thất bại</h1>
        </div>

        <div class="p-8 text-center space-y-6">
            <p class="text-gray-500 text-sm font-medium leading-relaxed">Quá trình thanh toán không thành công. Vui lòng kiểm tra lại số dư tài khoản hoặc thay đổi phương thức thanh toán.</p>
            
            <div class="bg-orange-50 rounded-2xl p-4 text-[10px] font-black text-orange-600 uppercase tracking-widest">
                Mã lỗi hệ thống: ${responseCode}
            </div>

            <button onclick="window.location.href='/customer/create-order'" 
                class="w-full bg-[#F26522] text-white py-4 rounded-2xl font-black uppercase text-[11px] shadow-lg shadow-orange-100 hover:scale-[1.02] transition-all active:scale-95">
                Quay lại trang tạo đơn
            </button>
        </div>
    </div>
</body>
</html>