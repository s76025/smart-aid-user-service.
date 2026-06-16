<%-- 
    Document   : login
    Created on : 17 May 2026, 10:37:33?pm
    Author     : Acer
--%>

<!DOCTYPE html>
<html>

    <head>

        <title>Login</title>

        <style>

            body{
                font-family: Arial;
            }

            table{
                border-collapse: collapse;
            }

            td{
                padding: 10px;
            }

            .error{
                color: red;
            }

        </style>

    </head>

    <body>
        <h1>Login System</h1>

        <%
            String msg
                    = request.getParameter("msg");

            if (msg != null) {
        %>
        <p class="error">
            <%= msg%>
        </p>
        <%

            }
        %>
        <form action="doLogin.jsp" method="post">
            <table>
                <tr>
                    <td>Username</td>
                    <td>
                        <input type="text" name="username">
                    </td>
                </tr>
                <tr>
                    <td>Password</td>
                    <td>
                        <input type="password" name="password">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Login">
                        <input type="reset" value="Cancel">
                    </td>
                    
                </tr>

            </table>

        </form>

    </body>
</html>