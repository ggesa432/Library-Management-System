package com.synergisticit.controller;

import com.synergisticit.domain.Member;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.domain.User;
import com.synergisticit.repository.UserRepository;
import com.synergisticit.service.MemberService;
import com.synergisticit.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/24/2025
 */
@RestController
@RequestMapping("/api/members")
public class MemberController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<Member>> getAllMembers() {
        List<Member> members = memberService.getAllMembers();
        return ResponseEntity.ok(members);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Member> getMemberById(@PathVariable Integer id) {
        try {
            Member member = memberService.getMemberById(id);
            return ResponseEntity.ok(member);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/search")
    public ResponseEntity<List<Member>> searchMembers(@RequestParam(required = false) String query) {
        List<Member> members = memberService.searchMembers(query);
        return ResponseEntity.ok(members);
    }

    @GetMapping("/{id}/overdue")
    public ResponseEntity<Map<String, Boolean>> checkOverdueBooks(@PathVariable Integer id) {
        Map<String, Boolean> response = new HashMap<>();
        response.put("hasOverdueBooks", memberService.hasMemberOverdueBooks(id));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}/active-borrowings")
    public ResponseEntity<Map<String, Integer>> getActiveBorrowings(@PathVariable Integer id) {
        Map<String, Integer> response = new HashMap<>();
        response.put("activeBorrowings", memberService.getActiveBorrowingsCount(id));
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<Member> createMember(@RequestBody Member member) {
        Member createdMember = memberService.createMember(member);
        return new ResponseEntity<>(createdMember, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Member> updateMember(@PathVariable Integer id, @RequestBody Member memberDetails) {
        try {
            Member updatedMember = memberService.updateMember(id, memberDetails);
            return ResponseEntity.ok(updatedMember);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteMember(@PathVariable Integer id) {
        try {
            memberService.deleteMember(id);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Member deleted successfully");
            return ResponseEntity.ok(response);
        } catch (ResourceNotFoundException e) {
            System.err.println("Member not found: " + e.getMessage());
            return ResponseEntity.notFound().build();
        } catch (IllegalStateException e) {
            System.err.println("Cannot delete member due to constraints: " + e.getMessage());
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            System.err.println("Unexpected error deleting member: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("error", "An unexpected error occurred: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/current")
    public ResponseEntity<Member> getCurrentMember(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String username = principal.getName();
        Optional<User> user = userRepository.findByUsername(username);

        if (user.isPresent() && user.get().getMember() != null) {
            return ResponseEntity.ok(user.get().getMember());
        }

        return ResponseEntity.notFound().build();
    }
}
