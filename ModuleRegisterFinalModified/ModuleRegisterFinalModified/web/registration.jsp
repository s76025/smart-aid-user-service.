<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lcms.dao.managerDAO, java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Student – Dino LCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        select {
            width:100%; padding:12px; border:3px solid #e0e0e0;
            border-radius:15px; box-sizing:border-box;
            font-family:'Quicksand',sans-serif; font-size:15px;
            transition:border-color .3s; background:white;
        }
        select:focus { border-color:var(--leaf-green); outline:none; }
        .success-banner {
            background:#e8f5e9; border:3px solid var(--leaf-green); border-radius:15px;
            padding:12px 18px; margin-bottom:18px; color:var(--dark-jungle); font-weight:700;
        }
    </style>
</head>
<body>
<%
    String role = (String) session.getAttribute("role");
    boolean isManager = "manager".equals(role);
    List<String[]> parents = null;

    String preParentId = request.getParameter("preParentId");
    String newParent   = request.getParameter("newParent");

    if (isManager) {
        try {
            managerDAO dao = new managerDAO();
            parents = dao.getAllParents();
        } catch (Exception e) { /* ignore */ }
    }
%>
<div class="dino-container">
    <header class="dino-header">
        <div class="dino-mascot">🦕</div>
        <div class="header-text">
            <h1>Child Registration</h1>
            <p><%= isManager ? "Register a student (Manager View)" : "Enroll a new little dinosaur!" %></p>
        </div>
    </header>

    <% if ("1".equals(newParent)) { %>
        <div class="success-banner">✅ Parent registered! Now add their student below.</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/StudentServlet" method="post">

        <%-- Parent selector (manager only) --%>
        <% if (isManager) { %>
        <fieldset class="dino-card jungle-green" style="border-color:#1565c0;">
            <legend>👪 Link to Parent</legend>
            <% if (parents != null && !parents.isEmpty()) { %>
                <div class="input-field">
                    <label>Select Parent *</label>
                    <select name="parentId" required>
                        <option value="">-- Choose a parent --</option>
                        <% for (String[] p : parents) {
                            boolean preSelected = p[0].equals(preParentId); %>
                            <option value="<%= p[0] %>" <%= preSelected ? "selected" : "" %>>
                                <%= p[1] %> (<%= p[2] %>)
                            </option>
                        <% } %>
                    </select>
                </div>
                <div style="margin-top:8px;font-size:13px;color:#555;">
                    Can't find the parent?
                    <a href="${pageContext.request.contextPath}/parentRegister.jsp"
                       style="color:#1565c0;font-weight:700;">Register a new parent first →</a>
                </div>
            <% } else { %>
                <div style="color:#bf360c;font-weight:700;padding:8px 0;">
                    ⚠️ No parents registered yet.
                    <a href="${pageContext.request.contextPath}/parentRegister.jsp"
                       style="color:#1565c0;">Register a parent first →</a>
                </div>
            <% } %>
        </fieldset>
        <% } %>

        <!-- Child info -->
        <fieldset class="dino-card jungle-green">
            <legend>🦖 Child Information</legend>
            <div class="row">
                <div class="input-field">
                    <label>First Name *</label>
                    <input type="text" name="fname" placeholder="Enter first name" required>
                </div>
                <div class="input-field">
                    <label>Last Name *</label>
                    <input type="text" name="lname" placeholder="Enter last name" required>
                </div>
            </div>
            <div class="input-field">
                <label>Date of Birth *</label>
                <input type="date" name="dob" required>
            </div>
            <div class="input-field">
                <label>Gender *</label>
                <div class="radio-group">
                    <label class="dino-radio"><input type="radio" name="gender" value="male"> Male</label>
                    <label class="dino-radio"><input type="radio" name="gender" value="female"> Female</label>
                </div>
            </div>
        </fieldset>

        <!-- Guardian info -->
        <fieldset class="dino-card volcano-orange">
            <legend>🌴 Guardian Information</legend>
            <div class="input-field">
                <label>Guardian Name *</label>
                <input type="text" name="gname" placeholder="Enter guardian name" required>
            </div>
            <div class="row">
                <div class="input-field">
                    <label>Relationship *</label>
                    <input type="text" name="rel" placeholder="e.g. Mother" required>
                </div>
                <div class="input-field">
                    <label>Guardian Phone *</label>
                    <input type="tel" name="phone" placeholder="+60 12-345 6789" required>
                </div>
            </div>
            <div class="input-field">
                <label>Guardian Email *</label>
                <input type="email" name="email" placeholder="guardian@example.com" required>
            </div>
        </fieldset>

        <div class="dino-actions">
            <button type="submit" class="btn-leaf">Register Student! 🐾</button>
            <% String cancelUrl = (preParentId != null && !preParentId.isEmpty())
                ? request.getContextPath() + "/ParentStudentsServlet?parentId=" + preParentId
                : request.getContextPath() + "/ManagerDashboardServlet"; %>
            <button type="button" class="btn-stone" onclick="history.back()">
                ✖ Cancel
            </button>
        </div>
    </form>
</div>
</body>
</html>