package com.dlms.service;

import com.dlms.dao.UserDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidLoginException;
import com.dlms.model.User;

/**
 * Service handling user authentication and credential security.
 */
public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public User login(String usernameOrEmail, String password) throws InvalidLoginException, DatabaseOperationException {
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            throw new InvalidLoginException("Username or email is required.");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new InvalidLoginException("Password is required.");
        }
        return userDAO.authenticate(usernameOrEmail, password);
    }

    public boolean register(User user) throws DatabaseOperationException {
        return userDAO.createUser(user);
    }

    public boolean changePassword(int userId, String newPassword) throws DatabaseOperationException {
        return userDAO.updatePassword(userId, newPassword);
    }
}
