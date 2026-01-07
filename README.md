# Hệ thống Quản lý Logistics (Logistics Management System)

![Logo](src/main/resources/static/img/logo.png)

Hệ thống quản lý logistics theo mô hình vận hành của một đơn vị giao nhận: tạo đơn (service request) → xử lý tại hub/kho (inbound/outbound) → vận tải liên hub (trip/route/container) → giao hàng last-mile (shipper tasks) → đối soát COD và theo dõi trạng thái.

README này mô tả cách chạy dự án, cấu trúc thư mục, phân hệ chức năng, cấu hình môi trường (MySQL/JWT/VNPAY), các trang giao diện JSP hiện có, và các script SQL có sẵn trong repo.

## Mục lục

- Tổng quan
- Ảnh demo giao diện
- Công nghệ
- Kiến trúc & cấu trúc thư mục
- Phân hệ chức năng theo vai trò
- Kịch bản demo nhanh (theo vai trò)
- Danh sách trang giao diện (JSP)
- Bảo mật & phân quyền
- Cấu hình môi trường
- Khởi tạo dữ liệu (SQL seed/test)
- Chạy dự án (Dev/Prod)
- Các URL/route thường dùng
- Uploads & static assets
- Troubleshooting

## Tổng quan

- Backend: Spring Boot (Spring MVC + Spring Data JPA/Hibernate)
- Frontend: JSP/JSTL + SiteMesh 3 (layout) + Bootstrap assets
- Security: Spring Security (Form Login cho Web) + JWT (cho API `/api/**`)
- Database: MySQL

Ứng dụng mặc định chạy ở cổng `9090` (có thể đổi qua biến môi trường).

## Ảnh demo giao diện

### Assets có sẵn trong repo

![Minh hoạ 1](src/main/resources/static/img/undraw_posting_photo.svg)

![Minh hoạ 2](src/main/resources/static/img/undraw_profile.svg)


```md
![Login](docs/screenshots/login.png)
![Admin Dashboard](docs/screenshots/admin-dashboard.png)
```

### Screenshot demo (đã được thêm vào repo)

![Demo 1](docs/screenshots/Screenshot%202026-01-07%20101530.png)

![Demo 2](docs/screenshots/Screenshot%202026-01-07%20101648.png)

![Demo 3](docs/screenshots/Screenshot%202026-01-07%20101714.png)

![Demo 4](docs/screenshots/Screenshot%202026-01-07%20101729.png)

![Demo 5](docs/screenshots/Screenshot%202026-01-07%20101821.png)

## Công nghệ

- Java 17
- Spring Boot `3.5.9`
- Maven (wrapper có sẵn `mvnw`, `mvnw.cmd`)
- MySQL Connector/J
- Lombok
- JSP engine (tomcat-embed-jasper) + JSTL
- SiteMesh 3.2.1
- Spring Security
- JWT: `io.jsonwebtoken (jjwt)`
- Apache POI (xuất/đọc Excel nếu project dùng ở một số báo cáo)

## Kiến trúc & cấu trúc thư mục

### Kiến trúc

- MVC cho web (JSP page controllers)
- REST API cho các thao tác AJAX hoặc client ngoài (đa số dưới `/api/**`)
- 3 tầng phổ biến:
    - Controller: nhận request, trả view hoặc JSON
    - Service: xử lý nghiệp vụ
    - Repository: truy cập DB qua JPA

### Cấu trúc thư mục chính

- `src/main/java/vn/web/logistic/`
    - `controller/`: web pages & REST controllers
    - `service/`: interface + `service/impl/`
    - `repository/`: Spring Data JPA repositories
    - `entity/`: JPA entities
    - `dto/`: request/response DTOs
    - `config/`: security, jwt, initializer, model advice...
    - `exception/`: `@RestControllerAdvice` xử lý lỗi API
- `src/main/resources/`
    - `application.properties`: cấu hình chung + env var mapping
    - `application-dev.properties`, `application-prod.properties`
    - `application-dev-local.properties.example`: mẫu override local
    - `META-INF/resources/WEB-INF/views/`: JSP views
    - `META-INF/resources/WEB-INF/decorators/`: SiteMesh layouts
    - `static/`: CSS/JS/vendor
- `uploads/`: thư mục upload runtime (cấu hình qua `APP_UPLOAD_DIR`)

## Phân hệ chức năng theo vai trò

Hệ thống có 4 vai trò chính: `ADMIN`, `STAFF` (bao gồm Manager/Hub), `SHIPPER`, `CUSTOMER`.

### Admin

- Dashboard & KPI/báo cáo (API dashboard)
- Quản lý hubs, routes, vehicles, drivers
- Quản lý service types
- Theo dõi chuyến (trip monitor)
- Quản lý COD/VNPAY transactions
- System log monitoring + cảnh báo rủi ro (risk)
- Quản lý users/roles + notifications

