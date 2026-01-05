# Hệ thống Quản lý Logistics (Logistics Management System)

!"Ảnh trang chủ"

## Giới thiệu (Introduction)
Đây là hệ thống quản lý logistics toàn diện, được xây dựng nhằm giải quyết bài toán vận hành của một công ty giao nhận. Hệ thống bao phủ quy trình từ lúc khách hàng tạo đơn, xử lý tại kho (Hub), đóng bao, điều phối xe tải, cho đến khi giao hàng thành công (Last-mile delivery).

Dự án tập trung mạnh vào việc số hóa quy trình nghiệp vụ nội bộ và tích hợp thanh toán điện tử.

## Tính năng nổi bật (Key Features)

Hệ thống phân quyền chặt chẽ cho 4 đối tượng: **Admin, Manager (Quản lý Hub), Shipper, và Customer.**

### 1. Phân hệ Quản trị (Admin Dashboard)
* **Quản lý rủi ro & Hệ thống:**
    * **Cảnh báo rủi ro (Risk Alert):** Phát hiện các dấu hiệu bất thường trong vận hành.
    * **System Log:** Ghi vết toàn bộ hoạt động hệ thống để audit.
* **Quản lý Tài chính:**
    * Tích hợp cổng thanh toán **VNPay**.
    * Quản lý và đối soát tiền thu hộ (COD).
* **Quản lý Tài nguyên:** Quản lý đội xe, tài xế, và cấu hình các loại dịch vụ vận chuyển.
* **Báo cáo:** Xuất báo cáo doanh thu và hiệu suất vận hành.

### 2. Phân hệ Vận hành Kho (Manager/Hub)
Đây là phân hệ xử lý nghiệp vụ phức tạp nhất:
* **Quy trình Đóng gói & Trung chuyển:**
    * **Quản lý Đóng bao (Consolidation):** Gom các đơn hàng lẻ vào bao lớn để vận chuyển.
    * **Xếp bao lên xe:** Quản lý việc chất hàng lên xe tải theo chuyến.
    * **Nhận đơn từ Hub khác:** Xử lý hàng luân chuyển giữa các kho.
* **Điều phối & Vận tải:**
    * **Điều phối xe:** Phân công xe và tài xế cho các tuyến đường.
    * Quản lý xuất bến và theo dõi chuyến xe.
* **Xử lý đơn hàng:** Tạo đơn tại quầy, Tra cứu vận đơn chi tiết.

### 3. Phân hệ Khách hàng & Shipper
* **Customer:** Tra cứu giá cước, theo dõi hành trình đơn hàng (Tracking), xem lịch sử đơn.
* **Shipper:** App/Giao diện nhận đơn giao, cập nhật trạng thái giao hàng, hoàn tất đối soát.

## 🛠 Công nghệ sử dụng (Tech Stack)

Dự án được xây dựng theo mô hình **MVC** với **Kiến trúc 3 tầng** (3-Tier Architecture):

### Backend
* **Language:** Java
* **Framework:** Spring Boot
* **Database Access:** Spring Data JPA & Hibernate
* **Security:** Spring Security + JSON Web Token (JWT)
* **Database:** MySQL

### Frontend
* **View Engine:** JavaServer Pages (JSP) & JSTL
* **Layout:** Sitemesh 3
* **UI Framework:** Bootstrap CSS

## 🗂 Thiết kế Hệ thống (System Design)
* **Mô hình dữ liệu:**
  <img width="2782" height="2409" alt="Untitled" src="https://github.com/user-attachments/assets/c6e12b46-f365-4304-a7d4-706b1cb0f392" />


* **Kiến trúc:** Mô hình MVC kết hợp RESTful API cho giao tiếp mobile/client.

## 👨‍💻 Tác giả
* Dự án Đồ án Lập trình Web - HCMUTE
* **Le Huu Van**
* **Phan Phuc Hau**
* **Pham Hoai Nam**
* **Ha Truong Giang**

