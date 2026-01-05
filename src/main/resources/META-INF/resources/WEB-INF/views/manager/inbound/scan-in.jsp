<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .scan-landing-header {
    background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
    padding: 22px;
    border-radius: 14px;
    color: #fff;
    margin-bottom: 18px;
  }
  .scan-card {
    background: #fff;
    border-radius: 14px;
    box-shadow: 0 5px 18px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 18px;
  }
  .scan-card .card-header {
    background: #f8f9fc;
    border-bottom: 1px solid #e3e6f0;
  }
  .scan-input {
    height: 56px;
    font-size: 1.15rem;
    font-weight: 700;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    border-radius: 10px;
  }
  .hint {
    color: #858796;
    font-size: 0.9rem;
  }
  .result-panel {
    margin-top: 12px;
    padding: 12px 14px;
    border-radius: 10px;
    display: none;
    border: 1px solid transparent;
  }
  .result-panel.success {
    background: #d4edda;
    border-color: #c3e6cb;
    color: #155724;
  }
  .result-panel.error {
    background: #f8d7da;
    border-color: #f5c6cb;
    color: #721c24;
  }
  .quick-links .btn {
    border-radius: 12px;
    padding: 14px 16px;
    font-weight: 700;
  }
</style>

<div class="scan-landing-header">
  <div class="d-flex justify-content-between align-items-center">
    <div>
      <h4 class="mb-1"><i class="fas fa-barcode mr-2"></i>Quét nhập kho</h4>
      <div class="opacity-75">Quét mã vận đơn để nhập kho theo đúng luồng</div>
    </div>
    <div>
      <span class="badge badge-light p-2" id="currentHubInfo">
        <i class="fas fa-building mr-1"></i>Đang tải...
      </span>
    </div>
  </div>
</div>

<div class="row">
  <div class="col-lg-8">
    <div class="scan-card">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-qrcode mr-2"></i>Nhập mã / Quét barcode</h6>
      </div>
      <div class="card-body">
        <form id="scanInboundForm" onsubmit="return submitScan(event)">
          <div class="form-row">
            <div class="form-group col-md-5">
              <label class="small text-muted mb-1">Luồng nhập kho</label>
              <select class="form-control" id="inboundFlow" required>
                <option value="hub-in">Nhập từ xe tải (Hub)</option>
                <option value="shipper-in">Shipper bàn giao</option>
              </select>
            </div>
            <div class="form-group col-md-7">
              <label class="small text-muted mb-1">Loại hành động</label>
              <select class="form-control" id="actionTypeId" required>
                <option value="">-- Chọn loại hành động --</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <input type="text" class="form-control scan-input" id="trackingCode" placeholder="QUÉT HOẶC NHẬP MÃ VẬN ĐƠN" autocomplete="off" autofocus />
            <div class="hint mt-2"><i class="fas fa-info-circle mr-1"></i>Nhấn Enter để xác nhận nhanh.</div>
          </div>

          <button type="submit" class="btn btn-primary btn-lg btn-block">
            <i class="fas fa-check-circle mr-1"></i>Xác nhận nhập kho
          </button>
        </form>

        <div id="resultPanel" class="result-panel"></div>

        <div id="orderDetail" class="mt-3" style="display:none;">
          <div class="alert alert-info mb-0">
            <div class="font-weight-bold mb-1"><i class="fas fa-box mr-1"></i>Chi tiết đơn vừa quét</div>
            <div><span class="text-muted">Mã vận đơn:</span> <strong id="detailTrackingCode">-</strong></div>
            <div><span class="text-muted">Trạng thái:</span> <strong id="detailStatus">-</strong></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="scan-card">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-bolt mr-2"></i>Đi nhanh</h6>
      </div>
      <div class="card-body quick-links">
        <a class="btn btn-success btn-block mb-2" href="<c:url value='/manager/inbound/hub-in' />">
          <i class="fas fa-truck-loading mr-1"></i>Nhập từ xe tải (Hub)
        </a>
        <a class="btn btn-danger btn-block mb-2" href="<c:url value='/manager/inbound/shipper-in' />">
          <i class="fas fa-motorcycle mr-1"></i>Shipper bàn giao
        </a>
        <a class="btn btn-warning btn-block" href="<c:url value='/manager/inbound/drop-off' />">
          <i class="fas fa-store mr-1"></i>Tạo đơn tại quầy
        </a>
      </div>
    </div>
  </div>
