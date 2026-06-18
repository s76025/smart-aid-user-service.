package com.lcms.servlet;

import com.lcms.dao.studentDAO;
import com.lcms.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

    private final studentDAO studentDAO = new studentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : "parent";

        int parentId = 0;
        if ("manager".equals(role)) {
            String pid = request.getParameter("parentId");
            if (pid != null && !pid.isEmpty()) {
                try { parentId = Integer.parseInt(pid); } catch (NumberFormatException ignored) {}
            }
        }

        Student student = new Student(
            request.getParameter("fname"),
            request.getParameter("lname"),
            request.getParameter("dob"),
            request.getParameter("gender"),
            request.getParameter("gname"),
            request.getParameter("rel"),
            request.getParameter("phone"),
            request.getParameter("email")
        );
        student.setParentId(parentId);

        try {
            studentDAO.registerStudent(student);
            request.setAttribute("success", true);
            request.setAttribute("message", "Student registered successfully. Welcome to the pack!");
        } catch (SQLException e) {
            request.setAttribute("success", false);
            request.setAttribute("message", e.getMessage());
        }

        request.getRequestDispatcher("/studentResult.jsp").forward(request, response);
    }
}