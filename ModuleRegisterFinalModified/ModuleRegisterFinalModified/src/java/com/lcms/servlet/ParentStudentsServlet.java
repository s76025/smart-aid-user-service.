package com.lcms.servlet;

import com.lcms.dao.parentDAO;
import com.lcms.dao.studentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ParentStudentsServlet")
public class ParentStudentsServlet extends HttpServlet {

    private final parentDAO  parentDAO  = new parentDAO();
    private final studentDAO studentDAO = new studentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"teacher".equals(role) && !"manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Can view by parentId OR studentId
        String pidStr = request.getParameter("parentId");
        String sidStr = request.getParameter("studentId");

        try {
            if (sidStr != null && !sidStr.isEmpty()) {
                // Came from clicking a student name — look up their parent
                String[] student = studentDAO.getStudentById(Integer.parseInt(sidStr));
                if (student != null && Integer.parseInt(student[9]) > 0) {
                    int parentId = Integer.parseInt(student[9]);
                    String[] parent   = parentDAO.getParentById(parentId);
                    List<String[]> students = studentDAO.getStudentsByParent(parentId);
                    request.setAttribute("parent",          parent);
                    request.setAttribute("students",        students);
                    request.setAttribute("highlightStudent", sidStr);
                } else {
                    // student has no parent linked
                    request.setAttribute("noParent", true);
                    request.setAttribute("studentName",
                        student != null ? student[1] + " " + student[2] : "Unknown");
                }
            } else if (pidStr != null && !pidStr.isEmpty()) {
                // Came from clicking a parent name
                int parentId = Integer.parseInt(pidStr);
                String[] parent   = parentDAO.getParentById(parentId);
                List<String[]> students = studentDAO.getStudentsByParent(parentId);
                request.setAttribute("parent",   parent);
                request.setAttribute("students", students);
            }
        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("dbError", e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/parentStudents.jsp").forward(request, response);
    }
}
