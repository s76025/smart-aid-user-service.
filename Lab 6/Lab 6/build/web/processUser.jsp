<%-- 
    Document   : processUser
    Created on : 17 May 2026, 10:34:50?pm
    Author     : Acer
--%>
<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>

    <head>
        <title>Process User</title>
    </head>
    <body>
        <h1>User Registration Result</h1>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                String username
                        = request.getParameter("username");
                String password
                        = request.getParameter("password");
                String firstname
                        = request.getParameter("firstname");
                String lastname
                        = request.getParameter("lastname");
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/CSA3203",
                        "root",
                        "admin"
                );
                String sql
                        = "INSERT INTO userprofile VALUES(?,?,?,?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, firstname);
                ps.setString(4, lastname);
                ps.executeUpdate();
        %>
        <h2>User registered successfully!</h2>
        <a href="login.jsp">
            Go to Login Page
        </a>
        <%    } catch (Exception e) {
                out.println(e);
            } finally {
                if (ps != null) {
                    ps.close();}
                if (conn != null) {
                    conn.close();
                }}
        %>
    </body>
</html>