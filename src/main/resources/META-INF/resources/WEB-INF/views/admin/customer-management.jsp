<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <div>
      <h1 class="h3 mb-0 text-gray-800">Quản lý khách hàng</h1>
      <div class="small text-muted">
        Xem thông tin khách hàng và địa chỉ của họ.
      </div>
    </div>
  </div>

  <!-- Filter Section -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Bộ lọc</h6>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-3">
          <label class="small font-weight-bold">Trạng thái</label>
          <select
            class="form-control"
            id="filterStatus"
            onchange="loadCustomers()">
            <option value="">-- Tất cả --</option>
            <option value="active">Hoạt động</option>
            <option value="inactive">Không hoạt động</option>
          </select>
        </div>
        <div class="col-md-7">
          <label class="small font-weight-bold">Tìm kiếm</label>
          <input
            type="text"
            class="form-control"
            id="filterKeyword"
            placeholder="Nhập tên, email, SĐT hoặc username..."
            onkeyup="debounceSearch()" />
        </div>
        <div class="col-md-2 d-flex align-items-end">
          <button class="btn btn-secondary btn-block" onclick="resetFilters()">
            <i class="fas fa-redo"></i> Đặt lại
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Data Table -->
  <div class="card shadow mb-4">
    <div
      class="card-header py-3 d-flex justify-content-between align-items-center">
      <h6 class="m-0 font-weight-bold text-primary">Danh sách khách hàng</h6>
      <span class="badge badge-info" id="totalCount">0 khách hàng</span>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table
          class="table table-bordered table-hover"
          width="100%"
          cellspacing="0">
          <thead class="bg-light">
            <tr>
              <th style="width: 60px">ID</th>
              <th style="width: 120px">Username</th>
              <th>Họ tên</th>
              <th>Email</th>
              <th style="width: 120px">SĐT</th>
              <th style="width: 100px">Loại KH</th>
              <th style="width: 100px">Trạng thái</th>
              <th style="width: 90px">Hành động</th>
            </tr>
          </thead>
          <tbody id="customerTableBody">
            <tr>
              <td colspan="8" class="text-center">Đang tải dữ liệu...</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- Pagination -->
      <nav>
        <ul class="pagination justify-content-center mb-0" id="pagination"></ul>
      </nav>
    </div>
  </div>
</div>

