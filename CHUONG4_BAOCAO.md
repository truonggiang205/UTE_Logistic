# CHƯƠNG 4: XÂY DỰNG VÀ CÀI ĐẶT CHƯƠNG TRÌNH

## 4.1. Tổ chức cấu trúc dự án (Project Structure)

Dự án được tổ chức theo mô hình Spring Boot MVC (JSP View) kết hợp REST API.

- `src/main/java/vn/web/logistic/`
  - `controller/`
    - `admin/` (các trang/quản trị và REST API phía Admin)
      - `AdminPageController` (điều hướng trang JSP Admin)
      - `HubController` (REST CRUD Hub + lock/unlock)
      - `RouteController` (REST CRUD Route + activate/deactivate)
      - `ActionTypeAdminController` (REST CRUD ActionType)
      - `AdminUserRestController` (REST quản lý User/Staff + lock/unlock + reset password)
      - `AdminRoleRestController` (REST CRUD Role + activate/deactivate + delete guard)
      - `AdminBroadcastController` (REST broadcast email async)
      - `AdminRiskAlertDetailController` (trang chi tiết đơn từ Risk Alerts)
    - `manager/` (REST API phía Manager)
      - `ManagerDashboardController` (tracking + order detail)
  - `service/` và `service/impl/` (xử lý nghiệp vụ)
    - `ManagerDashboardServiceImpl` (map dữ liệu tracking + ETA)
    - `BroadcastEmailService`, `BroadcastEmailAsyncSender` (gửi email async + log)
  - `repository/` (Spring Data JPA)
    - `UserRepository` (truy vấn user theo role/hub để broadcast)
    - `RouteRepository` (tuyến active phục vụ tính ETA)
    - `ParcelActionRepository` (lịch sử hành trình)
  - `entity/` (JPA Entities)
    - `Hub`, `Route`, `ActionType`, `User`, `Role`, `Staff`, ...
    - `HubStatus`, `RouteStatus`, `StaffStatus` (enum tách file public)

- `src/main/resources/`
  - `application*.properties` (cấu hình theo môi trường)
  - `META-INF/resources/WEB-INF/views/`
    - `admin/`
      - `hub-management.jsp`, `route-management.jsp`, `role-management.jsp`, ...
      - `risk-alerts.jsp` (danh sách cảnh báo)
      - `risk-alert-detail.jsp` (chi tiết đơn hàng từ cảnh báo)

Ghi chú cài đặt:
- Chạy bằng Maven Wrapper: `mvnw.cmd spring-boot:run` (Windows)
- Java 17, Spring Boot.

---

## 4.2. Phân tích chức năng

### 4.2.2. Phía Guest

**Bảng 26: Các chức năng và mô tả chức năng của role Guest**

| STT | Chức năng | Mô tả |
|-----|----------|-------|
|     |          |       |
|     |          |       |
|     |          |       |

### 4.2.2. Phía Manager

**Bảng 27: Các chức năng và mô tả chức năng của role Manager**

| STT | Chức năng | Mô tả |
|-----|----------|-------|
| 1 | Tra cứu/Tracking đơn hàng + ETA | Manager tra cứu đơn theo mã vận đơn / requestId / SĐT người gửi; hệ thống trả về chi tiết đơn + lịch sử hành trình và hiển thị ETA dự kiến dựa trên tuyến Route (estimatedTime) tương ứng. |

### 4.2.3. Phía Customer

**Bảng 28: Các chức năng và mô tả chức năng của role Customer**

| STT | Chức năng | Mô tả |
|-----|----------|-------|
|     |          |       |
|     |          |       |
|     |          |       |

### 4.2.4. Phía Shipper

**Bảng 29: Các chức năng và mô tả chức năng của role Shipper**

| STT | Chức năng | Mô tả |
|-----|----------|-------|
|     |          |       |
|     |          |       |
|     |          |       |

### 4.2.5. Phía Admin

**Bảng 30: Các chức năng và mô tả chức năng của role Admin**

