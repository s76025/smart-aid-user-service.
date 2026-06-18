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
    <title>Teacher Dashboard – Dino LCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        /* ── Layout ── */
        .dino-container { max-width: 900px; }

        /* ── Teacher header ── */
        .teacher-header { background: linear-gradient(135deg,#1565c0 0%,#0288d1 100%); border-color:#0288d1; }

        /* ── Stat bar ── */
        .stat-bar { display:flex; gap:12px; margin-bottom:22px; }
        .stat-pill {
            flex:1; background:white; border:3px solid #e0e0e0; border-radius:18px;
            padding:14px 18px; text-align:center;
        }
        .stat-pill .num  { font-size:28px; font-weight:700; color:var(--dark-jungle); }
        .stat-pill .lbl  { font-size:12px; color:#888; margin-top:2px; }
        .stat-pill.blue  { border-color:#1565c0; }
        .stat-pill.blue .num { color:#1565c0; }

        /* ── Quick-action bar ── */
        .quick-actions { display:flex; gap:12px; margin-bottom:22px; flex-wrap:wrap; }
        .qa-btn {
            flex:1; min-width:140px; padding:14px; border-radius:18px;
            border:none; font-family:'Quicksand',sans-serif; font-weight:700;
            font-size:14px; cursor:pointer; transition:transform .1s,box-shadow .1s;
        }
        .qa-btn:active { transform:translateY(3px); box-shadow:none !important; }
        .qa-green  { background:var(--leaf-green); color:white; box-shadow:0 4px 0 var(--dark-jungle); }
        .qa-orange { background:var(--volcano);    color:white; box-shadow:0 4px 0 #bf360c; }
        .qa-blue   { background:#1565c0;            color:white; box-shadow:0 4px 0 #0d47a1; }
        .qa-grey   { background:#90a4ae;            color:white; box-shadow:0 4px 0 #546e7a; }

        /* ── Section cards ── */
        .section-card {
            border:4px dashed var(--leaf-green); border-radius:22px;
            margin-bottom:22px; overflow:hidden;
        }
        .section-card.orange { border-color:var(--volcano); }
        .section-head {
            background:#f9fbe7; padding:14px 20px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .section-head.orange { background:#fff8f6; }
        .section-title { font-weight:700; color:var(--dark-jungle); font-size:15px; }
        .badge {
            display:inline-block; background:var(--leaf-green); color:white;
            padding:3px 12px; border-radius:12px; font-size:12px; font-weight:700;
        }
        .badge-orange { background:var(--volcano); }

        /* ── Data table ── */
        .data-table { width:100%; border-collapse:collapse; font-size:13px; }
        .data-table th {
            background:var(--dark-jungle); color:white;
            padding:9px 12px; text-align:left; font-weight:700;
        }
        .data-table td { padding:9px 12px; border-bottom:1px solid #f1f8e9; vertical-align:middle; }
        .data-table tr:hover td { background:#f9fbe7; }
        .data-table.orange-table th { background: #bf360c; }
        .data-table.orange-table tr:hover td { background:#fff3e0; }

        /* ── Parent name link ── */
        .parent-link {
            color:#1565c0; font-weight:700; text-decoration:none; cursor:pointer;
        }
        .parent-link:hover { text-decoration:underline; }

        /* ── Action buttons in table ── */
        .tbl-btn {
            padding:5px 12px; border-radius:10px; border:none;
            font-family:'Quicksand',sans-serif; font-weight:700;
            font-size:12px; cursor:pointer; margin-right:4px;
        }
        .tbl-edit   { background:#fff176; color:#333; }
        .tbl-delete { background:#ffcdd2; color:#b71c1c; }
        .tbl-btn:hover { opacity:.85; }

        /* ── Inline edit row ── */
        .edit-row td { background:#e8f5e9 !important; }
        .edit-input {
            padding:5px 8px; border:2px solid var(--leaf-green); border-radius:8px;
            font-family:'Quicksand',sans-serif; font-size:12px; width:100%;
            box-sizing:border-box;
        }
        .edit-row.orange-edit td { background:#fff3e0 !important; }
        .edit-row.orange-edit .edit-input { border-color:var(--volcano); }

        /* ── Flash messages ── */
        .flash-err {
            background:#fff3e0; border:3px solid var(--volcano); border-radius:15px;
            padding:12px 18px; margin-bottom:18px; color:#bf360c; font-weight:700;
        }
        .empty-msg { color:#aaa; padding:14px 18px; font-size:13px; }
    </style>
</head>
<body>
<%
    if (session == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/teacherLogin.jsp");
        return;
    }
%>
<%
    List<String[]> parents  = (List<String[]>) request.getAttribute("parents");
    List<String[]> students = (List<String[]>) request.getAttribute("students");
    int parentCount  = (parents  != null) ? parents.size()  : 0;
    int studentCount = (students != null) ? students.size() : 0;

    String flashErr = (String) session.getAttribute("flashError");
    if (flashErr != null) session.removeAttribute("flashError");
%>
<div class="dino-container">

    <header class="dino-header teacher-header">
        <div class="dino-mascot">🍎</div>
        <div class="header-text">
            <h1 style="color:white;">Teacher Dashboard</h1>
            <p style="color:#e3f2fd;">Welcome, ${sessionScope.user}! 📚</p>
        </div>
    </header>

    <% if (flashErr != null) { %>
        <div class="flash-err">❌ <%= flashErr %></div>
    <% } %>

    <!-- Stats -->
    <div class="stat-bar">
        <div class="stat-pill">
            <div class="num"><%= parentCount %></div>
            <div class="lbl">👪 Parents</div>
        </div>
        <div class="stat-pill">
            <div class="num"><%= studentCount %></div>
            <div class="lbl">🦕 Students</div>
        </div>
        <div class="stat-pill blue">
            <div class="num">📚</div>
            <div class="lbl">Teacher View</div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <button class="qa-btn qa-green"
            onclick="location.href='${pageContext.request.contextPath}/registration.jsp'">
            ➕ Add Student
        </button>
        <button class="qa-btn qa-orange"
            onclick="location.href='${pageContext.request.contextPath}/parentRegister.jsp'">
            ➕ Add Parent
        </button>
        <button class="qa-btn qa-blue"
            onclick="location.href='${pageContext.request.contextPath}/ClassServlet'">
            📚 Class Setup
        </button>
        <button class="qa-btn qa-grey"
            onclick="location.href='${pageContext.request.contextPath}/TeacherServlet?action=logout'">
            🚪 Logout
        </button>
    </div>

    <!-- ═══ PARENTS TABLE ═══ -->
    <div class="section-card">
        <div class="section-head">
            <span class="section-title">👪 Registered Parents</span>
            <span class="badge"><%= parentCount %></span>
        </div>
        <% if (parents == null || parents.isEmpty()) { %>
            <p class="empty-msg">No parents registered yet.</p>
        <% } else { %>
        <table class="data-table" id="parentsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th style="width:130px;">Actions</th>
                </tr>
            </thead>
            <tbody>
            <% int pi = 1; for (String[] p : parents) {
                String pId = p[0]; %>
                <!-- Display row -->
                <tr id="p-row-<%= pId %>">
                    <td><%= pi++ %></td>
                    <td>
                        <a class="parent-link"
                           href="${pageContext.request.contextPath}/ParentStudentsServlet?parentId=<%= pId %>">
                            <%= p[1] %>
                        </a>
                    </td>
                    <td><%= p[2] %></td>
                    <td><%= p[3] %></td>
                    <td>
                        <button class="tbl-btn tbl-edit"
                                onclick="showParentEdit('<%= pId %>')">✏️ Edit</button>
                        <button class="tbl-btn tbl-delete"
                                onclick="confirmDeleteParent('<%= pId %>','<%= p[1] %>')">🗑️</button>
                    </td>
                </tr>
                <!-- Inline edit row (hidden) -->
                <tr id="p-edit-<%= pId %>" class="edit-row" style="display:none;">
                    <td colspan="5">
                        <form action="${pageContext.request.contextPath}/TeacherServlet" method="post">
                            <input type="hidden" name="action" value="editParent">
                            <input type="hidden" name="id"     value="<%= pId %>">
                            <div style="display:grid;grid-template-columns:1fr 1fr 80px 1fr;gap:8px;margin-bottom:8px;">
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Email</label>
                                    <input class="edit-input" type="email" name="email" value="<%= p[2] %>" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Phone</label>
                                    <input class="edit-input" type="tel" name="phone" value="<%= p[3] %>" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Age</label>
                                    <input class="edit-input" type="number" name="age" placeholder="Age" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Occupation</label>
                                    <input class="edit-input" type="text" name="occupation" placeholder="Occupation" required>
                                </div>
                            </div>
                            <div style="margin-bottom:8px;">
                                <label style="font-size:11px;font-weight:700;">Address</label>
                                <input class="edit-input" type="text" name="address" placeholder="Home address" required>
                            </div>
                            <button type="submit" class="tbl-btn" style="background:#c8e6c9;color:#1b5e20;">💾 Save</button>
                            <button type="button" class="tbl-btn" style="background:#eee;"
                                    onclick="hideEdit('p-edit-<%= pId %>','p-row-<%= pId %>')">✖ Cancel</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <!-- ═══ STUDENTS TABLE ═══ -->
    <div class="section-card orange">
        <div class="section-head orange">
            <span class="section-title">🦕 Registered Students</span>
            <span class="badge badge-orange"><%= studentCount %></span>
        </div>
        <% if (students == null || students.isEmpty()) { %>
            <p class="empty-msg">No students registered yet.</p>
        <% } else { %>
        <table class="data-table orange-table" id="studentsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Full Name</th>
                    <th>Date of Birth</th>
                    <th style="width:130px;">Actions</th>
                </tr>
            </thead>
            <tbody>
            <% int si = 1; for (String[] s : students) {
                String sId = s[0]; %>
                <!-- Display row -->
                <tr id="s-row-<%= sId %>">
                    <td><%= si++ %></td>
                    <td><%= s[1] %> <%= s[2] %></td>
                    <td><%= s[3] %></td>
                    <td>
                        <button class="tbl-btn tbl-edit"
                                onclick="showStudentEdit('<%= sId %>')">✏️ Edit</button>
                        <button class="tbl-btn tbl-delete"
                                onclick="confirmDeleteStudent('<%= sId %>','<%= s[1] %> <%= s[2] %>')">🗑️</button>
                    </td>
                </tr>
                <!-- Inline edit row (hidden) -->
                <tr id="s-edit-<%= sId %>" class="edit-row orange-edit" style="display:none;">
                    <td colspan="4">
                        <form action="${pageContext.request.contextPath}/TeacherServlet" method="post">
                            <input type="hidden" name="action" value="editStudent">
                            <input type="hidden" name="id"     value="<%= sId %>">
                            <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:8px;">
                                <div>
                                    <label style="font-size:11px;font-weight:700;">First Name</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="text" name="firstName" value="<%= s[1] %>" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Last Name</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="text" name="lastName" value="<%= s[2] %>" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Date of Birth</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="date" name="dob" value="<%= s[3] %>" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Gender</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="text" name="gender" placeholder="male / female" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Guardian</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="text" name="guardian" placeholder="Guardian name" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Relationship</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="text" name="relationship" placeholder="e.g. Mother" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Phone</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="tel" name="phone" placeholder="+60 12-345 6789" required>
                                </div>
                                <div>
                                    <label style="font-size:11px;font-weight:700;">Email</label>
                                    <input class="edit-input" style="border-color:var(--volcano);" type="email" name="email" placeholder="guardian@email.com" required>
                                </div>
                            </div>
                            <button type="submit" class="tbl-btn" style="background:#ffe0b2;color:#bf360c;">💾 Save</button>
                            <button type="button" class="tbl-btn" style="background:#eee;"
                                    onclick="hideEdit('s-edit-<%= sId %>','s-row-<%= sId %>')">✖ Cancel</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>

<!-- Delete confirmation forms (hidden) -->
<form id="deleteParentForm"  action="${pageContext.request.contextPath}/TeacherServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteParent">
    <input type="hidden" name="id"     id="deleteParentId">
</form>
<form id="deleteStudentForm" action="${pageContext.request.contextPath}/TeacherServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteStudent">
    <input type="hidden" name="id"     id="deleteStudentId">
</form>

<script>
function showParentEdit(id) {
    document.getElementById('p-row-'  + id).style.display = 'none';
    document.getElementById('p-edit-' + id).style.display = 'table-row';
}
function showStudentEdit(id) {
    document.getElementById('s-row-'  + id).style.display = 'none';
    document.getElementById('s-edit-' + id).style.display = 'table-row';
}
function hideEdit(editId, rowId) {
    document.getElementById(editId).style.display = 'none';
    document.getElementById(rowId).style.display  = 'table-row';
}
function confirmDeleteParent(id, name) {
    if (confirm('Delete parent "' + name + '"? This cannot be undone.')) {
        document.getElementById('deleteParentId').value = id;
        document.getElementById('deleteParentForm').submit();
    }
}
function confirmDeleteStudent(id, name) {
    if (confirm('Delete student "' + name + '"? This cannot be undone.')) {
        document.getElementById('deleteStudentId').value = id;
        document.getElementById('deleteStudentForm').submit();
    }
}
</script>
</body>
</html>
