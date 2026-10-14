package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Abstract base class for all library patrons.
 * Demonstrates Abstraction, Encapsulation, and defines polymorphic contracts
 * for different member categories (Students, Faculty, Research Scholars).
 */
public abstract class Member implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum MemberType {
        STUDENT, FACULTY, SCHOLAR
    }

    private int id;
    private String memberId;
    private String name;
    private String email;
    private String phone;
    private String department;
    private MemberType memberType;
    private int maxBorrowLimit;
    private LocalDate registrationDate;
    private String status; // ACTIVE, EXPIRED, SUSPENDED

    public Member() {}

    public Member(int id, String memberId, String name, String email, String phone,
                  String department, MemberType memberType, int maxBorrowLimit,
                  LocalDate registrationDate, String status) {
        this.id = id;
        this.memberId = memberId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.memberType = memberType;
        this.maxBorrowLimit = maxBorrowLimit;
        this.registrationDate = registrationDate;
        this.status = status;
    }

    // Abstract methods demonstrating Polymorphism
    public abstract int getAllowedBorrowDays();
    public abstract double calculateFineRate(double baseFineRate);
    public abstract String getRoleDescription();

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public MemberType getMemberType() { return memberType; }
    public void setMemberType(MemberType memberType) { this.memberType = memberType; }

    public int getMaxBorrowLimit() { return maxBorrowLimit; }
    public void setMaxBorrowLimit(int maxBorrowLimit) { this.maxBorrowLimit = maxBorrowLimit; }

    public LocalDate getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(LocalDate registrationDate) { this.registrationDate = registrationDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }
}
