package com.synergisticit.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/3/2025
 */
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookCategoryId implements Serializable {

    @Column(name = "book_id")
    private Integer bookId;

    @Column(name = "category_id")
    private Integer categoryId;
}
