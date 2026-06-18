package com.lcms.servlet;

import com.lcms.dao.managerDAO;
import com.lcms.dao.parentDAO;
import com.lcms.dao.teacherDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles Forgot Password flow for all three user types:
 *   GET  ?role=parent|teacher|manager  → show lookup form
 *   POST action=lookup                  → check account exists
 *   POST action=reset                   → update password
 */
@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private final managerDAO managerDAO = new managerDAO();
    private final parentDAO  parentDAO  = new parentDAO();
    private final teacherDAO teacherDAO = new teacherDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String role = req.getParameter("role");
        if (role == null) role = "parent";
        req.setAttribute("role", role);
        req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String role   = req.getParameter("role");
        if (role   == null) role   = "parent";
        if (action == null) action = "lookup";

        if ("lookup".equals(action)) {
            handleLookup(req, res, role);
        } else if ("reset".equals(action)) {
            handleReset(req, res, role);
        } else {
            res.sendRedirect(req.getContextPath() + "/ForgotPasswordServlet?role=" + role);
        }
    }

    // ── Step 1: look up account ────────────────────────────────
    private void handleLookup(HttpServletRequest req, HttpServletResponse res, String role)
            throws ServletException, IOException {
        String value = req.getParameter("identifier");
        if (value == null || value.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your username or email.");
            req.setAttribute("role", role);
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            return;
        }
        value = value.trim();
        try {
            String[] found = findAccount(role, value);
            if (found == null) {
                req.setAttribute("error", "Account not found. Please check your username or email.");
                req.setAttribute("role", role);
                req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            } else {
                // Store id in session for reset step
                req.getSession().setAttribute("resetId",   found[0]);
                req.getSession().setAttribute("resetRole", role);
                req.setAttribute("accountUser", found[1]);
                req.setAttribute("role", role);
                req.setAttribute("step", "reset");
                req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.setAttribute("role", role);
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
        }
    }

    // ── Step 2: update password ────────────────────────────────
    private void handleReset(HttpServletRequest req, HttpServletResponse res, String role)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String resetId   = (session != null) ? (String) session.getAttribute("resetId")   : null;
        String resetRole = (session != null) ? (String) session.getAttribute("resetRole") : null;

        // Validate session token
        if (resetId == null || !role.equals(resetRole)) {
            req.setAttribute("error", "Session expired. Please start again.");
            req.setAttribute("role", role);
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            return;
        }

        String newPass     = req.getParameter("newPass");
        String confirmPass = req.getParameter("confirmPass");

        if (newPass == null || newPass.trim().isEmpty()) {
            req.setAttribute("error", "Password cannot be empty.");
            req.setAttribute("role", role);
            req.setAttribute("step", "reset");
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            return;
        }
        if (!newPass.equals(confirmPass)) {
            req.setAttribute("error", "Passwords do not match. Please try again.");
            req.setAttribute("role", role);
            req.setAttribute("step", "reset");
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
            return;
        }

        try {
            int id = Integer.parseInt(resetId);
            updatePassword(role, id, newPass.trim());
            // Clear reset session tokens
            session.removeAttribute("resetId");
            session.removeAttribute("resetRole");

            // Redirect to appropriate login with success message
            String loginPage = getLoginPage(req, role);
            req.getSession().setAttribute("flashSuccess",
                "Password updated successfully. Please login again.");
            res.sendRedirect(loginPage);
        } catch (Exception e) {
            req.setAttribute("error", "Reset failed: " + e.getMessage());
            req.setAttribute("role", role);
            req.setAttribute("step", "reset");
            req.getRequestDispatcher("/forgotPassword.jsp").forward(req, res);
        }
    }

    // ── Helpers ────────────────────────────────────────────────
    private String[] findAccount(String role, String value) throws SQLException {
        switch (role) {
            case "manager": return managerDAO.findByUsernameOrEmail(value);
            case "teacher": return teacherDAO.findByUsernameOrEmail(value);
            default:        return parentDAO.findByUsernameOrEmail(value);
        }
    }

    private void updatePassword(String role, int id, String pass) throws SQLException {
        switch (role) {
            case "manager": managerDAO.updatePassword(id, pass); break;
            case "teacher": teacherDAO.updatePassword(id, pass); break;
            default:        parentDAO.updatePassword(id, pass);  break;
        }
    }

    private String getLoginPage(HttpServletRequest req, String role) {
        String ctx = req.getContextPath();
        switch (role) {
            case "teacher": return ctx + "/teacherLogin.jsp";
            default:        return ctx + "/login.jsp";
        }
    }
}
