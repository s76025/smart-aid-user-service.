package com.lcms.dao;

import com.lcms.model.Manager;
import com.lcms.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class managerDAO {

    private static final String INSERT_SQL =
        "INSERT INTO managers (username, password, email) VALUES (?, ?, ?)";
    private static final String LOGIN_SQL =
        "SELECT * FROM managers WHERE username = ? AND password = ?";
    private static final String ALL_PARENTS_SQL =
        "SELECT id, username, email, phone FROM parents ORDER BY username";
    private static final String FIND_BY_USER_SQL =
        "SELECT id, username, email FROM managers WHERE username=? OR email=?";
    private static final String UPDATE_PASS_SQL =
        "UPDATE managers SET password=? WHERE id=?";

    public void registerManager(Manager manager) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setString(1, manager.getUsername());
            ps.setString(2, manager.getPassword());
            ps.setString(3, manager.getEmail());
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

    // Returns [id, username, email, phone] per row
    public List<String[]> getAllParents() throws SQLException {
        List<String[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(ALL_PARENTS_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone")
                });
            }
        }
        return list;
    }
}
