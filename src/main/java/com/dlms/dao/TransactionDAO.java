package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Transaction;
import com.dlms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

/**
 * Data Access Object for Transactions (Issue/Return Circulation).
 * Also aggregates real database statistics and analytics for dashboard charts.
 * Demonstrates Stack data structure for recent activity feeds.
 */
public class TransactionDAO {

    public boolean create(Transaction tx) throws DatabaseOperationException {
        String sql = "INSERT INTO transactions (transaction_id, member_id, book_id, issue_date, due_date, return_date, fine, status, issued_by, remarks) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, tx.getTransactionId());
            stmt.setString(2, tx.getMemberId());
            stmt.setString(3, tx.getBookId());
            stmt.setDate(4, Date.valueOf(tx.getIssueDate() != null ? tx.getIssueDate() : LocalDate.now()));
            stmt.setDate(5, Date.valueOf(tx.getDueDate()));
            if (tx.getReturnDate() != null) {
                stmt.setDate(6, Date.valueOf(tx.getReturnDate()));
            } else {
                stmt.setNull(6, java.sql.Types.DATE);
            }
            stmt.setDouble(7, tx.getFine());
            stmt.setString(8, tx.getStatus().name());
            stmt.setString(9, tx.getIssuedBy() != null ? tx.getIssuedBy() : "admin");
            stmt.setString(10, tx.getRemarks());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    tx.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to record issue transaction: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean updateReturn(String transactionId, LocalDate returnDate, double fine, String remarks) throws DatabaseOperationException {
        String sql = "UPDATE transactions SET return_date = ?, fine = ?, status = 'RETURNED', remarks = ? WHERE transaction_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(returnDate));
            stmt.setDouble(2, fine);
            stmt.setString(3, remarks);
            stmt.setString(4, transactionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to record return transaction: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public Transaction findByTransactionId(String transactionId) throws DatabaseOperationException {
        String sql = "SELECT t.*, b.title AS book_title, b.cover_url AS book_cover, m.name AS member_name " +
                     "FROM transactions t " +
                     "LEFT JOIN books b ON t.book_id = b.book_id " +
                     "LEFT JOIN members m ON t.member_id = m.member_id " +
                     "WHERE t.transaction_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, transactionId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToTransaction(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find transaction by ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public List<Transaction> findAll(String query, String status, String memberId, int offset, int limit) throws DatabaseOperationException {
        List<Transaction> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT t.*, b.title AS book_title, b.cover_url AS book_cover, m.name AS member_name " +
                "FROM transactions t " +
                "LEFT JOIN books b ON t.book_id = b.book_id " +
                "LEFT JOIN members m ON t.member_id = m.member_id " +
                "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (t.transaction_id LIKE ? OR t.member_id LIKE ? OR t.book_id LIKE ? OR b.title LIKE ? OR m.name LIKE ?) ");
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND t.status = ? ");
            params.add(status.trim());
        }

        if (memberId != null && !memberId.trim().isEmpty()) {
            sql.append(" AND t.member_id = ? ");
            params.add(memberId.trim());
        }

        sql.append(" ORDER BY t.id DESC LIMIT ? OFFSET ? ");
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
                list.add(mapRowToTransaction(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to query transactions: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public int count(String query, String status, String memberId) throws DatabaseOperationException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM transactions t " +
                "LEFT JOIN books b ON t.book_id = b.book_id " +
                "LEFT JOIN members m ON t.member_id = m.member_id " +
                "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (t.transaction_id LIKE ? OR t.member_id LIKE ? OR t.book_id LIKE ? OR b.title LIKE ? OR m.name LIKE ?) ");
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND t.status = ? ");
            params.add(status.trim());
        }

        if (memberId != null && !memberId.trim().isEmpty()) {
            sql.append(" AND t.member_id = ? ");
            params.add(memberId.trim());
        }

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
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to count transactions", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public int countActiveLoansByMember(String memberId) throws DatabaseOperationException {
        String sql = "SELECT COUNT(*) FROM transactions WHERE member_id = ? AND status IN ('ISSUED', 'OVERDUE')";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to count member loans", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    /**
     * Demonstrates Stack data structure for LIFO recent library circulation activity.
     */
    public Stack<Transaction> getRecentActivitiesStack(int limit) throws DatabaseOperationException {
        Stack<Transaction> stack = new Stack<>();
        List<Transaction> list = findAll(null, null, null, 0, limit);
        // Push in reverse order so latest is on top of stack
        for (int i = list.size() - 1; i >= 0; i--) {
            stack.push(list.get(i));
        }
        return stack;
    }

    // -------------------------------------------------------------
    // REAL DATABASE METRICS & AGGREGATIONS FOR DASHBOARDS & CHARTS
    // -------------------------------------------------------------

    public Map<String, Object> getDashboardStats() throws DatabaseOperationException {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.createStatement();

            // Total Books & Available Books
            rs = stmt.executeQuery("SELECT SUM(quantity) AS total_qty, SUM(available_copies) AS total_avail FROM books");
            int totalBooks = 0;
            int availBooks = 0;
            if (rs.next()) {
                totalBooks = rs.getInt("total_qty");
                availBooks = rs.getInt("total_avail");
            }
            rs.close();

            // Total Members
            rs = stmt.executeQuery("SELECT COUNT(*) FROM members WHERE status = 'ACTIVE'");
            int totalMembers = 0;
            if (rs.next()) {
                totalMembers = rs.getInt(1);
            }
            rs.close();

            // Issued Books (Active)
            rs = stmt.executeQuery("SELECT COUNT(*) FROM transactions WHERE status IN ('ISSUED', 'OVERDUE')");
            int issuedBooks = 0;
            if (rs.next()) {
                issuedBooks = rs.getInt(1);
            }
            rs.close();

            // Overdue Books (where status is OVERDUE OR due_date < CURDATE() and status = 'ISSUED')
            rs = stmt.executeQuery("SELECT COUNT(*) FROM transactions WHERE status = 'OVERDUE' OR (status = 'ISSUED' AND due_date < CURDATE())");
            int overdueBooks = 0;
            if (rs.next()) {
                overdueBooks = rs.getInt(1);
            }
            rs.close();

            // Total Unpaid Fines
            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM fines WHERE status = 'UNPAID'");
            double unpaidFines = 0.0;
            if (rs.next()) {
                unpaidFines = rs.getDouble(1);
            }
            rs.close();

            // Total Collected Fines
            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM fines WHERE status = 'PAID'");
            double paidFines = 0.0;
            if (rs.next()) {
                paidFines = rs.getDouble(1);
            }
            rs.close();

            // Total Pending Reservations
            rs = stmt.executeQuery("SELECT COUNT(*) FROM reservations WHERE status = 'PENDING'");
            int reservations = 0;
            if (rs.next()) {
                reservations = rs.getInt(1);
            }
            rs.close();

            int utilizationRate = totalBooks > 0 ? (int) Math.round((issuedBooks * 100.0) / totalBooks) : 0;
            int availableRatio = totalBooks > 0 ? (int) Math.round((availBooks * 100.0) / totalBooks) : 0;
            stats.put("totalBooks", totalBooks);
            stats.put("availableBooks", availBooks);
            stats.put("issuedBooks", issuedBooks);
            stats.put("totalMembers", totalMembers);
            stats.put("overdueBooks", overdueBooks);
            stats.put("unpaidFines", unpaidFines);
            stats.put("paidFines", paidFines);
            stats.put("pendingReservations", reservations);
            stats.put("utilizationRate", utilizationRate);
            stats.put("availableRatio", availableRatio);

            return stats;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to calculate real dashboard statistics: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Map<String, Integer> getCategoryDistribution() throws DatabaseOperationException {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT category, COUNT(*) AS cnt FROM books GROUP BY category ORDER BY cnt DESC LIMIT 7";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("cnt"));
            }
            return map;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to get category distribution", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Map<String, Integer> getMonthlyTransactionTrends() throws DatabaseOperationException {
        Map<String, Integer> trends = new HashMap<>();
        String sql = "SELECT DATE_FORMAT(issue_date, '%b %Y') AS m_label, COUNT(*) AS count_tx " +
                     "FROM transactions " +
                     "WHERE issue_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY m_label " +
                     "ORDER BY MIN(issue_date) ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                trends.put(rs.getString("m_label"), rs.getInt("count_tx"));
            }
            return trends;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to get monthly transaction trends", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    private Transaction mapRowToTransaction(ResultSet rs) throws SQLException {
        Transaction tx = new Transaction();
        tx.setId(rs.getInt("id"));
        tx.setTransactionId(rs.getString("transaction_id"));
        tx.setMemberId(rs.getString("member_id"));
        tx.setBookId(rs.getString("book_id"));

        Date issueDate = rs.getDate("issue_date");
        if (issueDate != null) tx.setIssueDate(issueDate.toLocalDate());

        Date dueDate = rs.getDate("due_date");
        if (dueDate != null) tx.setDueDate(dueDate.toLocalDate());

        Date returnDate = rs.getDate("return_date");
        if (returnDate != null) tx.setReturnDate(returnDate.toLocalDate());

        tx.setFine(rs.getDouble("fine"));
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                tx.setStatus(Transaction.Status.valueOf(statusStr));
            } catch (IllegalArgumentException ignored) {}
        }
        tx.setIssuedBy(rs.getString("issued_by"));
        tx.setRemarks(rs.getString("remarks"));

        try {
            tx.setBookTitle(rs.getString("book_title"));
            tx.setMemberName(rs.getString("member_name"));
            tx.setBookCoverUrl(rs.getString("book_cover"));
        } catch (SQLException ignored) {}

        return tx;
    }
}
