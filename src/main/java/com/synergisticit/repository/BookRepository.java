package com.synergisticit.repository;

import com.synergisticit.domain.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Repository
public interface BookRepository extends JpaRepository<Book, Integer> {
    List<Book> findByTitleContainingIgnoreCase(String title);

    List<Book> findByBookCategory(String category);

    @Query("SELECT b FROM Book b JOIN b.author a WHERE CONCAT(a.firstName, ' ', a.lastName) LIKE %:authorName%")
    List<Book> findByAuthorName(String authorName);

    List<Book> findByPublicationYear(Integer year);

    @Query("SELECT b FROM Book b JOIN b.publisher p WHERE p.name LIKE %:publisherName%")
    List<Book> findByPublisherName(String publisherName);

    List<Book> findByIsbn(String isbn);
}
