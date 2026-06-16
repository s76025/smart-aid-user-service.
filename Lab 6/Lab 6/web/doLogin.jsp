<%-- 
    Document   : doLogin
    Created on : 17 May 2026, 10:39:20?pm
    Author     : Acer
--%>

<%@page import="java.sql.*"%>

<%

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        String username
                = request.getParameter("username");

        String password
                = request.getParameter("password");

        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/CSA3203",
                "root",
                "admin"
        );

        String sql
                = "SELECT * FROM userprofile WHERE username=? AND password=?";

        ps = conn.prepareStatement(sql);

        ps.setString(1, username);
        ps.setString(2, password);

        rs = ps.executeQuery();

        if (rs.next()) {

            String firstname
                    = rs.getString("firstname");

            String lastname
                    = rs.getString("lastname");

            response.sendRedirect(
                    "main.jsp?username=" + username
                    + "&firstname=" + firstname
                    + "&lastname=" + lastname
            );

        } else {

            response.sendRedirect(
                    "login.jsp?msg=Invalid username or password..!"
            );
        }

    } catch (Exception e) {

        out.println(e);

    } finally {

        if (rs != null) {
            rs.close();
        }

        if (ps != null) {
            ps.close();
        }

        if (conn != null) {
            conn.close();
        }
    }
%>