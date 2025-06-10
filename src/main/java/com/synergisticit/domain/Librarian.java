package com.synergisticit.domain;

import jakarta.persistence.*;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Date;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Entity
@Table(name = "librarian")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Librarian {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "librarian_id")
    private Integer librarianId;

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

    @Column(name = "appointment_date")
    private LocalDate appointmentDate;
}
