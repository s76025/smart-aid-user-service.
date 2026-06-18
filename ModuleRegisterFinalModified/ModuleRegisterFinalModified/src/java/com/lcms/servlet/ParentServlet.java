package com.lcms.servlet;

import com.lcms.dao.parentDAO;
import com.lcms.model.Parent;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ParentServlet")
public class ParentServlet extends HttpServlet {

    private final parentDAO parentDAO = new parentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
        response.setHeader("Pragma","no-cache");
        response.setDateHeader("Expires",0);
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int age = 0;
        try { age = Integer.parseInt(request.getParameter("age")); }
        catch (NumberFormatException ignored) {}

        Parent parent = new Parent(
            request.getParameter("user"),
            request.getParameter("pass"),
            request.getParameter("email"),
            request.getParameter("phone"),
            age,
            request.getParameter("occupation"),
            request.getParameter("address"),
            request.getParameter("ic")
        );

        try {
            parentDAO.registerParent(parent);
            HttpSession session = request.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("role") : null;
            if ("manager".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/registration.jsp?newParent=1");
            } else {
                request.setAttribute("success", true);
                request.setAttribute("message", "Parent registered successfully! Welcome to the herd!");
                request.getRequestDispatcher("/parentResult.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("success", false);
            request.setAttribute("message", e.getMessage());
            request.getRequestDispatcher("/parentResult.jsp").forward(request, response);
        }
    }
}
