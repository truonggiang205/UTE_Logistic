<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tạo Đơn Tại Quầy - Manager Portal</title>

                <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900"
                    rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

                <style>
                    .dropoff-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 25px;
                        border-radius: 15px;
                        color: #fff;
                        margin-bottom: 25px;
                    }

                    .form-card {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                        margin-bottom: 20px;
                        overflow: hidden;
                    }

                    .form-card-header {
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                        color: #fff;
                        padding: 15px 20px;
                        display: flex;
                        align-items: center;
                    }

                    .form-card-header.sender {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    }

                    .form-card-header.receiver {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                    }

                    .form-card-header.package {
                        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                    }

                    .form-card-header.route {
                        background: linear-gradient(135deg, #ff9966 0%, #ff5e62 100%);
                    }

                    .card-icon {
                        width: 40px;
                        height: 40px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 15px;
                    }

                    .form-card-body {
                        padding: 20px;
                    }

                    .fee-summary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-radius: 15px;
                        padding: 25px;
                        color: #fff;
                    }

                    .fee-item {
                        display: flex;
                        justify-content: space-between;
                        padding: 8px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    .fee-item.total {
                        border-top: 2px solid #fff;
                        border-bottom: none;
                        font-size: 1.2rem;
                        font-weight: 700;
                        padding-top: 15px;
                        margin-top: 10px;
                    }

                    .address-suggestion {
                        border: 1px solid #e3e6f0;
                        border-radius: 8px;
                        padding: 10px 15px;
                        margin-bottom: 10px;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .address-suggestion:hover {
                        border-color: #667eea;
                        background: #f8f9fc;
                    }

                    .address-suggestion.selected {
                        border-color: #28a745;
                        background: #e8f5e9;
                    }

                    .route-option {
                        border: 2px solid #e3e6f0;
                        border-radius: 10px;
                        padding: 15px;
                        margin-bottom: 10px;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .route-option:hover {
                        border-color: #667eea;
                    }

                    .route-option.selected {
                        border-color: #28a745;
                        background: #e8f5e9;
                    }

                    .route-option input[type="radio"] {
                        margin-right: 10px;
                    }

                    /* Style cho upload ảnh */
                    .image-preview {
                        position: relative;
                        width: 100px;
                        height: 100px;
                        border-radius: 8px;
                        overflow: hidden;
                        border: 2px solid #e3e6f0;
                    }

                    .image-preview img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .image-preview .remove-btn {
                        position: absolute;
                        top: 5px;
                        right: 5px;
                        width: 24px;
                        height: 24px;
                        background: #dc3545;
                        color: #fff;
                        border: none;
                        border-radius: 50%;
                        cursor: pointer;
                        font-size: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .image-preview .remove-btn:hover {
                        background: #c82333;
                    }

                    /* Custom Modal Notification */
                    .notification-modal-backdrop {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.5);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 9999;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s ease;
                    }

                    .notification-modal-backdrop.show {
                        opacity: 1;
                        visibility: visible;
                    }

                    .notification-modal {
                        background: #fff;
                        border-radius: 15px;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                        max-width: 450px;
                        width: 90%;
                        transform: scale(0.8) translateY(-30px);
                        transition: all 0.3s ease;
                        overflow: hidden;
                    }

                    .notification-modal-backdrop.show .notification-modal {
                        transform: scale(1) translateY(0);
                    }

                    .notification-modal-header {
                        padding: 25px;
                        text-align: center;
                    }

                    .notification-modal-header.success {
                        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    }

                    .notification-modal-header.error {
                        background: linear-gradient(135deg, #dc3545 0%, #ff6b6b 100%);
                    }

                    .notification-modal-header.warning {
                        background: linear-gradient(135deg, #ffc107 0%, #ffb347 100%);
                    }

                    .notification-modal-header.info {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    }

                    .notification-modal-icon {
                        font-size: 48px;
                        color: #fff;
                        margin-bottom: 10px;
                    }

                    .notification-modal-title {
                        color: #fff;
                        font-size: 1.3rem;
                        font-weight: 600;
                        margin: 0;
                    }

                    .notification-modal-body {
                        padding: 25px;
                        text-align: center;
                    }

                    .notification-modal-message {
                        color: #333;
                        font-size: 1rem;
                        margin-bottom: 20px;
                        line-height: 1.6;
                    }

                    .notification-modal-footer {
                        padding: 0 25px 25px;
                        display: flex;
                        gap: 10px;
                        justify-content: center;
                    }

                    .notification-modal-btn {
                        padding: 12px 30px;
                        border: none;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .notification-modal-btn.primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                    }

                    .notification-modal-btn.primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
                    }

                    .notification-modal-btn.secondary {
                        background: #e9ecef;
                        color: #495057;
                    }

                    .notification-modal-btn.secondary:hover {
                        background: #dee2e6;
                    }

                    /* ==========================================
                       VNPAY QR CODE MODAL
                       ========================================== */
                    .qr-modal-backdrop {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.7);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 10000;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.3s ease;
                    }

                    .qr-modal-backdrop.show {
                        opacity: 1;
                        visibility: visible;
                    }

                    .qr-modal {
                        background: #fff;
                        border-radius: 20px;
                        box-shadow: 0 25px 80px rgba(0, 0, 0, 0.4);
                        max-width: 420px;
                        width: 95%;
                        transform: scale(0.8);
                        transition: all 0.3s ease;
                        overflow: hidden;
                    }

                    .qr-modal-backdrop.show .qr-modal {
                        transform: scale(1);
                    }

                    .qr-modal-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 20px;
                        text-align: center;
                        color: #fff;
                    }

                    .qr-modal-header h5 {
                        margin: 0;
                        font-weight: 600;
                    }

                    .qr-modal-body {
                        padding: 30px;
                        text-align: center;
                    }

                    .qr-code-container {
                        background: #f8f9fc;
                        border-radius: 15px;
                        padding: 20px;
                        display: inline-block;
                        margin-bottom: 20px;
                    }

                    .qr-code-container img {
                        border-radius: 10px;
                    }

                    .qr-amount {
                        font-size: 28px;
                        font-weight: 700;
                        color: #28a745;
                        margin-bottom: 10px;
                    }

                    .qr-order-info {
                        color: #858796;
                        font-size: 14px;
                        margin-bottom: 15px;
                    }

                    .qr-status {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 10px;
                        padding: 15px;
                        background: #fff3cd;
                        border-radius: 10px;
                        color: #856404;
                        font-weight: 500;
                    }

                    .qr-status.checking {
                        background: #e3f2fd;
                        color: #1565c0;
                    }

                    .qr-status.success {
                        background: #d4edda;
                        color: #155724;
                    }

                    .qr-status i {
                        font-size: 18px;
                    }

                    .qr-modal-footer {
                        padding: 20px;
                        background: #f8f9fc;
                        text-align: center;
                    }

                    .qr-countdown {
                        font-size: 12px;
                        color: #858796;
                        margin-top: 10px;
                    }
                </style>
            </head>

            <body id="page-top">
                <div id="wrapper">
                    <!-- Sidebar - sẽ được include từ layout -->

                    <div id="content-wrapper" class="d-flex flex-column">
                        <div id="content">
                            <div class="container-fluid py-4">

                                <!-- Header -->
                                <div class="dropoff-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h4 class="mb-1"><i class="fas fa-plus-circle"></i> Tạo Đơn Tại Quầy
                                                (Drop-off)</h4>
                                            <p class="mb-0 opacity-75">Khách hàng mang hàng đến bưu cục gửi</p>
                                        </div>
                                        <div>
                                            <span class="badge badge-light p-2" id="currentHubInfo">
                                                <i class="fas fa-building"></i> Đang tải...
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <form id="dropOffForm">
                                    <div class="row">
                                        <!-- Cột trái - Thông tin người gửi/nhận -->
                                        <div class="col-lg-8">

                                            <!-- Thông tin người gửi -->
                                            <div class="form-card">
                                                <div class="form-card-header sender">
                                                    <div class="card-icon"><i class="fas fa-user"></i></div>
                                                    <div>
                                                        <h6 class="mb-0">Thông tin Người gửi</h6>
                                                    </div>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label><i class="fas fa-phone"></i> Số điện thoại <span
                                                                        class="text-danger">*</span></label>
                                                                <div class="input-group">
                                                                    <input type="text" class="form-control"
                                                                        id="senderPhone"
                                                                        placeholder="Nhập SĐT người gửi" required>
                                                                    <div class="input-group-append">
                                                                        <button type="button" class="btn btn-primary"
                                                                            onclick="lookupSenderAddresses()">
                                                                            <i class="fas fa-search"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label><i class="fas fa-user"></i> Họ tên <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="senderName"
                                                                    placeholder="Họ tên người gửi" required>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Gợi ý địa chỉ cũ -->
                                                    <div id="senderAddressSuggestions" class="mb-3"
                                                        style="display: none;">
                                                        <label class="text-muted"><i class="fas fa-history"></i> Địa chỉ
                                                            đã lưu:</label>
                                                        <div id="senderAddressList"></div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Tỉnh/Thành phố <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="senderProvince" placeholder="Tỉnh/TP" required>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Quận/Huyện <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="senderDistrict" placeholder="Quận/Huyện"
                                                                    required>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Phường/Xã <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="senderWard"
                                                                    placeholder="Phường/Xã" required>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Địa chỉ chi tiết <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="senderAddressDetail"
                                                            placeholder="Số nhà, tên đường..." required>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Thông tin người nhận -->
                                            <div class="form-card">
                                                <div class="form-card-header receiver">
                                                    <div class="card-icon"><i class="fas fa-user-check"></i></div>
                                                    <div>
                                                        <h6 class="mb-0">Thông tin Người nhận</h6>
                                                    </div>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label><i class="fas fa-phone"></i> Số điện thoại <span
                                                                        class="text-danger">*</span></label>
                                                                <div class="input-group">
                                                                    <input type="text" class="form-control"
                                                                        id="receiverPhone"
                                                                        placeholder="Nhập SĐT người nhận" required>
                                                                    <div class="input-group-append">
                                                                        <button type="button" class="btn btn-danger"
                                                                            onclick="lookupReceiverAddresses()">
                                                                            <i class="fas fa-search"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label><i class="fas fa-user"></i> Họ tên <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="receiverName" placeholder="Họ tên người nhận"
                                                                    required>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Gợi ý địa chỉ cũ cho người nhận -->
                                                    <div id="receiverAddressSuggestions" class="mb-3"
                                                        style="display: none;">
                                                        <label class="text-muted"><i class="fas fa-history"></i> Địa chỉ
                                                            đã lưu:</label>
                                                        <div id="receiverAddressList"></div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Tỉnh/Thành phố <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="receiverProvince" placeholder="Tỉnh/TP"
                                                                    required>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Quận/Huyện <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="receiverDistrict" placeholder="Quận/Huyện"
                                                                    required>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="form-group">
                                                                <label>Phường/Xã <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control"
                                                                    id="receiverWard" placeholder="Phường/Xã" required>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Địa chỉ chi tiết <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control"
                                                            id="receiverAddressDetail"
                                                            placeholder="Số nhà, tên đường..." required>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Thông tin hàng hóa -->
                                            <div class="form-card">
                                                <div class="form-card-header package">
                                                    <div class="card-icon"><i class="fas fa-box"></i></div>
                                                    <div>
                                                        <h6 class="mb-0">Thông tin Hàng hóa</h6>
                                                    </div>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label>Tên hàng hóa <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="itemName"
                                                                    placeholder="Mô tả hàng hóa" required>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label>Loại dịch vụ <span
                                                                        class="text-danger">*</span></label>
                                                                <select class="form-control" id="serviceType" required
                                                                    onchange="calculateFees()">
                                                                    <option value="">-- Chọn dịch vụ --</option>
                                                                    <c:forEach var="st" items="${serviceTypes}">
                                                                        <option value="${st.serviceTypeId}"
                                                                            data-base-fee="${st.baseFee}"
                                                                            data-extra-kg="${st.extraPricePerKg}"
                                                                            data-cod-rate="${st.codRate}"
                                                                            data-cod-min="${st.codMinFee}"
                                                                            data-ins-rate="${st.insuranceRate}">
                                                                            ${st.serviceName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <div class="form-group">
                                                                <label>Trọng lượng (kg) <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="number" step="0.1" class="form-control"
                                                                    id="weight" placeholder="0.5" required
                                                                    onchange="calculateFees()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-group">
                                                                <label>Dài (cm)</label>
                                                                <input type="number" class="form-control" id="length"
                                                                    placeholder="20" onchange="calculateFees()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-group">
                                                                <label>Rộng (cm)</label>
                                                                <input type="number" class="form-control" id="width"
                                                                    placeholder="15" onchange="calculateFees()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <div class="form-group">
                                                                <label>Cao (cm)</label>
                                                                <input type="number" class="form-control" id="height"
                                                                    placeholder="10" onchange="calculateFees()">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label>Tiền thu hộ COD (VNĐ)</label>
                                                                <input type="number" class="form-control" id="codAmount"
                                                                    placeholder="0" value="0"
                                                                    onchange="calculateFees()">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label>Ghi chú</label>
                                                                <input type="text" class="form-control" id="note"
                                                                    placeholder="Ghi chú cho đơn hàng">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Upload ảnh hàng hóa -->
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <div class="form-group">
                                                                <label><i class="fas fa-camera text-primary"></i> Ảnh
                                                                    hàng hóa</label>
                                                                <div class="custom-file mb-2">
                                                                    <input type="file" class="custom-file-input"
                                                                        id="parcelImage" accept="image/*"
                                                                        onchange="previewImages(this)">
                                                                    <label class="custom-file-label"
                                                                        for="parcelImage">Chọn ảnh hàng hóa (tối đa 1
                                                                        ảnh)...</label>
                                                                </div>
                                                                <small class="text-muted">Hỗ trợ: JPG, PNG, GIF. Tối đa
                                                                    5MB.</small>
                                                                <div id="imagePreviewContainer"
                                                                    class="d-flex flex-wrap mt-2" style="gap: 10px;">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Chọn tuyến đường -->
                                            <div class="form-card">
                                                <div class="form-card-header route">
                                                    <div class="card-icon"><i class="fas fa-route"></i></div>
                                                    <div>
                                                        <h6 class="mb-0">Chọn Tuyến đường</h6>
                                                    </div>
                                                </div>
                                                <div class="form-card-body">
                                                    <div id="routeList">
                                                        <p class="text-muted text-center">
                                                            <i class="fas fa-spinner fa-spin"></i> Đang tải danh sách
                                                            tuyến đường...
                                                        </p>
                                                    </div>
                                                    <input type="hidden" id="selectedRouteId" name="routeId">
                                                </div>
                                            </div>

                                            <!-- Phương thức thanh toán -->
                                            <div class="form-card">
                                                <div class="form-card-header"
                                                    style="background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);">
                                                    <div class="card-icon"><i class="fas fa-credit-card"></i></div>
                                                    <div>
                                                        <h6 class="mb-0">Phương thức thanh toán</h6>
                                                    </div>
                                                </div>
                                                <div class="form-card-body">
                                                    <div class="row">
                                                        <!-- Người trả phí -->
                                                        <div class="col-md-6">
                                                            <label class="font-weight-bold mb-3">
                                                                <i class="fas fa-user-tag text-primary"></i> Ai trả cước
                                                                phí?
                                                            </label>
                                                            <div class="payment-option mb-2">
                                                                <label
                                                                    class="d-flex align-items-center p-3 border rounded"
                                                                    style="cursor: pointer;">
                                                                    <input type="radio" name="paymentBy" value="sender"
                                                                        checked class="mr-3">
                                                                    <div>
                                                                        <strong class="text-success">Người gửi trả
                                                                            ngay</strong>
                                                                        <br><small class="text-muted">Thu tiền cước khi
                                                                            nhận hàng</small>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                            <div class="payment-option">
                                                                <label
                                                                    class="d-flex align-items-center p-3 border rounded"
                                                                    style="cursor: pointer;">
                                                                    <input type="radio" name="paymentBy"
                                                                        value="receiver" class="mr-3">
                                                                    <div>
                                                                        <strong class="text-warning">Người nhận trả
                                                                            sau</strong>
                                                                        <br><small class="text-muted">Thu khi giao hàng
                                                                            (thêm vào COD)</small>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                        </div>

                                                        <!-- Phương thức thanh toán (khi người gửi trả) -->
                                                        <div class="col-md-6" id="paymentMethodSection">
                                                            <label class="font-weight-bold mb-3">
                                                                <i class="fas fa-wallet text-success"></i> Hình thức
                                                                thanh toán
                                                            </label>
                                                            <div class="payment-option mb-2">
                                                                <label
                                                                    class="d-flex align-items-center p-3 border rounded"
                                                                    style="cursor: pointer;">
                                                                    <input type="radio" name="paymentMethod"
                                                                        value="cash" checked class="mr-3">
                                                                    <div>
                                                                        <strong><i
                                                                                class="fas fa-money-bill-wave text-success"></i>
                                                                            Tiền mặt</strong>
                                                                        <br><small class="text-muted">Thu tiền trực tiếp
                                                                            tại quầy</small>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                            <div class="payment-option">
                                                                <label
                                                                    class="d-flex align-items-center p-3 border rounded"
                                                                    style="cursor: pointer;">
                                                                    <input type="radio" name="paymentMethod"
                                                                        value="vnpay" class="mr-3">
                                                                    <div>
                                                                        <strong><i
                                                                                class="fas fa-qrcode text-primary"></i>
                                                                            VNPAY (QR Code)</strong>
                                                                        <br><small class="text-muted">Quét QR thanh toán
                                                                            online</small>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Thông báo nhắc nhở thu tiền -->
                                                    <div id="paymentReminder" class="alert alert-success mt-3"
                                                        style="display: none;">
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <strong>Nhắc nhở:</strong> Vui lòng thu <span
                                                            id="amountToCollect" class="font-weight-bold">0 ₫</span> từ
                                                        khách hàng trước khi tạo đơn!
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Cột phải - Tổng kết phí -->
                                        <div class="col-lg-4">
                                            <div class="fee-summary sticky-top" style="top: 20px;">
                                                <h5 class="mb-4"><i class="fas fa-calculator"></i> Tổng kết chi phí</h5>

                                                <div class="fee-item">
                                                    <span>Phí vận chuyển:</span>
                                                    <span id="shippingFeeDisplay">0 ₫</span>
                                                </div>
                                                <div class="fee-item">
                                                    <span>Phí COD:</span>
                                                    <span id="codFeeDisplay">0 ₫</span>
                                                </div>
                                                <div class="fee-item">
                                                    <span>Phí bảo hiểm:</span>
                                                    <span id="insuranceFeeDisplay">0 ₫</span>
                                                </div>
                                                <div class="fee-item total">
                                                    <span>TỔNG CỘNG:</span>
                                                    <span id="totalFeeDisplay">0 ₫</span>
                                                </div>

                                                <hr style="border-color: rgba(255,255,255,0.3);">

                                                <div class="mb-3">
                                                    <small class="opacity-75">
                                                        <i class="fas fa-info-circle"></i>
                                                        Trọng lượng tính phí: <span
                                                            id="chargeableWeightDisplay">0</span> kg
                                                    </small>
                                                </div>

                                                <button type="submit" class="btn btn-light btn-lg btn-block">
                                                    <i class="fas fa-check-circle"></i> TẠO ĐƠN HÀNG
                                                </button>
                                                <button type="button" class="btn btn-outline-light btn-block"
                                                    onclick="resetForm()">
                                                    <i class="fas fa-redo"></i> Làm mới
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- Custom Notification Modal -->
                <div class="notification-modal-backdrop" id="notificationModal">
                    <div class="notification-modal">
                        <div class="notification-modal-header" id="notificationHeader">
                            <div class="notification-modal-icon" id="notificationIcon"></div>
                            <h5 class="notification-modal-title" id="notificationTitle"></h5>
                        </div>
                        <div class="notification-modal-body">
                            <p class="notification-modal-message" id="notificationMessage"></p>
                        </div>
                        <div class="notification-modal-footer" id="notificationFooter">
                            <button class="notification-modal-btn primary" onclick="closeNotification()">Đóng</button>
                        </div>
                    </div>
                </div>

                <!-- Confirm Modal -->
                <div class="notification-modal-backdrop" id="confirmModal">
                    <div class="notification-modal">
                        <div class="notification-modal-header info">
                            <div class="notification-modal-icon"><i class="fas fa-question-circle"></i></div>
                            <h5 class="notification-modal-title">Xác nhận</h5>
                        </div>
                        <div class="notification-modal-body">
                            <p class="notification-modal-message" id="confirmMessage"></p>
                        </div>
                        <div class="notification-modal-footer">
                            <button class="notification-modal-btn secondary" onclick="closeConfirm(false)">Hủy</button>
                            <button class="notification-modal-btn primary" onclick="closeConfirm(true)">Xác
                                nhận</button>
                        </div>
                    </div>
                </div>

                <!-- VNPAY QR Code Modal -->
                <div class="qr-modal-backdrop" id="vnpayQrModal">
                    <div class="qr-modal">
                        <div class="qr-modal-header">
                            <h5><i class="fas fa-qrcode"></i> Thanh toán VNPAY</h5>
                        </div>
                        <div class="qr-modal-body">
                            <div class="qr-code-container">
                                <img id="vnpayQrImage" src="" alt="QR Code" width="200" height="200">
                            </div>
                            <div class="qr-amount" id="vnpayQrAmount">0 ₫</div>
                            <div class="qr-order-info">
                                Mã đơn hàng: <strong id="vnpayQrOrderId">#</strong><br>
                                Mã giao dịch: <strong id="vnpayQrTxnRef"></strong>
                            </div>
                            <div class="qr-status checking" id="vnpayQrStatus">
                                <i class="fas fa-spinner fa-spin"></i>
                                <span>Đang chờ khách hàng quét mã...</span>
                            </div>
                            <div class="qr-countdown" id="vnpayQrCountdown">
                                Hết hạn sau: <span id="vnpayCountdownTimer">15:00</span>
                            </div>
                        </div>
                        <div class="qr-modal-footer">
                            <button class="btn btn-secondary" onclick="cancelVnpayPayment()">
                                <i class="fas fa-times"></i> Hủy thanh toán
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
                <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

                <script>
                    // ============ NOTIFICATION MODAL FUNCTIONS ============
                    function showNotification(type, title, message, callback) {
                        const modal = $('#notificationModal');
                        const header = $('#notificationHeader');
                        const icon = $('#notificationIcon');
                        const titleEl = $('#notificationTitle');
                        const messageEl = $('#notificationMessage');

                        // Reset classes
                        header.removeClass('success error warning info');
                        header.addClass(type);

                        // Set icon
                        const icons = {
                            success: '<i class="fas fa-check-circle"></i>',
                            error: '<i class="fas fa-times-circle"></i>',
                            warning: '<i class="fas fa-exclamation-triangle"></i>',
                            info: '<i class="fas fa-info-circle"></i>'
                        };
                        icon.html(icons[type] || icons.info);

                        titleEl.text(title);
                        messageEl.html(message);

                        // Store callback
                        window.notificationCallback = callback;

                        modal.addClass('show');
                    }

                    function closeNotification() {
                        $('#notificationModal').removeClass('show');
                        if (window.notificationCallback) {
                            window.notificationCallback();
                            window.notificationCallback = null;
                        }
                    }

                    // Confirm modal
                    let confirmCallback = null;

                    function showConfirm(message, callback) {
                        $('#confirmMessage').html(message);
                        confirmCallback = callback;
                        $('#confirmModal').addClass('show');
                    }

                    function closeConfirm(result) {
                        $('#confirmModal').removeClass('show');
                        if (confirmCallback) {
                            confirmCallback(result);
                            confirmCallback = null;
                        }
                    }

                    // ============ ORIGINAL SCRIPT ============
                    // Biến lưu thông tin hub và manager
                    let currentHubId = null;
                    let currentManagerId = null;

                    // Load thông tin ban đầu
                    $(document).ready(function () {
                        loadManagerInfo();
                        initPaymentListeners();
                    });

                    // Khởi tạo listener cho thanh toán
                    function initPaymentListeners() {
                        // Khi đổi người trả tiền
                        $('input[name="paymentBy"]').on('change', function () {
                            const paymentBy = $(this).val();
                            if (paymentBy === 'sender') {
                                $('#paymentMethodSection').show();
                                updatePaymentReminder();
                            } else {
                                $('#paymentMethodSection').hide();
                                $('#paymentReminder').hide();
                            }
                        });

                        // Khi đổi phương thức thanh toán
                        $('input[name="paymentMethod"]').on('change', function () {
                            updatePaymentReminder();
                        });
                    }

                    // Cập nhật nhắc nhở thu tiền
                    function updatePaymentReminder() {
                        const paymentBy = $('input[name="paymentBy"]:checked').val();
                        const paymentMethod = $('input[name="paymentMethod"]:checked').val();

                        if (paymentBy === 'sender') {
                            const totalFee = $('#totalFeeDisplay').text();
                            $('#amountToCollect').text(totalFee);

                            if (paymentMethod === 'cash') {
                                $('#paymentReminder').removeClass('alert-info').addClass('alert-success').show();
                                $('#paymentReminder').html('<i class="fas fa-money-bill-wave"></i> <strong>Thu tiền mặt:</strong> Vui lòng thu <span class="font-weight-bold">' + totalFee + '</span> từ khách hàng!');
                            } else if (paymentMethod === 'vnpay') {
                                $('#paymentReminder').removeClass('alert-success').addClass('alert-info').show();
                                $('#paymentReminder').html('<i class="fas fa-qrcode"></i> <strong>VNPAY:</strong> Sau khi tạo đơn, hệ thống sẽ hiển thị QR Code để khách quét thanh toán.');
                            }
                        } else {
                            $('#paymentReminder').hide();
                        }
                    }

                    // Lấy thông tin Manager và Hub
                    function loadManagerInfo() {
                        $.get('${pageContext.request.contextPath}/api/manager/dashboard/stats', function (response) {
                            if (response.success) {
                                currentHubId = response.hubId;
                                $('#currentHubInfo').html('<i class="fas fa-building"></i> Hub ID: ' + currentHubId);
                                loadAvailableRoutes();
                            }
                        }).fail(function () {
                            showNotification('error', 'Lỗi', 'Không thể lấy thông tin Hub. Vui lòng đăng nhập lại.');
                        });

                        // Lấy manager ID từ session
                        $.get('${pageContext.request.contextPath}/api/manager/current-user', function (response) {
                            if (response.userId) {
                                currentManagerId = response.userId;
                            }
                        });
                    }

                    // Tìm địa chỉ cũ của khách hàng
                    function lookupSenderAddresses() {
                        const phone = $('#senderPhone').val().trim();
                        if (!phone) {
                            showNotification('warning', 'Cảnh báo', 'Vui lòng nhập số điện thoại!');
                            return;
                        }

                        $.get('${pageContext.request.contextPath}/api/manager/inbound/customer-addresses',
                            { phone: phone },
                            function (addresses) {
                                if (addresses && addresses.length > 0) {
                                    let html = '';
                                    addresses.forEach(function (addr, index) {
                                        html += '<div class="address-suggestion" onclick="selectSenderAddress(' + index + ')" data-index="' + index + '">';
                                        html += '<strong>' + (addr.contactName || 'Không có tên') + '</strong><br>';
                                        html += '<small>' + addr.addressDetail + ', ' + addr.ward + ', ' + addr.district + ', ' + addr.province + '</small>';
                                        html += '</div>';
                                    });
                                    $('#senderAddressList').html(html);
                                    $('#senderAddressSuggestions').show();
                                    window.senderAddresses = addresses;
                                } else {
                                    $('#senderAddressSuggestions').hide();
                                }
                            }
                        );
                    }

                    // Chọn địa chỉ người gửi từ gợi ý
                    function selectSenderAddress(index) {
                        const addr = window.senderAddresses[index];
                        $('#senderName').val(addr.contactName || '');
                        $('#senderProvince').val(addr.province || '');
                        $('#senderDistrict').val(addr.district || '');
                        $('#senderWard').val(addr.ward || '');
                        $('#senderAddressDetail').val(addr.addressDetail || '');

                        $('.address-suggestion').removeClass('selected');
                        $('.address-suggestion[data-index="' + index + '"]').addClass('selected');
                    }
                    // --- THÊM LOGIC GỢI Ý CHO NGƯỜI NHẬN ---

                    // 1. Hàm tìm địa chỉ người nhận
                    function lookupReceiverAddresses() {
                        const phone = $('#receiverPhone').val().trim();
                        if (!phone) {
                            showNotification('warning', 'Cảnh báo', 'Vui lòng nhập số điện thoại người nhận!');
                            return;
                        }

                        // Gọi API lấy danh sách địa chỉ (dùng chung API với sender)
                        $.get('${pageContext.request.contextPath}/api/manager/inbound/customer-addresses',
                            { phone: phone },
                            function (addresses) {
                                if (addresses && addresses.length > 0) {
                                    let html = '';
                                    addresses.forEach(function (addr, index) {
                                        // Lưu ý: đổi tên hàm onclick thành selectReceiverAddress
                                        html += '<div class="address-suggestion" onclick="selectReceiverAddress(' + index + ')" data-index="' + index + '">';
                                        html += '<strong>' + (addr.contactName || 'Không có tên') + '</strong><br>';
                                        html += '<small>' + addr.addressDetail + ', ' + addr.ward + ', ' + addr.district + ', ' + addr.province + '</small>';
                                        html += '</div>';
                                    });
                                    $('#receiverAddressList').html(html);
                                    $('#receiverAddressSuggestions').show();

                                    // Lưu vào biến global riêng cho receiver
                                    window.receiverAddresses = addresses;
                                } else {
                                    $('#receiverAddressSuggestions').hide();
                                    showNotification('info', 'Thông báo', 'Không tìm thấy địa chỉ cũ nào cho số điện thoại này.');
                                }
                            }
                        );
                    }

                    // 2. Hàm chọn địa chỉ người nhận
                    function selectReceiverAddress(index) {
                        // Lấy từ biến window.receiverAddresses
                        const addr = window.receiverAddresses[index];

                        // Đổ dữ liệu vào form bên phải (Receiver)
                        $('#receiverName').val(addr.contactName || '');
                        $('#receiverProvince').val(addr.province || '');
                        $('#receiverDistrict').val(addr.district || '');
                        $('#receiverWard').val(addr.ward || '');
                        $('#receiverAddressDetail').val(addr.addressDetail || '');

                        // Highlight dòng đã chọn
                        $('#receiverAddressList .address-suggestion').removeClass('selected');
                        $('#receiverAddressList .address-suggestion[data-index="' + index + '"]').addClass('selected');
                    }

                    // 3. Cập nhật hàm resetForm để ẩn cả gợi ý người nhận
                    const originalResetForm = resetForm; // Lưu hàm cũ nếu cần, hoặc sửa trực tiếp hàm cũ
                    function resetForm() {
                        $('#dropOffForm')[0].reset();

                        // Ẩn cả 2 khung gợi ý
                        $('#senderAddressSuggestions').hide();
                        $('#receiverAddressSuggestions').hide();

                        $('.route-option').removeClass('selected');
                        $('#selectedRouteId').val('');
                        $('#chargeableWeightDisplay').text('0');
                        $('#shippingFeeDisplay').text('0 ₫');
                        $('#codFeeDisplay').text('0 ₫');
                        $('#insuranceFeeDisplay').text('0 ₫');
                        $('#totalFeeDisplay').text('0 ₫');
                    }
                    // Load danh sách tuyến đường
                    function loadAvailableRoutes() {
                        if (!currentHubId) {
                            console.warn('currentHubId is null, cannot load routes');
                            $('#routeList').html('<p class="text-warning text-center"><i class="fas fa-exclamation-triangle"></i> Không xác định được Hub hiện tại.</p>');
                            return;
                        }

                        console.log('Loading routes for hubId:', currentHubId);

                        $.ajax({
                            url: '${pageContext.request.contextPath}/api/manager/inbound/available-routes/' + currentHubId,
                            type: 'GET',
                            success: function (routes) {
                                console.log('Routes received:', routes);

                                // Kiểm tra nếu là response lỗi
                                if (routes && routes.success === false) {
                                    console.error('API error:', routes.message);
                                    $('#routeList').html('<p class="text-danger text-center"><i class="fas fa-times-circle"></i> ' + routes.message + '</p>');
                                    return;
                                }

                                if (routes && Array.isArray(routes) && routes.length > 0) {
                                    let html = '';
                                    routes.forEach(function (route) {
                                        const fromHubName = route.fromHub ? route.fromHub.hubName : 'N/A';
                                        const toHubName = route.toHub ? route.toHub.hubName : 'N/A';
                                        const description = route.description || ('Tuyến ' + fromHubName + ' → ' + toHubName);
                                        const estimatedTime = route.estimatedTime ? (' (~' + route.estimatedTime + ' phút)') : '';

                                        html += '<div class="route-option" onclick="selectRoute(' + route.routeId + ', this)">';
                                        html += '<input type="radio" name="route" value="' + route.routeId + '">';
                                        html += '<strong>' + description + '</strong>' + estimatedTime;
                                        html += '<br><small class="text-muted">';
                                        html += '<i class="fas fa-map-marker-alt text-success"></i> ' + fromHubName;
                                        html += ' → <i class="fas fa-map-marker-alt text-danger"></i> ' + toHubName;
                                        html += '</small>';
                                        html += '</div>';
                                    });
                                    $('#routeList').html(html);
                                } else {
                                    console.warn('No routes found for hubId:', currentHubId);
                                    $('#routeList').html('<p class="text-warning text-center"><i class="fas fa-exclamation-triangle"></i> Không có tuyến đường nào khả dụng từ Hub này.<br><small>Vui lòng liên hệ Admin để thêm tuyến đường.</small></p>');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error loading routes:', status, error);
                                console.error('Response:', xhr.responseText);
                                $('#routeList').html('<p class="text-danger text-center"><i class="fas fa-times-circle"></i> Lỗi tải danh sách tuyến đường.<br><small>' + error + '</small></p>');
                            }
                        });
                    }

                    // Chọn tuyến đường
                    function selectRoute(routeId, element) {
                        $('.route-option').removeClass('selected');
                        $(element).addClass('selected');
                        $(element).find('input[type="radio"]').prop('checked', true);
                        $('#selectedRouteId').val(routeId);
                    }

                    // Tính phí tự động
                    function calculateFees() {
                        const serviceSelect = $('#serviceType');
                        const selectedOption = serviceSelect.find('option:selected');

                        if (!selectedOption.val()) return;

                        const baseFee = parseFloat(selectedOption.data('base-fee')) || 0;
                        const extraKg = parseFloat(selectedOption.data('extra-kg')) || 0;
                        const codRate = parseFloat(selectedOption.data('cod-rate')) || 0;
                        const codMinFee = parseFloat(selectedOption.data('cod-min')) || 0;
                        const insRate = parseFloat(selectedOption.data('ins-rate')) || 0;

                        const weight = parseFloat($('#weight').val()) || 1;
                        const length = parseFloat($('#length').val()) || 1;
                        const width = parseFloat($('#width').val()) || 1;
                        const height = parseFloat($('#height').val()) || 1;
                        const codAmount = parseFloat($('#codAmount').val()) || 0;

                        // Tính trọng lượng quy đổi
                        const dimWeight = (length * width * height) / 6000;
                        const chargeableWeight = Math.max(weight, dimWeight);

                        // Tính phí vận chuyển
                        let shippingFee = baseFee;
                        if (chargeableWeight > 2) {
                            shippingFee += (chargeableWeight - 2) * extraKg;
                        }

                        // Tính phí COD
                        let codFee = 0;
                        if (codAmount > 0) {
                            codFee = Math.max(codAmount * codRate, codMinFee);
                        }

                        // Tính phí bảo hiểm
                        let insuranceFee = 0;
                        if (codAmount > 3000000) {
                            insuranceFee = codAmount * insRate;
                        }

                        const total = shippingFee + codFee + insuranceFee;

                        // Hiển thị
                        $('#chargeableWeightDisplay').text(chargeableWeight.toFixed(2));
                        $('#shippingFeeDisplay').text(formatCurrency(shippingFee));
                        $('#codFeeDisplay').text(formatCurrency(codFee));
                        $('#insuranceFeeDisplay').text(formatCurrency(insuranceFee));
                        $('#totalFeeDisplay').text(formatCurrency(total));

                        // Cập nhật nhắc nhở thanh toán
                        updatePaymentReminder();
                    }

                    function formatCurrency(amount) {
                        return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
                    }

                    // Submit form
                    $('#dropOffForm').on('submit', function (e) {
                        e.preventDefault();

                        const routeId = $('#selectedRouteId').val();
                        if (!routeId) {
                            showNotification('warning', 'Cảnh báo', 'Vui lòng chọn tuyến đường!');
                            return;
                        }

                        if (!currentManagerId) {
                            showNotification('error', 'Lỗi', 'Không xác định được Manager. Vui lòng đăng nhập lại.');
                            return;
                        }

                        const senderPhone = $('#senderPhone').val();
                        const receiverPhone = $('#receiverPhone').val();

                        if (!senderPhone || !receiverPhone) {
                            showNotification('warning', 'Cảnh báo', 'Vui lòng nhập SĐT người gửi và người nhận!');
                            return;
                        }

                        // Lấy thông tin thanh toán
                        const paymentBy = $('input[name="paymentBy"]:checked').val();
                        const paymentMethod = $('input[name="paymentMethod"]:checked').val();

                        // Xác định paymentStatus
                        // Nếu người gửi trả ngay (cash/vnpay) -> paid
                        // Nếu người nhận trả sau -> unpaid
                        let paymentStatus = 'unpaid';
                        if (paymentBy === 'sender') {
                            // Xác nhận đã thu tiền
                            if (paymentMethod === 'cash') {
                                const totalFee = $('#totalFeeDisplay').text();
                                showConfirm('Xác nhận đã thu <strong>' + totalFee + '</strong> tiền mặt từ khách hàng?', function (confirmed) {
                                    if (confirmed) {
                                        submitOrderData('paid', senderPhone, receiverPhone, routeId, paymentBy, paymentMethod);
                                    }
                                });
                                return; // Exit here, will continue in callback
                            } else if (paymentMethod === 'vnpay') {
                                // VNPAY sẽ xử lý riêng sau khi tạo đơn
                                paymentStatus = 'unpaid'; // Tạm thời unpaid, đợi callback VNPAY
                            }
                        }

                        submitOrderData(paymentStatus, senderPhone, receiverPhone, routeId, paymentBy, paymentMethod);
                    });

                    // Hàm submit order data riêng để có thể gọi từ callback
                    function submitOrderData(paymentStatus, senderPhone, receiverPhone, routeId, paymentBy, paymentMethod) {

                        // Hàm thực sự submit sau khi đã xử lý ảnh
                        function doSubmit(imagePath) {
                            const orderData = {
                                customer: {
                                    fullName: $('#senderName').val()
                                },
                                pickupAddress: {
                                    contactName: $('#senderName').val(),
                                    contactPhone: senderPhone,
                                    province: $('#senderProvince').val(),
                                    district: $('#senderDistrict').val(),
                                    ward: $('#senderWard').val(),
                                    addressDetail: $('#senderAddressDetail').val()
                                },
                                deliveryAddress: {
                                    contactName: $('#receiverName').val(),
                                    contactPhone: receiverPhone,
                                    province: $('#receiverProvince').val(),
                                    district: $('#receiverDistrict').val(),
                                    ward: $('#receiverWard').val(),
                                    addressDetail: $('#receiverAddressDetail').val()
                                },
                                serviceType: {
                                    serviceTypeId: parseInt($('#serviceType').val())
                                },
                                itemName: $('#itemName').val(),
                                weight: parseFloat($('#weight').val()) || 1,
                                length: parseFloat($('#length').val()) || 1,
                                width: parseFloat($('#width').val()) || 1,
                                height: parseFloat($('#height').val()) || 1,
                                codAmount: parseFloat($('#codAmount').val()) || 0,
                                note: $('#note').val(),
                                imageOrder: imagePath || null
                            };

                            // Build URL with query params - THÊM paymentStatus
                            const apiUrl = '${pageContext.request.contextPath}/api/manager/inbound/drop-off' +
                                '?senderPhone=' + encodeURIComponent(senderPhone) +
                                '&receiverPhone=' + encodeURIComponent(receiverPhone) +
                                '&managerId=' + currentManagerId +
                                '&routeId=' + routeId +
                                '&paymentStatus=' + paymentStatus;

                            $.ajax({
                                url: apiUrl,
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(orderData),
                                beforeSend: function () {
                                    $('button[type="submit"]').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang xử lý...');
                                },
                                success: function (response) {
                                    if (response.success) {
                                        const requestId = response.data.requestId;

                                        // Nếu chọn VNPAY, hiển thị QR Code Modal
                                        if (paymentBy === 'sender' && paymentMethod === 'vnpay') {
                                            // LƯU Ý: Sửa selector từ #totalFee -> #totalFeeDisplay
                                            // Và parse đúng số tiền (loại bỏ ký tự ₫, dấu phẩy, khoảng trắng)
                                            const totalFeeText = $('#totalFeeDisplay').text();
                                            const totalFee = parseFloat(totalFeeText.replace(/[^0-9]/g, '')) || 0;

                                            if (totalFee <= 0) {
                                                showNotification('error', 'Lỗi', 'Số tiền thanh toán không hợp lệ!');
                                                return;
                                            }

                                            // Hiển thị QR Modal thay vì redirect
                                            showVnpayQrModal(requestId, totalFee);
                                            resetForm();
                                        } else {
                                            // Hỏi có muốn in tem không
                                            showConfirm('<strong>✅ ' + response.message + '</strong><br>Mã đơn: <strong>' + requestId + '</strong><br><br>🖨️ Bạn có muốn in tem vận đơn ngay không?', function (confirmed) {
                                                if (confirmed) {
                                                    openPrintLabel(requestId);
                                                }
                                            });
                                            resetForm();
                                        }
                                    } else {
                                        showNotification('error', 'Lỗi', response.message);
                                    }
                                },
                                error: function (xhr) {
                                    const resp = xhr.responseJSON;
                                    showNotification('error', 'Lỗi', resp ? resp.message : 'Lỗi không xác định');
                                },
                                complete: function () {
                                    $('button[type="submit"]').prop('disabled', false).html('<i class="fas fa-check-circle"></i> TẠO ĐƠN HÀNG');
                                }
                            });
                        }

                        // Kiểm tra có ảnh cần upload không
                        if (selectedImages.length > 0) {
                            const formData = new FormData();
                            formData.append('file', selectedImages[0].file);

                            $.ajax({
                                url: '${pageContext.request.contextPath}/api/manager/inbound/upload-image',
                                type: 'POST',
                                data: formData,
                                processData: false,
                                contentType: false,
                                beforeSend: function () {
                                    $('button[type="submit"]').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Đang upload ảnh...');
                                },
                                success: function (response) {
                                    if (response.success) {
                                        doSubmit(response.imagePath);
                                    } else {
                                        showNotification('error', 'Lỗi', 'Lỗi upload ảnh: ' + response.message);
                                        $('button[type="submit"]').prop('disabled', false).html('<i class="fas fa-check-circle"></i> TẠO ĐƠN HÀNG');
                                    }
                                },
                                error: function (xhr) {
                                    const resp = xhr.responseJSON;
                                    showNotification('error', 'Lỗi', 'Lỗi upload ảnh: ' + (resp ? resp.message : 'Không xác định'));
                                    $('button[type="submit"]').prop('disabled', false).html('<i class="fas fa-check-circle"></i> TẠO ĐƠN HÀNG');
                                }
                            });
                        } else {
                            // Không có ảnh, submit trực tiếp
                            doSubmit(null);
                        }
                    }

                    // Mở trang in tem
                    function openPrintLabel(requestId) {
                        const printUrl = '${pageContext.request.contextPath}/manager/inbound/print-label/' + requestId;
                        window.open(printUrl, '_blank', 'width=450,height=600,scrollbars=yes');
                    }

                    function resetForm() {
                        $('#dropOffForm')[0].reset();
                        $('#senderAddressSuggestions').hide();
                        $('.route-option').removeClass('selected');
                        $('#selectedRouteId').val('');
                        $('#chargeableWeightDisplay').text('0');
                        $('#shippingFeeDisplay').text('0 ₫');
                        $('#codFeeDisplay').text('0 ₫');
                        $('#insuranceFeeDisplay').text('0 ₫');
                        $('#totalFeeDisplay').text('0 ₫');
                        // Xóa preview ảnh
                        $('#imagePreviewContainer').empty();
                        selectedImages = [];
                        $('.custom-file-label').text('Chọn ảnh hàng hóa (tối đa 1 ảnh)...');
                    }

                    // === QUẢN LÝ UPLOAD ẢNH ===
                    let selectedImages = [];

                    function previewImages(input) {
                        const files = input.files;
                        const container = $('#imagePreviewContainer');

                        // Chỉ cho phép 1 ảnh
                        if (selectedImages.length >= 1) {
                            showNotification('warning', 'Cảnh báo', 'Chỉ được upload tối đa 1 ảnh!');
                            return;
                        }

                        // Chỉ lấy file đầu tiên
                        if (files.length > 0) {
                            const file = files[0];

                            // Kiểm tra kích thước (max 5MB)
                            if (file.size > 5 * 1024 * 1024) {
                                showNotification('warning', 'Cảnh báo', 'Ảnh ' + file.name + ' vượt quá 5MB!');
                                return;
                            }

                            // Kiểm tra định dạng
                            if (!file.type.startsWith('image/')) {
                                showNotification('warning', 'Cảnh báo', 'File ' + file.name + ' không phải là ảnh!');
                                return;
                            }

                            $('.custom-file-label').text('1 ảnh đã chọn');

                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const imageId = 'img_' + Date.now();
                                selectedImages = [{
                                    id: imageId,
                                    file: file,
                                    dataUrl: e.target.result
                                }];

                                container.empty();
                                const previewHtml =
                                    '<div class="image-preview" id="' + imageId + '">' +
                                    '  <img src="' + e.target.result + '" alt="Preview">' +
                                    '  <button type="button" class="remove-btn" onclick="removeImage(\'' + imageId + '\')">' +
                                    '    <i class="fas fa-times"></i>' +
                                    '  </button>' +
                                    '</div>';

                                container.append(previewHtml);
                            };
                            reader.readAsDataURL(file);
                        }
                    }

                    function removeImage(imageId) {
                        // Xóa khỏi DOM
                        $('#' + imageId).remove();

                        // Xóa khỏi mảng
                        selectedImages = selectedImages.filter(img => img.id !== imageId);

                        // Cập nhật label
                        if (selectedImages.length === 0) {
                            $('.custom-file-label').text('Chọn ảnh hàng hóa (tối đa 1 ảnh)...');
                        } else {
                            $('.custom-file-label').text(selectedImages.length + ' ảnh đã chọn');
                        }
                    }

                    // ==========================================
                    // VNPAY PAYMENT INTEGRATION - QR CODE + POLLING
                    // ==========================================

                    // Biến global để quản lý polling
                    let vnpayPollingInterval = null;
                    let vnpayCountdownInterval = null;
                    let vnpayCurrentRequestId = null;
                    let vnpayCurrentTxnRef = null;
                    let vnpayTimeRemaining = 15 * 60; // 15 phút (giây)

                    /**
                     * Hiển thị QR Code Modal và bắt đầu polling
                     */
                    function showVnpayQrModal(requestId, amount) {
                        // Gọi API tạo URL thanh toán
                        $.ajax({
                            url: '${pageContext.request.contextPath}/api/payment/vnpay/create-payment-url',
                            type: 'GET',
                            data: {
                                requestId: requestId,
                                amount: amount
                            },
                            beforeSend: function () {
                                // Hiển thị loading
                                showNotification('info', 'Đang xử lý', 'Đang tạo mã QR thanh toán...');
                            },
                            success: function (response) {
                                closeNotification();

                                if (response.success && response.paymentUrl) {
                                    // Lưu thông tin giao dịch
                                    vnpayCurrentRequestId = requestId;
                                    vnpayCurrentTxnRef = response.vnpTxnRef;
                                    vnpayTimeRemaining = 15 * 60;

                                    // Tạo QR Code URL từ API bên thứ 3
                                    const qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data='
                                        + encodeURIComponent(response.paymentUrl);

                                    // Cập nhật Modal
                                    $('#vnpayQrImage').attr('src', qrCodeUrl);
                                    $('#vnpayQrAmount').text(formatCurrency(amount));
                                    $('#vnpayQrOrderId').text('#' + requestId);
                                    $('#vnpayQrTxnRef').text(response.vnpTxnRef);

                                    // Reset trạng thái
                                    $('#vnpayQrStatus')
                                        .removeClass('success')
                                        .addClass('checking')
                                        .html('<i class="fas fa-spinner fa-spin"></i><span>Đang chờ khách hàng quét mã...</span>');

                                    // Hiển thị modal
                                    $('#vnpayQrModal').addClass('show');

                                    // Bắt đầu countdown
                                    startVnpayCountdown();

                                    // Bắt đầu polling kiểm tra trạng thái (mỗi 3 giây)
                                    startVnpayPolling(response.vnpTxnRef, requestId);
                                } else {
                                    showNotification('error', 'Lỗi', response.message || 'Không thể tạo URL thanh toán VNPAY');
                                }
                            },
                            error: function (xhr) {
                                closeNotification();
                                const resp = xhr.responseJSON;
                                showNotification('error', 'Lỗi', resp ? resp.message : 'Lỗi kết nối VNPAY');
                            }
                        });
                    }

                    /**
                     * Bắt đầu đếm ngược thời gian hết hạn
                     */
                    function startVnpayCountdown() {
                        // Clear interval cũ nếu có
                        if (vnpayCountdownInterval) {
                            clearInterval(vnpayCountdownInterval);
                        }

                        vnpayCountdownInterval = setInterval(function () {
                            vnpayTimeRemaining--;

                            if (vnpayTimeRemaining <= 0) {
                                // Hết thời gian
                                clearInterval(vnpayCountdownInterval);
                                cancelVnpayPayment();
                                showNotification('warning', 'Hết thời gian', 'Mã QR đã hết hạn. Vui lòng thử lại!');
                                return;
                            }

                            const minutes = Math.floor(vnpayTimeRemaining / 60);
                            const seconds = vnpayTimeRemaining % 60;
                            $('#vnpayCountdownTimer').text(
                                String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0')
                            );
                        }, 1000);
                    }

                    /**
                     * Bắt đầu polling kiểm tra trạng thái thanh toán
                     */
                    function startVnpayPolling(vnpTxnRef, requestId) {
                        // Clear interval cũ nếu có
                        if (vnpayPollingInterval) {
                            clearInterval(vnpayPollingInterval);
                        }

                        vnpayPollingInterval = setInterval(function () {
                            $.ajax({
                                url: '${pageContext.request.contextPath}/api/payment/vnpay/check-status',
                                type: 'GET',
                                data: { vnpTxnRef: vnpTxnRef },
                                success: function (response) {
                                    if (response.success) {
                                        const status = response.paymentStatus;

                                        if (status === 'success') {
                                            // Thanh toán thành công!
                                            stopVnpayPolling();

                                            // Cập nhật UI
                                            $('#vnpayQrStatus')
                                                .removeClass('checking')
                                                .addClass('success')
                                                .html('<i class="fas fa-check-circle"></i><span>Thanh toán thành công!</span>');

                                            // Đợi 2 giây rồi đóng modal và hỏi in tem
                                            setTimeout(function () {
                                                closeVnpayQrModal();
                                                showConfirm(
                                                    '<strong>✅ Thanh toán VNPAY thành công!</strong><br>' +
                                                    'Mã đơn: <strong>' + requestId + '</strong><br><br>' +
                                                    '🖨️ Bạn có muốn in tem vận đơn ngay không?',
                                                    function (confirmed) {
                                                        if (confirmed) {
                                                            openPrintLabel(requestId);
                                                        }
                                                    }
                                                );
                                            }, 2000);

                                        } else if (status === 'failed') {
                                            // Thanh toán thất bại
                                            stopVnpayPolling();
                                            closeVnpayQrModal();
                                            showNotification('error', 'Thất bại', 'Giao dịch thanh toán thất bại!');
                                        }
                                        // Nếu status = 'pending' thì tiếp tục polling
                                    }
                                },
                                error: function (xhr) {
                                    console.error('Error polling VNPAY status:', xhr);
                                    // Không dừng polling khi có lỗi mạng, tiếp tục thử lại
                                }
                            });
                        }, 3000); // Poll mỗi 3 giây
                    }

                    /**
                     * Dừng polling
                     */
                    function stopVnpayPolling() {
                        if (vnpayPollingInterval) {
                            clearInterval(vnpayPollingInterval);
                            vnpayPollingInterval = null;
                        }
                        if (vnpayCountdownInterval) {
                            clearInterval(vnpayCountdownInterval);
                            vnpayCountdownInterval = null;
                        }
                    }

                    /**
                     * Đóng QR Modal
                     */
                    function closeVnpayQrModal() {
                        $('#vnpayQrModal').removeClass('show');
                        stopVnpayPolling();
                    }

                    /**
                     * Hủy thanh toán VNPAY
                     */
                    function cancelVnpayPayment() {
                        closeVnpayQrModal();

                        // LƯU requestId vào biến local TRƯỚC khi reset
                        var savedRequestId = vnpayCurrentRequestId;

                        // Reset biến global
                        vnpayCurrentRequestId = null;
                        vnpayCurrentTxnRef = null;

                        // Thông báo cho user biết đơn hàng đã được tạo nhưng chưa thanh toán
                        // Kiểm tra savedRequestId có giá trị hợp lệ không (không null, không undefined, không rỗng)
                        if (savedRequestId && savedRequestId !== 'null' && savedRequestId !== 'undefined') {
                            showConfirm(
                                '<strong>⚠️ Đã hủy thanh toán VNPAY</strong><br>' +
                                'Đơn hàng <strong>#' + savedRequestId + '</strong> đã được tạo với trạng thái <strong>Chưa thanh toán</strong>.<br><br>' +
                                '🖨️ Bạn có muốn in tem vận đơn không?',
                                function (confirmed) {
                                    if (confirmed && savedRequestId) {
                                        openPrintLabel(savedRequestId);
                                    }
                                }
                            );
                        } else {
                            // Nếu không có requestId hợp lệ (user hủy trước khi API trả về)
                            showNotification('warning', 'Thông báo', 'Đã hủy quá trình thanh toán.');
                        }
                    }
                </script>
            </body>

            </html>