package com.synergisticit.controller;

import com.synergisticit.domain.Fine;
import com.synergisticit.domain.Member;
import com.synergisticit.domain.Transaction;
import com.synergisticit.dto.TransactionDTO;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.FineRepository;
import com.synergisticit.repository.MemberRepository;
import com.synergisticit.repository.TransactionRepository;
import com.synergisticit.service.BookService;
import com.synergisticit.service.FineService;
import com.synergisticit.service.MemberService;
import com.synergisticit.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private MemberRepository memberRepository;
    @Autowired
    private FineRepository fineRepository;

    @Autowired
    private FineService fineService;

    @Autowired
    private BookService bookService;

    @Autowired
    private MemberService memberService;

    @GetMapping
    public ResponseEntity<List<TransactionDTO>> getAllTransactions() {
        List<Transaction> transactions = transactionService.getActiveTransactions();
        List<TransactionDTO> transactionDTOs = transactions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(transactionDTOs);
    }

    @GetMapping("/overdue")
    public ResponseEntity<List<TransactionDTO>> getOverdueTransactions() {
        List<Transaction> transactions = transactionService.getOverdueTransactions();
        List<TransactionDTO> transactionDTOs = transactions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(transactionDTOs);
    }

    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<TransactionDTO>> getMemberTransactions(@PathVariable Integer memberId) {
        List<Transaction> transactions = transactionService.getMemberTransactions(memberId);
        List<TransactionDTO> transactionDTOs = transactions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(transactionDTOs);
    }

    @PostMapping("/borrow")
    public ResponseEntity<TransactionDTO> borrowBook(@RequestParam Integer bookId,
                                                     @RequestParam Integer memberId,
                                                     @RequestParam(required = false) Integer durationDays) {
        try {
            Transaction transaction = transactionService.borrowBook(bookId, memberId, durationDays);
            return ResponseEntity.ok(convertToDTO(transaction));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PostMapping("/{id}/return")
    public ResponseEntity<TransactionDTO> returnBook(@PathVariable("id") Integer transactionId) {
        try {
            System.out.println("Return book request received for transaction ID: " + transactionId);

            Transaction transaction = transactionService.returnBook(transactionId);
            System.out.println("Book returned successfully, transaction ID: " + transactionId);

            return ResponseEntity.ok(convertToDTO(transaction));
        } catch (Exception e) {  // Changed from IllegalStateException to Exception
            System.err.println("Error returning book for transaction ID: " + transactionId + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @PostMapping("/{id}/renew")
    public ResponseEntity<TransactionDTO> renewBook(@PathVariable("id") Integer transactionId,
                                                    @RequestParam(required = false) Integer additionalDays) {
        try {
            Transaction transaction = transactionService.renewBook(transactionId, additionalDays);
            return ResponseEntity.ok(convertToDTO(transaction));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    private TransactionDTO convertToDTO(Transaction transaction) {
        TransactionDTO dto = new TransactionDTO();
        dto.setTransactionId(transaction.getTransactionId());

        if (transaction.getBook() != null) {
            dto.setBookId(transaction.getBook().getBookId());
            dto.setBookTitle(transaction.getBook().getTitle());
        }

        if (transaction.getMember() != null) {
            dto.setMemberId(transaction.getMember().getMemberId());
            dto.setMemberName(transaction.getMember().getFirstName() + " " + transaction.getMember().getLastName());
        }

        dto.setCheckOutDate(transaction.getCheckOutDate());
        dto.setDueDate(transaction.getDueDate());
        dto.setReturnDate(transaction.getReturnDate());

        // Calculate if overdue
        LocalDate today = LocalDate.now();
        if (transaction.getReturnDate() == null && transaction.getDueDate().isBefore(today)) {
            dto.setOverdue(true);
            long daysOverdue = ChronoUnit.DAYS.between(transaction.getDueDate(), today);
            dto.setDaysOverdue(daysOverdue);
        } else if (transaction.getReturnDate() == null) {
            long daysLeft = ChronoUnit.DAYS.between(today, transaction.getDueDate());
            dto.setDaysLeft(daysLeft);
        }

        return dto;
    }




}