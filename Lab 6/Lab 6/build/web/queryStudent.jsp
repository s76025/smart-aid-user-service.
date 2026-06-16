<%-- 
    Document   : queryStudent
    Created on : 17 May 2026, 9:51:57?pm
    Author     : Acer
--%>

<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Query Student</title>

        <style>
            body{
                font-family: Arial;
            }
            table{
                width: 80%;
                border-collapse: collapse;
            }
            th, td{
                border: 1px solid black;
                padding: 10px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <h1>Lab 6 - Task 4: Retrieving record via JSP Page</h1>
        <table>
            <tr>
                <th>Student ID</th>
                <th>Student Name</th>
                <th>Program</th>
                <th>Address</th>
            </tr>

            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/CSA3203",
                            "root",
                            "admin");
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM Student";
                    rs = stmt.executeQuery(sql);
                    while (rs.next()) {
            %>
            <tr>
                <td>
                    <%= rs.getString("stuid")%>
                </td>
                <td>
                    <%= rs.getString("stuname")%>
                </td>
                <td>
                    <%= rs.getString("stuprogram")%>
                </td>
                <td>
                    <%= rs.getString("address")%>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println(e);
                } finally {
                    if (rs != null) {
                        rs.close();}

                    if (stmt != null) {
                        stmt.close();
                    }

                    if (conn != null) {
                        conn.close();
                    }
                }
            %>
        </table>
    </body>
</html>