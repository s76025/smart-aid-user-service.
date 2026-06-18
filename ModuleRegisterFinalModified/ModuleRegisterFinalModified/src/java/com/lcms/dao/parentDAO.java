package com.lcms.dao;

import com.lcms.model.Parent;
import com.lcms.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class parentDAO {

    private static final String INSERT_SQL =
        "INSERT INTO parents (username, password, email, phone, age, occupation, address, ic) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String LOGIN_SQL =
        "SELECT * FROM parents WHERE username = ? AND password = ?";

    private static final String GET_BY_ID_SQL =
        "SELECT id, username, email, phone, age, occupation, address, ic FROM parents WHERE id = ?";

    private static final String UPDATE_SQL =
        "UPDATE parents SET email=?, phone=?, age=?, occupation=?, address=? WHERE id=?";

    private static final String DELETE_SQL =
        "DELETE FROM parents WHERE id=?";

    public void registerParent(Parent parent) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, parent.getUsername());
            ps.setString(2, parent.getPassword());
            ps.setString(3, parent.getEmail());
            ps.setString(4, parent.getPhone());
            ps.setInt(5, parent.getAge());
            ps.setString(6, parent.getOccupation());
            ps.setString(7, parent.getAddress());
            ps.setString(8, parent.getIc());
            ps.executeUpdate();
        }
    }

    public boolean validateLogin(String username, String password) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(LOGIN_SQL)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Returns [id, username, email, phone, age, occupation, address, ic]
    public String[] getParentById(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_BY_ID_SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        String.valueOf(rs.getInt("age")),
                        rs.getString("occupation"),
                        rs.getString("address"),
                        rs.getString("ic")
                    };
                }
            }
        }
        return null;
    }

    public void updateParent(int id, String email, String phone, int age,
                              String occupation, String address) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setInt(3, age);
            ps.setString(4, occupation);
            ps.setString(5, address);
            ps.setInt(6, id);
            ps.executeUpdate();
        }
    }

    public void deleteParent(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private static final String FIND_BY_USER_SQL =
        "SELECT id, username, email FROM parents WHERE username=? OR email=?";
    private static final String UPDATE_PASS_SQL =
        "UPDATE parents SET password=? WHERE id=?";

    /** Returns [id, username, email] or null for password-reset lookup. */
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
}
