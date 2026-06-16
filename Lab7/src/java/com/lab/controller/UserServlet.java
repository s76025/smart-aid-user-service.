package com.lab.controller;

import com.lab.bean.StudentBean;
import com.lab.dao.StudentDAO;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Name : Noor Izza Hazira bt Norddin
 * Matric no : S76025
 */
@MultipartConfig(maxFileSize = 16177215) // max 16 MB required for image upload
public class UserServlet extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
// Read the hidden parameter to decide which action to execute
        String action = request.getParameter("action");
        if ("register".equals(action)) {
//--- 1. HANDLE REGISTRATION--
            StudentBean newStudent = new StudentBean();
            newStudent.setMatricNo(request.getParameter("matricNo"));
            newStudent.setFullname(request.getParameter("fullname"));
            newStudent.setPassword(request.getParameter("password"));
            InputStream inputStream = null;
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                inputStream = filePart.getInputStream();
            }
            boolean isSuccess = studentDAO.registerStudent(newStudent, inputStream);
            if (isSuccess) {
                response.getWriter().println("Registration Successful! <a  href ='login.html'>Login here</a>");
            } else {
                response.getWriter().println("Registration Failed!");
            }
        } else if ("login".equals(action)) {
//--- 2. HANDLE LOGIN--
            String matric = request.getParameter("matricNo");
            String pass = request.getParameter("password");
            StudentBean student = studentDAO.loginStudent(matric, pass);
            if (student != null) {
// Login successful: Store the entire bean in the Session
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", student);
                response.sendRedirect("dashboard.jsp");
            } else {
                response.getWriter().println("Invalid Credentials! <a href ='login.html' >Try Again</a>");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        if ("logout".equals(action)) {
//--- 3. HANDLE LOGOUT--
            if (session != null) {
                session.invalidate(); // Destroy session
            }
            response.sendRedirect("login.html");
        } else if ("delete".equals(action)) {
//--- 4. HANDLE DELETE ACCOUNT--
            if (session != null && session.getAttribute("loggedUser") != null) {
                StudentBean user = (StudentBean) session.getAttribute("loggedUser");
                studentDAO.deleteStudent(user.getMatricNo());
                session.invalidate(); // Destroy session after account deletion
            }
            response.sendRedirect("register.html");
        }
    }
}
