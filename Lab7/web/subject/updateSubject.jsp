<%-- 
    Document   : updateSubject
    Created on : 19 May 2026, 4:11:18 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.bean.SubjectBean"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Update Subject</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%
            if (session.getAttribute("loggedUser") == null) {
                response.sendRedirect("../login.html");
                return;
            }
            SubjectBean subject = (SubjectBean) request.getAttribute("subject");
            if (subject == null) {
                response.sendRedirect("../SubjectServlet?action=view");
                return;
            }
        %>
        <div class="container mt-5" style="max-width: 500px;">
            <div class="card shadow border-0 rounded-3 p-4">
                <h3 class="mb-4 text-center">Modify Subject Details</h3>
                <form action="${pageContext.request.contextPath}/SubjectServlet" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= subject.getId()%>">

                    <div class="mb-3">
                        <label class="form-label">Subject Code</label>
                        <input type="text" name="subjectCode" class="form-control" value="<%= subject.getSubjectCode()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Subject Name</label>
                        <input type="text" name="subjectName" class="form-control" value="<%= subject.getSubjectName()%>" required>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning w-100">Update Info</button>
                        <a href="../SubjectServlet?action=view" class="btn btn-outline-secondary w-100">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>