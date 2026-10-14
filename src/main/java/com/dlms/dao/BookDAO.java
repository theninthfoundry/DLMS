package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Book;
import com.dlms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Books.
 * Demonstrates JDBC CRUD, dynamic parameterized search/filtering, pagination,
 * and uses Java Collections (ArrayList, HashMap) for efficient data structure operations.
 */
public class BookDAO {

    public List<Book> findAll(String query, String category, String sortBy, int offset, int limit) throws DatabaseOperationException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (book_id LIKE ? OR isbn LIKE ? OR title LIKE ? OR author LIKE ? OR category LIKE ?) ");
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        // Sorting
        if ("title_asc".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY title ASC ");
        } else if ("title_desc".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY title DESC ");
        } else if ("author".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY author ASC ");
        } else if ("year_desc".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY publication_year DESC ");
        } else if ("available".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY available_copies DESC ");
        } else {
            sql.append(" ORDER BY id DESC ");
        }

        sql.append(" LIMIT ? OFFSET ? ");
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
                books.add(mapRowToBook(rs));
            }
            return books;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch books: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public int count(String query, String category) throws DatabaseOperationException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM books WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (book_id LIKE ? OR isbn LIKE ? OR title LIKE ? OR author LIKE ? OR category LIKE ?) ");
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
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
            throw new DatabaseOperationException("Failed to count books", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Book findById(int id) throws DatabaseOperationException {
        String sql = "SELECT * FROM books WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToBook(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find book by ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Book findByBookId(String bookId) throws DatabaseOperationException {
        String sql = "SELECT * FROM books WHERE book_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToBook(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find book by Book ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean create(Book book) throws DatabaseOperationException {
        String sql = "INSERT INTO books (book_id, isbn, title, author, category, publisher, publication_year, language, description, shelf_number, quantity, available_copies, status, cover_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, book.getBookId());
            stmt.setString(2, book.getIsbn());
            stmt.setString(3, book.getTitle());
            stmt.setString(4, book.getAuthor());
            stmt.setString(5, book.getCategory());
            stmt.setString(6, book.getPublisher());
            stmt.setInt(7, book.getPublicationYear());
            stmt.setString(8, book.getLanguage());
            stmt.setString(9, book.getDescription());
            stmt.setString(10, book.getShelfNumber());
            stmt.setInt(11, book.getQuantity());
            stmt.setInt(12, book.getAvailableCopies());
            stmt.setString(13, book.getAvailableCopies() > 0 ? "AVAILABLE" : "OUT_OF_STOCK");
            stmt.setString(14, book.getCoverUrl());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    book.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to create book: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean update(Book book) throws DatabaseOperationException {
        String sql = "UPDATE books SET isbn = ?, title = ?, author = ?, category = ?, publisher = ?, publication_year = ?, " +
                     "language = ?, description = ?, shelf_number = ?, quantity = ?, available_copies = ?, status = ?, cover_url = ? " +
                     "WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, book.getIsbn());
            stmt.setString(2, book.getTitle());
            stmt.setString(3, book.getAuthor());
            stmt.setString(4, book.getCategory());
            stmt.setString(5, book.getPublisher());
            stmt.setInt(6, book.getPublicationYear());
            stmt.setString(7, book.getLanguage());
            stmt.setString(8, book.getDescription());
            stmt.setString(9, book.getShelfNumber());
            stmt.setInt(10, book.getQuantity());
            stmt.setInt(11, book.getAvailableCopies());
            stmt.setString(12, book.getAvailableCopies() > 0 ? "AVAILABLE" : "OUT_OF_STOCK");
            stmt.setString(13, book.getCoverUrl());
            stmt.setInt(14, book.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to update book: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public boolean delete(int id) throws DatabaseOperationException {
        String sql = "DELETE FROM books WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Cannot delete book. Historical transaction records reference this book.", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    /**
     * Updates available copies by delta (e.g., -1 for issue, +1 for return).
     * Synchronizes availability status.
     */
    public boolean updateAvailableCopies(String bookId, int delta) throws DatabaseOperationException {
        String sql = "UPDATE books SET available_copies = available_copies + ?, " +
                     "status = CASE WHEN (available_copies + ?) > 0 THEN 'AVAILABLE' ELSE 'OUT_OF_STOCK' END " +
                     "WHERE book_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, delta);
            stmt.setInt(2, delta);
            stmt.setString(3, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to adjust book available copies", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public List<String> getDistinctCategories() throws DatabaseOperationException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM books ORDER BY category ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
            return categories;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch book categories", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    /**
     * Demonstrates HashMap data structure for O(1) in-memory fast book lookup.
     */
    public Map<String, Book> getBookIdMap() throws DatabaseOperationException {
        Map<String, Book> map = new HashMap<>();
        List<Book> list = findAll(null, null, null, 0, 500);
        for (Book b : list) {
            map.put(b.getBookId(), b);
        }
        return map;
    }

    private Book mapRowToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setBookId(rs.getString("book_id"));
        b.setIsbn(rs.getString("isbn"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setPublisher(rs.getString("publisher"));
        b.setPublicationYear(rs.getInt("publication_year"));
        b.setLanguage(rs.getString("language"));
        b.setDescription(rs.getString("description"));
        b.setShelfNumber(rs.getString("shelf_number"));
        b.setQuantity(rs.getInt("quantity"));
        b.setAvailableCopies(rs.getInt("available_copies"));
        b.setStatus(rs.getString("status"));
        b.setCoverUrl(rs.getString("cover_url"));
        java.sql.Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            b.setCreatedAt(ts.toLocalDateTime());
        }
        return b;
    }
}
