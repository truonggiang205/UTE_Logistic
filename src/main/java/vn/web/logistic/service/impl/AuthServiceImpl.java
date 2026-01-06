package vn.web.logistic.service.impl;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import vn.web.logistic.config.JwtTokenProvider;
import vn.web.logistic.dto.request.LoginRequest;
import vn.web.logistic.dto.request.RegisterRequest;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.Customer.CustomerStatus;
import vn.web.logistic.entity.Customer.CustomerType;
import vn.web.logistic.entity.CustomerAddress;
import vn.web.logistic.entity.Role;
import vn.web.logistic.entity.SystemLog;
import vn.web.logistic.entity.User.UserStatus;
import vn.web.logistic.repository.CustomerAddressRepository;
import vn.web.logistic.repository.CustomerRepository;
import vn.web.logistic.repository.RoleRepository;
import vn.web.logistic.repository.SystemLogRepository;
import vn.web.logistic.repository.UserRepository;
import vn.web.logistic.service.AuthService;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
        private final UserRepository userRepository;
        private final CustomerRepository customerRepository;
        private final CustomerAddressRepository addressRepository;
        private final RoleRepository roleRepository;
        private final PasswordEncoder passwordEncoder; // PasswordEncoder có sẵn từ Spring Security
        private final JwtTokenProvider jwtTokenProvider;
        private final SystemLogRepository systemLogRepository;

        @Override
        @Transactional
        public void register(RegisterRequest dto) {
                // 1. Tự động tạo Username theo cấu trúc US + 6 số ngẫu nhiên
                String generatedUsername = "US" + String.format("%06d", new Random().nextInt(1000000));

                // 2. Tự động tạo Email tạm thời theo cấu trúc ngẫu nhiên + @nghv.io
                String tempEmail = UUID.randomUUID().toString().substring(0, 8) + "@nghv.io";

                // 3. Tạo User (Để fullName là null để làm dấu hiệu chưa hoàn thiện)
                vn.web.logistic.entity.User user = vn.web.logistic.entity.User.builder()
                                .username(generatedUsername)
                                .passwordHash(passwordEncoder.encode(dto.getPassword()))
                                .phone(dto.getPhone()) // SĐT dùng để đăng nhập
                                .email(tempEmail)
                                .fullName(null) // Chưa có họ tên admin
                                .status(UserStatus.active) // Kích hoạt ngay
                                .createdAt(LocalDateTime.now())
                                .build();

                Role userRole = roleRepository.findByRoleName("CUSTOMER")
                                .orElseThrow(() -> new RuntimeException("Lỗi: Không tìm thấy Role CUSTOMER"));
                user.setRoles(Collections.singleton(userRole));
                userRepository.save(user);

                // 4. Tạo Customer gắn với User vừa tạo
                Customer customer = Customer.builder()
                                .user(user)
                                .businessName(dto.getBusinessName())
                                .phone(dto.getPhone())
                                .customerType(CustomerType.business)
                                .status(CustomerStatus.active)
                                .createdAt(LocalDateTime.now())
                                .build();
                customerRepository.save(customer);

                Customer savedCustomer = customerRepository.save(customer);

                // 3. Tạo Địa chỉ lấy hàng mặc định
                CustomerAddress address = CustomerAddress.builder()
                                .customer(savedCustomer)
                                .addressDetail(dto.getAddressDetail())
                                .ward(dto.getWard())
                                .district(dto.getDistrict())
                                .province(dto.getProvince())
                                .contactName(dto.getFullName())
                                .contactPhone(dto.getPhone())
                                .isDefault(true) // Đây là địa chỉ mặc định của Shop
                                .build();
                addressRepository.save(address);
        }

        @Override
        @Transactional
        public String login(LoginRequest dto) {
                // Tìm user bằng identifier (SĐT)
                vn.web.logistic.entity.User user = userRepository.findByIdentifier(dto.getIdentifier())
                                .orElseThrow(() -> new RuntimeException("Tài khoản không tồn tại!"));

                if (!passwordEncoder.matches(dto.getPassword(), user.getPasswordHash())) {
                        throw new RuntimeException("Mật khẩu không chính xác!");
                }

                // Lấy danh sách quyền hạn
                List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                                .map(role -> new SimpleGrantedAuthority(role.getRoleName()))
                                .collect(Collectors.toList());

                // FIX LỖI: Tạo đối tượng UserDetails thay vì truyền String username
                User userPrincipal = new User(user.getUsername(), user.getPasswordHash(), authorities);

                Authentication authentication = new UsernamePasswordAuthenticationToken(
                                userPrincipal, // Truyền UserDetails vào đây
                                null,
                                authorities);

                String token = jwtTokenProvider.generateToken(authentication);

                // Ghi log đăng nhập thành công
                SystemLog loginLog = SystemLog.builder()
                                .user(user)
                                .action("LOGIN")
                                .objectType("USER")
                                .objectId(user.getUserId())
                                .logTime(LocalDateTime.now())
                                .build();
                systemLogRepository.save(loginLog);

                return token;
        }

        @Override
        @Transactional
        public void logout(String token) {
                // Lấy thông tin user trước khi clear context
                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                if (auth != null && auth.getName() != null) {
                        vn.web.logistic.entity.User user = userRepository.findByIdentifier(auth.getName()).orElse(null);
                        if (user != null) {
                                // Ghi log đăng xuất
                                SystemLog logoutLog = SystemLog.builder()
                                                .user(user)
                                                .action("LOGOUT")
                                                .objectType("USER")
                                                .objectId(user.getUserId())
                                                .logTime(LocalDateTime.now())
                                                .build();
                                systemLogRepository.save(logoutLog);
                        }
                }
                // Clear security context
                SecurityContextHolder.clearContext();
        }

        @Override
        public String getRedirectUrlByRole(String identifier) {
                vn.web.logistic.entity.User user = userRepository.findByIdentifier(identifier).orElse(null);
                if (user == null) {
                        return "/auth/login";
                }

                java.util.Set<Role> roles = user.getRoles();
                if (roles == null || roles.isEmpty()) {
                        return "/customer/overview"; // Mặc định cho customer
                }

                // Kiểm tra role theo thứ tự ưu tiên: Admin > Staff > Shipper > Customer
                for (Role role : roles) {
                        String roleName = role.getRoleName();
                        switch (roleName) {
                                case "ROLE_ADMIN":
                                        return "/admin/dashboard";
                                case "ROLE_STAFF":
                                        return "/manager/dashboard"; // Staff sử dụng trang manager
                                case "ROLE_SHIPPER":
                                        return "/shipper/dashboard";
                                case "ROLE_CUSTOMER":
                                        return "/customer/overview";
                        }
                }

                return "/customer/overview"; // Fallback
        }

        @Override
        public boolean isPhoneRegistered(String phone) {
                return userRepository.existsByPhone(phone);
        }
}
