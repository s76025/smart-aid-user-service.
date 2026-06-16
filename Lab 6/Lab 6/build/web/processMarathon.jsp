<%-- 
    Document   : processMarathon
    Created on : 17 May 2026, 10:16:13?pm
    Author     : Acer
--%>
<%@page import="lab6.com.Marathon"%>
<%@page import="lab6.com.MarathonDAO"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Process Marathon</title>
    </head>

    <body>

        <h1>Marathon Registration Result</h1>

        <%

            Marathon m = new Marathon();

            m.setParticipantID(
                    request.getParameter("participantID")
            );

            m.setParticipantName(
                    request.getParameter("participantName")
            );

            m.setCategory(
                    request.getParameter("category")
            );

            m.setContactNo(
                    request.getParameter("contactNo")
            );

            MarathonDAO dao = new MarathonDAO();

            boolean status = dao.addMarathon(m);

            if (status) {

        %>

        <h2>Registration Successful!</h2>

        <table border="1">

            <tr>
                <th>Participant ID</th>
                <td><%= m.getParticipantID()%></td>
            </tr>

            <tr>
                <th>Participant Name</th>
                <td><%= m.getParticipantName()%></td>
            </tr>

            <tr>
                <th>Category</th>
                <td><%= m.getCategory()%></td>
            </tr>

            <tr>
                <th>Contact Number</th>
                <td><%= m.getContactNo()%></td>
            </tr>

        </table>

        <%

        } else {

        %>

        <h2>Registration Failed!</h2>

        <%    }
        %>

    </body>
</html>