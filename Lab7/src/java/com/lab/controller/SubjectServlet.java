package com.lab.controller;

import com.lab.bean.StudentBean;
import com.lab.bean.SubjectBean;
import com.lab.dao.SubjectDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SubjectServlet extends HttpServlet {

    private SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        StudentBean student = (StudentBean) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            SubjectBean subject = new SubjectBean();
            subject.setMatricNo(student.getMatricNo());
            subject.setSubjectCode(request.getParameter("subjectCode"));
            subject.setSubjectName(request.getParameter("subjectName"));

            subjectDAO.addSubject(subject);
            response.sendRedirect("SubjectServlet?action=view");

        } else if ("update".equals(action)) {
            SubjectBean subject = new SubjectBean();
            subject.setId(Integer.parseInt(request.getParameter("id")));
            subject.setMatricNo(student.getMatricNo());
            subject.setSubjectCode(request.getParameter("subjectCode"));
            subject.setSubjectName(request.getParameter("subjectName"));

            subjectDAO.updateSubject(subject);
            response.sendRedirect("SubjectServlet?action=view");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.html");
            return;
        }

        StudentBean student = (StudentBean) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            List<SubjectBean> subjectList = subjectDAO.getSubjectsByMatric(student.getMatricNo());
            request.setAttribute("subjectList", subjectList);
            request.getRequestDispatcher("subject/viewSubjects.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            SubjectBean subject = subjectDAO.getSubjectById(id);

            // Security check: Verify the subject belongs to the logged-in student
            if (subject != null && subject.getMatricNo().equals(student.getMatricNo())) {
                request.setAttribute("subject", subject);
                request.getRequestDispatcher("subject/updateSubject.jsp").forward(request, response);
            } else {
                response.sendRedirect("SubjectServlet?action=view");
            }

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            subjectDAO.deleteSubject(id, student.getMatricNo());
            response.sendRedirect("SubjectServlet?action=view");
        }
    }
}
