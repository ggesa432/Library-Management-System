package com.synergisticit.controller;

import com.synergisticit.dto.BookDTO;
import com.synergisticit.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping
    public ResponseEntity<List<BookDTO>> getAllBooks() {
        List<BookDTO> books = bookService.getAllBooks();
        return ResponseEntity.ok(books);
    }

    @GetMapping("/{id}")
    public ResponseEntity<BookDTO> getBookById(@PathVariable("id") Integer bookId) {
        BookDTO book = bookService.getBookById(bookId);
        return ResponseEntity.ok(book);
    }

    @GetMapping("/search")
    public ResponseEntity<List<BookDTO>> searchBooks(@RequestParam("term") String searchTerm) {
        try {
            List<BookDTO> books = bookService.searchBooks(searchTerm);
            return ResponseEntity.ok(books);
        } catch (Exception e) {
            System.err.println("Error in search endpoint: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    public ResponseEntity<BookDTO> addBook(@RequestBody BookDTO bookDTO, Authentication authentication) {
        // Check if the user has the appropriate role
        if (!hasLibrarianOrAdminRole(authentication)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        BookDTO createdBook = bookService.addBook(bookDTO);
        return new ResponseEntity<>(createdBook, HttpStatus.CREATED);
    }
    private boolean hasLibrarianOrAdminRole(Authentication authentication) {
        return authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_LIBRARIAN") ||
                        a.getAuthority().equals("ROLE_ADMIN"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<BookDTO> updateBook(
            @PathVariable("id") Integer bookId,
            @RequestBody BookDTO bookDTO) {
        BookDTO updatedBook = bookService.updateBook(bookId, bookDTO);
        return ResponseEntity.ok(updatedBook);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable("id") Integer bookId) {
        bookService.deleteBook(bookId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/available")
    public ResponseEntity<Integer> getAvailableCopies(@PathVariable("id") Integer bookId) {
        int availableCopies = bookService.getAvailableCopies(bookId);
        return ResponseEntity.ok(availableCopies);
    }
}