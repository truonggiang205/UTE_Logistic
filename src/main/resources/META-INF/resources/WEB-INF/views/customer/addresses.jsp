<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%>

<div class="w-full space-y-6 animate-fade-in">
  <!-- Header -->
  <div class="flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-black text-gray-800">Quản lý Địa chỉ</h1>
      <p class="text-sm text-gray-400">
        Danh sách địa chỉ gửi/nhận hàng của bạn
      </p>
    </div>
    <button
      onclick="openAddModal()"
      class="bg-[#00B14F] text-white px-6 py-3 rounded-2xl text-sm font-bold hover:bg-green-600 transition-all shadow-lg shadow-green-200">
      <i class="fa-solid fa-plus mr-2"></i>Thêm địa chỉ
    </button>
  </div>

  <!-- Alert Messages -->
  <c:if test="${not empty message}">
    <div
      class="bg-green-50 border border-green-200 text-green-700 px-6 py-4 rounded-2xl text-sm font-medium">
      <i class="fa-solid fa-check-circle mr-2"></i>${message}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div
      class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-2xl text-sm font-medium">
      <i class="fa-solid fa-exclamation-circle mr-2"></i>${error}
    </div>
  </c:if>

  <!-- Addresses Grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:forEach items="${addresses}" var="addr">
      <div
        class="bg-white rounded-[24px] border border-gray-100 shadow-sm p-6 relative group hover:shadow-lg transition-all duration-300">
        <!-- Default Badge -->
        <c:if test="${addr.isDefault}">
          <span
            class="absolute top-4 right-4 bg-[#00B14F] text-white text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-wider">
            Mặc định
          </span>
        </c:if>

        <!-- Contact Info -->
        <div class="mb-4">
          <h3 class="text-lg font-black text-gray-800">${addr.contactName}</h3>
          <p class="text-sm text-gray-500 font-medium">${addr.contactPhone}</p>
        </div>

        <!-- Address -->
        <div class="text-sm text-gray-600 mb-6">
          <p class="font-medium">${addr.addressDetail}</p>
          <p class="text-gray-400">${addr.ward}, ${addr.district}</p>
          <p class="text-gray-400">${addr.province}</p>
        </div>

        <!-- Actions -->
        <div class="flex items-center gap-2 pt-4 border-t border-gray-100">
          <c:if test="${!addr.isDefault}">
            <form
              action="/customer/addresses/set-default/${addr.addressId}"
              method="post"
              class="inline">
              <button
                type="submit"
                class="text-[#00B14F] hover:bg-green-50 px-3 py-2 rounded-xl text-xs font-bold transition-all">
                <i class="fa-solid fa-star mr-1"></i>Đặt mặc định
              </button>
            </form>
          </c:if>
          <button
            onclick="openEditModal('${addr.addressId}', '${addr.contactName}', '${addr.contactPhone}', '${addr.addressDetail}', '${addr.ward}', '${addr.district}', '${addr.province}')"
            class="text-blue-500 hover:bg-blue-50 px-3 py-2 rounded-xl text-xs font-bold transition-all">
            <i class="fa-solid fa-pen mr-1"></i>Sửa
          </button>
          <c:if test="${!addr.isDefault}">
            <form
              action="/customer/addresses/delete/${addr.addressId}"
              method="post"
              class="inline"
              onsubmit="return confirm('Xác nhận xóa địa chỉ này?')">
              <button
                type="submit"
                class="text-red-500 hover:bg-red-50 px-3 py-2 rounded-xl text-xs font-bold transition-all">
                <i class="fa-solid fa-trash mr-1"></i>Xóa
              </button>
            </form>
          </c:if>
        </div>
      </div>
    </c:forEach>

    <!-- Empty State -->
    <c:if test="${empty addresses}">
      <div class="col-span-full py-16 text-center">
        <div
          class="w-24 h-24 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6">
          <i class="fa-solid fa-location-dot text-4xl text-gray-200"></i>
        </div>
        <p class="text-gray-400 font-bold text-sm">Bạn chưa có địa chỉ nào</p>
        <button
          onclick="openAddModal()"
          class="mt-4 text-[#00B14F] font-bold text-sm">
          <i class="fa-solid fa-plus mr-1"></i>Thêm địa chỉ đầu tiên
        </button>
      </div>
    </c:if>
  </div>
