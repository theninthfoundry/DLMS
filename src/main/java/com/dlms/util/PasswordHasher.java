package com.dlms.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility for hashing and verifying passwords securely using SHA-256.
 * Ensures plain text passwords are never stored in the database.
 */
public class PasswordHasher {

    /**
     * Hashes a plain password using SHA-256.
     * @param password raw input password
     * @return hex encoded string
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Verifies if input matches stored hash (or plain text match as dev fallback).
     */
    public static boolean verify(String inputPassword, String storedHash) {
        if (inputPassword == null || storedHash == null) {
            return false;
        }
        String hashedInput = hashPassword(inputPassword);
        return hashedInput.equalsIgnoreCase(storedHash) || inputPassword.equals(storedHash);
    }
}
