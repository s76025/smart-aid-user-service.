package com.lcms.dao;

import com.lcms.model.ClassRoom;
import com.lcms.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class classRoomDAO {

    private static final String INSERT_SQL =
        "INSERT INTO classes (class_name, class_code, max_children, teacher, class_days) " +
        "VALUES (?, ?, ?, ?, ?)";

    private static final String ALL_STUDENTS_SQL =
        "SELECT id, first_name, last_name FROM students ORDER BY first_name, last_name";

    private static final String ASSIGN_SQL =
        "UPDATE students SET classroom_id = ? WHERE id = ?";

    public void createClass(ClassRoom classRoom) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet keys = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert the class
            ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, classRoom.getClassName());
            ps.setString(2, classRoom.getClassCode());
            ps.setInt(3, classRoom.getMaxKids());
            ps.setString(4, classRoom.getTeacher());
            ps.setString(5, classRoom.getClassDays());
            ps.executeUpdate();

            // 2. Get the generated class ID
            int classId = -1;
            keys = ps.getGeneratedKeys();
            if (keys.next()) {
                classId = keys.getInt(1);
            }
            keys.close();
            ps.close();

            if (classId == -1) {
                throw new SQLException("Failed to get generated class ID.");
            }

            // 3. Assign selected students
            if (classRoom.getStudentIds() != null && !classRoom.getStudentIds().isEmpty()) {
                ps = conn.prepareStatement(ASSIGN_SQL);
                for (int sid : classRoom.getStudentIds()) {
                    ps.setInt(1, classId);
                    ps.setInt(2, sid);
                    ps.addBatch();
                }
                ps.executeBatch();
                ps.close();
            }

            conn.commit();

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            throw e;
        } finally {
            if (keys != null) try { keys.close(); } catch (SQLException ignored) {}
            if (ps   != null) try { ps.close();   } catch (SQLException ignored) {}
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public List<String[]> getAllStudents() throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(ALL_STUDENTS_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("first_name"),
                    rs.getString("last_name")
                });
            }
        }
        return list;
    }
}