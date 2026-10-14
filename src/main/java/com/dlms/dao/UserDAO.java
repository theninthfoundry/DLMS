package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidLoginException;
import com.dlms.model.User;
import com.dlms.util.DatabaseConnection;
import com.dlms.util.PasswordHasher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User operations and Authentication.
 * Uses PreparedStatements exclusively to eliminate SQL Injection vulnerabilities.
 */
public class UserDAO {

    public User authenticate(String usernameOrEmail, String password) throws InvalidLoginException, DatabaseOperationException {
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?) AND status = 'ACTIVE' LIMIT 1";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail.trim());
            stmt.setString(2, usernameOrEmail.trim());

            rs = stmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (PasswordHasher.verify(password, storedHash)) {
                    return mapRowToUser(rs);
                } else {
                    throw new InvalidLoginException("Invalid password. Please verify your credentials.");
                }
            } else {
                throw new InvalidLoginException("No active account found with username or email: " + usernameOrEmail);
            }
        } catch (SQLException e) {
            throw new DatabaseOperationException("Database error during authentication: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public User findById(int id) throws DatabaseOperationException {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find user by ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public User findByUsername(String username) throws DatabaseOperationException {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find user by username", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean createUser(User user) throws DatabaseOperationException {
        String sql = "INSERT INTO users (username, email, password_hash, role, member_id, status) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, PasswordHasher.hashPassword(user.getPasswordHash()));
            stmt.setString(4, user.getRole().name());
            stmt.setString(5, user.getMemberId());
            stmt.setString(6, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to create user account: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws DatabaseOperationException {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, PasswordHasher.hashPassword(newPassword));
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to update password", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public List<User> findAll() throws DatabaseOperationException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to retrieve users", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        String roleStr = rs.getString("role");
        u.setRole(roleStr != null ? User.Role.valueOf(roleStr) : User.Role.STUDENT);
        u.setMemberId(rs.getString("member_id"));
        u.setStatus(rs.getString("status"));
        java.sql.Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            u.setCreatedAt(ts.toLocalDateTime());
        }
        return u;
    }
}
