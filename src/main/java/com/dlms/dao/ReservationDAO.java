package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Reservation;
import com.dlms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

/**
 * Data Access Object for Book Reservations.
 * Explicitly implements Java Queue data structure (LinkedList FIFO)
 * for first-come-first-served waiting lists on out-of-stock titles.
 */
public class ReservationDAO {

    public boolean create(Reservation res) throws DatabaseOperationException {
        // Calculate next queue position
        String posSql = "SELECT COALESCE(MAX(queue_position), 0) + 1 FROM reservations WHERE book_id = ? AND status = 'PENDING'";
        String insertSql = "INSERT INTO reservations (reservation_id, member_id, book_id, queue_position, status, expiry_date) " +
                          "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement posStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();

            posStmt = conn.prepareStatement(posSql);
            posStmt.setString(1, res.getBookId());
            rs = posStmt.executeQuery();
            int nextPos = 1;
            if (rs.next()) {
                nextPos = rs.getInt(1);
            }
            res.setQueuePosition(nextPos);

            insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            insertStmt.setString(1, res.getReservationId());
            insertStmt.setString(2, res.getMemberId());
            insertStmt.setString(3, res.getBookId());
            insertStmt.setInt(4, nextPos);
            insertStmt.setString(5, Reservation.Status.PENDING.name());
            insertStmt.setDate(6, Date.valueOf(LocalDate.now().plusDays(30)));

            int affected = insertStmt.executeUpdate();
            if (affected > 0) {
                rs = insertStmt.getGeneratedKeys();
                if (rs.next()) {
                    res.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to reserve book: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, posStmt, null);
            DatabaseConnection.close(null, insertStmt, conn);
        }
    }

    /**
     * Demonstrates Queue (FIFO) data structure for waitlist ordering.
     */
    public Queue<Reservation> getQueueForBook(String bookId) throws DatabaseOperationException {
        Queue<Reservation> waitlist = new LinkedList<>();
        String sql = "SELECT r.*, b.title AS book_title, b.cover_url AS book_cover, m.name AS member_name " +
                     "FROM reservations r " +
                     "LEFT JOIN books b ON r.book_id = b.book_id " +
                     "LEFT JOIN members m ON r.member_id = m.member_id " +
                     "WHERE r.book_id = ? AND r.status = 'PENDING' " +
                     "ORDER BY r.queue_position ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookId.trim());
            rs = stmt.executeQuery();
            while (rs.next()) {
                waitlist.offer(mapRowToReservation(rs));
            }
            return waitlist;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to load reservation waitlist queue", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public List<Reservation> findAll(String query, String status, int offset, int limit) throws DatabaseOperationException {
        List<Reservation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, b.title AS book_title, b.cover_url AS book_cover, m.name AS member_name " +
                "FROM reservations r " +
                "LEFT JOIN books b ON r.book_id = b.book_id " +
                "LEFT JOIN members m ON r.member_id = m.member_id " +
                "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (r.reservation_id LIKE ? OR r.member_id LIKE ? OR r.book_id LIKE ? OR b.title LIKE ? OR m.name LIKE ?) ");
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND r.status = ? ");
            params.add(status.trim());
        }

        sql.append(" ORDER BY r.id DESC LIMIT ? OFFSET ? ");
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
                list.add(mapRowToReservation(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch reservations: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public List<Reservation> findByMemberId(String memberId) throws DatabaseOperationException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, b.title AS book_title, b.cover_url AS book_cover, m.name AS member_name " +
                     "FROM reservations r " +
                     "LEFT JOIN books b ON r.book_id = b.book_id " +
                     "LEFT JOIN members m ON r.member_id = m.member_id " +
                     "WHERE r.member_id = ? " +
                     "ORDER BY r.id DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToReservation(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch member reservations", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean cancel(String reservationId) throws DatabaseOperationException {
        String sql = "UPDATE reservations SET status = 'CANCELLED' WHERE reservation_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, reservationId.trim());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to cancel reservation", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public boolean isAlreadyReservedByMember(String memberId, String bookId) throws DatabaseOperationException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE member_id = ? AND book_id = ? AND status = 'PENDING'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            stmt.setString(2, bookId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to check active reservations", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    private Reservation mapRowToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationId(rs.getString("reservation_id"));
        r.setMemberId(rs.getString("member_id"));
        r.setBookId(rs.getString("book_id"));
        java.sql.Timestamp ts = rs.getTimestamp("reservation_date");
        if (ts != null) r.setReservationDate(ts.toLocalDateTime());
        r.setQueuePosition(rs.getInt("queue_position"));
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                r.setStatus(Reservation.Status.valueOf(statusStr));
            } catch (IllegalArgumentException ignored) {}
        }
        Date expDate = rs.getDate("expiry_date");
        if (expDate != null) r.setExpiryDate(expDate.toLocalDate());

        try {
            r.setBookTitle(rs.getString("book_title"));
            r.setMemberName(rs.getString("member_name"));
            r.setBookCoverUrl(rs.getString("book_cover"));
        } catch (SQLException ignored) {}

        return r;
    }
}
