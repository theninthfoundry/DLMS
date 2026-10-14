package com.dlms.exception;

/**
 * Thrown when a member ID is invalid, not found, or suspended.
 */
public class InvalidMemberException extends Exception {
    private static final long serialVersionUID = 1L;

    public InvalidMemberException(String message) {
        super(message);
    }

    public InvalidMemberException(String message, Throwable cause) {
        super(message, cause);
    }
}
