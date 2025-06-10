package com.synergisticit.config;

import com.synergisticit.component.CustomLoginSuccessHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/15/2025
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Autowired
    private CustomLoginSuccessHandler loginSuccessHandler;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/login", "/register", "/WEB-INF/views/**").permitAll()
                        .requestMatchers("/api/users/register").permitAll()
                        // Profile access for authenticated users
                        .requestMatchers("/profile").authenticated()
                        .requestMatchers("/api/users/profile", "/api/users/change-password").authenticated()

                        // READ-only endpoints for regular users
                        .requestMatchers(HttpMethod.GET, "/api/books", "/api/books/**").hasAnyRole("USER", "LIBRARIAN", "ADMIN")
                        .requestMatchers("/books").hasAnyRole("USER", "LIBRARIAN", "ADMIN")
                        // WRITE endpoints for librarians and admins only
                        .requestMatchers(HttpMethod.POST, "/api/books").hasAnyRole("LIBRARIAN", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/books/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/books/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        .requestMatchers("/books/add", "/books/edit/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        // Transaction operations for librarians and admins
                        .requestMatchers("/transactions/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        .requestMatchers("/api/transactions/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        // Member endpoints
                        .requestMatchers("/api/members/**").hasAnyRole("LIBRARIAN", "ADMIN")
                        // Admin-only access
                        .requestMatchers("/api/users/**").hasRole("ADMIN")
                        .requestMatchers("/users/**").hasRole("ADMIN")
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/", true)
                        .successHandler(loginSuccessHandler)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll()
                );

        return http.build();
    }
}
