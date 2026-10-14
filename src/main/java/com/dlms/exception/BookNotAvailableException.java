package com.dlms.exception;

/**
 * Thrown when an operation attempts to issue a book that has zero available copies.
 */
public class BookNotAvailableException extends Exception {
    private static final long serialVersionUID = 1L;

    public BookNotAvailableException(String message) {
        super(message);
    }

    public BookNotAvailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
