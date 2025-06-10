package com.synergisticit.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.synergisticit.domain.Publisher;

import java.util.List;
import java.util.Optional;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Repository
public interface PublisherRepository extends JpaRepository<Publisher, Integer> {

    List<Publisher> findByNameContaining(String name);

    Optional<Publisher> findByName(String name);

    List<Publisher> findByAddressContaining(String address);

    Optional<Publisher> findByEmail(String email);

    @Query("SELECT COUNT(b) FROM Book b WHERE b.publisher.publisherId = :publisherId")
    long countBooksByPublisher(Integer publisherId);
}
