package com.dlms.model;

import java.time.LocalDate;

/**
 * Concrete subclass representing Faculty patrons.
 * Demonstrates Inheritance, higher quota limits (8 books), and 30-day loan privileges.
 */
public class Faculty extends Member {
    private static final long serialVersionUID = 1L;

    private String designation;

    public Faculty() {
        super();
        setMemberType(MemberType.FACULTY);
        setMaxBorrowLimit(8);
    }

    public Faculty(int id, String memberId, String name, String email, String phone,
                   String department, String designation, LocalDate registrationDate, String status) {
        super(id, memberId, name, email, phone, department, MemberType.FACULTY, 8, registrationDate, status);
        this.designation = designation;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    @Override
    public int getAllowedBorrowDays() {
        return 30; // Extended 30-day borrowing period for faculty research
    }

    @Override
    public double calculateFineRate(double baseFineRate) {
        return 0.0; // Faculty research grace policy (waived automated fine)
    }

    @Override
    public String getRoleDescription() {
        return "Faculty Member" + (designation != null ? " (" + designation + ")" : "");
    }
}
