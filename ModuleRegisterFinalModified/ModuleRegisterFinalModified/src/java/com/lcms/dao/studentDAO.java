package com.lcms.dao;

import com.lcms.model.Student;
import com.lcms.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class studentDAO {

    private static final String INSERT_SQL =
        "INSERT INTO students (first_name, last_name, dob, gender, guardian, " +
        "relationship, phone, email, parent_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // [0]id [1]first_name [2]last_name [3]dob [4]parent_id
    private static final String ALL_STUDENTS_SQL =
        "SELECT s.id, s.first_name, s.last_name, s.dob, " +
        "COALESCE(s.parent_id, 0) AS parent_id, " +
        "COALESCE(p.username, '') AS parent_name " +
        "FROM students s " +
        "LEFT JOIN parents p ON s.parent_id = p.id " +
        "ORDER BY s.first_name, s.last_name";

    private static final String STUDENTS_BY_PARENT_SQL =
        "SELECT id, first_name, last_name, dob, gender FROM students WHERE parent_id = ? ORDER BY first_name";

    private static final String GET_BY_ID_SQL =
        "SELECT s.id, s.first_name, s.last_name, s.dob, s.gender, s.guardian, " +
        "s.relationship, s.phone, s.email, COALESCE(s.parent_id,0) AS parent_id, " +
        "COALESCE(p.username,'') AS parent_name " +
        "FROM students s LEFT JOIN parents p ON s.parent_id = p.id WHERE s.id = ?";

    private static final String UPDATE_SQL =
        "UPDATE students SET first_name=?, last_name=?, dob=?, gender=?, " +
        "guardian=?, relationship=?, phone=?, email=?, parent_id=? WHERE id=?";

    private static final String DELETE_SQL =
        "DELETE FROM students WHERE id=?";

    public void registerStudent(Student student) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, student.getFirstName());
            ps.setString(2, student.getLastName());
            ps.setString(3, student.getDob());
            ps.setString(4, student.getGender());
            ps.setString(5, student.getGuardian());
            ps.setString(6, student.getRelationship());
            ps.setString(7, student.getPhone());
            ps.setString(8, student.getEmail());
            if (student.getParentId() > 0) {
                ps.setInt(9, student.getParentId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.executeUpdate();
        }
    }

    // Returns [id, first_name, last_name, dob, parent_id, parent_name]
    public List<String[]> getAllStudents() throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(ALL_STUDENTS_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),         // [0]
                    rs.getString("first_name"),               // [1]
                    rs.getString("last_name"),                // [2]
                    rs.getString("dob"),                      // [3]
                    String.valueOf(rs.getInt("parent_id")),  // [4]
                    rs.getString("parent_name")               // [5]
                });
            }
        }
        return list;
    }

    // Returns [id, first_name, last_name, dob, gender]
    public List<String[]> getStudentsByParent(int parentId) throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(STUDENTS_BY_PARENT_SQL)) {
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("dob"),
                        rs.getString("gender")
                    });
                }
            }
        }
        return list;
    }

    // Returns full detail for one student
    // [0]id [1]fname [2]lname [3]dob [4]gender [5]guardian [6]rel [7]phone [8]email [9]parent_id [10]parent_name
    public String[] getStudentById(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_BY_ID_SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("dob"),
                        rs.getString("gender"),
                        rs.getString("guardian"),
                        rs.getString("relationship"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        String.valueOf(rs.getInt("parent_id")),
                        rs.getString("parent_name")
                    };
                }
            }
        }
        return null;
    }

    public void updateStudent(int id, String firstName, String lastName, String dob,
                               String gender, String guardian, String rel,
                               String phone, String email, int parentId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, dob);
            ps.setString(4, gender);
            ps.setString(5, guardian);
            ps.setString(6, rel);
            ps.setString(7, phone);
            ps.setString(8, email);
            if (parentId > 0) ps.setInt(9, parentId);
            else ps.setNull(9, Types.INTEGER);
            ps.setInt(10, id);
            ps.executeUpdate();
        }
    }

    public void deleteStudent(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