| STT | Chức năng | Mô tả |
|-----|----------|-------|
| 1 | Quản lý Hub (CRUD + khóa/mở) | Admin thêm/sửa danh sách hub; khóa hub để ngăn sử dụng trong tạo/cập nhật tuyến; mở khóa để hoạt động lại. |
| 2 | Quản lý Route (CRUD + active/inactive) | Admin tạo/sửa tuyến từ hub A đến hub B; bật/tắt tuyến (active/inactive); chỉ cho phép tạo/sửa tuyến khi hub liên quan đang active. |
| 3 | Quản lý ActionType (CRUD + ràng buộc xóa) | Admin tạo/sửa/xóa loại hành động dùng cho lịch sử đơn; chặn xóa nếu đã phát sinh `ParcelAction` tham chiếu. |
| 4 | Quản lý User/Staff (CRUD + khóa/mở + reset mật khẩu) | Admin tạo/sửa tài khoản, gán role; khóa/mở user; reset mật khẩu (có thể tạo mật khẩu ngẫu nhiên). |
| 5 | Quản lý Role (CRUD + activate/deactivate + delete guard) | Admin tạo/sửa role; bật/tắt role; chặn xóa role nếu đã được gán cho bất kỳ user nào. |
| 6 | Broadcast Email (Async) | Admin gửi email broadcast tới nhóm Managers (hoặc theo hub). Gửi bất đồng bộ; nếu chưa cấu hình SMTP thì hệ thống không crash và ghi log. |
| 7 | Cảnh báo rủi ro – xem chi tiết đơn (con mắt) | Từ trang Risk Alerts, admin bấm icon “con mắt” để mở trang chi tiết đơn (thông tin + timeline). |

---

## 4.3. Các chức năng chi tiết của Guest

### 4.3.1. Chức năng …………..

(Phần không thuộc phạm vi chỉnh sửa của tôi — giữ trống theo yêu cầu)

---

## 4.4. Các chức năng chi tiết của Manger

### 4.4.1. Chức năng Tra cứu/Tracking đơn hàng + ETA

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Track order (Manager) |
| Goal | Tra cứu chi tiết đơn hàng và lịch sử hành trình; hiển thị ETA dự kiến |
| Actors | Manager |
| Pre-conditions | Manager đã đăng nhập và có quyền truy cập trang/REST API Manager |
| Post-conditions | - Nếu tìm thấy: trả về chi tiết đơn + timeline + ETA dự kiến\n- Nếu không tìm thấy: trả thông báo không tìm thấy |
| Main Flow | 1) Manager nhập keyword (trackingCode hoặc requestId hoặc SĐT người gửi)\n2) Hệ thống gọi API tracking\n3) Hệ thống truy vấn đơn hàng và lịch sử ParcelAction\n4) Tính ETA: lấy tuyến active theo tỉnh/TP hub hiện tại → tỉnh/TP địa chỉ giao; cộng lead time (estimatedTime)\n5) Trả về dữ liệu chi tiết để hiển thị |
| Alternative | 2a) Nếu keyword là trackingCode: ưu tiên tìm theo tracking code; nếu không có thì fallback theo requestId/SĐT |
| Exception | 1a) Keyword rỗng: báo lỗi yêu cầu nhập keyword\n3a) Không tìm thấy đơn: trả 404/ thông báo\n4a) Không có tuyến active phù hợp: ETA để trống |

**b. Lược đồ chức năng (mô tả luồng)**

- Manager → Nhập keyword → Gửi request tới `/api/manager/tracking` hoặc `/api/manager/tracking/{requestId}`
- Server → Lấy `ServiceRequest` + `ParcelAction` (timeline) → Tính ETA từ `Route.estimatedTime` → Trả JSON
- UI → Render thông tin đơn + timeline + ETA

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Text | Nhập keyword (tracking code / mã đơn / SĐT người gửi) |
| 2 | Button | Thực hiện tra cứu |
| 3 | Text/Label | Hiển thị trạng thái đơn, hub hiện tại, thông tin người gửi/nhận |
| 4 | Text/Label | Hiển thị ETA dự kiến (nếu tính được) |
| 5 | Table | Hiển thị lịch sử hành trình (timeline ParcelAction) |

---

## 4.5. Các chức năng chi tiết của Customer

### 4.5.1. Chức năng …………..

