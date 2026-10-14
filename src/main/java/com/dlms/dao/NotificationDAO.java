package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Notification;
import com.dlms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Notifications and Alerts.
 */
public class NotificationDAO {

    public boolean create(Notification n) throws DatabaseOperationException {
        String sql = "INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, n.getUserId());
            stmt.setString(2, n.getTitle());
            stmt.setString(3, n.getMessage());
            stmt.setString(4, n.getType().name());
            stmt.setBoolean(5, n.isRead());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    n.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to save notification: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public List<Notification> findByUserId(int userId, int limit) throws DatabaseOperationException {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY id DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, limit > 0 ? limit : 10);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToNotification(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch notifications", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public int countUnread(int userId) throws DatabaseOperationException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to count unread notifications", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean markAllAsRead(int userId) throws DatabaseOperationException {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to mark notifications read", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    private Notification mapRowToNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        String typeStr = rs.getString("type");
        if (typeStr != null) {
            try {
                n.setType(Notification.Type.valueOf(typeStr));
            } catch (IllegalArgumentException ignored) {}
        }
        n.setRead(rs.getBoolean("is_read"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            n.setCreatedAt(ts.toLocalDateTime());
        }
        return n;
    }
}
