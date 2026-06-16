<%-- 
    Document   : processStudent
    Created on : 17 May 2026, 9:50:45?pm
    Author     : Acer
--%>
<%@page import="java.sql.*"%>
<%@page import="lab6.com.Student"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Process Student</title>
    </head>

    <body>

        <h1>Process Student Registration</h1>

        <%

            Connection conn = null;
            PreparedStatement ps = null;

            try {

                Student student = new Student();

                student.setStuid(request.getParameter("stuid"));
                student.setStuname(request.getParameter("stuname"));
                student.setStuprogram(request.getParameter("stuprogram"));
                student.setAddress(request.getParameter("address"));

                Class.forName("com.mysql.cj.jdbc.Driver");

                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/CSA3203",
                        "root",
                        "admin"
                );

                String sql
                        = "INSERT INTO Student VALUES(?,?,?,?)";

                ps = conn.prepareStatement(sql);

                ps.setString(1, student.getStuid());
                ps.setString(2, student.getStuname());
                ps.setString(3, student.getStuprogram());
                ps.setString(4, student.getAddress());

                ps.executeUpdate();

        %>

        <h2>Student record inserted successfully!</h2>

        <table border="1">

            <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Program</th>
                <th>Address</th>
            </tr>

            <tr>
                <td><%= student.getStuid()%></td>
                <td><%= student.getStuname()%></td>
                <td><%= student.getStuprogram()%></td>
                <td><%= student.getAddress()%></td>
            </tr>

        </table>

        <%

            } catch (Exception e) {

                request.setAttribute("errorMessage", e.getMessage());

                RequestDispatcher rd
                        = request.getRequestDispatcher("errorStudent.jsp");

                rd.forward(request, response);

            } finally {

                if (ps != null) {
                    ps.close();
                }

                if (conn != null) {
                    conn.close();
                }
            }
        %>

    </body>
</html>