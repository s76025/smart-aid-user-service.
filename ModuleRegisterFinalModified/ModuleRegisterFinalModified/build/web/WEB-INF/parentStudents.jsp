<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent & Students – Dino LCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        .dino-container { max-width:720px; }

        .back-btn {
            display:inline-flex; align-items:center; gap:6px;
            color:#1565c0; font-weight:700; font-size:14px; text-decoration:none;
            margin-bottom:18px; padding:8px 16px; border-radius:12px;
            background:#e3f2fd; border:2px solid #90caf9;
        }
        .back-btn:hover { background:#bbdefb; }

        /* Parent profile card */
        .profile-card {
            background:#f1f8e9; border:4px solid var(--leaf-green);
            border-radius:22px; padding:20px 24px; margin-bottom:22px;
        }
        .profile-card h2 { margin:0 0 14px; color:var(--dark-jungle); font-size:17px; }
        .profile-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px 20px; font-size:14px; }
        .pi .lbl { font-weight:700; color:#777; font-size:11px; }
        .pi .val { color:#222; margin-top:2px; font-size:13px; }

        /* Students card */
        .students-card {
            background:#fff8f6; border:4px dashed var(--volcano);
            border-radius:22px; overflow:hidden; margin-bottom:18px;
        }
        .students-head {
            background:#fff3e0; padding:12px 18px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .students-head h3 { margin:0; color:#bf360c; font-size:15px; }
        .badge-orange { background:var(--volcano); color:white; padding:2px 10px; border-radius:12px; font-size:12px; font-weight:700; }

        .data-table { width:100%; border-collapse:collapse; font-size:14px; }
        .data-table th { background:#bf360c; color:white; padding:10px 14px; text-align:left; }
        .data-table td { padding:10px 14px; border-bottom:1px solid #fff3e0; vertical-align:middle; }
        .data-table tr:last-child td { border-bottom:none; }
        .data-table tr:hover td { background:#fff3e0; }
        .data-table tr.highlight td { background:#ffe0b2 !important; font-weight:700; }

        .gender-badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; font-weight:700; }
        .gender-m { background:#e3f2fd; color:#1565c0; }
        .gender-f { background:#fce4ec; color:#c2185b; }

        /* Add student button */
        .add-student-btn {
            display:inline-flex; align-items:center; gap:6px;
            background:var(--volcano); color:white; font-weight:700;
            font-size:13px; padding:9px 18px; border-radius:14px;
            text-decoration:none; border:none; cursor:pointer;
            font-family:'Quicksand',sans-serif;
        }
        .add-student-btn:hover { opacity:.88; }

        .empty-msg { color:#aaa; padding:16px 20px; font-size:14px; }

        .no-parent-box {
            background:#fff3e0; border:3px solid var(--volcano); border-radius:18px;
            padding:18px; text-align:center; color:#bf360c; font-weight:700;
        }
        .err-box {
            background:#fff3e0; border:3px solid var(--volcano); border-radius:18px;
            padding:14px 18px; color:#bf360c; font-weight:700; margin-bottom:16px;
        }
    </style>
</head>
<body>
<%
    if (session == null || !"parent".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%
    String[] parent    = (String[]) request.getAttribute("parent");
    List<String[]> students = (List<String[]>) request.getAttribute("students");
    String highlightSid = (String) request.getAttribute("highlightStudent");
    Boolean noParent   = (Boolean) request.getAttribute("noParent");
    String studentName = (String) request.getAttribute("studentName");
    String dbError     = (String) request.getAttribute("dbError");

    String role = (String) session.getAttribute("role");
    String backUrl = "teacher".equals(role)
        ? request.getContextPath() + "/TeacherServlet"
        : request.getContextPath() + "/ManagerDashboardServlet";
%>
<div class="dino-container">

    <a class="back-btn" href="<%= backUrl %>">← Back to Dashboard</a>

    <% if (dbError != null) { %>
        <div class="err-box">⚠️ Database error: <%= dbError %></div>
    <% } %>

    <%-- Case: student has no parent linked --%>
    <% if (Boolean.TRUE.equals(noParent)) { %>
        <header class="dino-header">
            <div class="dino-mascot">🦕</div>
            <div class="header-text">
                <h1><%= studentName %></h1>
                <p>Student Profile</p>
            </div>
        </header>
    <div style="text-align:right; margin-bottom:16px;">
        <a href="${pageContext.request.contextPath}/ParentServlet?action=logout"
           style="display:inline-block; padding:10px 22px; background:#e65100; color:white;
                  border-radius:16px; text-decoration:none; font-weight:700; font-size:13px;
                  box-shadow:0 4px 0 #bf360c; font-family:'Quicksand',sans-serif;">
            🚪 Logout
        </a>
    </div>
        <div class="no-parent-box">
            ⚠️ This student has no parent linked yet.<br>
            <a href="<%= backUrl %>" style="color:#bf360c;">Go back to dashboard to edit and link a parent.</a>
        </div>

    <%-- Case: parent found --%>
    <% } else if (parent != null) {
        // parent: [0]id [1]username [2]email [3]phone [4]age [5]occupation [6]address [7]ic
    %>
        <header class="dino-header">
            <div class="dino-mascot">👪</div>
            <div class="header-text">
                <h1><%= parent[1] %></h1>
                <p>Parent Profile &amp; Linked Students</p>
            </div>
        </header>

        <!-- Parent Info -->
        <div class="profile-card">
            <h2>👤 Parent Information</h2>
            <div class="profile-grid">
                <div class="pi">
                    <div class="lbl">Username</div>
                    <div class="val"><%= parent[1] %></div>
                </div>
                <div class="pi">
                    <div class="lbl">Email</div>
                    <div class="val"><%= parent[2] != null ? parent[2] : "—" %></div>
                </div>
                <div class="pi">
                    <div class="lbl">Phone</div>
                    <div class="val"><%= parent[3] != null ? parent[3] : "—" %></div>
                </div>
                <div class="pi">
                    <div class="lbl">Age</div>
                    <div class="val"><%= parent[4] != null && !"0".equals(parent[4]) ? parent[4] : "—" %></div>
                </div>
                <div class="pi">
                    <div class="lbl">Occupation</div>
                    <div class="val"><%= parent[5] != null ? parent[5] : "—" %></div>
                </div>
                <div class="pi">
                    <div class="lbl">IC Number</div>
                    <div class="val"><%= parent[7] != null ? parent[7] : "—" %></div>
                </div>
                <div class="pi" style="grid-column:1/-1;">
                    <div class="lbl">Home Address</div>
                    <div class="val"><%= parent[6] != null ? parent[6] : "—" %></div>
                </div>
            </div>
        </div>

        <!-- Linked Students -->
        <div class="students-card">
            <div class="students-head">
                <h3>🦕 Linked Students (<%= students != null ? students.size() : 0 %>)</h3>
                <a class="add-student-btn"
                   href="${pageContext.request.contextPath}/registration.jsp?preParentId=<%= parent[0] %>">
                    ➕ Add Student
                </a>
            </div>
            <% if (students == null || students.isEmpty()) { %>
                <p class="empty-msg">No students linked to this parent yet.
                    <a href="${pageContext.request.contextPath}/registration.jsp?preParentId=<%= parent[0] %>">Add one →</a>
                </p>
            <% } else { %>
            <table class="data-table">
                <thead>
                    <tr><th>#</th><th>Full Name</th><th>Date of Birth</th><th>Gender</th></tr>
                </thead>
                <tbody>
                <% int i = 1; for (String[] s : students) {
                    boolean isHighlight = s[0].equals(highlightSid); %>
                    <tr id="student-<%= s[0] %>" class="<%= isHighlight ? "highlight" : "" %>">
                        <td><%= i++ %></td>
                        <td><strong><%= s[1] %> <%= s[2] %></strong>
                            <% if (isHighlight) { %> 👈<% } %>
                        </td>
                        <td><%= s[3] %></td>
                        <td>
                            <span class="gender-badge <%= "male".equalsIgnoreCase(s[4]) ? "gender-m" : "gender-f" %>">
                                <%= "male".equalsIgnoreCase(s[4]) ? "♂ Male" : "♀ Female" %>
                            </span>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>

    <% } else { %>
        <div class="no-parent-box">⚠️ Parent not found.</div>
    <% } %>

</div>

<% if (highlightSid != null) { %>
<script>
    // Scroll to the highlighted student row
    window.onload = function() {
        var el = document.getElementById('student-<%= highlightSid %>');
        if (el) el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    };
</script>
<% } %>
</body>
</html>
