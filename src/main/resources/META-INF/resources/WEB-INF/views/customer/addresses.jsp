<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-map-marked-alt"></i> Sổ địa chỉ</h1>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="row">
    <div class="col-lg-7 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Danh sách địa chỉ</h6>
            </div>
            <div class="card-body">
                <c:if test="${empty addresses}">
                    <div class="text-muted">Chưa có địa chỉ nào.</div>
                </c:if>

                <c:forEach var="a" items="${addresses}">
                    <div class="border rounded p-3 mb-3">
                        <div class="d-flex justify-content-between">
                            <div>
                                <strong><c:out value="${a.contactName}"/></strong>
                                <span class="text-muted">(<c:out value="${a.contactPhone}"/>)</span>
                                <c:if test="${a.isDefault}">
                                    <span class="badge badge-success ml-2">Mặc định</span>
                                </c:if>
                                <div class="mt-2">
                                    <c:out value="${a.addressDetail}"/>,
                                    <c:out value="${a.ward}"/>,
                                    <c:out value="${a.district}"/>,
                                    <c:out value="${a.province}"/>
                                </div>
                                <c:if test="${not empty a.note}">
                                    <div class="text-muted small">Ghi chú: <c:out value="${a.note}"/></div>
                                </c:if>
                            </div>
                            <div class="text-right">
                                <c:if test="${not a.isDefault}">
                                    <form method="post" action="<c:url value='/customer/addresses/${a.addressId}/default'/>" class="mb-2">
                                        <button class="btn btn-sm btn-outline-success" type="submit">
                                            <i class="fas fa-check"></i> Đặt mặc định
                                        </button>
                                    </form>
                                </c:if>
                                <form method="post" action="<c:url value='/customer/addresses/${a.addressId}/delete'/>">
                                    <button class="btn btn-sm btn-outline-danger" type="submit" onclick="return confirm('Xóa địa chỉ này?')">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="col-lg-5 mb-4">
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Thêm địa chỉ mới</h6>
            </div>
            <div class="card-body">
                <form method="post" action="<c:url value='/customer/addresses'/>">
                    <div class="form-group">
                        <label>Tên liên hệ</label>
                        <input class="form-control" name="contactName" value="${form.contactName}" required />
                    </div>
                    <div class="form-group">
                        <label>SĐT liên hệ</label>
                        <input class="form-control" name="contactPhone" value="${form.contactPhone}" required />
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ chi tiết</label>
                        <input class="form-control" name="addressDetail" value="${form.addressDetail}" required />
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>Phường/Xã</label>
                            <input class="form-control" name="ward" value="${form.ward}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Quận/Huyện</label>
                            <input class="form-control" name="district" value="${form.district}" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>Tỉnh/TP</label>
                            <input class="form-control" name="province" value="${form.province}" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú</label>
                        <input class="form-control" name="note" value="${form.note}" />
                    </div>

                    <div class="form-group form-check">
                        <input class="form-check-input" type="checkbox" name="makeDefault" id="makeDefault" <c:if test="${form.makeDefault}">checked</c:if> />
                        <label class="form-check-label" for="makeDefault">Đặt làm mặc định</label>
                    </div>

                    <button class="btn btn-primary btn-block" type="submit">
                        <i class="fas fa-plus"></i> Thêm
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
