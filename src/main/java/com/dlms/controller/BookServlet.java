package com.dlms.controller;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Book;
import com.dlms.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller for Book Management (CRUD, Search, Filter, Sort, Pagination, and Details).
 */
@WebServlet(name = "BookServlet", urlPatterns = {"/admin/books", "/admin/books/*"})
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showAddForm(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "view":
                    viewBookDetails(req, resp);
                    break;
                case "delete":
                    deleteBook(req, resp);
                    break;
                case "list":
                default:
                    listBooks(req, resp);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            listBooks(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "save";

        try {
            if ("update".equals(action)) {
                updateBook(req, resp);
            } else {
                saveBook(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Error saving book: " + e.getMessage());
            req.setAttribute("book", extractBookFromRequest(req));
            try {
                showAddForm(req, resp);
            } catch (DatabaseOperationException de) {
                throw new ServletException(de);
            }
        }
    }

    private void listBooks(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String query = req.getParameter("q");
            String category = req.getParameter("category");
            String sortBy = req.getParameter("sort");
            String viewMode = req.getParameter("view"); // "table" or "cards"
            if (viewMode == null) viewMode = "table";

            int page = 1;
            int pageSize = 12;
            try {
                if (req.getParameter("page") != null) {
                    page = Math.max(1, Integer.parseInt(req.getParameter("page")));
                }
            } catch (NumberFormatException ignored) {}

            List<Book> books = bookService.getBooks(query, category, sortBy, page, pageSize);
            int totalCount = bookService.getTotalBooksCount(query, category);
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            List<String> categories = bookService.getCategories();

            req.setAttribute("books", books);
            req.setAttribute("categories", categories);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("paramQuery", query);
            req.setAttribute("paramCategory", category);
            req.setAttribute("paramSort", sortBy);
            req.setAttribute("viewMode", viewMode);

            req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
        } catch (DatabaseOperationException e) {
            req.setAttribute("errorMessage", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/admin/books.jsp").forward(req, resp);
        }
    }

    private void viewBookDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        int id = Integer.parseInt(req.getParameter("id"));
        Book book = bookService.getBookById(id);
        if (book != null) {
            req.setAttribute("book", book);
            req.getRequestDispatcher("/admin/book-details.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/books?error=Book not found");
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        req.setAttribute("categories", bookService.getCategories());
        req.getRequestDispatcher("/admin/book-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, DatabaseOperationException {
        int id = Integer.parseInt(req.getParameter("id"));
        Book book = bookService.getBookById(id);
        req.setAttribute("book", book);
        req.setAttribute("categories", bookService.getCategories());
        req.getRequestDispatcher("/admin/book-form.jsp").forward(req, resp);
    }

    private void saveBook(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Book book = extractBookFromRequest(req);
        bookService.addBook(book);
        resp.sendRedirect(req.getContextPath() + "/admin/books?success=Book '" + book.getTitle() + "' added successfully!");
    }

    private void updateBook(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Book book = extractBookFromRequest(req);
        book.setId(Integer.parseInt(req.getParameter("id")));
        bookService.updateBook(book);
        resp.sendRedirect(req.getContextPath() + "/admin/books?success=Book updated successfully!");
    }

    private void deleteBook(HttpServletRequest req, HttpServletResponse resp) throws IOException, DatabaseOperationException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean deleted = bookService.deleteBook(id);
        if (deleted) {
            resp.sendRedirect(req.getContextPath() + "/admin/books?success=Book deleted successfully.");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/books?error=Cannot delete book with active loans or transactions.");
        }
    }

    private Book extractBookFromRequest(HttpServletRequest req) {
        Book book = new Book();
        book.setBookId(req.getParameter("bookId"));
        book.setIsbn(req.getParameter("isbn"));
        book.setTitle(req.getParameter("title"));
        book.setAuthor(req.getParameter("author"));
        book.setCategory(req.getParameter("category"));
        book.setPublisher(req.getParameter("publisher"));
        try {
            book.setPublicationYear(Integer.parseInt(req.getParameter("publicationYear")));
        } catch (Exception ignored) {
            book.setPublicationYear(2024);
        }
        book.setLanguage(req.getParameter("language") != null ? req.getParameter("language") : "English");
        book.setDescription(req.getParameter("description"));
        book.setShelfNumber(req.getParameter("shelfNumber"));
        try {
            book.setQuantity(Integer.parseInt(req.getParameter("quantity")));
        } catch (Exception ignored) {
            book.setQuantity(1);
        }
        try {
            book.setAvailableCopies(Integer.parseInt(req.getParameter("availableCopies")));
        } catch (Exception ignored) {
            book.setAvailableCopies(book.getQuantity());
        }
        book.setCoverUrl(req.getParameter("coverUrl"));
        return book;
    }
}
