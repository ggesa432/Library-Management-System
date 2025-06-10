package com.synergisticit.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Entity
@Table(name = "members")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"user", "transactions", "fines"})
@EqualsAndHashCode(exclude = {"user", "transactions", "fines"})
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "first_name", length = 50)
    private String firstName;

    @Column(name = "last_name", length = 50)
    private String lastName;

    @Column(name = "address")
    private String address;

    @Column(name = "phone", length = 10)
    private String phone;

    @Column(name = "email", length = 50)
    private String email;

    @Column(name = "membership_date")
    @Temporal(TemporalType.DATE)
    private LocalDate membershipDate;

    @OneToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference
    private User user;

    @OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
    private Set<Transaction> transactions = new HashSet<>();

}
