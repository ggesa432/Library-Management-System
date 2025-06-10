package com.synergisticit.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Date;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/24/2025
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TransactionDTO {
    private Integer transactionId;
    private Integer bookId;
    private String bookTitle;
    private Integer memberId;
    private String memberName;
    private LocalDate checkOutDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    private boolean isOverdue;
    private long daysLeft;
    private long daysOverdue;
}
