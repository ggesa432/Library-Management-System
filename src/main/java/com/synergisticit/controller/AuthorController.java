package com.synergisticit.controller;

import com.synergisticit.domain.Author;
import com.synergisticit.service.AuthorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/authors")
public class AuthorController {

    @Autowired
    private AuthorService authorService;

    @GetMapping
    public ResponseEntity<List<Author>> getAllAuthors() {
        List<Author> authors = authorService.getAllAuthors();
        return ResponseEntity.ok(authors);
    }

    @PostMapping
    public ResponseEntity<?> createAuthor(@RequestBody Author author) {
        try {
            Author savedAuthor = authorService.saveAuthor(author);
            return new ResponseEntity<>(savedAuthor, HttpStatus.CREATED);
        } catch (Exception e) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error creating author: " + e.getMessage());
        }
    }


}