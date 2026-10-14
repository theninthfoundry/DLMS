package com.dlms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Model representing system notifications and user alerts.
 */
public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Type {
        INFO, SUCCESS, WARNING, DANGER
    }

    private int id;
    private int userId;
    private String title;
    private String message;
    private Type type;
    private boolean read;
    private LocalDateTime createdAt;

    public Notification() {
        this.type = Type.INFO;
        this.read = false;
        this.createdAt = LocalDateTime.now();
    }

    public Notification(int id, int userId, String title, String message, Type type, boolean read, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.read = read;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Type getType() { return type; }
    public void setType(Type type) { this.type = type; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
