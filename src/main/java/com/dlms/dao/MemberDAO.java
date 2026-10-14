package com.dlms.dao;

import com.dlms.exception.DatabaseOperationException;
import com.dlms.model.Faculty;
import com.dlms.model.Member;
import com.dlms.model.Student;
import com.dlms.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Library Members.
 * Implements polymorphic mapping where rows are instantiated as concrete Student or Faculty objects.
 */
public class MemberDAO {

    public List<Member> findAll(String query, String department, String memberType, int offset, int limit) throws DatabaseOperationException {
        List<Member> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM members WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (member_id LIKE ? OR name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            for (int i = 0; i < 4; i++) {
                params.add(wildcard);
            }
        }

        if (department != null && !department.trim().isEmpty() && !"ALL".equalsIgnoreCase(department)) {
            sql.append(" AND department = ? ");
            params.add(department.trim());
        }

        if (memberType != null && !memberType.trim().isEmpty() && !"ALL".equalsIgnoreCase(memberType)) {
            sql.append(" AND member_type = ? ");
            params.add(memberType.trim());
        }

        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ? ");
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
                list.add(mapRowToMember(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch library members: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public int count(String query, String department, String memberType) throws DatabaseOperationException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM members WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            String wildcard = "%" + query.trim() + "%";
            sql.append(" AND (member_id LIKE ? OR name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            for (int i = 0; i < 4; i++) {
                params.add(wildcard);
            }
        }

        if (department != null && !department.trim().isEmpty() && !"ALL".equalsIgnoreCase(department)) {
            sql.append(" AND department = ? ");
            params.add(department.trim());
        }

        if (memberType != null && !memberType.trim().isEmpty() && !"ALL".equalsIgnoreCase(memberType)) {
            sql.append(" AND member_type = ? ");
            params.add(memberType.trim());
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
            throw new DatabaseOperationException("Failed to count members", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Member findById(int id) throws DatabaseOperationException {
        String sql = "SELECT * FROM members WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToMember(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find member by ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public Member findByMemberId(String memberId) throws DatabaseOperationException {
        String sql = "SELECT * FROM members WHERE member_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, memberId.trim());
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToMember(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to find member by Member ID", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean create(Member m) throws DatabaseOperationException {
        String sql = "INSERT INTO members (member_id, name, email, phone, department, year, member_type, max_borrow_limit, registration_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, m.getMemberId());
            stmt.setString(2, m.getName());
            stmt.setString(3, m.getEmail());
            stmt.setString(4, m.getPhone());
            stmt.setString(5, m.getDepartment());

            String yearOrDesignation = "N/A";
            if (m instanceof Student) {
                yearOrDesignation = ((Student) m).getYear();
            } else if (m instanceof Faculty) {
                yearOrDesignation = ((Faculty) m).getDesignation();
            }
            stmt.setString(6, yearOrDesignation);
            stmt.setString(7, m.getMemberType().name());
            stmt.setInt(8, m.getMaxBorrowLimit());
            stmt.setDate(9, m.getRegistrationDate() != null ? Date.valueOf(m.getRegistrationDate()) : new Date(System.currentTimeMillis()));
            stmt.setString(10, m.getStatus() != null ? m.getStatus() : "ACTIVE");

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    m.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to register member: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    public boolean update(Member m) throws DatabaseOperationException {
        String sql = "UPDATE members SET name = ?, email = ?, phone = ?, department = ?, year = ?, member_type = ?, max_borrow_limit = ?, status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, m.getName());
            stmt.setString(2, m.getEmail());
            stmt.setString(3, m.getPhone());
            stmt.setString(4, m.getDepartment());

            String yearOrDesig = "N/A";
            if (m instanceof Student) {
                yearOrDesig = ((Student) m).getYear();
            } else if (m instanceof Faculty) {
                yearOrDesig = ((Faculty) m).getDesignation();
            }
            stmt.setString(5, yearOrDesig);
            stmt.setString(6, m.getMemberType().name());
            stmt.setInt(7, m.getMaxBorrowLimit());
            stmt.setString(8, m.getStatus());
            stmt.setInt(9, m.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to update member: " + e.getMessage(), e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public boolean delete(int id) throws DatabaseOperationException {
        String sql = "DELETE FROM members WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Cannot delete member. Member has linked transaction history.", e);
        } finally {
            DatabaseConnection.close(null, stmt, conn);
        }
    }

    public List<String> getDistinctDepartments() throws DatabaseOperationException {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT department FROM members ORDER BY department ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("department"));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseOperationException("Failed to fetch departments", e);
        } finally {
            DatabaseConnection.close(rs, stmt, conn);
        }
    }

    /**
     * Demonstrates HashMap data structure for fast O(1) in-memory member lookup.
     */
    public Map<String, Member> getMemberIdMap() throws DatabaseOperationException {
        Map<String, Member> map = new HashMap<>();
        List<Member> list = findAll(null, null, null, 0, 500);
        for (Member m : list) {
            map.put(m.getMemberId(), m);
        }
        return map;
    }

    private Member mapRowToMember(ResultSet rs) throws SQLException {
        String typeStr = rs.getString("member_type");
        Member.MemberType mType = Member.MemberType.STUDENT;
        try {
            if (typeStr != null) mType = Member.MemberType.valueOf(typeStr);
        } catch (IllegalArgumentException ignored) {}

        Member member;
        if (mType == Member.MemberType.FACULTY) {
            Faculty faculty = new Faculty();
            faculty.setDesignation(rs.getString("year"));
            member = faculty;
        } else {
            Student student = new Student();
            student.setYear(rs.getString("year"));
            member = student;
        }

        member.setId(rs.getInt("id"));
        member.setMemberId(rs.getString("member_id"));
        member.setName(rs.getString("name"));
        member.setEmail(rs.getString("email"));
        member.setPhone(rs.getString("phone"));
        member.setDepartment(rs.getString("department"));
        member.setMemberType(mType);
        member.setMaxBorrowLimit(rs.getInt("max_borrow_limit"));
        Date regDate = rs.getDate("registration_date");
        if (regDate != null) {
            member.setRegistrationDate(regDate.toLocalDate());
        }
        member.setStatus(rs.getString("status"));
        return member;
    }
}
