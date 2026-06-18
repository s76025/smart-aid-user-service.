package com.lcms.servlet;

import com.lcms.dao.teacherDAO;
import com.lcms.dao.managerDAO;
import com.lcms.dao.studentDAO;
import com.lcms.model.Teacher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/TeacherServlet")
public class TeacherServlet extends HttpServlet {

    private final teacherDAO teacherDAO = new teacherDAO();
    private final managerDAO managerDAO = new managerDAO();
    private final studentDAO studentDAO = new studentDAO();

    private boolean isTeacher(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "teacher".equals(s.getAttribute("role"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "login":
                request.getRequestDispatcher("/teacherLogin.jsp").forward(request, response);
                break;
            case "logout":
                handleLogout(request, response);
                break;
            default: // dashboard
                if (!isTeacher(request)) {
                    response.sendRedirect(request.getContextPath() + "/teacherLogin.jsp");
                    return;
                }
                loadDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login":         handleLogin(request, response);         break;
            case "logout":        handleLogout(request, response);        break;
            case "editParent":    handleEditParent(request, response);    break;
            case "deleteParent":  handleDeleteParent(request, response);  break;
            case "editStudent":   handleEditStudent(request, response);   break;
            case "deleteStudent": handleDeleteStudent(request, response); break;
            default: response.sendRedirect(request.getContextPath() + "/TeacherServlet");
        }
    }

    // ── Logout ──────────────────────────────────────────────────
    private void handleLogout(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        res.sendRedirect(req.getContextPath() + "/teacherLogin.jsp");
    }

    // ── Login ───────────────────────────────────────────────────
    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String user = req.getParameter("user");
        String pass = req.getParameter("pass");
        try {
            if (teacherDAO.validateLogin(user, pass)) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", "teacher");
                res.sendRedirect(req.getContextPath() + "/TeacherServlet");
            } else {
                req.setAttribute("error", "Invalid teacher credentials. Please try again.");
                req.getRequestDispatcher("/teacherLogin.jsp").forward(req, res);
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("/teacherLogin.jsp").forward(req, res);
        }
    }

    // ── Dashboard ───────────────────────────────────────────────
    private void loadDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("parents",  managerDAO.getAllParents());
            req.setAttribute("students", studentDAO.getAllStudents());
        } catch (SQLException e) { req.setAttribute("dbError", e.getMessage()); }
        req.getRequestDispatcher("/WEB-INF/teacherDashboard.jsp").forward(req, res);
    }

    // ── Edit Parent ─────────────────────────────────────────────
    private void handleEditParent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            new com.lcms.dao.parentDAO().updateParent(id,
                req.getParameter("email"), req.getParameter("phone"),
                Integer.parseInt(req.getParameter("age")),
                req.getParameter("occupation"), req.getParameter("address"));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Edit failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/TeacherServlet");
    }

    // ── Delete Parent ────────────────────────────────────────────
    private void handleDeleteParent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            new com.lcms.dao.parentDAO().deleteParent(Integer.parseInt(req.getParameter("id")));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Delete failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/TeacherServlet");
    }

    // ── Edit Student ─────────────────────────────────────────────
    private void handleEditStudent(HttpServletRequest req, HttpServletResponse res)
        throws IOException {
    try {
        int id = Integer.parseInt(req.getParameter("id"));

        int parentId = 0;
        String parentIdStr = req.getParameter("parentId");
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            parentId = Integer.parseInt(parentIdStr);
        }

        studentDAO.updateStudent(
            id,
            req.getParameter("firstName"),
            req.getParameter("lastName"),
            req.getParameter("dob"),
            req.getParameter("gender"),
            req.getParameter("guardian"),
            req.getParameter("relationship"),
            req.getParameter("phone"),
            req.getParameter("email"),
            parentId
        );

    } catch (Exception e) {
        req.getSession().setAttribute("flashError",
                "Edit failed: " + e.getMessage());
    }

    res.sendRedirect(req.getContextPath() + "/TeacherServlet");
}

    // ── Delete Student ────────────────────────────────────────────
    private void handleDeleteStudent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            studentDAO.deleteStudent(Integer.parseInt(req.getParameter("id")));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Delete failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/TeacherServlet");
    }
}