(Phần không thuộc phạm vi chỉnh sửa của tôi — giữ trống theo yêu cầu)

---

## 4.6. Các chức năng chi tiết của Shipper

### 4.6.1. Chức năng …………..

(Phần không thuộc phạm vi chỉnh sửa của tôi — giữ trống theo yêu cầu)

---

## 4.7. Các chức năng chi tiết của Admin

### 4.7.1. Chức năng Quản lý Hub (CRUD + khóa/mở)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Hub management |
| Goal | Quản lý danh mục hub và trạng thái hoạt động (active/inactive) |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập |
| Post-conditions | - Hub được tạo/sửa thành công\n- Hub có thể khóa/mở; hub bị khóa sẽ bị chặn khi dùng tạo/sửa route |
| Main Flow | 1) Admin mở trang quản lý hub\n2) Chọn thêm/sửa hub\n3) Gửi dữ liệu tới API `/api/admin/hubs`\n4) Hệ thống validate và lưu DB\n5) Hiển thị lại danh sách |
| Alternative | 2a) Khóa hub: gọi `/api/admin/hubs/{hubId}/lock`\n2b) Mở khóa hub: gọi `/api/admin/hubs/{hubId}/unlock` |
| Exception | 3a) Dữ liệu thiếu/không hợp lệ: trả lỗi validation |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → Form Hub → REST API → DB (Hub) → refresh danh sách

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách hub |
| 2 | Button | Thêm hub |
| 3 | Button | Sửa hub |
| 4 | Button | Khóa/Mở hub |

---

### 4.7.2. Chức năng Quản lý Route (CRUD + active/inactive)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Route management |
| Goal | Quản lý tuyến vận chuyển giữa các hub và bật/tắt tuyến |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập; hub tham gia tuyến phải active |
| Post-conditions | - Tạo/sửa route thành công\n- Có thể activate/deactivate route |
| Main Flow | 1) Admin vào trang quản lý route\n2) Chọn tạo/sửa route (fromHub, toHub, estimatedTime, ...)\n3) Hệ thống validate hub active\n4) Lưu route\n5) Hiển thị danh sách |
| Alternative | 2a) Deactivate: `/api/admin/routes/{routeId}/deactivate`\n2b) Activate: `/api/admin/routes/{routeId}/activate` |
| Exception | 3a) Hub bị khóa: chặn tạo/sửa route |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → Form Route → Validate hub status → Lưu DB → refresh danh sách

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách route |
| 2 | Button | Thêm/Sửa route |
| 3 | Button | Activate/Deactivate route |

---

### 4.7.3. Chức năng Quản lý ActionType (CRUD + ràng buộc xóa)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | ActionType management |
| Goal | Quản lý loại hành động dùng trong timeline đơn hàng |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập |
| Post-conditions | - Tạo/sửa action type thành công\n- Chỉ xóa được nếu chưa phát sinh hành động lịch sử |
| Main Flow | 1) Admin mở cấu hình action types\n2) Thêm/sửa actionCode, actionName\n3) Lưu qua API\n4) Refresh danh sách |
| Alternative | Xóa: gọi DELETE `/api/admin/action-types/{id}` (nếu không bị ràng buộc) |
| Exception | Nếu action type đã được dùng: hệ thống chặn xóa và trả thông báo |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → CRUD ActionType → Kiểm tra có `ParcelAction` tham chiếu → Cho phép/Chặn xóa

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách action types |
| 2 | Button | Thêm/Sửa |
| 3 | Button | Xóa (nếu hợp lệ) |

---

### 4.7.4. Chức năng Quản lý User/Staff (CRUD + lock/unlock + reset password)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | User & Staff management |
| Goal | Quản lý tài khoản nội bộ, gán role, khóa/mở, reset mật khẩu |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập |
| Post-conditions | - User được tạo/sửa\n- User có thể lock/unlock\n- Reset mật khẩu thành công |
| Main Flow | 1) Admin vào quản lý nhân sự\n2) Tạo/sửa user (username/email/phone/fullName/roles...)\n3) Lưu qua API\n4) Thực hiện lock/unlock hoặc reset password khi cần |
| Alternative | Reset password có thể nhập mật khẩu mới hoặc để hệ thống tạo ngẫu nhiên |
| Exception | Role không tồn tại hoặc role inactive: chặn gán role |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → Form User → Validate role → Lưu DB → (Lock/Unlock/Reset password)

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách user |
| 2 | Button | Thêm/Sửa user |
| 3 | Button | Khóa/Mở user |
| 4 | Button | Reset mật khẩu |

