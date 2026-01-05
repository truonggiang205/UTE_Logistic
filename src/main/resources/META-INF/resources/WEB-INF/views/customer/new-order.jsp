<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-plus-circle"></i> Tạo đơn giao hàng</h1>
    <a class="btn btn-secondary btn-sm" href="<c:url value='/customer/orders'/>">
        <i class="fas fa-arrow-left"></i> Quay lại
    </a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">Thông tin đơn</h6>
    </div>
    <div class="card-body">
        <form method="post" action="<c:url value='/customer/orders'/>">

            <div class="row">
                <div class="col-lg-6">
                    <h6 class="text-primary font-weight-bold mb-3"><i class="fas fa-upload"></i> Thông tin lấy hàng</h6>

                    <div class="form-group">
                        <label>Tên người gửi</label>
                        <input class="form-control" name="senderName" value="${form.senderName}" required />
                    </div>

                    <div class="form-group">
                        <label>SĐT người gửi</label>
                        <input class="form-control" name="senderPhone" value="${form.senderPhone}" required />
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ lấy hàng</label>
                        <input class="form-control" name="pickupAddressDetail" value="${form.pickupAddressDetail}" required />
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>Phường/Xã</label>
                            <input class="form-control" name="pickupWard" value="${form.pickupWard}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Quận/Huyện</label>
                            <input class="form-control" name="pickupDistrict" value="${form.pickupDistrict}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Tỉnh/TP</label>
                            <input class="form-control" name="pickupProvince" value="${form.pickupProvince}" />
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <h6 class="text-primary font-weight-bold mb-3"><i class="fas fa-download"></i> Thông tin giao hàng</h6>

                    <div class="form-group">
                        <label>Tên người nhận</label>
                        <input class="form-control" name="receiverName" value="${form.receiverName}" required />
                    </div>

                    <div class="form-group">
                        <label>SĐT người nhận</label>
                        <input class="form-control" name="receiverPhone" value="${form.receiverPhone}" required />
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ giao hàng</label>
                        <input class="form-control" name="deliveryAddressDetail" value="${form.deliveryAddressDetail}" required />
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>Phường/Xã</label>
                            <input class="form-control" name="deliveryWard" value="${form.deliveryWard}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Quận/Huyện</label>
                            <input class="form-control" name="deliveryDistrict" value="${form.deliveryDistrict}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Tỉnh/TP</label>
                            <input class="form-control" name="deliveryProvince" value="${form.deliveryProvince}" />
                        </div>
                    </div>
                </div>
            </div>

            <hr />

            <div class="row">
                <div class="col-lg-6">
                    <h6 class="text-primary font-weight-bold mb-3"><i class="fas fa-box"></i> Thông tin hàng hóa</h6>

                    <div class="form-group">
                        <label>Loại dịch vụ</label>
                        <select class="form-control" name="serviceTypeId" required>
                            <option value="">-- Chọn dịch vụ --</option>
                            <c:forEach var="st" items="${serviceTypes}">
                                <option value="${st.serviceTypeId}" <c:if test="${st.serviceTypeId == form.serviceTypeId}">selected</c:if>>
                                    ${st.serviceName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Tên hàng</label>
                        <input class="form-control" name="itemName" value="${form.itemName}" placeholder="VD: Tài liệu / Hàng điện tử" />
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-3">
                            <label>Khối lượng (kg)</label>
                            <input class="form-control" name="weight" value="${form.weight}" type="number" step="0.01" min="0.01" required />
                        </div>
                        <div class="form-group col-md-3">
                            <label>Dài (cm)</label>
                            <input class="form-control" name="length" value="${form.length}" type="number" step="0.01" min="0.01" required />
                        </div>
                        <div class="form-group col-md-3">
                            <label>Rộng (cm)</label>
                            <input class="form-control" name="width" value="${form.width}" type="number" step="0.01" min="0.01" required />
                        </div>
                        <div class="form-group col-md-3">
                            <label>Cao (cm)</label>
                            <input class="form-control" name="height" value="${form.height}" type="number" step="0.01" min="0.01" required />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>COD (nếu thu hộ)</label>
                        <input class="form-control" name="codAmount" value="${form.codAmount}" type="number" step="0.01" min="0" placeholder="0" />
                    </div>
                </div>

                <div class="col-lg-6">
                    <h6 class="text-primary font-weight-bold mb-3"><i class="fas fa-money-bill-wave"></i> Thanh toán</h6>

                    <div class="form-group">
                        <label>Ai trả phí vận chuyển?</label>
                        <select class="form-control" name="paymentStatus" required>
                            <option value="paid" <c:if test="${form.paymentStatus == 'paid'}">selected</c:if>>Người gửi trả trước</option>
                            <option value="unpaid" <c:if test="${form.paymentStatus == 'unpaid'}">selected</c:if>>Người nhận trả sau</option>
                        </select>
                        <small class="text-muted">Phí sẽ được tính tự động theo loại dịch vụ và khối lượng.</small>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea class="form-control" name="note" rows="5" placeholder="Ghi chú cho shipper...">${form.note}</textarea>
                    </div>

                    <button class="btn btn-primary btn-block" type="submit">
                        <i class="fas fa-check"></i> Tạo đơn
                    </button>
                </div>
            </div>

        </form>
    </div>
</div>