### Manager/Hub (thuộc nhóm STAFF)

- Dashboard thống kê theo hub
- Inbound:
    - nhận hàng drop-off / hub-in / shipper-in
    - scan-in
    - upload ảnh chứng từ (nếu có)
- Outbound:
    - gom đơn vào container (consolidation)
    - seal/reopen container
    - lập kế hoạch chuyến đi (trips)
    - loading/unloading container
    - gate-out / quản lý chuyến
- Last-mile:
    - phân công pickup/delivery tasks cho shipper
    - xác nhận giao hàng, báo delay
    - xử lý hàng hoàn/return
- Tài nguyên & theo dõi:
    - danh sách drivers/vehicles/shippers
    - tra cứu order/tracking
- Đối soát COD theo shipper

### Shipper

- Dashboard shipper
- Nhận danh sách đơn cần pickup/delivery
- Cập nhật trạng thái pickup/delivery
- Lịch sử giao hàng
- COD (nộp/đối soát)
- Earning/thu nhập (nếu có)
- Notifications
- Quản lý profile + đổi mật khẩu + avatar

### Customer

- Dashboard khách hàng
- Tạo đơn hàng (service request)
- Xem danh sách đơn + chi tiết đơn
- Hủy đơn (tùy trạng thái)
- Tracking đơn
- Quản lý địa chỉ (addresses) + set default
- Profile + avatar

## Kịch bản demo nhanh (theo vai trò)

Mục này giúp bạn demo nhanh theo đúng luồng nghiệp vụ “tạo đơn → xử lý hub → vận tải → giao last-mile → đối soát COD”. Tuỳ dữ liệu seed (SQL) mà màn hình/thống kê có thể khác nhau.

### 1) Demo Customer (tạo đơn + theo dõi)

1) Đăng nhập Customer → vào `/customer/dashboard`.
2) Vào trang tạo đơn (JSP có sẵn: `customer/new-order.jsp`).
3) Tạo đơn, kiểm tra danh sách đơn (`customer/orders.jsp`).
4) Vào chi tiết đơn (`customer/order-detail.jsp`) và theo dõi trạng thái (`customer/tracking.jsp`).

### 2) Demo Manager/Hub (inbound → outbound → last-mile)

1) Đăng nhập Manager/Staff → `/manager/dashboard`.
2) Inbound (nhận hàng/scan): nhóm trang trong `manager/inbound/`.
3) Outbound (gom container, lập chuyến, xuất cổng): nhóm trang trong `manager/outbound/`.
4) Last-mile (giao/hoàn/assign task): nhóm trang trong `manager/lastmile/`.
5) Theo dõi đơn theo hub (`manager/hub-orders.jsp`) và tra cứu tracking (`manager/tracking.jsp`).
6) COD settlement (nếu dữ liệu có) tại `manager/cod-settlement.jsp`.

### 3) Demo Shipper (nhận task + cập nhật trạng thái + COD)

1) Đăng nhập Shipper → `/shipper/dashboard`.
2) Xem danh sách đơn giao/nhận (`shipper/orders.jsp`) → vào chi tiết (`shipper/order-detail.jsp`).
3) Cập nhật tiến trình giao/nhận (một số trạng thái có thể nằm ở `shipper/delivering.jsp`).
4) Theo dõi lịch sử (`shipper/history.jsp`), COD (`shipper/cod.jsp`) và thu nhập (`shipper/earnings.jsp` nếu có dữ liệu).

### 4) Demo Admin (quản trị danh mục + theo dõi vận hành)

1) Đăng nhập Admin → `/admin/dashboard`.
2) Thiết lập danh mục: hubs/routes/vehicles/drivers/service types.
3) Theo dõi vận hành: trip monitor, reports, system logs, risk alerts.
4) Quản trị người dùng/role: `admin/staff-accounts.jsp`, `admin/role-management.jsp`.

## Bảo mật & phân quyền

### Web (JSP)

- Login page: `/login`, submit form: `/do-login`
- Logout: `/logout`
- Public pages: `/`, `/login`, `/forgot-password`, `/reset-password`, `/payment/**`
- Phân quyền theo path:
    - `/admin/**` → `ADMIN`
    - `/manager/**` → `ADMIN` hoặc `STAFF`
    - `/shipper/**` → `ADMIN` hoặc `SHIPPER`
    - `/customer/**` → `ADMIN` hoặc `CUSTOMER`
- Static assets được permit: `/css/**`, `/js/**`, `/vendor/**`, ...

### API (JSON)

- `Authorization: Bearer <token>`
- Public:
    - `/api/auth/**` (login/logout/validate)
    - `/api/public/**`
    - `/api/payment/**` (permitAll để VNPAY callback)
