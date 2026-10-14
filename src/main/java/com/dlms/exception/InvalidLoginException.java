package com.dlms.exception;

/**
 * Thrown when user authentication fails due to bad credentials or account suspension.
 */
public class InvalidLoginException extends Exception {
    private static final long serialVersionUID = 1L;

    public InvalidLoginException(String message) {
        super(message);
    }

    public InvalidLoginException(String message, Throwable cause) {
        super(message, cause);
    }
}
