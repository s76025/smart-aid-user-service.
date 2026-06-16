<%-- 
    Document   : registerSubject
    Created on : 19 May 2026, 4:10:55 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.bean.StudentBean"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Register Subject</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%
            if (session.getAttribute("loggedUser") == null) {
                response.sendRedirect("../login.html");
                return;
            }
        %>
        <div class="container mt-5" style="max-width: 500px;">
            <div class="card shadow border-0 rounded-3 p-4">
                <h3 class="mb-4 text-center">Add New Subject</h3>
                <form action="../SubjectServlet" method="POST">
                    <input type="hidden" name="action" value="add">

                    <div class="mb-3">
                        <label class="form-label">Subject Code</label>
                        <input type="text" name="subjectCode" class="form-pattern form-control" placeholder="e.g., CSM3023" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Subject Name</label>
                        <input type="text" name="subjectName" class="form-control" placeholder="e.g., Web-Based Application Development" required>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success w-100">Register Subject</button>
                        <a href="../SubjectServlet?action=view" class="btn btn-outline-secondary w-100">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>