- Role-based:
    - `/api/admin/**` → `ADMIN`
    - `/api/shipper/**` → `ADMIN` hoặc `SHIPPER`
    - `/api/customer/**` → `ADMIN` hoặc `CUSTOMER`
    - `/api/staff/**` → `ADMIN` hoặc `STAFF`

## Cấu hình môi trường

### Profiles

- Mặc định: `dev` (xem `spring.profiles.default=dev` trong `application.properties`)
- Có thể đổi profile khi chạy bằng:
    - Biến môi trường: `SPRING_PROFILES_ACTIVE=prod`
    - Hoặc tham số JVM: `-Dspring.profiles.active=prod`

### Biến môi trường (khuyến nghị)

Các key cấu hình quan trọng trong `application.properties` đã hỗ trợ env var:

- `SERVER_PORT` (mặc định `9090`)
- `DB_URL` (mặc định: `jdbc:mysql://localhost:3306/logistic?...`)
- `DB_USERNAME` (mặc định `root`)
- `DB_PASSWORD`
- `APP_UPLOAD_DIR` (mặc định `uploads`)

- `JWT_SECRET` (dev có thể để trống; prod bắt buộc)
- `JWT_EXPIRATION` (mặc định `86400000` ms)

- `CORS_ALLOWED_ORIGINS` (mặc định `http://localhost:9090,http://localhost:3000`)

- `VNPAY_RETURN_URL`
- `VNPAY_TMN_CODE`
- `VNPAY_SECRET_KEY`
- (tùy chọn) `VNPAY_PAY_URL`, `VNPAY_API_URL`, `VNPAY_VERSION`, `VNPAY_COMMAND`, `VNPAY_ORDER_TYPE`

### Override local (không commit secrets)

- File mẫu: `src/main/resources/application-dev-local.properties.example`
- Cách dùng:
    - copy thành `src/main/resources/application-dev-local.properties`
    - chỉ dùng ở môi trường dev (được import từ `application-dev.properties`)

## Khởi tạo dữ liệu (SQL seed/test)

Repo có nhiều script SQL để seed dữ liệu nhanh trong MySQL:

- `seed_logistic.sql`: tạo DB `logistic` + xóa dữ liệu cũ + seed roles/users/hubs/staff/shippers/... và các bảng liên quan
- `logistic_db_test.sql`: bộ dữ liệu test theo schema hiện tại
- `manual_data_assign.sql`: tạo đơn mẫu và gán thủ công shipper task (hub 1)
- `test_assign_task.sql`: dữ liệu test phân công shipper (pickup/delivery) + summary queries
- `src/main/resources/data-*.sql`: các script nhỏ (action types/hub/shipper/cod test...)

Chạy seed bằng PowerShell (cần MySQL client):

```powershell
mysql -u root -p < .\seed_logistic.sql
```

Lưu ý về mật khẩu demo:

- Ứng dụng có `DataInitializer` tự tạo/cập nhật 4 demo users mỗi lần khởi động và đảm bảo password đúng theo BCrypt.
- Đây là cơ chế phục vụ demo/dev; khi deploy thực tế nên vô hiệu hóa hoặc giới hạn theo profile để tránh tự động ghi đè mật khẩu.
- Demo users mặc định:
    - Admin: `admin@logistic.local` / `admin123`
    - Staff: `staff01@logistic.local` / `staff123`
    - Shipper: `shipper01@logistic.local` / `shipper123`
    - Customer: `cust01@logistic.local` / `cust123`

Nếu bạn dùng seed SQL, app vẫn sẽ cập nhật lại `passwordHash` theo BCrypt cho các user demo trên khi app start.

## Chạy dự án

### Yêu cầu

- Java 17
- MySQL 8+ (khuyến nghị)
- Maven (có thể dùng Maven Wrapper đi kèm)

### Dev mode (profile `dev`)

1) Tạo DB `logistic` và seed dữ liệu (khuyến nghị):

```powershell
mysql -u root -p < .\seed_logistic.sql
```

2) Chạy ứng dụng:

```powershell
.\mvnw.cmd spring-boot:run
```

3) Mở trình duyệt:

- `http://localhost:9090/`

### Build jar và chạy

```powershell
.\mvnw.cmd clean package
java -jar .\target\logistic-0.0.1-SNAPSHOT.jar
```

### Prod profile

Trong `prod`, JPA dùng `ddl-auto=validate` (không tự thay đổi schema). Bạn cần chuẩn bị schema/DB đúng trước khi chạy.

Ví dụ chạy:

```powershell
$env:SPRING_PROFILES_ACTIVE='prod'
$env:JWT_SECRET='a-very-long-random-secret'
.\mvnw.cmd spring-boot:run
```

