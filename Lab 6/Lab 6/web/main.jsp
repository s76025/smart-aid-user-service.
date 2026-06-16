<%-- 
    Document   : main
    Created on : 17 May 2026, 10:40:16?pm
    Author     : Acer
--%>

<!DOCTYPE html>
<html>

    <head>

        <title>Main Page</title>

        <style>

            body{
                font-family: Arial;
            }

        </style>

    </head>

    <body>

        <h1>Welcome to the System</h1>

        <h3>

            Username:
            <%= request.getParameter("username")%>

        </h3>

        <h3>

            First Name:
            <%= request.getParameter("firstname")%>

        </h3>

        <h3>

            Last Name:
            <%= request.getParameter("lastname")%>

        </h3>

    </body>
</html>