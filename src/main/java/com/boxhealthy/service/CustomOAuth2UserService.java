package com.boxhealthy.service;

import com.boxhealthy.entity.Role;
import com.boxhealthy.entity.User;
import com.boxhealthy.repository.UserRepository;
import jakarta.transaction.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final DefaultOAuth2UserService delegate = new DefaultOAuth2UserService();

    public CustomOAuth2UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oauthUser = delegate.loadUser(userRequest);
        String email = oauthUser.getAttribute("email");
        String fullName = oauthUser.getAttribute("name");

        if (email == null || email.isBlank()) {
            throw new OAuth2AuthenticationException("Tai khoan Google khong co email.");
        }

        User user = userRepository.findByEmail(email)
                .orElseGet(() -> createGoogleUser(email, fullName));

        if ((user.getFullName() == null || user.getFullName().isBlank())
                && fullName != null && !fullName.isBlank()) {
            user.setFullName(fullName);
            user = userRepository.save(user);
        }

        Map<String, Object> attributes = new HashMap<>(oauthUser.getAttributes());
        attributes.put("appUserId", user.getId());
        attributes.put("appRole", user.getRole().name());

        return new DefaultOAuth2User(
                List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name())),
                attributes,
                "email");
    }

    private User createGoogleUser(String email, String fullName) {
        User user = new User();
        user.setEmail(email);
        user.setFullName((fullName == null || fullName.isBlank()) ? email : fullName);
        user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
        user.setRole(Role.CUSTOMER);
        user.setEnabled(true);
        return userRepository.save(user);
    }
}
