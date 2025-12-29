<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div class="bg-dark text-white h-100">
  <div class="p-3 border-bottom border-secondary">
    <div class="fw-semibold">Menu</div>
    <div class="small text-secondary">Admin Console</div>
  </div>

  <div class="accordion accordion-flush" id="adminSidebarAccordion">

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingDashboard">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDashboard">
          <i class="bi bi-speedometer2 me-2"></i>Tổng quan
        </button>
      </h2>
      <div id="collapseDashboard" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin">Dashboard</a>
          </div>
        </div>
      </div>
    </div>

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingNetwork">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseNetwork">
          <i class="bi bi-diagram-3 me-2"></i>Quản trị Mạng lưới
        </button>
      </h2>
      <div id="collapseNetwork" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/hubs">Quản lý Hub (Bưu cục)</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/routes">Quản lý Tuyến đường (Routes)</a>
          </div>
        </div>
      </div>
    </div>

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingFinance">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFinance">
          <i class="bi bi-cash-coin me-2"></i>Tài chính & Dịch vụ
        </button>
      </h2>
      <div id="collapseFinance" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/finance/services">Cấu hình Dịch vụ & Giá</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/finance/vnpay">Tra soát VNPay</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/finance/cod">Quản lý thu hộ (COD)</a>
          </div>
        </div>
      </div>
    </div>

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingIam">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseIam">
          <i class="bi bi-people me-2"></i>Người dùng & Phân quyền
        </button>
      </h2>
      <div id="collapseIam" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/users">Quản lý Người dùng (All Users)</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/roles">Định nghĩa Role (RBAC)</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/broadcast-email">Broadcast / Gửi thông báo Email</a>
          </div>
        </div>
      </div>
    </div>

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingMonitoring">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseMonitoring">
          <i class="bi bi-activity me-2"></i>Giám sát & Báo cáo
        </button>
      </h2>
      <div id="collapseMonitoring" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/monitoring/center">Trung tâm Giám sát</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/monitoring/risk-alerts">Cảnh báo rủi ro</a>
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/reporting">Xuất báo cáo</a>
          </div>
        </div>
      </div>
    </div>

    <div class="accordion-item bg-dark">
      <h2 class="accordion-header" id="headingConfig">
        <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseConfig">
          <i class="bi bi-gear me-2"></i>Cấu hình hệ thống
        </button>
      </h2>
      <div id="collapseConfig" class="accordion-collapse collapse" data-bs-parent="#adminSidebarAccordion">
        <div class="accordion-body py-2">
          <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action bg-dark text-white" href="/admin/action-types">Quản lý trạng thái đơn (Master Data)</a>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>
