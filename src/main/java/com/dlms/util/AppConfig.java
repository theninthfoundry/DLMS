package com.dlms.util;

import java.io.InputStream;
import java.util.Properties;

/**
 * Singleton configuration manager reading settings from db.properties.
 * Demonstrates Singleton pattern and clean external configuration management.
 */
public class AppConfig {
    private static AppConfig instance;
    private final Properties properties = new Properties();

    private AppConfig() {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                properties.load(is);
            } else {
                System.err.println("Warning: db.properties not found on classpath, using defaults.");
                setDefaultProperties();
            }
        } catch (Exception e) {
            System.err.println("Error loading db.properties: " + e.getMessage());
            setDefaultProperties();
        }
    }

    private void setDefaultProperties() {
        properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        properties.setProperty("db.url", "jdbc:mysql://localhost:3306/library_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
        properties.setProperty("db.username", "root");
        properties.setProperty("db.password", "root");
        properties.setProperty("library.finePerDay", "5.00");
        properties.setProperty("library.studentBorrowDays", "14");
        properties.setProperty("library.facultyBorrowDays", "30");
        properties.setProperty("library.studentMaxBooks", "4");
        properties.setProperty("library.facultyMaxBooks", "8");
    }

    public static synchronized AppConfig getInstance() {
        if (instance == null) {
            instance = new AppConfig();
        }
        return instance;
    }

    public String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    public String getProperty(String key) {
        return properties.getProperty(key);
    }

    public double getDouble(String key, double defaultValue) {
        try {
            return Double.parseDouble(properties.getProperty(key, String.valueOf(defaultValue)));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public int getInt(String key, int defaultValue) {
        try {
            return Integer.parseInt(properties.getProperty(key, String.valueOf(defaultValue)));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
