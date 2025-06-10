package com.synergisticit.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Entity
@Table(name = "publishers")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Publisher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "publisher_id")
    private Integer publisherId;

    @Column(name = "name", length = 50)
    private String name;

    @Column(name = "address")
    private String address;

    @Column(name = "phone", length = 10)
    private String phone;

    @Column(name = "email", length = 50)
    private String email;

    @OneToMany(mappedBy = "publisher", cascade = CascadeType.ALL)
    @JsonIgnore
    private Set<Book> books = new HashSet<>();


}
