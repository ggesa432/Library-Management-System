package com.synergisticit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/books")
    public String bookList() {
        return "bookList";
    }

    @GetMapping("/books/add")
    public String addBook() {
        return "addBook";
    }

    @GetMapping("/books/edit")
    public String editBook() {
        return "editBook";
    }

    @GetMapping("/users")
    public String userList() {
        return "userList";
    }

    @GetMapping("/users/register")
    public String register() {
        return "register";
    }

    @GetMapping("/users/edit")
    public String editUser() {
        return "editUser";
    }
    @GetMapping("/books/view")
    public String viewBook() {
        return "viewBook";
    }

    @GetMapping("/users/view")
    public String viewUser() {
        return "viewUser";
    }

    @GetMapping("/transactions")
    public String transactions() {
        return "transactions";
    }

    @GetMapping("/transactions/borrow")
    public String borrowBook() {
        return "borrowBook";
    }

    @GetMapping("/members")
    public String listMembers() {
        return "memberList";
    }

    @GetMapping("/members/add")
    public String addMember() {
        return "addMember";
    }

    @GetMapping("/members/edit")
    public String editMember() {
        return "editMember";
    }

    @GetMapping("/members/view")
    public String viewMember() {
        return "viewMember";
    }

    @GetMapping("/profile")
    public String profile() {
        return "profile";
    }

    // New mapping for fines page
    @GetMapping("/fines")
    @PreAuthorize("hasAnyRole('LIBRARIAN', 'ADMIN')")
    public String fines() {
        return "fines";
    }


}
