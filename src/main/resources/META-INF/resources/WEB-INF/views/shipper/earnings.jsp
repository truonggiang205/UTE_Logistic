<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
  <!-- Page Header -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-wallet text-success"></i> Thu nhập của tôi
    </h1>
    <div class="btn-group" role="group">
      <button
        type="button"
        class="btn btn-outline-primary btn-sm active"
        onclick="filterPeriod('week')">
        Tuần này
      </button>
      <button
        type="button"
        class="btn btn-outline-primary btn-sm"
        onclick="filterPeriod('month')">
        Tháng này
      </button>
      <button
        type="button"
        class="btn btn-outline-primary btn-sm"
        onclick="filterPeriod('all')">
        Tất cả
      </button>
    </div>
  </div>

  <!-- Summary Cards -->
  <div class="row mb-4">
    <!-- Thu nhập hôm nay -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-success text-uppercase mb-1">
                Thu nhập hôm nay
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${earnings.todayEarnings != null ? earnings.todayEarnings : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </div>
              <div class="text-xs text-muted mt-1">
                <i class="fas fa-box"></i> ${earnings.todayOrders != null ?
                earnings.todayOrders : 0} đơn
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-calendar-day fa-2x text-success"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Thu nhập tuần này -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-info shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-info text-uppercase mb-1">
                Thu nhập tuần này
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${earnings.weeklyEarnings != null ? earnings.weeklyEarnings : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </div>
              <div class="text-xs text-muted mt-1">
                <i class="fas fa-box"></i> ${earnings.weeklyOrders != null ?
                earnings.weeklyOrders : 0} đơn
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-calendar-week fa-2x text-info"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Thu nhập tháng này -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                Thu nhập tháng này
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${earnings.monthlyEarnings != null ? earnings.monthlyEarnings : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </div>
              <div class="text-xs text-muted mt-1">
                <i class="fas fa-box"></i> ${earnings.monthlyOrders != null ?
                earnings.monthlyOrders : 0} đơn
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-calendar-alt fa-2x text-primary"></i>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bonus -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card border-left-warning shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div
                class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                Bonus tháng này
              </div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">
                <fmt:formatNumber
                  value="${earnings.bonusAmount != null ? earnings.bonusAmount : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </div>
              <div class="text-xs text-muted mt-1">
                <c:choose>
                  <c:when test="${earnings.monthlyOrders >= 20}">
                    <span class="text-success"
                      ><i class="fas fa-check-circle"></i> Đã đạt bonus!</span
                    >
                  </c:when>
                  <c:otherwise>
                    <i class="fas fa-info-circle"></i> Còn ${20 -
                    (earnings.monthlyOrders != null ? earnings.monthlyOrders :
                    0)} đơn nữa
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
            <div class="col-auto">
              <i class="fas fa-gift fa-2x text-warning"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <!-- Biểu đồ thu nhập 7 ngày -->
    <div class="col-xl-8 col-lg-7">
      <div class="card shadow mb-4">
        <div
          class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">
            <i class="fas fa-chart-line"></i> Thu nhập 7 ngày gần đây
          </h6>
        </div>
        <div class="card-body">
          <div class="chart-area" style="height: 280px">
            <canvas id="earningsChart"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- Thống kê hiệu suất -->
    <div class="col-xl-4 col-lg-5">
      <div class="card shadow mb-4">
        <div class="card-header py-3 bg-success text-white">
          <h6 class="m-0 font-weight-bold">
            <i class="fas fa-chart-pie"></i> Hiệu suất làm việc
          </h6>
        </div>
        <div class="card-body">
          <!-- Tỷ lệ thành công -->
          <div class="text-center mb-4">
            <div class="h2 font-weight-bold text-success mb-0">
              <fmt:formatNumber
                value="${earnings.successRate != null ? earnings.successRate : 0}"
                maxFractionDigits="0" />%
            </div>
            <div class="text-muted small">Tỷ lệ giao thành công</div>
            <div class="progress mt-2" style="height: 10px">
              <div
                class="progress-bar bg-success"
                role="progressbar"
                style="width: ${earnings.successRate != null ? earnings.successRate : 0}%"></div>
            </div>
          </div>

          <hr />

          <!-- Thống kê khác -->
          <div class="mb-3">
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-muted">Phí trung bình/đơn</span>
              <strong class="text-primary">
                <fmt:formatNumber
                  value="${earnings.averagePerOrder != null ? earnings.averagePerOrder : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </strong>
            </div>
          </div>
          <div class="mb-3">
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-muted">Tổng đơn đã giao</span>
              <strong class="text-info"
                >${earnings.totalOrders != null ? earnings.totalOrders : 0}
                đơn</strong
              >
            </div>
          </div>
          <div>
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-muted">Tổng thu nhập</span>
              <strong class="text-success">
                <fmt:formatNumber
                  value="${earnings.totalEarnings != null ? earnings.totalEarnings : 0}"
                  type="currency"
                  currencySymbol=""
                  maxFractionDigits="0" />đ
              </strong>
            </div>
          </div>
        </div>
      </div>

      <!-- Cách tính thu nhập -->
      <div class="card shadow mb-4 border-left-info">
        <div class="card-body">
          <div class="text-xs font-weight-bold text-info text-uppercase mb-2">
            <i class="fas fa-info-circle"></i> Cách tính thu nhập
          </div>
          <p class="mb-1 small">
            • Mỗi đơn giao hàng: <strong>13,000đ</strong>
          </p>
          <p class="mb-1 small text-muted">
            • Đơn lấy hàng: <em>Không tính phí</em>
          </p>
          <p class="mb-1 small">
            • Bonus: <strong>50,000đ</strong> khi giao ≥20 đơn/tháng
          </p>
          <p class="mb-0 small text-muted">
            Thu nhập được thanh toán vào cuối tháng
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- Lịch sử giao dịch gần đây -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">
        <i class="fas fa-history"></i> Lịch sử giao dịch gần đây
      </h6>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-hover" id="historyTable">
          <thead class="thead-light">
            <tr>
              <th>Mã đơn</th>
              <th>Loại</th>
              <th>Khách hàng</th>
              <th>Thời gian</th>
              <th class="text-right">Thu nhập</th>
              <th class="text-center">Trạng thái</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty earnings.recentHistory}">
                <tr>
                  <td colspan="6" class="text-center text-muted py-4">
                    <i class="fas fa-inbox fa-2x mb-2"></i>
                    <p class="mb-0">Chưa có giao dịch nào</p>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach items="${earnings.recentHistory}" var="item">
                  <tr>
                    <td>
                      <a
                        href="${pageContext.request.contextPath}/shipper/order/${item.taskId}/detail"
                        class="font-weight-bold text-primary">
                        ${item.trackingNumber}
                      </a>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${item.taskType == 'pickup'}">
                          <span class="badge badge-info">Lấy hàng</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-success">Giao hàng</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${item.customerName}</td>
                    <td>
                      <small class="text-muted">${item.completedAt}</small>
                    </td>
                    <td class="text-right font-weight-bold text-success">
                      +<fmt:formatNumber
                        value="${item.amount}"
                        type="currency"
                        currencySymbol=""
                        maxFractionDigits="0" />đ
                    </td>
                    <td class="text-center">
                      <span class="badge badge-success">
                        <i class="fas fa-check"></i> Hoàn thành
                      </span>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Chart.js -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    var ctx = document.getElementById("earningsChart").getContext("2d");

    // Dữ liệu từ server
    var chartLabels = [
      <c:forEach items="${earnings.chartLabels}" var="label" varStatus="loop">
        "${label}"<c:if test="${!loop.last}">,</c:if>
      </c:forEach>,
    ];

    var chartData = [
      <c:forEach items="${earnings.chartData}" var="data" varStatus="loop">
        ${data}
        <c:if test="${!loop.last}">,</c:if>
      </c:forEach>,
    ];

    // Nếu không có dữ liệu, tạo dữ liệu mẫu
    if (chartLabels.length === 0) {
      chartLabels = [
        "24/12",
        "25/12",
        "26/12",
        "27/12",
        "28/12",
        "29/12",
        "30/12",
      ];
      chartData = [0, 0, 0, 0, 0, 0, 0];
    }

    new Chart(ctx, {
      type: "bar",
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: "Thu nhập (đ)",
            data: chartData,
            backgroundColor: "rgba(28, 200, 138, 0.7)",
            borderColor: "rgba(28, 200, 138, 1)",
            borderWidth: 1,
            borderRadius: 5,
            barThickness: 30,
          },
        ],
      },
      options: {
        maintainAspectRatio: false,
        responsive: true,
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            callbacks: {
              label: function (context) {
                return new Intl.NumberFormat("vi-VN").format(context.raw) + "đ";
              },
            },
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function (value) {
                if (value >= 1000) {
                  return value / 1000 + "k";
                }
                return value;
              },
            },
          },
        },
      },
    });
  });

  function filterPeriod(period) {
    // TODO: Implement filter by period
    console.log("Filter by:", period);
  }
</script>

<style>
  .border-left-success {
    border-left: 4px solid #1cc88a !important;
  }
  .border-left-info {
    border-left: 4px solid #36b9cc !important;
  }
  .border-left-primary {
    border-left: 4px solid #4e73df !important;
  }
  .border-left-warning {
    border-left: 4px solid #f6c23e !important;
  }
</style>
