package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Model representing a book reservation in the waitlist queue.
 * Implements FIFO queue semantics for reserving out-of-stock titles.
 */
public class Reservation implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Status {
        PENDING, NOTIFIED, FULFILLED, CANCELLED, EXPIRED
    }

    private int id;
    private String reservationId;
    private String memberId;
    private String bookId;
    private LocalDateTime reservationDate;
    private int queuePosition;
    private Status status;
    private LocalDate expiryDate;

    // View-helper joined attributes
    private String bookTitle;
    private String memberName;
    private String bookCoverUrl;

    public Reservation() {
        this.status = Status.PENDING;
        this.queuePosition = 1;
    }

    public Reservation(int id, String reservationId, String memberId, String bookId,
                       LocalDateTime reservationDate, int queuePosition, Status status, LocalDate expiryDate) {
        this.id = id;
        this.reservationId = reservationId;
        this.memberId = memberId;
        this.bookId = bookId;
        this.reservationDate = reservationDate;
        this.queuePosition = queuePosition;
        this.status = status;
        this.expiryDate = expiryDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReservationId() { return reservationId; }
    public void setReservationId(String reservationId) { this.reservationId = reservationId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getBookId() { return bookId; }
    public void setBookId(String bookId) { this.bookId = bookId; }

    public LocalDateTime getReservationDate() { return reservationDate; }
    public void setReservationDate(LocalDateTime reservationDate) { this.reservationDate = reservationDate; }

    public int getQueuePosition() { return queuePosition; }
    public void setQueuePosition(int queuePosition) { this.queuePosition = queuePosition; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    public String getBookCoverUrl() { return bookCoverUrl; }
    public void setBookCoverUrl(String bookCoverUrl) { this.bookCoverUrl = bookCoverUrl; }
}
