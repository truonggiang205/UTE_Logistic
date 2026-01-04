<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="w-full space-y-6 animate-fade-in">
    <div class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm">
        <form action="/customer/orders" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-6 items-end">
            <div class="space-y-2">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-2">Mã đơn hàng</label>
                <div class="relative">
                    <input type="number" name="orderId" value="${selectedId}" placeholder="VD: 104" 
                           class="w-full pl-10 pr-4 py-3 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F] transition-all">
                    <i class="fa-solid fa-hashtag absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 text-[10px]"></i>
                </div>
            </div>

            <div class="space-y-2">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-2">Trạng thái đơn</label>
                <select name="status" class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-[#00B14F] appearance-none cursor-pointer">
                    <option value="">Tất cả trạng thái</option>
                    <c:forEach items="${statuses}" var="s">
                        <option value="${s}" ${s == selectedStatus ? 'selected' : ''}>${s}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="space-y-2">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-2">Thời gian tạo đơn</label>
                <div class="flex items-center space-x-2">
                    <input type="date" name="fromDate" value="${fromDate}" class="w-full px-3 py-3 bg-gray-50 border-none rounded-2xl text-[10px] font-bold focus:ring-2 focus:ring-[#00B14F]">
                    <span class="text-gray-300">-</span>
                    <input type="date" name="toDate" value="${toDate}" class="w-full px-3 py-3 bg-gray-50 border-none rounded-2xl text-[10px] font-bold focus:ring-2 focus:ring-[#00B14F]">
                </div>
            </div>

            <div class="flex space-x-2">
                <button type="submit" class="flex-1 bg-gray-800 text-white py-3 rounded-2xl text-xs font-black hover:bg-black transition-all shadow-lg shadow-gray-200">
                    <i class="fa-solid fa-magnifying-glass mr-2"></i> LỌC ĐƠN
                </button>
                <a href="/customer/orders" class="p-3 bg-gray-100 text-gray-500 rounded-2xl hover:bg-gray-200 transition-all">
                    <i class="fa-solid fa-rotate-left"></i>
                </a>
            </div>
        </form>
    </div>

    <div class="bg-white rounded-[32px] border border-gray-100 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50/50">
                    <tr class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                        <th class="px-8 py-5">Thông tin đơn</th>
                        <th class="px-8 py-5">Người nhận & Địa chỉ</th>
                        <th class="px-8 py-5">Trạng thái</th>
                        <th class="px-8 py-5 text-right">Tài chính</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    <c:forEach items="${orders}" var="order">
                        <tr class="group hover:bg-gray-50/30 transition-all duration-300">
                            <td class="px-8 py-6">
                                <div class="flex flex-col">
                                    <span class="text-sm font-black text-gray-800">#${order.requestId}</span>
                                    <span class="text-[10px] font-bold text-[#00B14F] uppercase mt-0.5">${order.serviceType.serviceName}</span>
                                    <span class="text-[10px] text-gray-300 italic mt-2">${order.formattedCreatedAt}</span>
                                </div>
                            </td>

                            <td class="px-8 py-6">
                                <div class="flex flex-col max-w-[250px]">
                                    <p class="text-xs font-black text-gray-700">${order.deliveryAddress.contactName}</p>
                                    <p class="text-[10px] text-gray-400 font-bold">${order.deliveryAddress.contactPhone}</p>
                                    <p class="text-[10px] text-gray-400 truncate mt-1" title="${order.deliveryAddress.addressDetail}">
                                        <i class="fa-solid fa-location-dot mr-1"></i>${order.deliveryAddress.addressDetail}
                                    </p>
                                </div>
                            </td>

                            <td class="px-8 py-6">
                                <span class="px-3 py-1.5 rounded-full text-[9px] font-black uppercase tracking-wider shadow-sm
                                    ${order.status == 'delivered' ? 'bg-green-100 text-green-600' : 
                                      order.status == 'failed' ? 'bg-red-100 text-red-600' : 
                                      order.status == 'pending' ? 'bg-blue-100 text-blue-600' : 'bg-orange-100 text-orange-600'}">
                                    ${order.status}
                                </span>
                            </td>

                            <td class="px-8 py-6 text-right">
                                <div class="flex flex-col">
                                    <span class="text-xs font-black text-gray-800"><fmt:formatNumber value="${order.totalPrice}" /> đ</span>
                                    <span class="text-[10px] text-gray-400 font-bold mt-1">COD: <fmt:formatNumber value="${order.codAmount}" /> đ</span>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="4" class="py-24 text-center">
                                <div class="flex flex-col items-center">
                                    <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mb-4">
                                        <i class="fa-solid fa-box-open text-3xl text-gray-200"></i>
                                    </div>
                                    <p class="text-xs font-black text-gray-300 uppercase tracking-widest">Không tìm thấy đơn hàng nào</p>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    @keyframes fade-in { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    .animate-fade-in { animation: fade-in 0.5s ease-out forwards; }
</style>