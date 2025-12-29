<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<sitemesh:page title="Admin Dashboard"/>

<meta http-equiv="refresh" content="300" />

<div class="d-flex justify-content-between align-items-center mb-3">
  <h3 class="mb-0">Tổng quan (Dashboard)</h3>
  <form class="d-flex gap-2" method="get" action="/admin">
    <select class="form-select form-select-sm" name="range">
      <option value="7d">7 ngày</option>
      <option value="30d">30 ngày</option>
    </select>
    <select class="form-select form-select-sm" name="hub">
      <option value="">Tất cả Hub</option>
    </select>
    <button class="btn btn-sm btn-outline-secondary" type="submit">Lọc</button>
  </form>
</div>

<div class="row g-3 mb-3">
  <div class="col-md-3">
    <div class="card">
      <div class="card-body">
        <div class="text-muted small">Đơn mới</div>
        <div class="fs-4 fw-semibold">0</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card">
      <div class="card-body">
        <div class="text-muted small">Đơn hoàn thành</div>
        <div class="fs-4 fw-semibold">0</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card">
      <div class="card-body">
        <div class="text-muted small">Doanh thu</div>
        <div class="fs-4 fw-semibold">0</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card">
      <div class="card-body">
        <div class="text-muted small">Sự cố (Kẹt/Hủy)</div>
        <div class="fs-4 fw-semibold">0</div>
      </div>
    </div>
  </div>
</div>

<div class="row g-3">
  <div class="col-lg-8">
    <div class="card">
      <div class="card-body">
        <h5 class="card-title mb-3">Doanh thu 7 ngày gần nhất</h5>
        <div class="text-muted">(Placeholder chart theo mô tả — sẽ nối dữ liệu sau)</div>
      </div>
    </div>
  </div>
  <div class="col-lg-4">
    <div class="card mb-3">
      <div class="card-body">
        <h6 class="card-title">Top Hub hiệu quả nhất</h6>
        <ol class="mb-0 text-muted">
          <li>—</li>
          <li>—</li>
          <li>—</li>
        </ol>
      </div>
    </div>
    <div class="card">
      <div class="card-body">
        <h6 class="card-title">Top Shipper hiệu quả nhất</h6>
        <ol class="mb-0 text-muted">
          <li>—</li>
          <li>—</li>
          <li>—</li>
        </ol>
      </div>
    </div>
  </div>
</div>
