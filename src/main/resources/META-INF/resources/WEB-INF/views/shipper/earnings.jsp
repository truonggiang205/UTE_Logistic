<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %> <%@
taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">
      <i class="fas fa-wallet text-info"></i> Thu nhập của tôi
    </h1>
  </div>

  <div class="row mb-4">
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card bg-success text-white shadow h-100">
        <div class="card-body">
          <div class="text-uppercase mb-1 small font-weight-bold">
            Thu nhập tháng này
          </div>
          <div class="h4 mb-0 font-weight-bold">
            <fmt:formatNumber
              value="${monthlyEarnings != null ? monthlyEarnings : 0}"
              type="currency"
              currencySymbol=""
              maxFractionDigits="0" />đ
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card bg-info text-white shadow h-100">
        <div class="card-body">
          <div class="text-uppercase mb-1 small font-weight-bold">
            Số đơn đã giao
          </div>
          <div class="h4 mb-0 font-weight-bold">
            ${monthlyOrders != null ? monthlyOrders : 0}
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card bg-warning text-white shadow h-100">
        <div class="card-body">
          <div class="text-uppercase mb-1 small font-weight-bold">
            Phí/đơn trung bình
          </div>
          <div class="h4 mb-0 font-weight-bold">
            <fmt:formatNumber
              value="${averagePerOrder != null ? averagePerOrder : 0}"
              type="currency"
              currencySymbol=""
              maxFractionDigits="0" />đ
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="card bg-primary text-white shadow h-100">
        <div class="card-body">
          <div class="text-uppercase mb-1 small font-weight-bold">
            Bonus đạt được
          </div>
          <div class="h4 mb-0 font-weight-bold">
            <fmt:formatNumber
              value="${bonusAmount != null ? bonusAmount : 0}"
              type="currency"
              currencySymbol=""
              maxFractionDigits="0" />đ
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-8">
      <div class="card shadow mb-4">
        <div class="card-header py-3">
          <h6 class="m-0 font-weight-bold text-success">
            <i class="fas fa-chart-line"></i> Biểu đồ thu nhập
          </h6>
        </div>
        <div class="card-body">
          <div class="chart-area" style="height: 300px">
            <canvas id="earningsChart"></canvas>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="card shadow mb-4">
        <div class="card-header py-3 bg-success text-white">
          <h6 class="m-0 font-weight-bold">Hiệu suất làm việc</h6>
        </div>
        <div class="card-body text-center">
          <h4 class="text-success">
            ${successRate != null ? successRate : 0}%
          </h4>
          <p class="text-muted">Tỷ lệ giao thành công</p>
          <div class="progress" style="height: 20px">
            <div
              class="progress-bar bg-success"
              style="width: ${successRate != null ? successRate : 0}%"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    var ctx = document.getElementById("earningsChart").getContext("2d");
    new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["Tuần 1", "Tuần 2", "Tuần 3", "Tuần 4"],
        datasets: [
          {
            label: "Thu nhập",
            data: [500000, 750000, 600000, 800000],
            backgroundColor: "#1cc88a",
          },
        ],
      },
      options: { maintainAspectRatio: false },
    });
  });
</script>
