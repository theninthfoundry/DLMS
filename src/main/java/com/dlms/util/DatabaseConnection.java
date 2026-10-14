package com.dlms.util;

import com.dlms.exception.DatabaseOperationException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Manages database connectivity using JDBC.
 * Implements standard singleton design pattern and centralized connection lifecycle.
 */
public class DatabaseConnection {

    private static DatabaseConnection instance;
    private final String url;
    private final String username;
    private final String password;
    private final String driver;

    private DatabaseConnection() {
        AppConfig config = AppConfig.getInstance();
        this.driver = config.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        this.url = config.getProperty("db.url", "jdbc:mysql://localhost:3306/library_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
        this.username = config.getProperty("db.username", "root");
        this.password = config.getProperty("db.password", "root");

        try {
            Class.forName(this.driver);
        } catch (ClassNotFoundException e) {
            System.err.println("CRITICAL: MySQL JDBC Driver not found in classpath: " + driver);
        }
    }

    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    /**
     * Obtains a new database connection.
     * @return Connection object
     * @throws DatabaseOperationException if connection cannot be established
     */
    public Connection getConnection() throws DatabaseOperationException {
        try {
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            throw new DatabaseOperationException("Unable to connect to the library database. " +
                    "Please verify MySQL is running and database 'library_management' exists. Error: " + e.getMessage(), e);
        }
    }

    /**
     * Tests if MySQL server and the library database are reachable.
     */
    public boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Safely closes JDBC resources.
     */
    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException ignored) {}
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException ignored) {}
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
