package com.lcms.dao;

import com.lcms.model.Teacher;
import com.lcms.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class teacherDAO {

    private static final String INSERT_SQL =
        "INSERT INTO teachers (username, password, full_name, ic_number, email, phone, qualification, teaching_experience, subject) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String LOGIN_SQL =
        "SELECT * FROM teachers WHERE username = ? AND password = ?";
    private static final String ALL_SQL =
        "SELECT id, username, full_name, ic_number, email, phone, qualification, teaching_experience, subject " +
        "FROM teachers ORDER BY full_name";
    private static final String UPDATE_SQL =
        "UPDATE teachers SET full_name=?, ic_number=?, email=?, phone=?, qualification=?, teaching_experience=?, subject=? WHERE id=?";
    private static final String DELETE_SQL =
        "DELETE FROM teachers WHERE id=?";
    private static final String EXISTS_SQL =
        "SELECT id FROM teachers WHERE id=?";
    private static final String FIND_BY_USER_SQL =
        "SELECT id, username, email FROM teachers WHERE username=? OR email=?";
    private static final String UPDATE_PASS_SQL =
        "UPDATE teachers SET password=? WHERE id=?";

    public void registerTeacher(Teacher t) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, t.getUsername());
            ps.setString(2, t.getPassword());
            ps.setString(3, t.getFullName());
            ps.setString(4, t.getIcNumber());
            ps.setString(5, t.getEmail());
            ps.setString(6, t.getPhone());
            ps.setString(7, t.getQualification());
            ps.setString(8, t.getTeachingExperience());
            ps.setString(9, t.getSubject());
            ps.executeUpdate();
        }
    }

    public boolean validateLogin(String username, String password) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(LOGIN_SQL)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    /** Returns true if a teacher with this id exists in the DB. */
    public boolean existsById(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(EXISTS_SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    /** Returns [id, username, email] for password-reset lookup, or null if not found. */
    public String[] findByUsernameOrEmail(String value) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_USER_SQL)) {
            ps.setString(1, value);
            ps.setString(2, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("username"),
                    rs.getString("email")
                };
            }
        }
        return null;
    }

    public void updatePassword(int id, String newPassword) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASS_SQL)) {
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    // Returns [id, username, full_name, ic_number, email, phone, qualification, teaching_experience, subject]
    public List<String[]> getAllTeachers() throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("username"),
                    rs.getString("full_name"),
                    rs.getString("ic_number"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("qualification"),
                    rs.getString("teaching_experience"),
                    rs.getString("subject")
                });
            }
        }
        return list;
    }

    public void updateTeacher(int id, String fullName, String icNumber, String email,
                              String phone, String qualification,
                              String teachingExperience, String subject) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, fullName);
            ps.setString(2, icNumber);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, qualification);
            ps.setString(6, teachingExperience);
            ps.setString(7, subject);
            ps.setInt(8, id);
            ps.executeUpdate();
        }
    }

    public void deleteTeacher(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
