<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>In Tem Vận Đơn - ${trackingCode}</title>

                <!-- QRCode Library -->
                <script src="https://cdn.jsdelivr.net/npm/qrcode-generator@1.4.4/qrcode.min.js"></script>

                <style>
                    /* Reset */
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    /* Khổ giấy A6: 105mm x 148mm (10.5cm x 14.8cm) - tối ưu cho máy in nhiệt */
                    @page {
                        size: 105mm 148mm;
                        margin: 0;
                    }

                    body {
                        font-family: 'Arial', sans-serif;
                        font-size: 11px;
                        line-height: 1.3;
                        background: #f0f0f0;
                    }

                    .label-container {
                        width: 105mm;
                        height: 148mm;
                        background: #fff;
                        margin: 10px auto;
                        padding: 8px;
                        border: 2px solid #000;
                        position: relative;
                    }

                    /* Header với Logo */
                    .label-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border-bottom: 2px solid #000;
                        padding-bottom: 8px;
                        margin-bottom: 8px;
                    }

                    .logo {
                        font-size: 18px;
                        font-weight: bold;
                        color: #667eea;
                    }

                    .logo i {
                        margin-right: 5px;
                    }

                    .service-type {
                        background: #667eea;
                        color: #fff;
                        padding: 4px 10px;
                        border-radius: 4px;
                        font-weight: bold;
                        font-size: 10px;
                    }

                    /* QR Code & Barcode */
                    .code-section {
                        text-align: center;
                        border-bottom: 2px dashed #000;
                        padding: 10px 0;
                        margin-bottom: 8px;
                    }

                    #qrcode {
                        margin: 0 auto 8px;
                    }

                    .tracking-code {
                        font-size: 16px;
                        font-weight: bold;
                        letter-spacing: 2px;
                        font-family: 'Courier New', monospace;
                    }

                    /* Thông tin người gửi/nhận */
                    .info-section {
                        margin-bottom: 8px;
                    }

                    .info-row {
                        display: flex;
                        border-bottom: 1px solid #ddd;
                    }

                    .info-label {
                        width: 50%;
                        padding: 6px;
                        border-right: 1px solid #ddd;
                    }

                    .info-label.full {
                        width: 100%;
                        border-right: none;
                    }

                    .info-title {
                        font-size: 9px;
                        color: #666;
                        text-transform: uppercase;
                        margin-bottom: 2px;
                    }

                    .info-name {
                        font-size: 12px;
                        font-weight: bold;
                    }

                    .info-phone {
                        font-size: 11px;
                        color: #333;
                    }

                    .info-address {
                        font-size: 10px;
                        color: #555;
                    }

                    /* COD Section */
                    .cod-section {
                        background: #ffeb3b;
                        border: 3px solid #f57c00;
                        border-radius: 8px;
                        padding: 10px;
                        text-align: center;
                        margin: 10px 0;
                    }

                    .cod-label {
                        font-size: 12px;
                        font-weight: bold;
                        color: #e65100;
                    }

                    .cod-amount {
                        font-size: 24px;
                        font-weight: bold;
                        color: #d32f2f;
                    }

                    .no-cod {
                        background: #e8f5e9;
                        border-color: #4caf50;
                    }

                    .no-cod .cod-label,
                    .no-cod .cod-amount {
                        color: #2e7d32;
                    }

                    /* Chi tiết phí */
                    .fee-detail-section {
                        background: #f9f9f9;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                        padding: 8px;
                        margin: 8px 0;
                        font-size: 10px;
                    }

                    .fee-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 3px 0;
                        border-bottom: 1px dashed #e0e0e0;
                    }

                    .fee-row:last-child {
                        border-bottom: none;
                    }

                    .fee-label {
                        color: #666;
                    }

                    .fee-value {
                        font-weight: bold;
                        color: #333;
                    }

                    .fee-value.free-shipping {
                        color: #28a745;
                        font-weight: bold;
                    }

                    /* Footer */
                    .label-footer {
                        position: absolute;
                        bottom: 8px;
                        left: 8px;
                        right: 8px;
                        border-top: 1px solid #ddd;
                        padding-top: 6px;
                        display: flex;
                        justify-content: space-between;
                        font-size: 9px;
                        color: #666;
                    }

                    /* Package Info */
                    .package-info {
                        display: flex;
                        justify-content: space-between;
                        font-size: 10px;
                        padding: 5px 0;
                        border-bottom: 1px solid #ddd;
                    }

                    .package-info span {
                        background: #f5f5f5;
                        padding: 3px 6px;
                        border-radius: 3px;
                    }

                    /* In ấn */
                    @media print {
                        body {
                            background: #fff;
                        }

                        .label-container {
                            margin: 0;
                            border: none;
                            box-shadow: none;
                        }

                        .no-print {
                            display: none !important;
                        }
                    }

                    /* Nút điều khiển */
                    .controls {
                        text-align: center;
                        margin: 20px auto;
                        max-width: 400px;
                    }

                    .controls button {
                        padding: 12px 30px;
                        font-size: 14px;
                        margin: 5px;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                    }

                    .btn-print {
                        background: #667eea;
                        color: #fff;
                    }

                    .btn-close {
                        background: #6c757d;
                        color: #fff;
                    }
                </style>
            </head>

            <body>
                <!-- Nút điều khiển -->
                <div class="controls no-print">
                    <button class="btn-print" onclick="window.print()">
                        🖨️ In Tem Ngay
                    </button>
                    <button class="btn-close" onclick="window.close()">
                        ✖ Đóng
                    </button>
                </div>

                <!-- Tem vận đơn -->
                <div class="label-container">
                    <!-- Header -->
                    <div class="label-header">
                        <div class="logo">
                            📦 UTE LOGISTICS
                        </div>
                        <div class="service-type">
                            ${order.serviceType.serviceName}
                        </div>
                    </div>

                    <!-- QR Code & Mã vận đơn -->
                    <div class="code-section">
                        <div id="qrcode"></div>
                        <div class="tracking-code">${trackingCode}</div>
                    </div>

                    <!-- Thông tin người gửi/nhận -->
                    <div class="info-section">
                        <div class="info-row">
                            <!-- Người gửi -->
                            <div class="info-label">
                                <div class="info-title">📤 Người gửi</div>
                                <div class="info-name">${order.pickupAddress.contactName}</div>
                                <div class="info-phone">📞 ${order.pickupAddress.contactPhone}</div>
                                <div class="info-address">
                                    ${order.pickupAddress.addressDetail},
                                    ${order.pickupAddress.ward},
                                    ${order.pickupAddress.district}
                                </div>
                            </div>

                            <!-- Người nhận -->
                            <div class="info-label">
                                <div class="info-title">📥 Người nhận</div>
                                <div class="info-name">${order.deliveryAddress.contactName}</div>
                                <div class="info-phone">📞 ${order.deliveryAddress.contactPhone}</div>
                                <div class="info-address">
                                    ${order.deliveryAddress.addressDetail},
                                    ${order.deliveryAddress.ward},
                                    ${order.deliveryAddress.district}
                                </div>
                            </div>
                        </div>

                        <!-- Địa chỉ đích đầy đủ -->
                        <div class="info-row">
                            <div class="info-label full">
                                <div class="info-title">🏠 Địa chỉ giao hàng</div>
                                <div class="info-name" style="font-size: 11px;">
                                    ${order.deliveryAddress.addressDetail},
                                    ${order.deliveryAddress.ward},
                                    ${order.deliveryAddress.district},
                                    ${order.deliveryAddress.province}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin kiện hàng -->
                    <div class="package-info">
                        <span>📦 ${itemNameSafe}</span>
                        <span>⚖️ ${weightSafe} kg</span>
                        <span>📐 ${lengthSafe}x${widthSafe}x${heightSafe} cm</span>
                    </div>

                    <!-- COD Section -->
                    <c:choose>
                        <c:when test="${hasCod}">
                            <div class="cod-section">
                                <div class="cod-label">💰 TIỀN THU HỘ (COD)</div>
                                <div class="cod-amount">
                                    ${codAmountFormatted} ₫
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="cod-section no-cod">
                                <div class="cod-label">✅ ĐÃ THANH TOÁN</div>
                                <div class="cod-amount">KHÔNG THU TIỀN</div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Chi tiết phí -->
                    <div class="fee-detail-section">
                        <div class="fee-row">
                            <span class="fee-label">Phí vận chuyển:</span>
                            <span class="fee-value <c:if test='${isFreeShipping}'>free-shipping</c:if>">
                                <c:choose>
                                    <c:when test="${isFreeShipping}">MIỄN PHÍ</c:when>
                                    <c:otherwise>${shippingFeeFormatted} ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="fee-row">
                            <span class="fee-label">Phí COD:</span>
                            <span class="fee-value">${codFeeFormatted} ₫</span>
                        </div>
                        <c:if test="${insuranceFee != null && insuranceFee > 0}">
                            <div class="fee-row">
                                <span class="fee-label">Phí bảo hiểm:</span>
                                <span class="fee-value">${insuranceFeeFormatted} ₫</span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Footer -->
                    <div class="label-footer">
                        <span>Ngày tạo: ${createdAtFormatted}</span>
                        <span>Tổng phí: ${totalPriceFormatted} ₫</span>
                    </div>
                </div>

                <script>
                    // Tạo QR Code
                    document.addEventListener('DOMContentLoaded', function () {
                        var qr = qrcode(0, 'M');
                        qr.addData('${trackingCode}');
                        qr.make();
                        document.getElementById('qrcode').innerHTML = qr.createImgTag(3, 0);

                        // Tự động in sau 500ms
                        setTimeout(function () {
                            window.print();
                        }, 500);
                    });
                </script>
            </body>

            </html>