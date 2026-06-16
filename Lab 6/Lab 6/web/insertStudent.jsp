<%-- 
    Document   : insertStudent
    Created on : 17 May 2026, 9:50:14 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Insert Student</title>

        <style>

            body{
                font-family: Arial;
            }

            table{
                border-collapse: collapse;
            }

            td{
                padding: 8px;
            }

        </style>

    </head>

    <body>

        <h1>Student Registration Form</h1>

        <form action="processStudent.jsp" method="post">

            <table>
                <tr>
                    <td>Student ID</td>
                    <td>
                        <input type="text" name="stuid"
                               placeholder="Example: UK12345" required> </td>
                </tr>
                <tr> <td>Student Name</td>
                    <td>
                        <input type="text" name="stuname" required></td>
                </tr>
                <tr><td>Program</td>
                    <td>
                        <select name="stuprogram">
                            <option>BSc Soft. Eng.</option>
                            <option>BSc with IM</option>
                            <option>BSc in Robotics</option>
                        </select>
                    </td>
                </tr>
                <tr><td>Address</td>
                    <td>
                        <textarea name="address"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Submit">
                        <input type="reset" value="Cancel">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>