package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents an authenticated user in the system.
 * Demonstrates encapsulation with private fields, validation, and accessors.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Role {
        ADMIN, LIBRARIAN, STUDENT, FACULTY
    }

    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private Role role;
    private String memberId; // Links to member profile if STUDENT or FACULTY
    private String status;
    private LocalDateTime createdAt;

    public User() {}

    public User(int id, String username, String email, String passwordHash, Role role, String memberId, String status) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.memberId = memberId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() {
        return this.role == Role.ADMIN || this.role == Role.LIBRARIAN;
    }

    public boolean isStudent() {
        return this.role == Role.STUDENT;
    }

    public boolean isFaculty() {
        return this.role == Role.FACULTY;
    }
}
