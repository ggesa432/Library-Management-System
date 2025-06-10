package com.synergisticit.repository;

import com.synergisticit.domain.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Repository
public interface AuthorRepository extends JpaRepository<Author, Integer> {

    List<Author> findByFirstNameContainingOrLastNameContaining(String firstName, String lastName);

    @Query("SELECT a FROM Author a WHERE CONCAT(a.firstName, ' ', a.lastName) LIKE %:fullName%")
    List<Author> findByFullName(String fullName);

    Optional<Author> findByFirstNameAndLastName(String firstName, String lastName);

    @Query("SELECT COUNT(b) FROM Book b WHERE b.author.authorId = :authorId")
    long countBooksByAuthor(Integer authorId);
}
