package com.lcms.servlet;

import com.lcms.dao.managerDAO;
import com.lcms.dao.parentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private final parentDAO  parentDAO  = new parentDAO();
    private final managerDAO managerDAO = new managerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String role = request.getParameter("role"); // "parent" or "manager"

        try {
            if ("manager".equals(role)) {
                if (managerDAO.validateLogin(user, pass)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("role", "manager");
                    response.sendRedirect("ManagerDashboardServlet");
                } else {
                    request.setAttribute("error", "Invalid manager credentials. Please try again.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                if (parentDAO.validateLogin(user, pass)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("role", "parent");
                    response.sendRedirect("registration.jsp");
                } else {
                    request.setAttribute("error", "Invalid username or password. Please try again.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}