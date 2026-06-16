<%-- 
    Document   : errorStudent
    Created on : 17 May 2026, 9:51:25?pm
    Author     : Acer
--%>

<%@page isErrorPage="true"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Error Page</title>
    </head>

    <body>

        <h1>Error Occurred!</h1>

        <h3>

            <%= request.getAttribute("errorMessage")%>

        </h3>

        <a href="insertStudent.jsp">

            Back to Student Form

        </a>

    </body>
</html>