<%-- 
    Document   : jstl_test
    Created on : 12 May 2026, 12:19:24 pm
    Author     : Acer
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>JSTL Core Tags</title>
    </head>
    <body>
        <h2>JSTL Conditional Test</h2>
        <c:set var="score" value="85" />
        <p>Student Score: <c:out value="${score}" /> marks.</p>
        <c:if test="${score >= 50}">
            <p style="color: green;"><strong>Status: Pass! Congratulations.</strong>
            </p>
        </c:if>
        <c:if test="${score < 50}">
            <p style="color: red;"><strong>Status: Fail. Please try again.</strong>
            </p>
        </c:if>
    </body>
</html>