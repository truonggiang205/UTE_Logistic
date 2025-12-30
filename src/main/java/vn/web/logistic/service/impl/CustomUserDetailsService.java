package vn.web.logistic.service.impl;

import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.web.logistic.entity.User;
import vn.web.logistic.repository.UserRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {

        @Autowired
        private UserRepository userRepository;

        @Override
        @Transactional
        public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
                // Tìm user bằng email (dùng email làm identifier chính cho đăng nhập)
                User user = userRepository.findByEmail(email)
                                .orElseThrow(() -> new UsernameNotFoundException(
                                                "Không tìm thấy người dùng với email: " + email));

                // Check if user is active
                if (user.getStatus() != User.UserStatus.active) {
                        throw new UsernameNotFoundException("Tài khoản không hoạt động: " + email);
                }

                Set<GrantedAuthority> authorities = user.getRoles().stream()
                                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getRoleName()))
                                .collect(Collectors.toSet());

                // Sử dụng email làm username trong Spring Security
                return org.springframework.security.core.userdetails.User
                                .withUsername(user.getEmail())
                                .password(user.getPasswordHash())
                                .authorities(authorities)
                                .accountExpired(false)
                                .accountLocked(user.getStatus() == User.UserStatus.banned)
                                .credentialsExpired(false)
                                .disabled(user.getStatus() == User.UserStatus.inactive)
                                .build();
        }

        /**
         * Load user by user ID
         */
        @Transactional
        public UserDetails loadUserById(Long userId) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new UsernameNotFoundException("User not found with id: " + userId));

                Set<GrantedAuthority> authorities = user.getRoles().stream()
                                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getRoleName()))
                                .collect(Collectors.toSet());

                return org.springframework.security.core.userdetails.User
                                .withUsername(user.getUsername())
                                .password(user.getPasswordHash())
                                .authorities(authorities)
                                .build();
        }
}
