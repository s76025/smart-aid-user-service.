<%-- 
    Document   : process
    Created on : 12 May 2026, 12:09:12 pm
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <body>
        <h2>Calculation Result</h2>
        <jsp:useBean id="calc" class="com.lab.bean.CalculatorBean" />
        <jsp:setProperty name="calc" property="*" />
        <p>The sum of
            <jsp:getProperty name="calc" property="number1" /> and
            <jsp:getProperty name="calc" property="number2" /> is:
            <strong><jsp:getProperty name="calc" property="sum" /></strong>
        </p>
        <br><a href="calculator.html">Calculate Again</a>
    </body>
</html>