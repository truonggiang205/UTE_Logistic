package vn.web.logistic.service;

import vn.web.logistic.dto.request.inbound.DropOffRequest;
import vn.web.logistic.dto.request.inbound.ScanInRequest;
import vn.web.logistic.dto.response.inbound.DropOffResponse;
import vn.web.logistic.dto.response.inbound.ScanInResponse;

/**
 * Service Interface cho phân hệ NHẬP KHO (INBOUND)
 * Xử lý các nghiệp vụ liên quan đến việc nhập hàng vào kho
 */
public interface InboundService {

    /**
     * Chức năng 1: Quét Nhập (Scan In)
     * Nhân viên kho quét mã đơn hàng để xác nhận hàng đã về kho hiện tại
     *
     * @param request Thông tin quét nhập (danh sách đơn, kho, chuyến xe)
     * @param actorId ID người thực hiện (nhân viên kho)
     * @return ScanInResponse Kết quả quét nhập
     */
    ScanInResponse scanIn(ScanInRequest request, Long actorId);

    /**
     * Chức năng 2: Tạo đơn tại quầy (Drop-off)
     * Khách mang hàng ra bưu cục gửi trực tiếp
     *
     * @param request Thông tin tạo đơn (sender, receiver, weight, ...)
     * @param actorId ID người thực hiện (nhân viên quầy)
     * @return DropOffResponse Thông tin đơn hàng vừa tạo
     */
    DropOffResponse createDropOffOrder(DropOffRequest request, Long actorId);
}
