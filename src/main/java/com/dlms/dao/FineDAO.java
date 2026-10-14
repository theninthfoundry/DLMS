package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Fine;
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
 * Data Access Object for Overdue Fines and Payment Tracking.
 */
public class FineDAO {

    public boolean create(Fine fine) throws DatabaseOperationException {
        String sql = "INSERT INTO fines (fine_id, transaction_id, member_id, amount, days_late, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, fine.getFineId());
            stmt.setString(2, fine.getTransactionId());
            stmt.setString(3, fine.getMemberId());
            stmt.setDouble(4, fine.getAmount());
            stmt.setInt(5, fine.getDaysLate());
            stmt.setString(6, fine.getStatus().name());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    fine.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to insert fine record: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean markAsPaid(String fineId, String paymentMode) throws DatabaseOperationException {
        String sql = "UPDATE fines SET status = 'PAID', paid_at = NOW(), payment_mode = ? WHERE fine_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, paymentMode != null ? paymentMode : "CASH");
            stmt.setString(2, fineId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to update fine payment: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public List<Fine> findAll(String query, String status, int offset, int limit) throws DatabaseOperationException {
        List<Fine> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT f.*, m.name AS member_name, b.title AS book_title " +
                "FROM fines f " +
                "LEFT JOIN members m ON f.member_id = m.member_id " +
                "LEFT JOIN transactions t ON f.transaction_id = t.transaction_id " +
                "LEFT JOIN books b ON t.book_id = b.book_id " +
                "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (f.fine_id LIKE ? OR f.member_id LIKE ? OR f.transaction_id LIKE ? OR m.name LIKE ?) ");
            for (int i = 0; i < 4; i++) {
                params.add(wildcard);
            }
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND f.status = ? ");
            params.add(status.trim());
        }

        sql.append(" ORDER BY f.id DESC LIMIT ? OFFSET ? ");
        params.add(limit > 0 ? limit : 20);
        params.add(Math.max(0, offset));

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToFine(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch fines: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public List<Fine> findByMemberId(String memberId) throws DatabaseOperationException {
        List<Fine> list = new ArrayList<>();
        String sql = "SELECT f.*, m.name AS member_name, b.title AS book_title " +
                     "FROM fines f " +
                     "LEFT JOIN members m ON f.member_id = m.member_id " +
                     "LEFT JOIN transactions t ON f.transaction_id = t.transaction_id " +
                     "LEFT JOIN books b ON t.book_id = b.book_id " +
                     "WHERE f.member_id = ? " +
                     "ORDER BY f.id DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToFine(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch member fines", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public double getTotalUnpaidForMember(String memberId) throws DatabaseOperationException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM fines WHERE member_id = ? AND status = 'UNPAID'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
            return 0.0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to calculate member unpaid fines", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    private Fine mapRowToFine(ResultSet rs) throws SQLException {
        Fine f = new Fine();
        f.setId(rs.getInt("id"));
        f.setFineId(rs.getString("fine_id"));
        f.setTransactionId(rs.getString("transaction_id"));
        f.setMemberId(rs.getString("member_id"));
        f.setAmount(rs.getDouble("amount"));
        f.setDaysLate(rs.getInt("days_late"));
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                f.setStatus(Fine.Status.valueOf(statusStr));
            } catch (IllegalArgumentException ignored) {}
        }
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) f.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp paidAt = rs.getTimestamp("paid_at");
        if (paidAt != null) f.setPaidAt(paidAt.toLocalDateTime());
        f.setPaymentMode(rs.getString("payment_mode"));

        try {
            f.setMemberName(rs.getString("member_name"));
            f.setBookTitle(rs.getString("book_title"));
        } catch (SQLException ignored) {}

        return f;
    }
}
