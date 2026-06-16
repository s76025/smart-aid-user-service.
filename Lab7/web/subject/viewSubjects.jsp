<%-- 
    Document   : viewSubjects
    Created on : 19 May 2026, 4:10:21 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.bean.StudentBean"%>
<%@page import="com.lab.bean.SubjectBean"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Registered Subjects</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%
            // Session Verification
            StudentBean student = (StudentBean) session.getAttribute("loggedUser");
            if (student == null) {
                response.sendRedirect("../login.html");
                return;
            }
            List<SubjectBean> subjectList = (List<SubjectBean>) request.getAttribute("subjectList");
        %>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Subject Management System</h2>
                <div>
                    <a href="../dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                    <a href="registerSubject.jsp" class="btn btn-success">Register New Subject</a>
                </div>
            </div>

            <div class="card shadow border-0 rounded-3 p-4">
                <h5 class="text-muted mb-3">Registered Subjects for: <strong><%= student.getFullname()%> (<%= student.getMatricNo()%>)</strong></h5>
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Subject Code</th>
                            <th>Subject Name</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (subjectList != null && !subjectList.isEmpty()) {
                                int count = 1;
                                for (SubjectBean subject : subjectList) {
                        %>
                        <tr>
                            <td><%= count++%></td>
                            <td><span class="badge bg-secondary fs-6"><%= subject.getSubjectCode()%></span></td>
                            <td><%= subject.getSubjectName()%></td>
                            <td class="text-center">
                                <a href="SubjectServlet?action=edit&id=<%= subject.getId()%>" class="btn btn-sm btn-warning me-2">Edit</a>
                                <a href="SubjectServlet?action=delete&id=<%= subject.getId()%>" 
                                   onclick="return confirm('Remove this subject?');" class="btn btn-sm btn-danger">Delete</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">No subjects registered yet.</td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>