</div>

<!-- Add Modal -->
<div
  id="addModal"
  class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
  <div class="bg-white rounded-[32px] w-full max-w-lg mx-4 p-8">
    <h2 class="text-xl font-black text-gray-800 mb-6">Thêm địa chỉ mới</h2>
    <form action="/customer/addresses/add" method="post" class="space-y-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Họ tên</label
          >
          <input
            type="text"
            name="contactName"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Số điện thoại</label
          >
          <input
            type="text"
            name="contactPhone"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
      </div>
      <div>
        <label class="text-xs font-bold text-gray-500 block mb-2"
          >Địa chỉ chi tiết</label
        >
        <input
          type="text"
          name="addressDetail"
          required
          class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
      </div>
      <div class="grid grid-cols-3 gap-4">
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Phường/Xã</label
          >
          <input
            type="text"
            name="ward"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Quận/Huyện</label
          >
          <input
            type="text"
            name="district"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Tỉnh/Thành phố</label
          >
          <input
            type="text"
            name="province"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
      </div>
      <div class="flex gap-4 pt-4">
        <button
          type="button"
          onclick="closeAddModal()"
          class="flex-1 bg-gray-100 text-gray-600 py-3 rounded-2xl font-bold">
          Hủy
        </button>
        <button
          type="submit"
          class="flex-1 bg-[#00B14F] text-white py-3 rounded-2xl font-bold hover:bg-green-600">
          Thêm địa chỉ
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Edit Modal -->
<div
  id="editModal"
  class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
  <div class="bg-white rounded-[32px] w-full max-w-lg mx-4 p-8">
    <h2 class="text-xl font-black text-gray-800 mb-6">Sửa địa chỉ</h2>
    <form id="editForm" method="post" class="space-y-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Họ tên</label
          >
          <input
            type="text"
            id="editContactName"
            name="contactName"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Số điện thoại</label
          >
          <input
            type="text"
            id="editContactPhone"
            name="contactPhone"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
      </div>
      <div>
        <label class="text-xs font-bold text-gray-500 block mb-2"
          >Địa chỉ chi tiết</label
        >
        <input
          type="text"
          id="editAddressDetail"
          name="addressDetail"
          required
          class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
      </div>
      <div class="grid grid-cols-3 gap-4">
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Phường/Xã</label
          >
          <input
            type="text"
            id="editWard"
            name="ward"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Quận/Huyện</label
          >
          <input
            type="text"
            id="editDistrict"
            name="district"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
        <div>
          <label class="text-xs font-bold text-gray-500 block mb-2"
            >Tỉnh/Thành phố</label
          >
          <input
            type="text"
            id="editProvince"
            name="province"
            required
            class="w-full px-4 py-3 bg-gray-50 border-none rounded-2xl text-sm focus:ring-2 focus:ring-[#00B14F]" />
        </div>
      </div>
      <div class="flex gap-4 pt-4">
        <button
          type="button"
          onclick="closeEditModal()"
          class="flex-1 bg-gray-100 text-gray-600 py-3 rounded-2xl font-bold">
          Hủy
        </button>
        <button
          type="submit"
          class="flex-1 bg-blue-500 text-white py-3 rounded-2xl font-bold hover:bg-blue-600">
          Lưu thay đổi
        </button>
      </div>
    </form>
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
  function openAddModal() {
    document.getElementById("addModal").classList.remove("hidden");
    document.getElementById("addModal").classList.add("flex");
  }

  function closeAddModal() {
    document.getElementById("addModal").classList.add("hidden");
    document.getElementById("addModal").classList.remove("flex");
  }

  function openEditModal(id, name, phone, detail, ward, district, province) {
    document.getElementById("editForm").action =
      "/customer/addresses/update/" + id;
    document.getElementById("editContactName").value = name;
    document.getElementById("editContactPhone").value = phone;
    document.getElementById("editAddressDetail").value = detail;
    document.getElementById("editWard").value = ward;
    document.getElementById("editDistrict").value = district;
    document.getElementById("editProvince").value = province;
    document.getElementById("editModal").classList.remove("hidden");
    document.getElementById("editModal").classList.add("flex");
  }

  function closeEditModal() {
    document.getElementById("editModal").classList.add("hidden");
    document.getElementById("editModal").classList.remove("flex");
  }
</script>
