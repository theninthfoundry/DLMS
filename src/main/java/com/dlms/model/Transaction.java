package com.dlms.model;

import com.dlms.util.DateUtils;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Model representing book circulation issue and return transactions.
 */
public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Status {
        ISSUED, RETURNED, OVERDUE, LOST
    }

    private int id;
    private String transactionId;
    private String memberId;
    private String bookId;
    private LocalDate issueDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    private double fine;
    private Status status;
    private String issuedBy;
    private String remarks;

    // View-helper joined attributes
    private String bookTitle;
    private String memberName;
    private String bookCoverUrl;

    public Transaction() {
        this.status = Status.ISSUED;
        this.fine = 0.0;
    }

    public Transaction(int id, String transactionId, String memberId, String bookId,
                       LocalDate issueDate, LocalDate dueDate, LocalDate returnDate,
                       double fine, Status status, String issuedBy, String remarks) {
        this.id = id;
        this.transactionId = transactionId;
        this.memberId = memberId;
        this.bookId = bookId;
        this.issueDate = issueDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.fine = fine;
        this.status = status;
        this.issuedBy = issuedBy;
        this.remarks = remarks;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getBookId() { return bookId; }
    public void setBookId(String bookId) { this.bookId = bookId; }

    public LocalDate getIssueDate() { return issueDate; }
    public void setIssueDate(LocalDate issueDate) { this.issueDate = issueDate; }

    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public LocalDate getReturnDate() { return returnDate; }
    public void setReturnDate(LocalDate returnDate) { this.returnDate = returnDate; }

    public double getFine() { return fine; }
    public void setFine(double fine) { this.fine = fine; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public String getIssuedBy() { return issuedBy; }
    public void setIssuedBy(String issuedBy) { this.issuedBy = issuedBy; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    public String getBookCoverUrl() { return bookCoverUrl; }
    public void setBookCoverUrl(String bookCoverUrl) { this.bookCoverUrl = bookCoverUrl; }

    public boolean isOverdue() {
        if (status == Status.RETURNED) return false;
        return LocalDate.now().isAfter(dueDate);
    }

    public int getDaysOverdue() {
        if (status == Status.RETURNED) {
            return DateUtils.calculateDaysLate(dueDate, returnDate);
        }
        return DateUtils.calculateDaysLate(dueDate, LocalDate.now());
    }

    public String getFormattedDueDate() {
        return DateUtils.formatDisplayDate(dueDate);
    }

    public String getFormattedIssueDate() {
        return DateUtils.formatDisplayDate(issueDate);
    }

    public String getFormattedReturnDate() {
        return DateUtils.formatDisplayDate(returnDate);
    }
}
