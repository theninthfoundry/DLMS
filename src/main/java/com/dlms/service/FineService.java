package com.dlms.service;

import com.dlms.dao.FineDAO;
import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Fine;

import java.util.List;

/**
 * Service managing overdue fine collections and payment records.
 */
public class FineService {
    private final FineDAO fineDAO = new FineDAO();

    public List<Fine> getFines(String query, String status, int page, int pageSize) throws DatabaseOperationException {
        int offset = (page - 1) * pageSize;
        return fineDAO.findAll(query, status, offset, pageSize);
    }

    public List<Fine> getMemberFines(String memberId) throws DatabaseOperationException {
        return fineDAO.findByMemberId(memberId);
    }

    public double getMemberUnpaidTotal(String memberId) throws DatabaseOperationException {
        return fineDAO.getTotalUnpaidForMember(memberId);
    }

    public boolean markFinePaid(String fineId, String paymentMode) throws DatabaseOperationException {
        return fineDAO.markAsPaid(fineId, paymentMode);
    }
}
