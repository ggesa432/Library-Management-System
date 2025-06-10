package com.synergisticit.component;

import com.synergisticit.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDate;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Component
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws ServletException, IOException {

        // Get the logged-in username
        String username = authentication.getName();

        // Update last login date
        userRepository.findByUsername(username).ifPresent(user -> {
            user.setLastLoginDate(LocalDate.now());
            userRepository.save(user);
        });

        // Continue with the default success handler behavior
        super.onAuthenticationSuccess(request, response, authentication);
    }
}