</div>

<script>
  (function () {
    var contextPath = "${pageContext.request.contextPath}";
    var currentHubId = null;
    var currentManagerId = null;

    function showResult(type, message) {
      var panel = document.getElementById("resultPanel");
      panel.className = "result-panel " + type;
      panel.style.display = "block";
      panel.innerHTML = message;
    }

    function setOrderDetail(orderDto, trackingCodeFallback) {
      var detail = document.getElementById("orderDetail");
      var codeEl = document.getElementById("detailTrackingCode");
      var statusEl = document.getElementById("detailStatus");
      codeEl.textContent = (orderDto && orderDto.trackingCode) ? orderDto.trackingCode : (trackingCodeFallback || "-");
      statusEl.textContent = (orderDto && orderDto.status) ? orderDto.status : "-";
      detail.style.display = "block";
    }

    function initJQueryReady() {
      if (typeof jQuery === "undefined") {
        setTimeout(initJQueryReady, 50);
        return;
      }

      // load action types
      $.get(contextPath + "/api/manager/inbound/action-types", function (response) {
        var select = $("#actionTypeId");
        select.empty().append('<option value="">-- Chọn loại hành động --</option>');
        (response || []).forEach(function (at) {
          select.append('<option value="' + at.actionTypeId + '">' + (at.description || at.actionCode) + '</option>');
        });
      });

      // load current user
      $.get(contextPath + "/api/manager/current-user", function (response) {
        currentManagerId = response && response.userId;
        currentHubId = response && response.hubId;
        if (currentHubId) {
          $("#currentHubInfo").html('<i class="fas fa-building mr-1"></i>Hub ID: ' + currentHubId);
        } else {
          $("#currentHubInfo").html('<i class="fas fa-building mr-1"></i>Hub: N/A');
        }
      }).fail(function () {
        $("#currentHubInfo").html('<i class="fas fa-building mr-1"></i>Không lấy được thông tin hub');
      });

      window.submitScan = function (event) {
        event.preventDefault();

        var trackingCode = $("#trackingCode").val().trim();
        var actionTypeId = $("#actionTypeId").val();
        var inboundFlow = $("#inboundFlow").val();

        $("#orderDetail").hide();

        if (!trackingCode) {
          showResult("error", "Vui lòng nhập mã vận đơn.");
          return false;
        }
        if (!actionTypeId) {
          showResult("error", "Vui lòng chọn loại hành động.");
          return false;
        }
        if (!currentHubId || !currentManagerId) {
          showResult("error", "Không lấy được thông tin người dùng/hub. Vui lòng tải lại trang.");
          return false;
        }

        var url = (inboundFlow === "shipper-in")
          ? (contextPath + "/api/manager/inbound/shipper-in")
          : (contextPath + "/api/manager/inbound/hub-in");

        $.ajax({
          url: url,
          method: "POST",
          data: {
            trackingCode: trackingCode,
            currentHubId: currentHubId,
            managerId: currentManagerId,
            actionTypeId: actionTypeId
          },
          success: function (res) {
            if (res && res.success) {
              showResult("success", res.message || "Nhập kho thành công!");
              setOrderDetail(res.data, trackingCode);
              $("#trackingCode").val("").focus();
            } else {
              showResult("error", (res && res.message) ? res.message : "Thao tác thất bại");
            }
          },
          error: function (xhr) {
            var msg = "Có lỗi xảy ra";
            try {
              var json = xhr.responseJSON;
              if (json && json.message) msg = json.message;
            } catch (e) {}
            showResult("error", msg);
          }
        });

        return false;
      };
    }

    initJQueryReady();
  })();
</script>
