<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Kết quả thanh toán VNPAY</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

                <style>
                    body {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }

                    .result-card {
                        background: #fff;
                        border-radius: 20px;
                        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                        max-width: 500px;
                        width: 100%;
                        overflow: hidden;
                        animation: slideUp 0.5s ease-out;
                    }

                    @keyframes slideUp {
                        from {
                            opacity: 0;
                            transform: translateY(30px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .result-header {
                        padding: 40px;
                        text-align: center;
                    }

                    .result-header.success {
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        color: #fff;
                    }

                    .result-header.failed {
                        background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                        color: #fff;
                    }

                    .result-icon {
                        width: 80px;
                        height: 80px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 20px;
                        font-size: 36px;
                    }

                    .result-title {
                        font-size: 24px;
                        font-weight: 700;
                        margin-bottom: 10px;
                    }

                    .result-body {
                        padding: 30px;
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 12px 0;
                        border-bottom: 1px solid #e3e6f0;
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        color: #858796;
                        font-weight: 500;
                    }

                    .info-value {
                        font-weight: 600;
                        color: #5a5c69;
                    }

                    .info-value.amount {
                        color: #28a745;
                        font-size: 18px;
                    }

                    .result-footer {
                        padding: 20px 30px 30px;
                        display: flex;
                        gap: 15px;
                    }

                    .result-footer .btn {
                        flex: 1;
                        padding: 12px 20px;
                        border-radius: 10px;
                        font-weight: 600;
                    }
                </style>
            </head>

            <body>
                <div class="result-card">
                    <c:choose>
                        <c:when test="${paymentSuccess}">
                            <div class="result-header success">
                                <div class="result-icon">
                                    <i class="fas fa-check"></i>
                                </div>
                                <h2 class="result-title">Thanh toán thành công!</h2>
                                <p class="mb-0">Giao dịch của bạn đã được xử lý</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="result-header failed">
                                <div class="result-icon">
                                    <i class="fas fa-times"></i>
                                </div>
                                <h2 class="result-title">Thanh toán thất bại</h2>
                                <p class="mb-0">${errorMessage}</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="result-body">
                        <div class="info-row">
                            <span class="info-label">Mã đơn hàng</span>
                            <span class="info-value">#${requestId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Mã giao dịch VNPAY</span>
                            <span class="info-value">${vnpTransactionNo}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Mã tham chiếu</span>
                            <span class="info-value">${vnpTxnRef}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số tiền</span>
                            <span class="info-value amount">
                                <fmt:formatNumber value="${amount}" type="currency" currencySymbol=""
                                    maxFractionDigits="0" /> VNĐ
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Thời gian</span>
                            <span class="info-value">${paymentTime}</span>
                        </div>
                        <c:if test="${not empty vnpResponseCode and vnpResponseCode != '00'}">
                            <div class="info-row">
                                <span class="info-label">Mã lỗi</span>
                                <span class="info-value text-danger">${vnpResponseCode}</span>
                            </div>
                        </c:if>
                    </div>

                    <div class="result-footer">
                        <c:if test="${paymentSuccess}">
                            <a href="${pageContext.request.contextPath}/manager/inbound/print-label/${requestId}"
                                class="btn btn-success" target="_blank">
                                <i class="fas fa-print"></i> In tem vận đơn
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/manager/inbound/drop-off" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i> Tạo đơn mới
                        </a>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>