<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Teacher self-registration has been disabled.
    // Only the Manager/Admin can register teachers via the Manager Dashboard.
    response.sendRedirect(request.getContextPath() + "/teacherLogin.jsp");
%>
