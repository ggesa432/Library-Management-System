package com.synergisticit.service;

import com.synergisticit.domain.Book;
import com.synergisticit.domain.Fine;
import com.synergisticit.domain.Member;
import com.synergisticit.domain.Transaction;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.BookRepository;
import com.synergisticit.repository.FineRepository;
import com.synergisticit.repository.MemberRepository;
import com.synergisticit.repository.TransactionRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/24/2025
 */
@Service
public class TransactionService {
    @Autowired
    private TransactionRepository transactionRepository;
    @Autowired
    private FineRepository fineRepository;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private FineService fineService;

    @Transactional
    public Transaction borrowBook(Integer bookId, Integer memberId, Integer durationDays) {
        // Find book and member
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));

        // Check if book is available
        int availableCopies = getAvailableCopies(bookId);
        if (availableCopies <= 0) {
            throw new IllegalStateException("Book is not available for borrowing");
        }

        // Check if member has any pending fines
        if (!fineService.canMemberBorrowBooks(memberId)) {
            throw new IllegalStateException("Member has pending fines or has reached the maximum books limit");
        }

        // Check if member has any overdue books
        List<Transaction> overdueTransactions = transactionRepository
                .findByMemberAndDueDateBeforeAndReturnDateIsNull(member, LocalDate.now());
        if (!overdueTransactions.isEmpty()) {
            throw new IllegalStateException("Cannot borrow book. Member has overdue books");
        }

        // Create new transaction
        Transaction transaction = new Transaction();
        transaction.setBook(book);
        transaction.setMember(member);
        transaction.setCheckOutDate(LocalDate.now());

        // Calculate due date based on configuration or provided duration
        int loanDays = durationDays != null ? durationDays : fineService.getDefaultLoanPeriod();
        LocalDate dueDate = LocalDate.now().plusDays(loanDays);
        transaction.setDueDate(dueDate);

        return transactionRepository.save(transaction);
    }

    @Transactional
    public Transaction returnBook(Integer transactionId) {
        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new ResourceNotFoundException("Transaction not found with id: " + transactionId));

        // Check if book is already returned
        if (transaction.getReturnDate() != null) {
            throw new IllegalStateException("Book is already returned");
        }

        // Set return date
        LocalDate returnDate = LocalDate.now();
        transaction.setReturnDate(returnDate);

        Transaction updatedTransaction = transactionRepository.save(transaction);

        // Check if book is returned late and calculate fine
        if (returnDate.isAfter(transaction.getDueDate())) {
            try {
                // Use the existing method in FineService
                Fine fine = fineService.calculateFineForOverdueBook(updatedTransaction);
                System.out.println("Fine calculated: " + (fine != null ? fine.getFineId() : "no fine"));
            } catch (Exception e) {
                System.err.println("Error calculating fine: " + e.getMessage());
                e.printStackTrace();
            }
        }

        return updatedTransaction;
    }

    @Transactional
    public Transaction renewBook(Integer transactionId, Integer additionalDays) {
        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new ResourceNotFoundException("Transaction not found with id: " + transactionId));

        // Check if book is already returned
        if (transaction.getReturnDate() != null) {
            throw new IllegalStateException("Cannot renew. Book is already returned");
        }

        // Check if book is overdue
        LocalDate today = LocalDate.now();
        if (transaction.getDueDate().isBefore(today)) {
            throw new IllegalStateException("Cannot renew. Book is overdue");
        }

        // Calculate new due date
        int renewalDays = additionalDays != null ? additionalDays : 14; // Default to 14 days
        LocalDate newDueDate = transaction.getDueDate().plusDays(renewalDays);
        transaction.setDueDate(newDueDate);

        return transactionRepository.save(transaction);
    }

    @Transactional(readOnly = true)
    public List<Transaction> getActiveTransactions() {
        return transactionRepository.findByReturnDateIsNull();
    }

    @Transactional(readOnly = true)
    public List<Transaction> getOverdueTransactions() {
        return transactionRepository.findByDueDateBeforeAndReturnDateIsNull(LocalDate.now());
    }

    @Transactional(readOnly = true)
    public List<Transaction> getMemberTransactions(Integer memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + memberId));

        return transactionRepository.findByMember(member);
    }

    @Transactional(readOnly = true)
    public int getAvailableCopies(Integer bookId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));

        long borrowedCopies = transactionRepository.countByBookAndReturnDateIsNull(book);

        // Assuming total copies is 1 per book for now
        // This could be enhanced by adding a totalCopies field to the Book entity
        int totalCopies = 1;

        return totalCopies - (int)borrowedCopies;
    }
}