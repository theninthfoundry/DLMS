package com.dlms.service;

import com.dlms.dao.BookDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Book;

import java.util.List;

/**
 * Service managing book business logic, validation, and search algorithms.
 */
public class BookService {
    private final BookDAO bookDAO = new BookDAO();

    public List<Book> getBooks(String query, String category, String sortBy, int page, int pageSize) throws DatabaseOperationException {
        int offset = (page - 1) * pageSize;
        return bookDAO.findAll(query, category, sortBy, offset, pageSize);
    }

    public int getTotalBooksCount(String query, String category) throws DatabaseOperationException {
        return bookDAO.count(query, category);
    }

    public Book getBookById(int id) throws DatabaseOperationException {
        return bookDAO.findById(id);
    }

    public Book getBookByBookId(String bookId) throws DatabaseOperationException {
        return bookDAO.findByBookId(bookId);
    }

    public List<String> getCategories() throws DatabaseOperationException {
        return bookDAO.getDistinctCategories();
    }

    public boolean addBook(Book book) throws DatabaseOperationException, IllegalArgumentException {
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book title is required.");
        }
        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            throw new IllegalArgumentException("Author is required.");
        }
        if (book.getBookId() == null || book.getBookId().trim().isEmpty()) {
            book.setBookId("BK-" + (System.currentTimeMillis() % 100000));
        }
        if (book.getQuantity() <= 0) {
            book.setQuantity(1);
        }
        book.setAvailableCopies(book.getQuantity());
        book.setStatus("AVAILABLE");

        return bookDAO.create(book);
    }

    public boolean updateBook(Book book) throws DatabaseOperationException, IllegalArgumentException {
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book title is required.");
        }
        if (book.getAvailableCopies() > book.getQuantity()) {
            book.setAvailableCopies(book.getQuantity());
        }
        book.setStatus(book.getAvailableCopies() > 0 ? "AVAILABLE" : "OUT_OF_STOCK");
        return bookDAO.update(book);
    }

    public boolean deleteBook(int id) throws DatabaseOperationException {
        return bookDAO.delete(id);
    }
}
