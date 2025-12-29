package vn.web.logistic.repository.projection;

public interface TopPerformerProjection {

    // 1. ID-> Alias: id
    Long getId();

    // 2. Tên hiển thị (Tên Hub hoặc Tên Shipper) -> Alias: name
    String getName();

    // 3. Thông tin thêm (Địa chỉ Hub hoặc SĐT/Email Shipper) -> Alias: extraInfo
    String getExtraInfo();

    // 4. Số lượng thành công (Dùng để xếp hạng) -> Alias: successCount
    Long getSuccessCount();

    // 5. Số lượng tồn đọng (Dùng để cảnh báo) -> Alias: pendingCount
    Long getPendingCount();
}