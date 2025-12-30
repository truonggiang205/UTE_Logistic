<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <head>
                <title>Tạo Đơn Tại Quầy - Logistics Manager</title>
                <style>
                    .form-section {
                        background: #f8f9fc;
                        border-radius: 10px;
                        padding: 20px;
                        margin-bottom: 20px;
                    }

                    .form-section-title {
                        font-weight: 600;
                        color: #4e73df;
                        margin-bottom: 15px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #4e73df;
                    }

                    .fee-summary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border-radius: 15px;
                        padding: 25px;
                    }

                    .fee-item {
                        display: flex;
                        justify-content: space-between;
                        padding: 8px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .fee-item:last-child {
                        border-bottom: none;
                    }

                    .fee-total {
                        font-size: 1.5rem;
                        font-weight: bold;
                        padding-top: 15px;
                        margin-top: 10px;
                        border-top: 2px solid rgba(255, 255, 255, 0.5);
                    }

                    .service-type-card {
                        border: 2px solid #e3e6f0;
                        border-radius: 10px;
                        padding: 15px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        margin-bottom: 10px;
                    }

                    .service-type-card:hover {
                        border-color: #4e73df;
                        transform: translateY(-2px);
                    }

                    .service-type-card.selected {
                        border-color: #4e73df;
                        background: #eef2ff;
                    }

                    .service-type-card .price {
                        font-weight: bold;
                        color: #4e73df;
                    }

                    .dimension-input {
                        width: 100%;
                    }

                    .success-modal-content {
                        text-align: center;
                        padding: 30px;
                    }

                    .success-icon {
                        font-size: 5rem;
                        color: #1cc88a;
                        margin-bottom: 20px;
                    }

                    .required-label::after {
                        content: " *";
                        color: #e74a3b;
                    }

                    .input-icon-wrapper {
                        position: relative;
                    }

                    .input-icon-wrapper i {
                        position: absolute;
                        left: 12px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #858796;
                    }

                    .input-icon-wrapper input,
                    .input-icon-wrapper select {
                        padding-left: 35px;
                    }
                </style>
            </head>

            <body>
                <div class="container-fluid">
                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-plus-circle"></i> Tạo Đơn Tại Quầy
                        </h1>
                        <div>
                            <a href="${pageContext.request.contextPath}/manager/inbound/scan-in"
                                class="btn btn-info btn-sm shadow-sm">
                                <i class="fas fa-barcode"></i> Quét nhập kho
                            </a>
                        </div>
                    </div>

                    <form id="dropOffForm" onsubmit="return false;">
                        <div class="row">
                            <!-- Left Column - Form Inputs -->
                            <div class="col-lg-8">
                                <!-- Hub & Service Selection -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3">
                                        <h6 class="m-0 font-weight-bold text-primary">
                                            <i class="fas fa-cog"></i> Thông tin dịch vụ
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">
                                                        <i class="fas fa-warehouse"></i> Bưu cục nhận hàng
                                                    </label>
                                                    <select class="form-control" id="currentHubId" required>
                                                        <option value="">-- Chọn bưu cục --</option>
                                                        <c:forEach var="hub" items="${hubs}">
                                                            <option value="${hub.hubId}">${hub.hubId} - ${hub.hubName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">
                                                        <i class="fas fa-truck-loading"></i> Loại dịch vụ
                                                    </label>
                                                    <select class="form-control" id="serviceTypeId" required
                                                        onchange="updateServiceInfo()">
                                                        <option value="">-- Chọn dịch vụ --</option>
                                                        <c:forEach var="st" items="${serviceTypes}">
                                                            <option value="${st.serviceTypeId}"
                                                                data-basefee="${st.baseFee}"
                                                                data-extrakg="${st.extraPricePerKg}"
                                                                data-codrate="${st.codRate}"
                                                                data-codmin="${st.codMinFee}">
                                                                ${st.serviceName} -
                                                                <fmt:formatNumber value="${st.baseFee}" type="currency"
                                                                    currencySymbol="₫" />
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sender Info -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3 bg-primary text-white">
                                        <h6 class="m-0 font-weight-bold">
                                            <i class="fas fa-user"></i> Thông tin người gửi
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Họ tên</label>
                                                    <input type="text" class="form-control" id="senderName"
                                                        placeholder="Nhập họ tên người gửi" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Số điện thoại</label>
                                                    <input type="tel" class="form-control" id="senderPhone"
                                                        placeholder="Nhập số điện thoại" required
                                                        pattern="[0-9]{10,11}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="required-label">Địa chỉ chi tiết</label>
                                                    <input type="text" class="form-control" id="senderAddress"
                                                        placeholder="Số nhà, đường, ngõ..." required>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Phường/Xã</label>
                                                    <input type="text" class="form-control" id="senderWard"
                                                        placeholder="Phường/Xã">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label class="required-label">Quận/Huyện</label>
                                                    <input type="text" class="form-control" id="senderDistrict"
                                                        placeholder="Quận/Huyện" required>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label class="required-label">Tỉnh/Thành phố</label>
                                                    <input type="text" class="form-control" id="senderProvince"
                                                        placeholder="Tỉnh/Thành phố" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Receiver Info -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3 bg-success text-white">
                                        <h6 class="m-0 font-weight-bold">
                                            <i class="fas fa-user-check"></i> Thông tin người nhận
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Họ tên</label>
                                                    <input type="text" class="form-control" id="receiverName"
                                                        placeholder="Nhập họ tên người nhận" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Số điện thoại</label>
                                                    <input type="tel" class="form-control" id="receiverPhone"
                                                        placeholder="Nhập số điện thoại" required
                                                        pattern="[0-9]{10,11}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="required-label">Địa chỉ chi tiết</label>
                                                    <input type="text" class="form-control" id="receiverAddress"
                                                        placeholder="Số nhà, đường, ngõ..." required>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Phường/Xã</label>
                                                    <input type="text" class="form-control" id="receiverWard"
                                                        placeholder="Phường/Xã">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label class="required-label">Quận/Huyện</label>
                                                    <input type="text" class="form-control" id="receiverDistrict"
                                                        placeholder="Quận/Huyện" required>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label class="required-label">Tỉnh/Thành phố</label>
                                                    <input type="text" class="form-control" id="receiverProvince"
                                                        placeholder="Tỉnh/Thành phố" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Package Info -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3">
                                        <h6 class="m-0 font-weight-bold text-primary">
                                            <i class="fas fa-box"></i> Thông tin hàng hóa
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Tên hàng hóa</label>
                                                    <input type="text" class="form-control" id="itemName"
                                                        placeholder="VD: Quần áo, Điện thoại..." required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Trọng lượng (kg)</label>
                                                    <input type="number" class="form-control" id="weight"
                                                        placeholder="0.5" min="0.01" step="0.01" required
                                                        onchange="calculateFee()">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Chiều dài (cm)</label>
                                                    <input type="number" class="form-control" id="length"
                                                        placeholder="0" min="0" step="0.1" onchange="calculateFee()">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Chiều rộng (cm)</label>
                                                    <input type="number" class="form-control" id="width" placeholder="0"
                                                        min="0" step="0.1" onchange="calculateFee()">
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label>Chiều cao (cm)</label>
                                                    <input type="number" class="form-control" id="height"
                                                        placeholder="0" min="0" step="0.1" onchange="calculateFee()">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Tiền thu hộ COD (₫)</label>
                                                    <input type="number" class="form-control" id="codAmount"
                                                        placeholder="0" min="0" step="1000" value="0"
                                                        onchange="calculateFee()">
                                                    <small class="text-muted">Để 0 nếu không thu hộ</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="required-label">Phương thức thanh toán</label>
                                                    <select class="form-control" id="paymentMethod" required>
                                                        <option value="cash">Tiền mặt</option>
                                                        <option value="card">Thẻ ngân hàng</option>
                                                        <option value="transfer">Chuyển khoản</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>Ghi chú</label>
                                            <textarea class="form-control" id="note" rows="2"
                                                placeholder="Ghi chú cho đơn hàng (tuỳ chọn)"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column - Fee Summary -->
                            <div class="col-lg-4">
                                <!-- Fee Summary Card -->
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3">
                                        <h6 class="m-0 font-weight-bold text-primary">
                                            <i class="fas fa-calculator"></i> Tính cước phí
                                        </h6>
                                    </div>
                                    <div class="card-body fee-summary">
                                        <div class="fee-item">
                                            <span>Trọng lượng thực:</span>
                                            <span id="displayActualWeight">0 kg</span>
                                        </div>
                                        <div class="fee-item">
                                            <span>Trọng lượng quy đổi:</span>
                                            <span id="displayDimWeight">0 kg</span>
                                        </div>
                                        <div class="fee-item">
                                            <span><strong>Trọng lượng tính cước:</strong></span>
                                            <span id="displayChargeWeight"><strong>0 kg</strong></span>
                                        </div>
                                        <hr style="border-color: rgba(255,255,255,0.3);">
                                        <div class="fee-item">
                                            <span>Phí vận chuyển:</span>
                                            <span id="displayShippingFee">0 ₫</span>
                                        </div>
                                        <div class="fee-item">
                                            <span>Phí COD:</span>
                                            <span id="displayCodFee">0 ₫</span>
                                        </div>
                                        <div class="fee-item">
                                            <span>Phí bảo hiểm:</span>
                                            <span id="displayInsuranceFee">0 ₫</span>
                                        </div>
                                        <div class="fee-item fee-total">
                                            <span>TỔNG CƯỚC:</span>
                                            <span id="displayTotalFee">0 ₫</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Service Info -->
                                <div class="card shadow mb-4" id="serviceInfoCard" style="display: none;">
                                    <div class="card-header py-3">
                                        <h6 class="m-0 font-weight-bold text-info">
                                            <i class="fas fa-info-circle"></i> Thông tin dịch vụ
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-sm table-borderless mb-0">
                                            <tr>
                                                <td class="text-muted">Phí cơ bản:</td>
                                                <td class="text-right" id="infoBaseFee">-</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Phí/kg tiếp theo:</td>
                                                <td class="text-right" id="infoExtraKg">-</td>
                                            </tr>
                                            <tr>
                                                <td class="text-muted">Phí COD:</td>
                                                <td class="text-right" id="infoCodRate">-</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="card shadow">
                                    <div class="card-body">
                                        <button type="button" class="btn btn-success btn-lg btn-block"
                                            onclick="submitDropOff()" id="btnSubmit">
                                            <i class="fas fa-check-circle"></i> Tạo đơn & Thu tiền
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary btn-block"
                                            onclick="resetForm()">
                                            <i class="fas fa-redo"></i> Làm mới form
                                        </button>
                                    </div>
                                </div>

                                <!-- Quick Tips -->
                                <div class="card shadow mt-4">
                                    <div class="card-header py-3">
                                        <h6 class="m-0 font-weight-bold text-secondary">
                                            <i class="fas fa-lightbulb"></i> Hướng dẫn
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <small class="text-muted">
                                            <ul class="pl-3 mb-0">
                                                <li>Trọng lượng quy đổi = (D × R × C) / 6000</li>
                                                <li>Tính cước theo trọng lượng lớn hơn</li>
                                                <li>Phí COD = MAX(COD × tỷ lệ, phí tối thiểu)</li>
                                                <li>Khách thanh toán ngay khi gửi hàng</li>
                                            </ul>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Success Modal -->
                <div class="modal fade" id="successModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-body success-modal-content">
                                <i class="fas fa-check-circle success-icon"></i>
                                <h4 class="mb-3">Tạo đơn thành công!</h4>
                                <p class="text-muted">Mã đơn hàng:</p>
                                <h2 class="text-primary" id="createdOrderId">#000000</h2>
                                <hr>
                                <div class="row text-left mb-3">
                                    <div class="col-6">
                                        <small class="text-muted">Tổng cước:</small>
                                        <div class="font-weight-bold" id="modalTotalFee">0 ₫</div>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted">Phương thức:</small>
                                        <div class="font-weight-bold" id="modalPaymentMethod">Tiền mặt</div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-primary btn-lg" data-dismiss="modal"
                                    onclick="resetForm()">
                                    <i class="fas fa-plus"></i> Tạo đơn mới
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="printReceipt()">
                                    <i class="fas fa-print"></i> In biên lai
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // ==================== STATE ====================
                    var selectedService = null;
                    var calculatedFees = {
                        actualWeight: 0,
                        dimWeight: 0,
                        chargeWeight: 0,
                        shippingFee: 0,
                        codFee: 0,
                        insuranceFee: 0,
                        totalFee: 0
                    };

                    // ==================== SERVICE INFO ====================
                    function updateServiceInfo() {
                        var select = document.getElementById('serviceTypeId');
                        var option = select.options[select.selectedIndex];

                        if (!option.value) {
                            document.getElementById('serviceInfoCard').style.display = 'none';
                            selectedService = null;
                            calculateFee();
                            return;
                        }

                        selectedService = {
                            baseFee: parseFloat(option.dataset.basefee) || 0,
                            extraKg: parseFloat(option.dataset.extrakg) || 0,
                            codRate: parseFloat(option.dataset.codrate) || 0,
                            codMin: parseFloat(option.dataset.codmin) || 0
                        };

                        // Display service info
                        document.getElementById('serviceInfoCard').style.display = 'block';
                        document.getElementById('infoBaseFee').textContent = formatCurrency(selectedService.baseFee);
                        document.getElementById('infoExtraKg').textContent = formatCurrency(selectedService.extraKg) + '/kg';
                        document.getElementById('infoCodRate').textContent = (selectedService.codRate * 100).toFixed(2) + '%';

                        calculateFee();
                    }

                    // ==================== FEE CALCULATION ====================
                    function calculateFee() {
                        if (!selectedService) {
                            resetFeeDisplay();
                            return;
                        }

                        var weight = parseFloat(document.getElementById('weight').value) || 0;
                        var length = parseFloat(document.getElementById('length').value) || 0;
                        var width = parseFloat(document.getElementById('width').value) || 0;
                        var height = parseFloat(document.getElementById('height').value) || 0;
                        var codAmount = parseFloat(document.getElementById('codAmount').value) || 0;

                        // Calculate dimensional weight
                        var dimWeight = 0;
                        if (length > 0 && width > 0 && height > 0) {
                            dimWeight = (length * width * height) / 6000;
                            dimWeight = Math.ceil(dimWeight * 100) / 100; // Round up to 2 decimals
                        }

                        // Chargeable weight = max of actual and dimensional
                        var chargeWeight = Math.max(weight, dimWeight);

                        // Shipping fee = baseFee + (chargeWeight * extraKg)
                        var shippingFee = selectedService.baseFee + (chargeWeight * selectedService.extraKg);
                        shippingFee = Math.ceil(shippingFee);

                        // COD fee
                        var codFee = 0;
                        if (codAmount > 0) {
                            codFee = codAmount * selectedService.codRate;
                            codFee = Math.max(codFee, selectedService.codMin);
                            codFee = Math.ceil(codFee);
                        }

                        // Insurance fee (placeholder - can be expanded)
                        var insuranceFee = 0;

                        // Total
                        var totalFee = shippingFee + codFee + insuranceFee;

                        // Store calculated values
                        calculatedFees = {
                            actualWeight: weight,
                            dimWeight: dimWeight,
                            chargeWeight: chargeWeight,
                            shippingFee: shippingFee,
                            codFee: codFee,
                            insuranceFee: insuranceFee,
                            totalFee: totalFee
                        };

                        // Update display
                        document.getElementById('displayActualWeight').textContent = weight.toFixed(2) + ' kg';
                        document.getElementById('displayDimWeight').textContent = dimWeight.toFixed(2) + ' kg';
                        document.getElementById('displayChargeWeight').innerHTML = '<strong>' + chargeWeight.toFixed(2) + ' kg</strong>';
                        document.getElementById('displayShippingFee').textContent = formatCurrency(shippingFee);
                        document.getElementById('displayCodFee').textContent = formatCurrency(codFee);
                        document.getElementById('displayInsuranceFee').textContent = formatCurrency(insuranceFee);
                        document.getElementById('displayTotalFee').textContent = formatCurrency(totalFee);
                    }

                    function resetFeeDisplay() {
                        document.getElementById('displayActualWeight').textContent = '0 kg';
                        document.getElementById('displayDimWeight').textContent = '0 kg';
                        document.getElementById('displayChargeWeight').innerHTML = '<strong>0 kg</strong>';
                        document.getElementById('displayShippingFee').textContent = '0 ₫';
                        document.getElementById('displayCodFee').textContent = '0 ₫';
                        document.getElementById('displayInsuranceFee').textContent = '0 ₫';
                        document.getElementById('displayTotalFee').textContent = '0 ₫';
                    }

                    // ==================== FORM SUBMISSION ====================
                    function submitDropOff() {
                        // Validate form
                        var form = document.getElementById('dropOffForm');
                        if (!form.checkValidity()) {
                            form.reportValidity();
                            return;
                        }

                        // Validate service selection
                        if (!selectedService) {
                            showToast('Vui lòng chọn loại dịch vụ', 'error');
                            return;
                        }

                        // Prepare request data
                        var requestData = {
                            currentHubId: parseInt(document.getElementById('currentHubId').value),
                            serviceTypeId: parseInt(document.getElementById('serviceTypeId').value),
                            senderInfo: {
                                contactName: document.getElementById('senderName').value.trim(),
                                contactPhone: document.getElementById('senderPhone').value.trim(),
                                addressDetail: document.getElementById('senderAddress').value.trim(),
                                ward: document.getElementById('senderWard').value.trim(),
                                district: document.getElementById('senderDistrict').value.trim(),
                                province: document.getElementById('senderProvince').value.trim()
                            },
                            receiverInfo: {
                                contactName: document.getElementById('receiverName').value.trim(),
                                contactPhone: document.getElementById('receiverPhone').value.trim(),
                                addressDetail: document.getElementById('receiverAddress').value.trim(),
                                ward: document.getElementById('receiverWard').value.trim(),
                                district: document.getElementById('receiverDistrict').value.trim(),
                                province: document.getElementById('receiverProvince').value.trim()
                            },
                            weight: parseFloat(document.getElementById('weight').value),
                            length: parseFloat(document.getElementById('length').value) || null,
                            width: parseFloat(document.getElementById('width').value) || null,
                            height: parseFloat(document.getElementById('height').value) || null,
                            codAmount: parseFloat(document.getElementById('codAmount').value) || 0,
                            itemName: document.getElementById('itemName').value.trim(),
                            note: document.getElementById('note').value.trim(),
                            paymentMethod: document.getElementById('paymentMethod').value
                        };

                        // Disable button
                        var btn = document.getElementById('btnSubmit');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                        // Call API
                        fetch('${pageContext.request.contextPath}/api/manager/inbound/drop-off', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(requestData)
                        })
                            .then(function (response) {
                                if (!response.ok) {
                                    return response.json().then(function (err) {
                                        throw new Error(err.message || 'Lỗi không xác định');
                                    });
                                }
                                return response.json();
                            })
                            .then(function (data) {
                                handleSubmitSuccess(data);
                            })
                            .catch(function (error) {
                                console.error('Error:', error);
                                showToast(error.message || 'Lỗi kết nối server', 'error');
                            })
                            .finally(function () {
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fas fa-check-circle"></i> Tạo đơn & Thu tiền';
                            });
                    }

                    function handleSubmitSuccess(data) {
                        // Show success modal
                        document.getElementById('createdOrderId').textContent = '#' + data.requestId;
                        document.getElementById('modalTotalFee').textContent = formatCurrency(data.feeDetails.totalPrice);

                        var paymentMethodText = {
                            'cash': 'Tiền mặt',
                            'card': 'Thẻ ngân hàng',
                            'transfer': 'Chuyển khoản'
                        };
                        document.getElementById('modalPaymentMethod').textContent =
                            paymentMethodText[data.codTransaction.paymentMethod] || data.codTransaction.paymentMethod;

                        // Store order data for printing
                        window.lastCreatedOrder = data;

                        // Show modal
                        $('#successModal').modal('show');

                        showToast('Tạo đơn hàng thành công!', 'success');
                    }

                    // ==================== UTILITY FUNCTIONS ====================
                    function resetForm() {
                        document.getElementById('dropOffForm').reset();
                        selectedService = null;
                        document.getElementById('serviceInfoCard').style.display = 'none';
                        resetFeeDisplay();
                        $('#successModal').modal('hide');
                    }

                    function printReceipt() {
                        if (!window.lastCreatedOrder) {
                            showToast('Không có dữ liệu để in', 'error');
                            return;
                        }
                        // TODO: Implement print functionality
                        alert('Chức năng in biên lai sẽ được phát triển sau.\nMã đơn: #' + window.lastCreatedOrder.requestId);
                    }

                    function formatCurrency(amount) {
                        return new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(amount);
                    }

                    function showToast(message, type) {
                        var bgColor = type === 'success' ? '#1cc88a' : (type === 'error' ? '#e74a3b' : '#f6c23e');

                        var toast = document.createElement('div');
                        toast.style.cssText = 'position:fixed;top:20px;right:20px;padding:15px 25px;background:' + bgColor +
                            ';color:white;border-radius:8px;z-index:9999;box-shadow:0 4px 15px rgba(0,0,0,0.2);';
                        toast.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : (type === 'error' ? 'times' : 'exclamation')) +
                            '-circle mr-2"></i>' + message;

                        document.body.appendChild(toast);

                        setTimeout(function () {
                            toast.remove();
                        }, 3000);
                    }
                </script>
            </body>