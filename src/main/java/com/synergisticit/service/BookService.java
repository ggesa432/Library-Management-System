package com.synergisticit.service;

import com.synergisticit.domain.Author;
import com.synergisticit.domain.Book;
import com.synergisticit.domain.Publisher;
import com.synergisticit.dto.BookDTO;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.AuthorRepository;
import com.synergisticit.repository.BookRepository;
import com.synergisticit.repository.PublisherRepository;
import com.synergisticit.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private AuthorRepository authorRepository;

    @Autowired
    private PublisherRepository publisherRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Transactional(readOnly = true)
    public List<BookDTO> getAllBooks() {
        List<Book> books = bookRepository.findAll();
        return books.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public BookDTO getBookById(Integer bookId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));
        return convertToDTO(book);
    }

    @Transactional(readOnly = true)
    public List<BookDTO> searchBooks(String searchTerm) {
        try {
            // Get all books first
            List<Book> allBooks = bookRepository.findAll();

            // Filter in memory
            List<Book> foundBooks = allBooks.stream()
                    .filter(book ->
                            (book.getTitle() != null && book.getTitle().toLowerCase().contains(searchTerm.toLowerCase())) ||
                                    (book.getBookCategory() != null && book.getBookCategory().toLowerCase().contains(searchTerm.toLowerCase())) ||
                                    (book.getIsbn() != null && book.getIsbn().toLowerCase().contains(searchTerm.toLowerCase())) ||
                                    (book.getAuthor() != null &&
                                            ((book.getAuthor().getFirstName() != null && book.getAuthor().getFirstName().toLowerCase().contains(searchTerm.toLowerCase())) ||
                                                    (book.getAuthor().getLastName() != null && book.getAuthor().getLastName().toLowerCase().contains(searchTerm.toLowerCase())))) ||
                                    (book.getPublisher() != null && book.getPublisher().getName() != null &&
                                            book.getPublisher().getName().toLowerCase().contains(searchTerm.toLowerCase()))
                    )
                    .collect(Collectors.toList());

            // Convert to DTOs
            return foundBooks.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error searching for books: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Transactional
    public BookDTO addBook(BookDTO bookDTO) {
        Book book = convertToEntity(bookDTO);
        Book savedBook = bookRepository.save(book);
        return convertToDTO(savedBook);
    }

    @Transactional
    public BookDTO updateBook(Integer bookId, BookDTO bookDTO) {
        // Check if book exists
        Book existingBook = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));

        // Update book properties
        existingBook.setTitle(bookDTO.getTitle());
        existingBook.setIsbn(bookDTO.getIsbn());
        existingBook.setPublicationYear(bookDTO.getPublicationYear());
        existingBook.setBookCategory(bookDTO.getCategory());

        // Update author if needed
        if (bookDTO.getAuthorId() != null) {
            Author author = authorRepository.findById(bookDTO.getAuthorId())
                    .orElseThrow(() -> new ResourceNotFoundException("Author not found with id: " + bookDTO.getAuthorId()));
            existingBook.setAuthor(author);
        }

        // Update publisher if needed
        if (bookDTO.getPublisherId() != null) {
            Publisher publisher = publisherRepository.findById(bookDTO.getPublisherId())
                    .orElseThrow(() -> new ResourceNotFoundException("Publisher not found with id: " + bookDTO.getPublisherId()));
            existingBook.setPublisher(publisher);
        }

        Book updatedBook = bookRepository.save(existingBook);
        return convertToDTO(updatedBook);
    }

    @Transactional
    public void deleteBook(Integer bookId) {
        // Check if book exists
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));

        // Check if book has any ongoing transactions
        long activeTransactions = transactionRepository.countByBookAndReturnDateIsNull(book);
        if (activeTransactions > 0) {
            throw new IllegalStateException("Cannot delete book with active transactions");
        }

        bookRepository.deleteById(bookId);
    }

    @Transactional(readOnly = true)
    public int getAvailableCopies(Integer bookId) {
        // Implementation depends on how you're tracking copies
        // This is just a placeholder implementation
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));

        // Count active transactions for this book
        long borrowedCopies = transactionRepository.countByBookAndReturnDateIsNull(book);

        // Assuming total copies is stored somewhere
        int totalCopies = 1; // Replace with actual implementation

        return totalCopies - (int)borrowedCopies;
    }

    private BookDTO convertToDTO(Book book) {
        BookDTO dto = new BookDTO();
        dto.setBookId(book.getBookId());
        dto.setTitle(book.getTitle());
        dto.setIsbn(book.getIsbn());
        dto.setPublicationYear(book.getPublicationYear());
        dto.setCategory(book.getBookCategory());

        if (book.getAuthor() != null) {
            dto.setAuthorId(book.getAuthor().getAuthorId());
            dto.setAuthorName(book.getAuthor().getFirstName() + " " + book.getAuthor().getLastName());
        }

        if (book.getPublisher() != null) {
            dto.setPublisherId(book.getPublisher().getPublisherId());
            dto.setPublisherName(book.getPublisher().getName());
        }

        // Calculate available copies
        int availableCopies = getAvailableCopies(book.getBookId());
        dto.setAvailableCopies((long) availableCopies);

        // Set status based on available copies
        dto.setStatus(availableCopies > 0 ? "Available" : "Borrowed");

        return dto;
    }

    private Book convertToEntity(BookDTO dto) {
        Book book = new Book();

        // Set book ID only if it's an update operation
        if (dto.getBookId() != null) {
            book.setBookId(dto.getBookId());
        }

        book.setTitle(dto.getTitle());
        book.setIsbn(dto.getIsbn());
        book.setPublicationYear(dto.getPublicationYear());
        book.setBookCategory(dto.getCategory());

        // Set author if provided
        if (dto.getAuthorId() != null) {
            Author author = authorRepository.findById(dto.getAuthorId())
                    .orElseThrow(() -> new ResourceNotFoundException("Author not found with id: " + dto.getAuthorId()));
            book.setAuthor(author);
        }

        // Set publisher if provided
        if (dto.getPublisherId() != null) {
            Publisher publisher = publisherRepository.findById(dto.getPublisherId())
                    .orElseThrow(() -> new ResourceNotFoundException("Publisher not found with id: " + dto.getPublisherId()));
            book.setPublisher(publisher);
        }

        return book;
    }
}
