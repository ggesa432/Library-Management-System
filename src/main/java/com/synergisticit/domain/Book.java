package com.synergisticit.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "books")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"authors", "publisher", "transactions"})
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "book_id")
    private Integer bookId;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "isbn", length = 20)
    private String isbn;

    @Column(name = "publication_year")
    private Integer publicationYear;

    @Column(name = "book_category", length = 20)
    private String bookCategory;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id")
    private Author author;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "publisher_id")
    private Publisher publisher;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL)
    private Set<Transaction> transactions = new HashSet<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL)
    private Set<BookCategory> bookCategories = new HashSet<>();


}