## Các URL/route thường dùng

### Web pages

- `/login` (đăng nhập)
- `/access-denied` (403)
- `/forgot-password`, `/reset-password`

- `/admin/dashboard`
- `/manager/dashboard`
- `/shipper/dashboard`
- `/customer/dashboard`

## Danh sách trang giao diện (JSP)

Danh sách này phản ánh các file JSP hiện có trong repo (đường dẫn: `src/main/resources/META-INF/resources/WEB-INF/views/`). Route controller tương ứng có thể map khác nhau tuỳ cấu hình, nhưng các trang dưới đây là “nguồn sự thật” về UI.

### Public/Auth

- `login.jsp`
- `forgot-password.jsp`
- `reset-password.jsp`
- `access-denied.jsp`
- `payment/vnpay-result.jsp`

### Admin pages (thư mục `views/admin/`)

- `dashboard.jsp`
- `hub-management.jsp`, `route-management.jsp`
- `vehicle-management.jsp`, `driver-management.jsp`, `container-management.jsp`, `trip-monitor.jsp`
- `cod-management.jsp`, `reconciliation_vnpay.jsp`
- `service-type-config.jsp`, `order-status-config.jsp`
- `staff-accounts.jsp`, `role-management.jsp`
- `reports.jsp`, `system-logs.jsp`, `risk-alerts.jsp`, `notifications.jsp`

### Manager pages (thư mục `views/manager/`)

- `dashboard.jsp`, `hub-orders.jsp`, `tracking.jsp`
- Inbound: `inbound/drop-off.jsp`, `inbound/hub-in.jsp`, `inbound/shipper-in.jsp`, `inbound/scan-in.jsp`, `inbound/print-label.jsp`
- Outbound: `outbound/consolidate.jsp`, `outbound/loading.jsp`, `outbound/gate-out.jsp`, `outbound/trip-planning.jsp`, `outbound/trip-management.jsp`
- Last-mile: `lastmile/assign-task.jsp`, `lastmile/confirm-delivery.jsp`, `lastmile/counter-pickup.jsp`, `lastmile/return-shop.jsp`, `lastmile/return-goods.jsp`
- Resource: `resource/resource-management.jsp`

### Shipper pages (thư mục `views/shipper/`)

- `dashboard.jsp`, `orders.jsp`, `order-detail.jsp`, `delivering.jsp`
- `history.jsp`, `cod.jsp`, `earnings.jsp`
- `notifications.jsp`, `profile.jsp`, `layout.jsp`

### Customer pages (thư mục `views/customer/`)

- `dashboard.jsp`, `new-order.jsp`, `orders.jsp`, `order-detail.jsp`
- `tracking.jsp`, `addresses.jsp`, `profile.jsp`

### API

- Auth:
    - `POST /api/auth/login`
    - `POST /api/auth/logout`
    - `GET  /api/auth/validate`

- Payment (VNPAY):
    - `GET /api/payment/vnpay/create-payment-url`
    - `GET /api/payment/vnpay/ipn`
    - `GET /api/payment/vnpay/check-status`
    - Web return page: `/payment/vnpay/return`

- Manager (một phần):
    - `/api/manager/inbound/**`
    - `/api/manager/outbound/**`
    - `/api/manager/lastmile/**`
    - `/api/manager/cod/**`
    - `/api/manager/tasks/**`

- Admin (một phần):
    - `/api/admin/dashboard/**`
    - `/api/admin/hubs/**`
    - `/api/admin/routes/**`
    - `/api/admin/vehicles/**`
    - `/api/admin/drivers/**`
    - `/api/system-log/monitoring/**`

## Uploads & static assets

- Upload directory mặc định: `uploads/` (có thể đổi qua `APP_UPLOAD_DIR`)
- Static assets: `src/main/resources/static/`
- JSP views nằm ở: `src/main/resources/META-INF/resources/WEB-INF/views/`
- SiteMesh layouts ở: `src/main/resources/META-INF/resources/WEB-INF/decorators/`

## Troubleshooting

- Không connect được DB:
    - kiểm tra `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`
    - kiểm tra MySQL đang chạy và schema `logistic` tồn tại

- Token JWT bị đổi sau restart (dev):
    - set `JWT_SECRET` trong env hoặc `application-dev-local.properties` để ổn định key

- Prod bị lỗi khi start vì thiếu JWT secret:
    - `JWT_SECRET` bắt buộc trong profile `prod`

- Port bị trùng:
    - set `SERVER_PORT` sang giá trị khác

## Tác giả

- Dự án Đồ án Lập trình Web - HCMUTE
- Le Huu Van
- Phan Phuc Hau
- Pham Hoai Nam
- Ha Truong Giang

