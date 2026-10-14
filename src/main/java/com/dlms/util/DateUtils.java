package com.dlms.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 * Utility for date calculations, overdue detection, and fine logic.
 */
public class DateUtils {

    public static final DateTimeFormatter DISPLAY_FORMATTER = DateTimeFormatter.ofPattern("dd MMM yyyy");
    public static final DateTimeFormatter ISO_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Calculates the due date from issue date (defaults to +14 days).
     */
    public static LocalDate calculateDueDate(LocalDate issueDate, int allowedDays) {
        if (issueDate == null) {
            issueDate = LocalDate.now();
        }
        return issueDate.plusDays(allowedDays > 0 ? allowedDays : 14);
    }

    /**
     * Calculates days overdue. Returns 0 if returned before or on due date.
     */
    public static int calculateDaysLate(LocalDate dueDate, LocalDate returnDate) {
        if (dueDate == null) return 0;
        if (returnDate == null) returnDate = LocalDate.now();

        if (returnDate.isAfter(dueDate)) {
            return (int) ChronoUnit.DAYS.between(dueDate, returnDate);
        }
        return 0;
    }

    /**
     * Computes fine amount based on overdue days and daily fine rate.
     */
    public static double calculateFine(int daysLate, double finePerDay) {
        if (daysLate <= 0) return 0.0;
        return Math.round((daysLate * finePerDay) * 100.0) / 100.0;
    }

    /**
     * Formats LocalDate for UI display.
     */
    public static String formatDisplayDate(LocalDate date) {
        if (date == null) return "-";
        return date.format(DISPLAY_FORMATTER);
    }

    /**
     * Parses a date string in YYYY-MM-DD format.
     */
    public static LocalDate parseIsoDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return LocalDate.now();
        }
        try {
            return LocalDate.parse(dateStr.trim(), ISO_FORMATTER);
        } catch (Exception e) {
            return LocalDate.now();
        }
    }
}
