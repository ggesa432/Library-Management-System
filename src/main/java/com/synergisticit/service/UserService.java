package com.synergisticit.service;

import com.synergisticit.domain.Member;
import com.synergisticit.domain.User;
import com.synergisticit.dto.UserDTO;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.MemberRepository;
import com.synergisticit.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;


import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;


@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<UserDTO> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserDTO getUserById(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        return convertToDTO(user);
    }

    @Transactional(readOnly = true)
    public UserDTO getUserByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));
        return convertToDTO(user);
    }

    @Transactional
    public UserDTO registerUser(UserDTO userDTO) {
        // Check if username or email already exists
        if (userRepository.existsByUsername(userDTO.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        if (userRepository.existsByEmail(userDTO.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = convertToEntity(userDTO);

        // Set registration date
        user.setRegistrationDate(LocalDateTime.now());

        // Default role if not specified
        if (user.getRole() == null) {
            user.setRole("USER");
        }

        // Hash password
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        User savedUser = userRepository.save(user);

        // Create Member entity if it's a regular user
        if ("USER".equals(user.getRole())) {
            Member member = new Member();
            member.setFirstName(user.getFirstName());
            member.setLastName(user.getLastName());
            member.setAddress(user.getAddress());
            member.setPhone(user.getPhone());
            member.setEmail(user.getEmail());
            member.setMembershipDate(LocalDate.now());
            member.setUser(savedUser);

            Member savedMember = memberRepository.save(member);

            // Update bidirectional relationship
            savedUser.setMember(savedMember);
            userRepository.save(savedUser);
        }

        return convertToDTO(savedUser);
    }

    @Transactional
    public UserDTO updateUser(Integer userId, UserDTO userDTO) {
        User existingUser = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        // Check if email is being changed and if it already exists
        if (!existingUser.getEmail().equals(userDTO.getEmail()) &&
                userRepository.existsByEmail(userDTO.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }

        // Update fields
        existingUser.setFirstName(userDTO.getFirstName());
        existingUser.setLastName(userDTO.getLastName());
        existingUser.setEmail(userDTO.getEmail());
        existingUser.setPhone(userDTO.getPhone());
        existingUser.setAddress(userDTO.getAddress());
        existingUser.setDateOfBirth(userDTO.getDateOfBirth());

        // Update password if provided
        if (userDTO.getPassword() != null && !userDTO.getPassword().isEmpty()) {
            existingUser.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        }

        User updatedUser = userRepository.save(existingUser);

        // Update related Member if exists
        if (updatedUser.getMember() != null) {
            Member member = updatedUser.getMember();
            member.setFirstName(updatedUser.getFirstName());
            member.setLastName(updatedUser.getLastName());
            member.setAddress(updatedUser.getAddress());
            member.setPhone(updatedUser.getPhone());
            member.setEmail(updatedUser.getEmail());

            memberRepository.save(member);
        }

        return convertToDTO(updatedUser);
    }

    @Transactional
    public void deleteUser(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        // Check if user has associated member with ongoing transactions
        if (user.getMember() != null) {
            // Logic to check for active transactions
            // For now, we'll just delete the user
        }

        userRepository.deleteById(userId);
    }

    @Transactional
    public void updateLastLogin(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        user.setLastLoginDate(LocalDate.now());
        userRepository.save(user);
    }

    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setUserId(user.getUserId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFirstName(user.getFirstName());
        dto.setLastName(user.getLastName());
        dto.setPhone(user.getPhone());
        dto.setAddress(user.getAddress());
        dto.setDateOfBirth(user.getDateOfBirth());
        dto.setRegistrationDate(user.getRegistrationDate());
        dto.setRole(user.getRole());
        dto.setActive(user.getActive());
        dto.setLastLoginDate(user.getLastLoginDate());

        if (user.getMember() != null) {
            dto.setMemberId(user.getMember().getMemberId());
        }

        return dto;
    }

    private User convertToEntity(UserDTO dto) {
        User user = new User();

        // Don't set ID for new users
        if (dto.getUserId() != null) {
            user.setUserId(dto.getUserId());
        }

        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword()); // Will be encoded in service methods
        user.setEmail(dto.getEmail());
        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setPhone(dto.getPhone());
        user.setAddress(dto.getAddress());
        user.setDateOfBirth(dto.getDateOfBirth());
        user.setRole(dto.getRole());
        user.setActive(dto.getActive() != null ? dto.getActive() : true);

        return user;
    }

    @Transactional
    public void changePassword(String username, String currentPassword, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with username: " + username));

        // Check current password
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        // Update to new password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }


}