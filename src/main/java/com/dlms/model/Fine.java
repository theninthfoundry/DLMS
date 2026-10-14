package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Model representing overdue fine penalties and payments.
 */
public class Fine implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Status {
        UNPAID, PAID, WAIVED
    }

    private int id;
    private String fineId;
    private String transactionId;
    private String memberId;
    private double amount;
    private int daysLate;
    private Status status;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
    private String paymentMode;

    // View-helper joined attributes
    private String memberName;
    private String bookTitle;

    public Fine() {
        this.status = Status.UNPAID;
    }

    public Fine(int id, String fineId, String transactionId, String memberId,
                double amount, int daysLate, Status status,
                LocalDateTime createdAt, LocalDateTime paidAt, String paymentMode) {
        this.id = id;
        this.fineId = fineId;
        this.transactionId = transactionId;
        this.memberId = memberId;
        this.amount = amount;
        this.daysLate = daysLate;
        this.status = status;
        this.createdAt = createdAt;
        this.paidAt = paidAt;
        this.paymentMode = paymentMode;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFineId() { return fineId; }
    public void setFineId(String fineId) { this.fineId = fineId; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public int getDaysLate() { return daysLate; }
    public void setDaysLate(int daysLate) { this.daysLate = daysLate; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }

    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }

    public String getMemberName() { return memberName; }
    public void setMemberName(String memberName) { this.memberName = memberName; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public boolean isPaid() {
        return this.status == Status.PAID;
    }
}
