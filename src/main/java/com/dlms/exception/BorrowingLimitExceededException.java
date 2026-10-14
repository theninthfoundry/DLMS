package com.dlms.exception;

/**
 * Thrown when a patron attempts to issue more books than their allowed quota.
 */
public class BorrowingLimitExceededException extends Exception {
    private static final long serialVersionUID = 1L;

    public BorrowingLimitExceededException(String message) {
        super(message);
    }
}
