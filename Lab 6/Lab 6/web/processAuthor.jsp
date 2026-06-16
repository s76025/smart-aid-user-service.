<%-- 
    Document   : processAuthor
    Created on : 17 May 2026, 9:30:38?pm
    Author     : Acer
--%>

<%@page import="java.sql.*"%>
<%@page import="lab6.com.Author"%>

<!DOCTYPE html>
<html>
<head>
    <title>Process Author</title>
</head>
<body>

<jsp:useBean id="author" class="lab6.com.Author" scope="request"/>

<jsp:setProperty name="author" property="*"/>

<%

Connection conn = null;
PreparedStatement ps = null;

try {

    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/CSA3203",
        "root",
        "admin"
    );

    String sql = "INSERT INTO Author VALUES(?,?,?,?,?,?)";

    ps = conn.prepareStatement(sql);

    ps.setString(1, author.getAuthno());
    ps.setString(2, author.getName());
    ps.setString(3, author.getAddress());
    ps.setString(4, author.getCity());
    ps.setString(5, author.getState());
    ps.setString(6, author.getZip());

    ps.executeUpdate();

    out.println("Author record inserted successfully!");

} catch(Exception e) {

    out.println("Error: " + e);

} finally {

    if(ps != null)
        ps.close();

    if(conn != null)
        conn.close();
}
%>

</body>
</html>