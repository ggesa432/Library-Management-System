package com.synergisticit.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class BookDTO {

    private Integer bookId;
    private String title;
    private String isbn;
    private Integer publicationYear;
    private String category;
    private Integer authorId;
    private String authorName; // First name + Last name
    private Integer publisherId;
    private String publisherName;
    private Long availableCopies;
    private String status; // Available, Borrowed, Reserved, etc.

}