<!-- Modal Xem Chi tiết Customer + Địa chỉ -->
<div
  class="modal fade"
  id="detailModal"
  tabindex="-1"
  role="dialog"
  aria-hidden="true">
  <div class="modal-dialog modal-xl" role="document">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">
          <i class="fas fa-user"></i> Chi tiết khách hàng
        </h5>
        <button
          class="close text-white"
          type="button"
          data-dismiss="modal"
          aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="row">
          <!-- Thông tin User -->
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header py-2 bg-light">
                <h6 class="m-0 font-weight-bold text-primary">
                  <i class="fas fa-id-card"></i> Thông tin tài khoản
                </h6>
              </div>
              <div class="card-body">
                <table class="table table-sm mb-0">
                  <tr>
                    <td class="font-weight-bold" style="width: 40%">User ID</td>
                    <td id="detailUserId">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Username</td>
                    <td id="detailUsername">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Email (User)</td>
                    <td id="detailUserEmail">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">SĐT (User)</td>
                    <td id="detailUserPhone">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Trạng thái User</td>
                    <td id="detailUserStatus">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Đăng nhập gần nhất</td>
                    <td id="detailLastLogin">-</td>
                  </tr>
                </table>
              </div>
            </div>
          </div>

          <!-- Thông tin Customer -->
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header py-2 bg-light">
                <h6 class="m-0 font-weight-bold text-success">
                  <i class="fas fa-user-tag"></i> Thông tin khách hàng
                </h6>
              </div>
              <div class="card-body">
                <table class="table table-sm mb-0">
                  <tr>
                    <td class="font-weight-bold" style="width: 40%">
                      Customer ID
                    </td>
                    <td id="detailCustomerId">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Họ tên</td>
                    <td id="detailFullName">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Loại KH</td>
                    <td id="detailCustomerType">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Tên doanh nghiệp</td>
                    <td id="detailBusinessName">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Email</td>
                    <td id="detailEmail">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">SĐT</td>
                    <td id="detailPhone">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Mã số thuế</td>
                    <td id="detailTaxCode">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Trạng thái</td>
                    <td id="detailStatus">-</td>
                  </tr>
                  <tr>
                    <td class="font-weight-bold">Ngày tạo</td>
                    <td id="detailCreatedAt">-</td>
                  </tr>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Danh sách địa chỉ -->
        <div class="card">
          <div
            class="card-header py-2 bg-light d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-info">
              <i class="fas fa-map-marker-alt"></i> Danh sách địa chỉ
            </h6>
            <span class="badge badge-info" id="addressCount">0 địa chỉ</span>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-sm table-hover mb-0">
                <thead class="bg-light">
                  <tr>
                    <th style="width: 40px">ID</th>
                    <th style="width: 120px">Người liên hệ</th>
                    <th style="width: 110px">SĐT liên hệ</th>
                    <th>Địa chỉ đầy đủ</th>
                    <th style="width: 80px">Mặc định</th>
                    <th style="width: 100px">Ghi chú</th>
                  </tr>
                </thead>
                <tbody id="addressTableBody">
                  <tr>
                    <td colspan="6" class="text-center text-muted">
                      Không có địa chỉ
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" type="button" data-dismiss="modal">
          Đóng
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  var API_BASE = window.location.origin + "/api/admin/customers";
  var currentPage = 0;
  var pageSize = 10;
  var debounceTimer;

  // Load data on page ready
  document.addEventListener("DOMContentLoaded", function () {
    loadCustomers();
  });

  function loadCustomers() {
    var status = document.getElementById("filterStatus").value;
    var keyword = document.getElementById("filterKeyword").value;

    var url = API_BASE + "?page=" + currentPage + "&size=" + pageSize;
    if (status) url += "&status=" + status;
    if (keyword) url += "&keyword=" + encodeURIComponent(keyword);

    fetch(url)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          renderTable(response.data.content);
          renderPagination(response.data);
          document.getElementById("totalCount").innerText =
            response.data.totalElements + " khách hàng";
        } else {
          document.getElementById("customerTableBody").innerHTML =
            '<tr><td colspan="8" class="text-center text-danger">Lỗi tải dữ liệu</td></tr>';
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        document.getElementById("customerTableBody").innerHTML =
          '<tr><td colspan="8" class="text-center text-danger">Lỗi kết nối server</td></tr>';
      });
  }

  function renderTable(items) {
    if (!items || items.length === 0) {
      document.getElementById("customerTableBody").innerHTML =
        '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < items.length; i++) {
      var c = items[i];
      var statusBadge = getStatusBadge(c.status);
      var typeBadge = getTypeBadge(c.customerType);

      var actionBtns =
        '<button class="btn btn-sm btn-primary" onclick="viewDetail(' +
        c.customerId +
        ')" title="Xem chi tiết">' +
        '<i class="fas fa-eye"></i></button>';

      html +=
        "<tr>" +
        "<td>" +
        c.customerId +
        "</td>" +
        "<td>" +
        escapeHtml(c.username || "-") +
        "</td>" +
        "<td><strong>" +
        escapeHtml(c.fullName || c.businessName || "-") +
        "</strong></td>" +
        "<td>" +
        escapeHtml(c.email || "-") +
        "</td>" +
        "<td>" +
        escapeHtml(c.phone || "-") +
        "</td>" +
        "<td>" +
        typeBadge +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        "<td>" +
        actionBtns +
        "</td>" +
        "</tr>";
    }
    document.getElementById("customerTableBody").innerHTML = html;
  }

  function getStatusBadge(status) {
    switch (status) {
      case "active":
        return '<span class="badge badge-success">Hoạt động</span>';
      case "inactive":
        return '<span class="badge badge-secondary">Không HĐ</span>';
      default:
        return '<span class="badge badge-light">' + (status || "-") + "</span>";
    }
  }

  function getTypeBadge(type) {
    switch (type) {
      case "individual":
        return '<span class="badge badge-info">Cá nhân</span>';
      case "business":
        return '<span class="badge badge-warning">Doanh nghiệp</span>';
      default:
        return '<span class="badge badge-light">' + (type || "-") + "</span>";
    }
  }

  function escapeHtml(text) {
    if (!text) return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
  }

  function formatDateTime(value) {
    if (!value) return "-";
    try {
      var d = new Date(value);
      if (isNaN(d.getTime())) return value;
      return d.toLocaleString("vi-VN");
    } catch (e) {
      return value;
    }
  }

  function renderPagination(pageData) {
    var html = "";
    var totalPages = pageData.totalPages;

    if (totalPages <= 1) {
      document.getElementById("pagination").innerHTML = "";
      return;
    }

    html +=
      '<li class="page-item ' +
      (pageData.first ? "disabled" : "") +
      '">' +
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage - 1) +
      ')">Trước</a></li>';

    for (var i = 0; i < totalPages; i++) {
      if (i === currentPage) {
        html +=
          '<li class="page-item active"><a class="page-link" href="javascript:void(0)">' +
          (i + 1) +
          "</a></li>";
      } else if (
        Math.abs(i - currentPage) <= 2 ||
        i === 0 ||
        i === totalPages - 1
      ) {
        html +=
          '<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
          i +
          ')">' +
          (i + 1) +
          "</a></li>";
      } else if (Math.abs(i - currentPage) === 3) {
        html +=
          '<li class="page-item disabled"><a class="page-link">...</a></li>';
      }
    }

    html +=
      '<li class="page-item ' +
      (pageData.last ? "disabled" : "") +
      '">' +
      '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' +
      (currentPage + 1) +
      ')">Sau</a></li>';

    document.getElementById("pagination").innerHTML = html;
  }

  function goToPage(page) {
    currentPage = page;
    loadCustomers();
  }

  function debounceSearch() {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(function () {
      currentPage = 0;
      loadCustomers();
    }, 500);
  }

  function resetFilters() {
    document.getElementById("filterStatus").value = "";
    document.getElementById("filterKeyword").value = "";
    currentPage = 0;
    loadCustomers();
  }

  function viewDetail(customerId) {
    fetch(API_BASE + "/" + customerId)
      .then(function (res) {
        return res.json();
      })
      .then(function (response) {
        if (response.success && response.data) {
          var c = response.data;

          // User info
          document.getElementById("detailUserId").innerText = c.userId || "-";
          document.getElementById("detailUsername").innerText =
            c.username || "-";
          document.getElementById("detailUserEmail").innerText =
            c.userEmail || "-";
          document.getElementById("detailUserPhone").innerText =
            c.userPhone || "-";
          document.getElementById("detailUserStatus").innerHTML = c.userStatus
            ? getStatusBadge(c.userStatus)
            : "-";
          document.getElementById("detailLastLogin").innerText = formatDateTime(
            c.lastLoginAt
          );

          // Customer info
          document.getElementById("detailCustomerId").innerText =
            c.customerId || "-";
          document.getElementById("detailFullName").innerText =
            c.fullName || "-";
          document.getElementById("detailCustomerType").innerHTML =
            getTypeBadge(c.customerType);
          document.getElementById("detailBusinessName").innerText =
            c.businessName || "-";
          document.getElementById("detailEmail").innerText = c.email || "-";
          document.getElementById("detailPhone").innerText = c.phone || "-";
          document.getElementById("detailTaxCode").innerText = c.taxCode || "-";
          document.getElementById("detailStatus").innerHTML = getStatusBadge(
            c.status
          );
          document.getElementById("detailCreatedAt").innerText = formatDateTime(
            c.createdAt
          );

          // Addresses
          renderAddresses(c.addresses || []);

          $("#detailModal").modal("show");
        } else {
          showToast("error", response.message || "Không thể tải thông tin");
        }
      })
      .catch(function (err) {
        console.error("Error:", err);
        showToast("error", "Lỗi kết nối server");
      });
  }

  function renderAddresses(addresses) {
    document.getElementById("addressCount").innerText =
      addresses.length + " địa chỉ";

    if (!addresses || addresses.length === 0) {
      document.getElementById("addressTableBody").innerHTML =
        '<tr><td colspan="6" class="text-center text-muted">Không có địa chỉ</td></tr>';
      return;
    }

    var html = "";
    for (var i = 0; i < addresses.length; i++) {
      var addr = addresses[i];
      var defaultBadge = addr.isDefault
        ? '<span class="badge badge-success">Mặc định</span>'
        : "";

      html +=
        "<tr" +
        (addr.isDefault ? ' class="table-success"' : "") +
        ">" +
        "<td>" +
        addr.addressId +
        "</td>" +
        "<td>" +
        escapeHtml(addr.contactName || "-") +
        "</td>" +
        "<td>" +
        escapeHtml(addr.contactPhone || "-") +
        "</td>" +
        "<td><small>" +
        escapeHtml(addr.fullAddress || "-") +
        "</small></td>" +
        "<td>" +
        defaultBadge +
        "</td>" +
        "<td><small>" +
        escapeHtml(addr.note || "-") +
        "</small></td>" +
        "</tr>";
    }
    document.getElementById("addressTableBody").innerHTML = html;
  }

  function showToast(type, message) {
    var bgClass = type === "success" ? "bg-success" : "bg-danger";
    var toast = document.createElement("div");
    toast.className = "toast-notification " + bgClass;
    toast.innerHTML =
      '<i class="fas fa-' +
      (type === "success" ? "check" : "times") +
      '-circle mr-2"></i>' +
      message;
    toast.style.cssText =
      "position:fixed;top:20px;right:20px;padding:15px 25px;color:white;border-radius:5px;z-index:9999;animation:slideIn 0.3s ease;";
    document.body.appendChild(toast);
    setTimeout(function () {
      toast.remove();
    }, 3000);
  }
</script>

<style>
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
</style>
