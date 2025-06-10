package com.synergisticit.repository;

import com.synergisticit.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.synergisticit.domain.Book;
import com.synergisticit.domain.Transaction;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {
    List<Transaction> findByMember(Member member);

    List<Transaction> findByBook(Book book);

    List<Transaction> findByReturnDateIsNull();

    List<Transaction> findByDueDateBeforeAndReturnDateIsNull(LocalDate currentDate);

    List<Transaction> findByMemberAndDueDateBeforeAndReturnDateIsNull(Member member, LocalDate currentDate);

    long countByBookAndReturnDateIsNull(Book book);

    boolean existsByMemberAndDueDateBeforeAndReturnDateIsNull(Member member, LocalDate currentDate);

    int countByMemberAndReturnDateIsNull(Member member);
}
