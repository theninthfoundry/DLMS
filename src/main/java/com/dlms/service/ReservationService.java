package com.dlms.service;

import com.dlms.dao.BookDAO;
import com.dlms.dao.MemberDAO;
import com.dlms.dao.ReservationDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.exception.InvalidMemberException;
import com.dlms.model.Book;
import com.dlms.model.Member;
import com.dlms.model.Reservation;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service managing reservation queues for books currently on loan.
 */
public class ReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final MemberDAO memberDAO = new MemberDAO();
    private final BookDAO bookDAO = new BookDAO();

    public Reservation reserveBook(String memberId, String bookId)
            throws InvalidMemberException, IllegalArgumentException, DatabaseOperationException {

        Member member = memberDAO.findByMemberId(memberId);
        if (member == null) {
            throw new InvalidMemberException("Member with ID '" + memberId + "' does not exist.");
        }

        Book book = bookDAO.findByBookId(bookId);
        if (book == null) {
            throw new IllegalArgumentException("Book with ID '" + bookId + "' was not found.");
        }

        if (reservationDAO.isAlreadyReservedByMember(memberId, bookId)) {
            throw new IllegalArgumentException("You already have an active pending reservation for '" + book.getTitle() + "'.");
        }

        Reservation res = new Reservation();
        res.setReservationId("RES-" + System.currentTimeMillis());
        res.setMemberId(memberId);
        res.setBookId(bookId);
        res.setReservationDate(LocalDateTime.now());
        res.setStatus(Reservation.Status.PENDING);
        res.setExpiryDate(LocalDate.now().plusDays(30));

        reservationDAO.create(res);
        return res;
    }

    public List<Reservation> getReservations(String query, String status, int page, int pageSize) throws DatabaseOperationException {
        int offset = (page - 1) * pageSize;
        return reservationDAO.findAll(query, status, offset, pageSize);
    }

    public List<Reservation> getMemberReservations(String memberId) throws DatabaseOperationException {
        return reservationDAO.findByMemberId(memberId);
    }

    public boolean cancelReservation(String reservationId) throws DatabaseOperationException {
        return reservationDAO.cancel(reservationId);
    }
}
