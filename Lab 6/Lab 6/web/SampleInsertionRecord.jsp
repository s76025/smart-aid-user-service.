<%-- 
    Document   : SampleInsertionRecord
    Created on : 17 May 2026, 9:12:42?pm
    Author     : Acer
--%>

<%@ page import="java.sql.*" %>

<html>
    <head>
        <title>Sample Insertion Record</title>
    </head>
    <body>

        <h1>Lab 6 - Task 1 - Sample Insertion records into MySQL through JSP page</h1>

        <%
            Connection conn = null;
            Statement stmt = null;

            try {

                Class.forName("com.mysql.cj.jdbc.Driver");

                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/CSA3203",
                        "root",
                        "admin"
                );

                stmt = conn.createStatement();

                String sql = "INSERT INTO FirstTable VALUES ('Welcome to access MySQL database with JSP...!')";

                stmt.executeUpdate(sql);

                out.println("Record inserted successfully!");

            } catch (Exception e) {

                out.println("Error: " + e);

            }
        %>

    </body>
</html>