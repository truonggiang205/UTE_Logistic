<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="w-full space-y-8 animate-fade-in">
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <div
      class="bg-gradient-to-br from-[#00B14F] to-[#008f3f] p-8 rounded-[32px] text-white shadow-xl shadow-green-100 relative overflow-hidden group">
      <div class="relative z-10">
        <p class="text-[10px] font-black uppercase tracking-[2px] opacity-80">
          Tiền COD đang giữ hộ
        </p>
        <h2 class="text-4xl font-black mt-3">
          <fmt:formatNumber value="${codHolding}" type="number" />
          <span class="text-lg font-bold">đ</span>
        </h2>
        <div
          class="mt-6 flex items-center space-x-2 bg-white/10 w-fit px-3 py-1.5 rounded-full backdrop-blur-md">
          <i class="fa-solid fa-clock-rotate-left text-[10px]"></i>
          <span class="text-[10px] font-bold">Chờ đối soát kỳ tới</span>
        </div>
      </div>
      <i
        class="fa-solid fa-vault absolute -right-4 -bottom-4 text-8xl opacity-10 rotate-12 group-hover:scale-110 transition-transform duration-500"></i>
    </div>

    <div
      class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm flex flex-col justify-between">
      <div>
        <p
          class="text-[10px] text-gray-400 font-black uppercase tracking-[2px]">
          Số lượng giao dịch
        </p>
        <h2 class="text-3xl font-black text-gray-800 mt-2">
          ${history.size()}
        </h2>
      </div>
      <p class="text-[11px] text-gray-400 font-medium mt-4">
        Bao gồm thu hộ và thanh toán phí
      </p>
    </div>
  </div>

  <div
    class="bg-white rounded-[32px] border border-gray-100 shadow-sm overflow-hidden">
    <div
      class="p-8 border-b border-gray-50 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h3 class="text-sm font-black text-gray-800 uppercase tracking-[2px]">
          Biến động dòng tiền
        </h3>
        <p class="text-[11px] text-gray-400 font-medium mt-1">
          Chi tiết các khoản thu/chi gắn liền với đơn hàng
        </p>
      </div>

      <div class="flex items-center space-x-3">
        <div class="relative">
          <input
            type="text"
            id="txnSearchInput"
            placeholder="Tìm mã đơn..."
            class="pl-10 pr-4 py-2.5 bg-gray-50 border-none rounded-xl text-xs font-bold focus:ring-2 focus:ring-green-500 w-48 transition-all" />
          <i
            class="fa-solid fa-magnifying-glass absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 text-[10px]"></i>
        </div>
        <button
          class="p-2.5 bg-gray-50 text-gray-500 rounded-xl hover:bg-gray-100 transition-all">
          <i class="fa-solid fa-filter text-xs"></i>
        </button>
      </div>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full text-left border-collapse">
        <thead class="bg-gray-50/50">
          <tr
            class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
            <th class="px-8 py-5">Thời gian</th>
            <th class="px-8 py-5">Nghiệp vụ</th>
            <th class="px-8 py-5">Trạng thái</th>
            <th class="px-8 py-5 text-right">Số tiền</th>
          </tr>
        </thead>
        <tbody id="txnTableBody" class="divide-y divide-gray-50">
          <c:forEach items="${history}" var="item">
            <tr class="group hover:bg-gray-50/50 transition-all duration-300">
              <td class="px-8 py-6 text-[11px] font-bold text-gray-400">
                ${item.transactionDate}
              </td>

              <td class="px-8 py-6">
                <div class="flex flex-col">
                  <span
                    class="text-xs font-black text-gray-800 uppercase tracking-tight"
                    >${item.transactionType}</span
                  >
                  <span class="text-[10px] text-gray-400 mt-1 font-bold"
                    >Mã đơn:
                    <span class="text-blue-500 font-black"
                      >${item.orderId}</span
                    ></span
                  >
                </div>
              </td>

              <td class="px-8 py-6">
                <span
                  class="inline-flex items-center px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-tighter shadow-sm ${item.status == 'success' || item.status == 'settled' || item.status == 'Completed' ? 'bg-green-100 text-green-600' : item.status == 'failed' ? 'bg-red-100 text-red-600' : 'bg-orange-100 text-orange-600'}">
                  <i
                    class="fa-solid fa-circle text-[4px] mr-1.5 opacity-60"></i>
                  ${item.status}
                </span>
              </td>

              <td class="px-8 py-6 text-right">
                <span
                  class="text-sm font-black ${item.flowType == 'IN' ? 'text-[#00B14F]' : 'text-red-500'}">
                  ${item.flowType == 'IN' ? '+' : '-'}
                  <fmt:formatNumber value="${item.amount}" type="number" /> đ
                </span>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty history}">
            <tr>
              <td colspan="4" class="py-24 text-center">
                <div class="flex flex-col items-center">
                  <div
                    class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mb-4">
                    <i class="fa-solid fa-receipt text-3xl text-gray-200"></i>
                  </div>
                  <p
                    class="text-xs font-black text-gray-300 uppercase tracking-widest">
                    Không tìm thấy dữ liệu giao dịch
                  </p>
                </div>
              </td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <div class="p-6 bg-gray-50/30 border-t border-gray-50 flex justify-center">
      <nav class="flex items-center space-x-2">
        <button
          class="w-8 h-8 flex items-center justify-center rounded-lg bg-white border border-gray-100 text-gray-400 hover:text-green-500 transition-colors shadow-sm">
          <i class="fa-solid fa-chevron-left text-[10px]"></i>
        </button>
        <button
          class="w-8 h-8 flex items-center justify-center rounded-lg bg-[#00B14F] text-white text-[10px] font-black shadow-lg shadow-green-100">
          1
        </button>
        <button
          class="w-8 h-8 flex items-center justify-center rounded-lg bg-white border border-gray-100 text-gray-400 hover:text-green-500 transition-colors shadow-sm text-[10px] font-black">
          2
        </button>
        <button
          class="w-8 h-8 flex items-center justify-center rounded-lg bg-white border border-gray-100 text-gray-400 hover:text-green-500 transition-colors shadow-sm">
          <i class="fa-solid fa-chevron-right text-[10px]"></i>
        </button>
      </nav>
    </div>
  </div>
