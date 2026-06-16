<%-- 
    Document   : payroll_view
    Created on : 12 May 2026, 2:50:33 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Employee Payroll Display</title>
    </head>
    <body>

        <h2>Employee Payroll List</h2>

        <table border="1" cellpadding="8">

            <thead>
                <tr style="background-color: lightgray;">
                    <th>ID</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Basic Salary</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>

                <c:forEach var="emp" items="${employeeList}">

                    <tr>
                        <td>${emp.empId}</td>
                        <td>${emp.name}</td>
                        <td>${emp.department}</td>
                        <td>RM ${emp.basicSalary}</td>

                        <td>
                            <c:choose>

                                <c:when test="${emp.basicSalary >= 3000}">
                                    Senior
                                </c:when>

                                <c:otherwise>
                                    Junior
                                </c:otherwise>

                            </c:choose>
                        </td>
                    </tr>

                </c:forEach>

            </tbody>

        </table>

    </body>
</html>