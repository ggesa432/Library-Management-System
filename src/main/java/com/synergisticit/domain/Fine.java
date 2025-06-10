package com.synergisticit.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Entity
@Table(name = "fines")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Fine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fine_id")
    private Integer fineId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @Column(name = "amount")
    private Double amount;

    @Column(name = "reason")
    private String reason;

    @Column(name = "issue_date")
    private LocalDate issueDate;

    @Column(name = "payment_date")
    private LocalDate paymentDate;

    @Column(name = "status")
    private String status; // PENDING, PAID
}
