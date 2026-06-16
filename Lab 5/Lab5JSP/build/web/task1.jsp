<%-- 
    Document   : task1.jsp
    Created on : 12 May 2026, 11:59:40 am
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.bean.StudentBean"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Task 1: Scriptlet & Bean</title>
    </head>
    <body>
        <h2>Student Information (Using Scriptlet)</h2>
        <%
            // Instantiating the bean
            StudentBean student = new StudentBean();
            student.setName("Ahmad Ali");
            student.setMatricNo("S123456");
        %>
        <p><strong>Name:</strong> <%= student.getName()%></p>
        <p><strong>Matric No:</strong> <%= student.getMatricNo()%></p>

    </body>
</html>
