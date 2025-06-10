package com.synergisticit.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 2/13/2025
 */
@Entity
@Table(name = "book_categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookCategory {

    @EmbeddedId
    private BookCategoryId id;

    @ManyToOne
    @MapsId("bookId")
    @JoinColumn(name = "book_id")
    private Book book;

    @ManyToOne
    @MapsId("categoryId")
    @JoinColumn(name = "category_id")
    private Category category;
}
