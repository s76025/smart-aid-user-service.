<%-- 
    Document   : studentResult
    Created on : May 15, 2026, 7:06:25 AM
    Author     : Dini <s75909@ocean.umt.edu.my>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Status Report</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="dino-container">
        <header class="dino-header">
            <div class="dino-mascot">🐾</div>
            <div class="header-text"><h1>Action Status</h1></div>
        </header>
        <% if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
            <div class="dino-card jungle-green">
                <legend>✅ Success!</legend>
                <p>${message}</p>
            </div>
            <div class="dino-actions">
                <a href="${pageContext.request.contextPath}/registration.jsp"
                   class="btn-leaf" style="text-decoration:none;text-align:center;display:block;">Go Back</a>
            </div>
        <% } else { %>
            <div class="dino-card volcano-orange">
                <legend>⚠️ Error</legend>
                <p>${message}</p>
            </div>
            <div class="dino-actions">
                <a href="${pageContext.request.contextPath}/registration.jsp"
                   class="btn-leaf" style="text-decoration:none;text-align:center;display:block;">Try Again</a>
            </div>
        <% } %>
    </div>
</body>
</html>