---

### 4.7.5. Chức năng Quản lý Role (CRUD + activate/deactivate + delete guard)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Role management |
| Goal | Quản trị vai trò và trạng thái role |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập |
| Post-conditions | - Role được tạo/sửa\n- Role có thể activate/deactivate\n- Chặn xóa role nếu đã gán user |
| Main Flow | 1) Admin mở trang quản lý role\n2) Tạo/sửa roleName, description\n3) Activate/Deactivate role\n4) Xóa role nếu không bị gán cho user |
| Exception | Nếu role đã được gán: hệ thống chặn xóa |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → CRUD Role → Kiểm tra `User.roles` → Cho phép/Chặn xóa

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách roles |
| 2 | Button | Thêm/Sửa |
| 3 | Button | Activate/Deactivate |
| 4 | Button | Xóa (nếu hợp lệ) |

---

### 4.7.6. Chức năng Broadcast Email (Async)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Broadcast email |
| Goal | Gửi email thông báo hàng loạt cho nhóm Managers (hoặc theo hub) |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập |
| Post-conditions | - Email được xếp hàng gửi async\n- Nếu thiếu cấu hình SMTP: hệ thống không crash, ghi log và skip gửi |
| Main Flow | 1) Admin gửi request broadcast email\n2) Hệ thống truy vấn danh sách email theo role (MANAGER, fallback STAFF)\n3) Ghi `SystemLog` trạng thái QUEUED\n4) Async sender gửi từng email và ghi `SystemLog` DONE/ SKIPPED |
| Alternative | Target `HUB_MANAGERS`: lọc theo `Staff.hubId` |
| Exception | Thiếu `hubId` khi target HUB_MANAGERS: trả lỗi; thiếu SMTP: skip gửi |

**b. Lược đồ chức năng (mô tả luồng)**

- Admin → POST `/api/admin/broadcast/email` → Service resolve recipients → enqueue async → sender gửi mail → log

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Select | Chọn target (ALL_MANAGERS / HUB_MANAGERS) |
| 2 | Select/Text | Chọn hub (nếu HUB_MANAGERS) |
| 3 | Text | Nhập subject |
| 4 | Textarea | Nhập nội dung |
| 5 | Button | Gửi broadcast |

---

### 4.7.7. Chức năng Cảnh báo rủi ro – Xem chi tiết đơn (con mắt)

**a. Mô tả chức năng**

| Thuộc tính | Nội dung |
|---|---|
| Name | Risk alerts – view order detail |
| Goal | Từ danh sách đơn bị treo, mở trang chi tiết đơn để xử lý |
| Actors | Admin |
| Pre-conditions | Admin đã đăng nhập; trang risk alerts hiển thị danh sách stuck orders |
| Post-conditions | Mở trang chi tiết đơn và xem timeline hành trình |
| Main Flow | 1) Admin vào `/admin/risk-alerts`\n2) Bấm icon “con mắt” tại dòng đơn\n3) Điều hướng tới `/admin/risk-alerts/{requestId}`\n4) Server lấy chi tiết đơn + timeline và render JSP |
| Exception | Không tìm thấy đơn: hiển thị thông báo lỗi trên trang chi tiết |

**b. Lược đồ chức năng (mô tả luồng)**

- UI Risk Alerts → click con mắt → GET trang chi tiết → load dữ liệu tracking → render chi tiết

**c. Thiết kế giao diện (bảng nút/chức năng)**

| STT | Dạng | Mục đích |
|---|---|---|
| 1 | Table | Danh sách stuck orders |
| 2 | Icon Button (Eye) | Mở trang chi tiết đơn |
| 3 | Button | Quay lại danh sách |
| 4 | Table | Timeline hành trình (ActionHistory) |
