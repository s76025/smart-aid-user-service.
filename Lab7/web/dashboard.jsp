<%-- 
    Document   : dashboard
    Created on : 19 May 2026, 3:41:37 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.bean.StudentBean"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Student Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <style>
            /* Custom CSS minor untuk saiz dan bingkai gambar sahaja */
            .profile-img {
                width: 160px;
                height: 160px;
                object-fit: cover;
                border: 5px solid #198754; /* Warna hijau success Bootstrap */
            }
        </style>
    </head>
    <body class="bg-light">
        <%
// 1. Session Verification (Security Check)
            response.setContentType("text/html;charset=UTF-8");
            StudentBean user = (StudentBean) session.getAttribute("loggedUser");
            if (user == null) {
                response.sendRedirect("login.html");
                return;
            }
        %>
        <div class="container d-flex justify-content-center align-items-center"
             style="min-height: 100vh;">
            <div class="card shadow-lg border-0 rounded-4 p-4 p-md-5 text-center"
                 style="max-width: 600px; width: 100%;">
                <div class="card-body">
                    <img src="data:image/jpeg;base64,<%= user.getBase64Image()%>"
                         alt="Profile Picture" class="profile-img rounded-circle shadow-sm mb-4" />
                    <h2 class="fw-bold text-dark mb-2">Welcome, <%= user.getFullname()%>!</h2>
                    <p class="text-muted fs-5 mb-4">Matric Number: <strong class="text-secondary"><%= user.getMatricNo()%></
                            <div class="d-flex justify-content-center gap-3 flex-wrap">

                                <a href="SubjectServlet?action=view" class="btn btn-success px-4 py-2 fw-semibold">Manage My Subjects</a>

                                <a href="UserServlet?action=logout" class="btn btn-dark px-4 py-2
                                   fw-semibold">Logout</a>

                                <a href="UserServlet?action=delete"
                                   onclick="return confirm('WARNING: Are you sure you want to delete
                                               your account permanently?');"
                                   class="btn btn-danger px-4 py-2 fw-semibold">Delete Account</a>
                            </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/
        bootstrap.bundle.min.js"></script>
    </body>
</html>