</div>

<style>
  @keyframes fade-in {
    from {
      opacity: 0;
      transform: translateY(10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  .animate-fade-in {
    animation: fade-in 0.5s ease-out forwards;
  }
</style>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("txnSearchInput");
    const tableBody = document.getElementById("txnTableBody");
    const rows = tableBody.getElementsByTagName("tr");

    // ===== 1. LOGIC TÌM KIẾM THEO MÃ ĐƠN =====
    searchInput.addEventListener("keyup", function () {
      const filter = searchInput.value.toLowerCase();
      let visibleCount = 0;

      for (let i = 0; i < rows.length; i++) {
        // Lấy cột chứa mã đơn (Cột thứ 2, index 1)
        const orderIdCell = rows[i].getElementsByTagName("td")[1];
        if (orderIdCell) {
          const textValue = orderIdCell.textContent || orderIdCell.innerText;
          if (textValue.toLowerCase().indexOf(filter) > -1) {
            rows[i].style.display = "";
            visibleCount++;
          } else {
            rows[i].style.display = "none";
          }
        }
      }
    });

    // ===== 2. LOGIC PHÂN TRANG ĐƠN GIẢN (CLIENT-SIDE) =====
    const rowsPerPage = 5; // Số dòng mỗi trang
    let currentPage = 1;

    function showPage(page) {
      const start = (page - 1) * rowsPerPage;
      const end = start + rowsPerPage;

      for (let i = 0; i < rows.length; i++) {
        if (i >= start && i < end) {
          rows[i].style.display = "";
        } else {
          rows[i].style.display = "none";
        }
      }
    }

    // Gắn sự kiện cho các nút chuyển trang trong giao diện của bạn
    const pageButtons = document.querySelectorAll("nav button");
    pageButtons.forEach((btn, index) => {
      btn.addEventListener("click", function () {
        // Logic đơn giản: nút số 1 (index 1), nút số 2 (index 2)
        if (index === 1) showPage(1);
        if (index === 2) showPage(2);

        // Cập nhật giao diện nút Active
        pageButtons.forEach((b) =>
          b.classList.remove("bg-[#00B14F]", "text-white")
        );
        btn.classList.add("bg-[#00B14F]", "text-white");
      });
    });

    // Khởi tạo trang đầu tiên
    if (rows.length > 0) showPage(1);
  });
</script>
