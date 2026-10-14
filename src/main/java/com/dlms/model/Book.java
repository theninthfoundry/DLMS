package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Model representing a Book in the digital library collection.
 * Demonstrates Encapsulation and business rule helpers.
 */
public class Book implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String bookId;
    private String isbn;
    private String title;
    private String author;
    private String category;
    private String publisher;
    private int publicationYear;
    private String language;
    private String description;
    private String shelfNumber;
    private int quantity;
    private int availableCopies;
    private String status; // AVAILABLE, OUT_OF_STOCK, ARCHIVED, LOST
    private String coverUrl;
    private LocalDateTime createdAt;

    public Book() {
        this.language = "English";
        this.status = "AVAILABLE";
        this.quantity = 1;
        this.availableCopies = 1;
    }

    public Book(int id, String bookId, String isbn, String title, String author,
                String category, String publisher, int publicationYear, String language,
                String description, String shelfNumber, int quantity, int availableCopies,
                String status, String coverUrl) {
        this.id = id;
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.category = category;
        this.publisher = publisher;
        this.publicationYear = publicationYear;
        this.language = language;
        this.description = description;
        this.shelfNumber = shelfNumber;
        this.quantity = quantity;
        this.availableCopies = availableCopies;
        this.status = status;
        this.coverUrl = coverUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBookId() { return bookId; }
    public void setBookId(String bookId) { this.bookId = bookId; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public int getPublicationYear() { return publicationYear; }
    public void setPublicationYear(int publicationYear) { this.publicationYear = publicationYear; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getShelfNumber() { return shelfNumber; }
    public void setShelfNumber(String shelfNumber) { this.shelfNumber = shelfNumber; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getAvailableCopies() { return availableCopies; }
    public void setAvailableCopies(int availableCopies) { this.availableCopies = availableCopies; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCoverUrl() {
        if (coverUrl == null || coverUrl.trim().isEmpty()) {
            return "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&q=80";
        }
        return coverUrl;
    }
    public void setCoverUrl(String coverUrl) { this.coverUrl = coverUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isAvailable() {
        return this.availableCopies > 0 && "AVAILABLE".equalsIgnoreCase(this.status);
    }

    public int getIssuedCopies() {
        return Math.max(0, this.quantity - this.availableCopies);
    }
}
