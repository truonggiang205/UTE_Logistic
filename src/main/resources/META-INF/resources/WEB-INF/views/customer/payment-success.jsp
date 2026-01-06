<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh toán thành công - NGHV Logistics</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap"
      rel="stylesheet" />
    <style>
      body {
        font-family: "Inter", sans-serif;
      }
    </style>
  </head>
  <body class="bg-slate-100 min-h-screen flex items-center justify-center p-4">
    <div
      class="max-w-md w-full bg-white rounded-[40px] shadow-2xl overflow-hidden border border-green-100">
      <div class="bg-[#00B14F] p-10 text-center text-white relative">
        <div
          class="w-20 h-20 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center mx-auto mb-4 border border-white/30">
          <i class="fa-solid fa-check text-4xl"></i>
        </div>
        <h1 class="text-xl font-black uppercase tracking-widest">
          Thanh toán thành công
        </h1>
      </div>

      <div class="p-8 space-y-6">
        <div class="text-center">
          <p
            class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">
            Số tiền đã quyết toán
          </p>
          <p class="text-3xl font-black text-gray-800 tracking-tighter">
            <fmt:formatNumber value="${amount}" type="number" />đ
          </p>
        </div>

        <div
          class="bg-slate-50 rounded-3xl p-6 space-y-4 border-2 border-dashed border-slate-200">
          <div class="flex justify-between items-center text-xs">
            <span class="text-gray-400 font-bold uppercase">Mã đơn hàng</span>
            <span class="text-gray-800 font-black">${orderId}</span>
          </div>
          <div class="flex justify-between items-center text-xs">
            <span class="text-gray-400 font-bold uppercase">Ngân hàng</span>
            <span class="text-gray-800 font-bold">${bankCode}</span>
          </div>
        </div>

        <button
          onclick="window.location.href='http://localhost:9090/customer/orders'"
          class="w-full bg-[#00B14F] text-white py-4 rounded-2xl font-black uppercase text-[11px] shadow-lg shadow-green-100 hover:scale-[1.02] transition-all">
          Về danh sách đơn hàng
        </button>
      </div>
    </div>
  </body>
</html>
