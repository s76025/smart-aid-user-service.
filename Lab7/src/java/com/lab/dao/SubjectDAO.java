package com.lab.dao;

import com.lab.bean.SubjectBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/lab7_db", "root", "admin");
    }

    // CREATE (Add Subject)
    public boolean addSubject(SubjectBean subject) {
        String sql = "INSERT INTO registered_subjects (matric_no, subject_code, subject_name) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, subject.getMatricNo());
            pstmt.setString(2, subject.getSubjectCode());
            pstmt.setString(3, subject.getSubjectName());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ (View list filtered by specific user session)
    public List<SubjectBean> getSubjectsByMatric(String matricNo) {
        List<SubjectBean> list = new ArrayList<>();
        String sql = "SELECT * FROM registered_subjects WHERE matric_no = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, matricNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SubjectBean subject = new SubjectBean();
                    subject.setId(rs.getInt("id"));
                    subject.setMatricNo(rs.getString("matric_no"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                    list.add(subject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // READ SINGLE (For updating view)
    public SubjectBean getSubjectById(int id) {
        SubjectBean subject = null;
        String sql = "SELECT * FROM registered_subjects WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    subject = new SubjectBean();
                    subject.setId(rs.getInt("id"));
                    subject.setMatricNo(rs.getString("matric_no"));
                    subject.setSubjectCode(rs.getString("subject_code"));
                    subject.setSubjectName(rs.getString("subject_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subject;
    }

    // UPDATE
    public boolean updateSubject(SubjectBean subject) {
        String sql = "UPDATE registered_subjects SET subject_code = ?, subject_name = ? WHERE id = ? AND matric_no = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, subject.getSubjectCode());
            pstmt.setString(2, subject.getSubjectName());
            pstmt.setInt(3, subject.getId());
            pstmt.setString(4, subject.getMatricNo());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE
    public boolean deleteSubject(int id, String matricNo) {
        String sql = "DELETE FROM registered_subjects WHERE id = ? AND matric_no = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, matricNo);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
