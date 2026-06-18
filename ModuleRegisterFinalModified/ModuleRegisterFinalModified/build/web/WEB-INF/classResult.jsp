<%-- 
    Document   : classResult
    Created on : May 15, 2026, 7:06:52 AM
    Author     : Dini <s75909@ocean.umt.edu.my>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Class Setup Status</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="dino-container">
        <header class="dino-header">
            <div class="dino-mascot">🌿</div>
            <div class="header-text">
                <h1>Class Status</h1>
                <p>Adventure Log Update</p>
            </div>
        </header>
                <% if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
             <div class="dino-card jungle-green">
                 <legend>✅ Success!</legend>
                 <p>Class <strong>${className}</strong> created. Rawr!</p>
             </div>
             <div class="dino-actions">
                 <a href="${pageContext.request.contextPath}/ClassServlet"
                    class="btn-leaf" style="text-decoration:none;text-align:center;display:block;">Add Another</a>
             </div>
         <% } else { %>
             <div class="dino-card volcano-orange">
                 <legend>⚠️ Error</legend>
                 <p>${message}</p>
             </div>
             <div class="dino-actions">
                 <a href="${pageContext.request.contextPath}/ClassServlet"
                    class="btn-leaf" style="text-decoration:none;text-align:center;display:block;">Try Again</a>
             </div>
         <% } %>
    </div>
</body>
</html>