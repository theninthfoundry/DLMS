package com.dlms.exception;

/**
 * Thrown when a low-level SQL or database connection error occurs.
 */
public class DatabaseOperationException extends Exception {
    private static final long serialVersionUID = 1L;

    public DatabaseOperationException(String message) {
        super(message);
    }

    public DatabaseOperationException(String message, Throwable cause) {
        super(message, cause);
    }
}
