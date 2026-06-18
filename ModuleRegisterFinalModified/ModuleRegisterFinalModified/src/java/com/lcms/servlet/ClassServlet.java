package com.lcms.servlet;

import com.lcms.dao.classRoomDAO;
import com.lcms.model.ClassRoom;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ClassServlet")
public class ClassServlet extends HttpServlet {

    private final classRoomDAO classRoomDAO = new classRoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("students", classRoomDAO.getAllStudents());
        } catch (SQLException e) {
            request.setAttribute("dbError", e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/classSetup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] daysArray = request.getParameterValues("classDays");
        String days = (daysArray != null) ? String.join(", ", daysArray) : "";

        String[] studentParams = request.getParameterValues("studentIds");
        List<Integer> studentIds = new ArrayList<>();
        if (studentParams != null) {
            for (String s : studentParams) {
                try { studentIds.add(Integer.parseInt(s)); } catch (NumberFormatException ignored) {}
            }
        }

        int maxKids = 0;
        try { maxKids = Integer.parseInt(request.getParameter("maxKids")); }
        catch (NumberFormatException ignored) {}

        ClassRoom classRoom = new ClassRoom(
            request.getParameter("className"),
            request.getParameter("classCode"),
            maxKids,
            request.getParameter("teacher"),
            days
        );
        classRoom.setStudentIds(studentIds);

        try {
            classRoomDAO.createClass(classRoom);
            request.setAttribute("success", true);
            request.setAttribute("className", request.getParameter("className"));
            request.setAttribute("assignedCount", studentIds.size());
            request.setAttribute("message", "Class created successfully. Rawr!");
            request.getRequestDispatcher("/WEB-INF/classResult.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("success", false);
            request.setAttribute("message", e.getMessage());
            try {
                request.setAttribute("students", classRoomDAO.getAllStudents());
            } catch (SQLException ex) {
                request.setAttribute("dbError", ex.getMessage());
            }
            request.getRequestDispatcher("/WEB-INF/classSetup.jsp").forward(request, response);
        }
    }
}