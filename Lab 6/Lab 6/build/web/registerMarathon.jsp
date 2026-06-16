<%-- 
    Document   : registerMarathon
    Created on : 17 May 2026, 10:15:46 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <title>Marathon Registration</title>

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

        </style>

    </head>

    <body>

        <h1>Marathon Registration Form</h1>

        <form action="processMarathon.jsp" method="post">

            <table>
                <tr>
                    <td>Participant ID</td>
                    <td>
                        <input type="text" name="participantID" required>
                    </td>
                </tr>
                <tr>
                    <td>Participant Name</td>
                    <td>
                        <input type="text" name="participantName" required>
                    </td>
                </tr>
                <tr>
                    <td>Category</td>
                    <td>
                        <select name="category">
                            <option>5 KM</option>
                            <option>10 KM</option>
                            <option>21 KM</option>
                            <option>42 KM</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Contact Number</td>
                    <td>
                        <input type="text" name="contactNo">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Register">
                        <input type="reset" value="Cancel">
                        
                    </td>

                </tr>

            </table>

        </form>

    </body>
</html>