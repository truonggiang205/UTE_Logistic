package vn.web.logistic.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;

@Service
@Primary
public class UserDetailsServiceImpl implements UserDetailsService {

        @Autowired
        private UserRepository userRepository;

        @Override
        @Transactional(readOnly = true)
        public UserDetails loadUserByUsername(String identifier) throws UsernameNotFoundException {
                // Sử dụng findByIdentifier để tìm được cả Mã US (từ Token) và SĐT/Email (từ
                // Login)
                User user = userRepository.findByIdentifier(identifier)
                                .orElseThrow(() -> new UsernameNotFoundException(
                                                "Không tìm thấy người dùng: " + identifier));

                // Thêm prefix "ROLE_" để Spring Security hasRole() hoạt động đúng
                // DB lưu "ADMIN" -> authority "ROLE_ADMIN"
                List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getRoleName()))
                                .collect(Collectors.toList());

                return org.springframework.security.core.userdetails.User.builder()
                                .username(user.getUsername()) // Luôn dùng Mã US (USxxxxx) làm định danh chính
                                .password(user.getPasswordHash())
                                .authorities(authorities)
                                .build();
        }
}