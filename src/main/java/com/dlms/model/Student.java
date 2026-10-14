package com.dlms.model;

import java.time.LocalDate;

/**
 * Concrete subclass representing Student patrons.
 * Demonstrates Inheritance and Method Overriding (Polymorphism).
 */
public class Student extends Member {
    private static final long serialVersionUID = 1L;

    private String year; // e.g. 1st Year, 2nd Year, etc.

    public Student() {
        super();
        setMemberType(MemberType.STUDENT);
        setMaxBorrowLimit(4);
    }

    public Student(int id, String memberId, String name, String email, String phone,
                   String department, String year, LocalDate registrationDate, String status) {
        super(id, memberId, name, email, phone, department, MemberType.STUDENT, 4, registrationDate, status);
        this.year = year;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    @Override
    public int getAllowedBorrowDays() {
        return 14; // Standard 2-week borrowing period for students
    }

    @Override
    public double calculateFineRate(double baseFineRate) {
        return baseFineRate; // Standard fine calculation for students
    }

    @Override
    public String getRoleDescription() {
        return "Student (" + (year != null ? year : "Undergraduate") + ")";
    }
}
