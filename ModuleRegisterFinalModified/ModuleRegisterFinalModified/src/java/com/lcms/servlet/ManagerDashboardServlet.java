package com.lcms.servlet;

import com.lcms.dao.managerDAO;
import com.lcms.dao.studentDAO;
import com.lcms.dao.parentDAO;
import com.lcms.dao.teacherDAO;
import com.lcms.model.Teacher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManagerDashboardServlet")
public class ManagerDashboardServlet extends HttpServlet {

    private final managerDAO managerDAO = new managerDAO();
    private final studentDAO studentDAO = new studentDAO();
    private final parentDAO  parentDAO  = new parentDAO();
    private final teacherDAO teacherDAO = new teacherDAO();

    // ── Session guard helper ───────────────────────────────────
    private boolean isManager(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "manager".equals(s.getAttribute("role"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Prevent caching – stops back-button bypass after logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("addTeacher".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/addTeacher.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            loadDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "registerTeacher": handleRegisterTeacher(request, response); break;
            case "editTeacher":     handleEditTeacher(request, response);     break;
            case "deleteTeacher":   handleDeleteTeacher(request, response);   break;
            case "editParent":      handleEditParent(request, response);      break;
            case "deleteParent":    handleDeleteParent(request, response);    break;
            case "editStudent":     handleEditStudent(request, response);     break;
            case "deleteStudent":   handleDeleteStudent(request, response);   break;
            case "logout":          handleLogout(request, response);          break;
            default: response.sendRedirect(request.getContextPath() + "/ManagerDashboardServlet");
        }
    }

    // ── Logout ─────────────────────────────────────────────────
    private void handleLogout(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try { request.setAttribute("parents",  managerDAO.getAllParents()); }
        catch (SQLException e) { request.setAttribute("dbError", e.getMessage()); }
        try { request.setAttribute("students", studentDAO.getAllStudents()); }
        catch (SQLException e) { request.setAttribute("dbError", e.getMessage()); }
        try { request.setAttribute("teachers", teacherDAO.getAllTeachers()); }
        catch (SQLException e) { request.setAttribute("dbError", e.getMessage()); }
        request.getRequestDispatcher("/WEB-INF/managerDashboard.jsp").forward(request, response);
    }

    // ── Register Teacher ───────────────────────────────────────
    private void handleRegisterTeacher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        Teacher t = new Teacher(
            req.getParameter("user"),
            req.getParameter("pass"),
            req.getParameter("fullName"),
            req.getParameter("icNumber"),
            req.getParameter("email"),
            req.getParameter("phone"),
            req.getParameter("qualification"),
            req.getParameter("teachingExperience"),
            req.getParameter("subject")
        );
        try {
            teacherDAO.registerTeacher(t);
            req.getSession().setAttribute("flashSuccess",
                "Teacher \"" + t.getFullName() + "\" registered successfully!");
        } catch (SQLException e) {
            req.getSession().setAttribute("flashError",
                "Teacher registration failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Edit Teacher ───────────────────────────────────────────
    private void handleEditTeacher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            teacherDAO.updateTeacher(id,
                req.getParameter("fullName"),
                req.getParameter("icNumber"),
                req.getParameter("email"),
                req.getParameter("phone"),
                req.getParameter("qualification"),
                req.getParameter("teachingExperience"),
                req.getParameter("subject"));
            req.getSession().setAttribute("flashSuccess", "Teacher record updated successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Edit failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Delete Teacher (with existence validation) ─────────────
    private void handleDeleteTeacher(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            if (!teacherDAO.existsById(id)) {
                req.getSession().setAttribute("flashError",
                    "Delete failed: Teacher record not found. It may have already been removed.");
            } else {
                teacherDAO.deleteTeacher(id);
                req.getSession().setAttribute("flashSuccess",
                    "Teacher account deleted successfully.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flashError", "Delete failed: Invalid teacher ID.");
        } catch (SQLException e) {
            req.getSession().setAttribute("flashError", "Delete failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Edit Parent ────────────────────────────────────────────
    private void handleEditParent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int age = 0;
            try { age = Integer.parseInt(req.getParameter("age")); } catch (NumberFormatException ignored) {}
            parentDAO.updateParent(id,
                req.getParameter("email"), req.getParameter("phone"), age,
                req.getParameter("occupation"), req.getParameter("address"));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Edit failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Delete Parent ──────────────────────────────────────────
    private void handleDeleteParent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            parentDAO.deleteParent(Integer.parseInt(req.getParameter("id")));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Delete failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Edit Student ───────────────────────────────────────────
    private void handleEditStudent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int parentId = 0;
            try { parentId = Integer.parseInt(req.getParameter("parentId")); } catch (NumberFormatException ignored) {}
            studentDAO.updateStudent(id,
                req.getParameter("firstName"), req.getParameter("lastName"),
                req.getParameter("dob"),       req.getParameter("gender"),
                req.getParameter("guardian"),  req.getParameter("relationship"),
                req.getParameter("phone"),     req.getParameter("email"),
                parentId);
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Edit failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }

    // ── Delete Student ─────────────────────────────────────────
    private void handleDeleteStudent(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            studentDAO.deleteStudent(Integer.parseInt(req.getParameter("id")));
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Delete failed: " + e.getMessage());
        }
        res.sendRedirect(req.getContextPath() + "/ManagerDashboardServlet");
    }
}
