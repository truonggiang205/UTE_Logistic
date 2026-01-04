-- =============================================
-- FILE: check-manager-staff.sql
-- KIỂM TRA VÀ SỬA DỮ LIỆU STAFF CHO MANAGER
-- =============================================

USE logistic;

-- BƯỚC 1: Xem tất cả user có role STAFF
SELECT 
    u.user_id, 
    u.email, 
    u.full_name,
    r.role_name,
    s.staff_id,
    s.hub_id,
    h.hub_name
FROM USERS u
JOIN USER_ROLES ur ON u.user_id = ur.user_id
JOIN ROLES r ON ur.role_id = r.role_id
LEFT JOIN STAFF s ON u.user_id = s.user_id
LEFT JOIN HUBS h ON s.hub_id = h.hub_id
WHERE r.role_name = 'STAFF';

-- BƯỚC 2: Xem tất cả Hub
SELECT hub_id, hub_name, district, province FROM HUBS;

-- BƯỚC 3: Nếu Staff chưa có Hub, sửa như sau (thay hub_id phù hợp):
-- UPDATE STAFF SET hub_id = 1 WHERE staff_id = 1;

-- BƯỚC 4: Kiểm tra đơn hàng pending cần lấy (pickup)
SELECT 
    r.request_id, 
    r.status, 
    pa.district as pickup_district,
    r.current_hub_id,
    'Cần pickup' as note
FROM SERVICE_REQUESTS r
LEFT JOIN CUSTOMER_ADDRESSES pa ON r.pickup_address_id = pa.address_id
WHERE r.status = 'pending'
  AND NOT EXISTS (
      SELECT 1 FROM SHIPPER_TASKS t 
      WHERE t.request_id = r.request_id 
        AND t.taskType = 'pickup' 
        AND t.taskStatus IN ('assigned', 'in_progress')
  );

-- BƯỚC 5: Kiểm tra đơn hàng cần giao (delivery)
SELECT 
    r.request_id, 
    r.status, 
    r.current_hub_id,
    da.district as delivery_district,
    'Cần delivery' as note
FROM SERVICE_REQUESTS r
LEFT JOIN CUSTOMER_ADDRESSES da ON r.delivery_address_id = da.address_id
WHERE r.current_hub_id IS NOT NULL
  AND r.status IN ('picked', 'in_transit')
  AND NOT EXISTS (
      SELECT 1 FROM SHIPPER_TASKS t 
      WHERE t.request_id = r.request_id 
        AND t.taskType = 'delivery' 
        AND t.taskStatus IN ('assigned', 'in_progress')
  );

-- BƯỚC 6: Kiểm tra shipper active trong Hub
SELECT 
    s.shipper_id, 
    u.full_name, 
    s.hub_id, 
    s.status
FROM SHIPPERS s
JOIN USERS u ON s.user_id = u.user_id
WHERE s.status IN ('active', 'busy');
