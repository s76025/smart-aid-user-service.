<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Manager Dashboard – Dino LCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        .dino-container { max-width: 860px; }

        /* ── Action cards ── */
        .dashboard-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:24px; }
        .action-card {
            background:white; border:4px dashed var(--leaf-green);
            border-radius:20px; padding:18px; text-align:center;
            cursor:pointer; transition:transform .1s, box-shadow .1s; text-decoration:none;
            display:block; color:inherit;
        }
        .action-card:hover { transform:translateY(-3px); box-shadow:0 6px 0 var(--dark-jungle); }
        .action-card .icon { font-size:34px; margin-bottom:6px; }
        .action-card h3 { margin:0 0 4px; color:var(--dark-jungle); font-size:15px; }
        .action-card p  { margin:0; font-size:12px; color:#666; }
        .action-card.volcano { border-color:var(--volcano); }
        .action-card.volcano:hover { box-shadow:0 6px 0 #bf360c; }

        /* ── Section cards ── */
        .section-wrap { border:4px dashed var(--leaf-green); border-radius:22px; margin-bottom:22px; overflow:hidden; }
        .section-wrap.orange { border-color:var(--volcano); }
        .section-head {
            background:#f9fbe7; padding:12px 18px;
            display:flex; justify-content:space-between; align-items:center;
        }
        .section-head.orange { background:#fff8f6; }
        .section-title { font-weight:700; color:var(--dark-jungle); font-size:15px; }
        .badge         { background:var(--leaf-green); color:white; padding:2px 10px; border-radius:12px; font-size:12px; font-weight:700; }
        .badge-orange  { background:var(--volcano);    color:white; padding:2px 10px; border-radius:12px; font-size:12px; font-weight:700; }

        /* ── Data table ── */
        .data-table { width:100%; border-collapse:collapse; font-size:13px; }
        .data-table th { background:var(--dark-jungle); color:white; padding:9px 12px; text-align:left; }
        .data-table td { padding:9px 12px; border-bottom:1px solid #f1f8e9; vertical-align:middle; }
        .data-table tr:hover td { background:#f9fbe7; }
        .data-table.ot th { background:#bf360c; }
        .data-table.ot tr:hover td { background:#fff3e0; }
        .data-table td:last-child { white-space:nowrap; }

        /* ── Clickable name links ── */
        .name-link { color:#1565c0; font-weight:700; text-decoration:none; cursor:pointer; }
        .name-link:hover { text-decoration:underline; }
        .name-link.orange { color:#e65100; }

        /* ── Table action buttons ── */
        .tbl-btn { padding:5px 11px; border-radius:10px; border:none; font-family:'Quicksand',sans-serif; font-weight:700; font-size:12px; cursor:pointer; margin-right:3px; }
        .tbl-edit   { background:#fff176; color:#333; }
        .tbl-delete { background:#ffcdd2; color:#b71c1c; }
        .tbl-btn:hover { opacity:.85; }

        /* ── Inline edit rows ── */
        .edit-row td { background:#e8f5e9 !important; padding:10px 12px !important; }
        .edit-row.ot td { background:#fff3e0 !important; }
        .edit-grid { display:grid; gap:8px; margin-bottom:8px; }
        .edit-grid-2 { grid-template-columns:1fr 1fr; }
        .edit-grid-3 { grid-template-columns:1fr 1fr 1fr; }
        .edit-grid-4 { grid-template-columns:1fr 1fr 1fr 1fr; }
        .edit-lbl { font-size:11px; font-weight:700; color:#555; margin-bottom:3px; display:block; }
        .edit-input {
            width:100%; padding:6px 10px; border:2px solid var(--leaf-green);
            border-radius:8px; font-family:'Quicksand',sans-serif; font-size:12px;
            box-sizing:border-box;
        }
        .edit-row.ot .edit-input { border-color:var(--volcano); }
        select.edit-input { background:white; }
        .edit-save-row { display:flex; gap:8px; margin-top:6px; }
        .btn-save-inline   { background:#c8e6c9; color:#1b5e20; }
        .btn-cancel-inline { background:#eee; color:#555; }

        /* ── Parent tag on student ── */
        .parent-tag {
            display:inline-block; background:#e3f2fd; color:#1565c0;
            font-size:11px; font-weight:700; padding:2px 8px; border-radius:8px;
        }
        .no-parent-tag {
            display:inline-block; background:#f5f5f5; color:#aaa;
            font-size:11px; padding:2px 8px; border-radius:8px;
        }

        /* ── Flash error ── */
        .flash-err {
            background:#fff3e0; border:3px solid var(--volcano); border-radius:15px;
            padding:12px 18px; margin-bottom:18px; color:#bf360c; font-weight:700;
        }
        .empty-msg { color:#aaa; padding:14px 18px; font-size:13px; }

        /* ── Teacher section ── */
        .section-wrap.blue { border-color: #1565c0; }
        .section-head.blue { background: #e3f2fd; }
        .badge-blue { background: #1565c0; color: white; padding:2px 10px; border-radius:12px; font-size:12px; font-weight:700; }
        .data-table.bt th { background: #1565c0; }
        .data-table.bt tr:hover td { background: #e3f2fd; }
        /* ── Flash success ── */
        .flash-ok {
            background:#f1f8e9; border:3px solid var(--leaf-green); border-radius:15px;
            padding:12px 18px; margin-bottom:18px; color:#1b5e20; font-weight:700;
        }
    </style>
</head>
<body>
<%
    List<String[]> parents  = (List<String[]>) request.getAttribute("parents");
    List<String[]> students = (List<String[]>) request.getAttribute("students");
    List<String[]> teachers = (List<String[]>) request.getAttribute("teachers");
    int teacherCount = (teachers != null) ? teachers.size() : 0;
    int parentCount  = (parents  != null) ? parents.size()  : 0;
    int studentCount = (students != null) ? students.size() : 0;
    String flashErr = (String) session.getAttribute("flashError");
    if (flashErr != null) session.removeAttribute("flashError");
    String flashOk = (String) session.getAttribute("flashSuccess");
    if (flashOk != null) session.removeAttribute("flashSuccess");
%>
<div class="dino-container">

    <!-- Header -->
    <header class="dino-header">
        <div class="dino-mascot">🛡️</div>
        <div class="header-text">
            <h1>Manager Dashboard</h1>
            <p>Welcome, ${sessionScope.user}! Manage the LCMS.</p>
        </div>
    </header>

    <% if (flashErr != null) { %>
        <div class="flash-err">❌ <%= flashErr %></div>
    <% } %>
    <% if (flashOk != null) { %>
        <div class="flash-ok">✅ <%= flashOk %></div>
    <% } %>

    <!-- Action cards -->
    <div class="dashboard-grid">
        <a class="action-card" href="${pageContext.request.contextPath}/parentRegister.jsp">
            <div class="icon">👪</div>
            <h3>Add Parent</h3>
            <p>Register a new parent account</p>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/registration.jsp">
            <div class="icon">🦕</div>
            <h3>Add Student</h3>
            <p>Enroll a student &amp; link to a parent</p>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/ManagerDashboardServlet?action=addTeacher">
            <div class="icon">🍎</div>
            <h3>Add Teacher</h3>
            <p>Register a new teacher account</p>
        </a>
        <a class="action-card" href="${pageContext.request.contextPath}/ClassServlet">
            <div class="icon">📚</div>
            <h3>Setup Class</h3>
            <p>Create or configure a classroom</p>
        </a>
        <a class="action-card volcano" href="${pageContext.request.contextPath}/ManagerDashboardServlet?action=logout">
            <div class="icon">🚪</div>
            <h3>Logout</h3>
            <p>Return to the login screen</p>
        </a>
    </div>

    <!-- ═══ PARENTS TABLE ═══ -->
    <div class="section-wrap">
        <div class="section-head">
            <span class="section-title">👪 Registered Parents</span>
            <span class="badge"><%= parentCount %></span>
        </div>
        <% if (parents == null || parents.isEmpty()) { %>
            <p class="empty-msg">No parents registered yet. <a href="${pageContext.request.contextPath}/parentRegister.jsp">Add one now →</a></p>
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
                        <a class="name-link"
                           href="${pageContext.request.contextPath}/ParentStudentsServlet?parentId=<%= pId %>">
                            👪 <%= p[1] %>
                        </a>
                    </td>
                    <td><%= p[2] %></td>
                    <td><%= p[3] %></td>
                    <td>
                        <button class="tbl-btn tbl-edit" onclick="showEdit('p-edit-<%= pId %>','p-row-<%= pId %>')">✏️ Edit</button>
                        <button class="tbl-btn tbl-delete" onclick="confirmDelete('deleteParentForm','deleteParentId','<%= pId %>','<%= p[1] %>')">🗑️</button>
                    </td>
                </tr>
                <!-- Edit row -->
                <tr id="p-edit-<%= pId %>" class="edit-row" style="display:none;">
                    <td colspan="5">
                        <form action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post">
                            <input type="hidden" name="action" value="editParent">
                            <input type="hidden" name="id"     value="<%= pId %>">
                            <div class="edit-grid edit-grid-4">
                                <div>
                                    <span class="edit-lbl">Email</span>
                                    <input class="edit-input" type="email" name="email" value="<%= p[2] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Phone</span>
                                    <input class="edit-input" type="tel" name="phone" value="<%= p[3] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Age</span>
                                    <input class="edit-input" type="number" name="age" placeholder="Age" min="18" max="99" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Occupation</span>
                                    <input class="edit-input" type="text" name="occupation" placeholder="Occupation" required>
                                </div>
                            </div>
                            <div>
                                <span class="edit-lbl">Address</span>
                                <input class="edit-input" type="text" name="address" placeholder="Home address" required>
                            </div>
                            <div class="edit-save-row">
                                <button type="submit" class="tbl-btn btn-save-inline">💾 Save</button>
                                <button type="button" class="tbl-btn btn-cancel-inline"
                                        onclick="hideEdit('p-edit-<%= pId %>','p-row-<%= pId %>')">✖ Cancel</button>
                            </div>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <!-- ═══ STUDENTS TABLE ═══ -->
    <div class="section-wrap orange">
        <div class="section-head orange">
            <span class="section-title">🦕 Registered Students</span>
            <span class="badge-orange"><%= studentCount %></span>
        </div>
        <% if (students == null || students.isEmpty()) { %>
            <p class="empty-msg">No students registered yet. <a href="${pageContext.request.contextPath}/registration.jsp">Add one now →</a></p>
        <% } else { %>
        <table class="data-table ot" id="studentsTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Full Name</th>
                    <th>DOB</th>
                    <th>Parent</th>
                    <th style="width:130px;">Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                // Build parent options string once for reuse in edit dropdowns
                StringBuilder parentOpts = new StringBuilder();
                parentOpts.append("<option value='0'>-- No parent --</option>");
                if (parents != null) {
                    for (String[] po : parents) {
                        parentOpts.append("<option value='").append(po[0]).append("'>")
                                  .append(po[1]).append("</option>");
                    }
                }
            %>
            <% int si = 1; for (String[] s : students) {
                String sId = s[0];
                String sPid = (s.length > 4) ? s[4] : "0";
                String sPname = (s.length > 5 && s[5] != null && !s[5].isEmpty()) ? s[5] : null;
            %>
                <!-- Display row -->
                <tr id="s-row-<%= sId %>">
                    <td><%= si++ %></td>
                    <td>
                        <a class="name-link orange"
                           href="${pageContext.request.contextPath}/ParentStudentsServlet?studentId=<%= sId %>">
                            🦕 <%= s[1] %> <%= s[2] %>
                        </a>
                    </td>
                    <td><%= s[3] %></td>
                    <td>
                        <% if (sPname != null) { %>
                            <a class="parent-tag"
                               href="${pageContext.request.contextPath}/ParentStudentsServlet?parentId=<%= sPid %>">
                                👪 <%= sPname %>
                            </a>
                        <% } else { %>
                            <span class="no-parent-tag">No parent</span>
                        <% } %>
                    </td>
                    <td>
                        <button class="tbl-btn tbl-edit" onclick="showEdit('s-edit-<%= sId %>','s-row-<%= sId %>')">✏️ Edit</button>
                        <button class="tbl-btn tbl-delete" onclick="confirmDelete('deleteStudentForm','deleteStudentId','<%= sId %>','<%= s[1] %> <%= s[2] %>')">🗑️</button>
                    </td>
                </tr>
                <!-- Edit row -->
                <tr id="s-edit-<%= sId %>" class="edit-row ot" style="display:none;">
                    <td colspan="5">
                        <form action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post">
                            <input type="hidden" name="action" value="editStudent">
                            <input type="hidden" name="id"     value="<%= sId %>">
                            <div class="edit-grid edit-grid-4">
                                <div>
                                    <span class="edit-lbl">First Name</span>
                                    <input class="edit-input" type="text" name="firstName" value="<%= s[1] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Last Name</span>
                                    <input class="edit-input" type="text" name="lastName"  value="<%= s[2] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Date of Birth</span>
                                    <input class="edit-input" type="date" name="dob" value="<%= s[3] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Gender</span>
                                    <select class="edit-input" name="gender" required>
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                    </select>
                                </div>
                                <div>
                                    <span class="edit-lbl">Guardian Name</span>
                                    <input class="edit-input" type="text" name="guardian" placeholder="Guardian" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Relationship</span>
                                    <input class="edit-input" type="text" name="relationship" placeholder="e.g. Mother" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Phone</span>
                                    <input class="edit-input" type="tel" name="phone" placeholder="+60 12-345 6789" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Email</span>
                                    <input class="edit-input" type="email" name="email" placeholder="guardian@email.com" required>
                                </div>
                            </div>
                            <div>
                                <span class="edit-lbl">Link to Parent</span>
                                <select class="edit-input" name="parentId">
                                    <%=
                                        // Mark current parent as selected
                                        parentOpts.toString()
                                            .replace("value='" + sPid + "'>", "value='" + sPid + "' selected>")
                                    %>
                                </select>
                            </div>
                            <div class="edit-save-row">
                                <button type="submit" class="tbl-btn btn-save-inline">💾 Save</button>
                                <button type="button" class="tbl-btn btn-cancel-inline"
                                        onclick="hideEdit('s-edit-<%= sId %>','s-row-<%= sId %>')">✖ Cancel</button>
                            </div>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>


    <!-- ═══ TEACHERS TABLE ═══ -->
    <div class="section-wrap blue">
        <div class="section-head blue">
            <span class="section-title">🍎 Registered Teachers</span>
            <span class="badge-blue"><%= teacherCount %></span>
        </div>
        <% if (teachers == null || teachers.isEmpty()) { %>
            <p class="empty-msg">No teachers registered yet.
                <a href="${pageContext.request.contextPath}/ManagerDashboardServlet?action=addTeacher">Add one now →</a></p>
        <% } else { %>
        <table class="data-table bt" id="teachersTable">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>IC Number</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Qualification</th>
                    <th>Experience</th>
                    <th>Subjects</th>
                    <th style="width:130px;">Actions</th>
                </tr>
            </thead>
            <tbody>
            <% int ti = 1; for (String[] t : teachers) {
                String tId = t[0]; %>
                <!-- Display row -->
                <tr id="t-row-<%= tId %>">
                    <td><%= ti++ %></td>
                    <td><%= t[1] %></td>
                    <td><strong><%= t[2] %></strong></td>
                    <td><%= t[3] != null ? t[3] : "-" %></td>
                    <td><%= t[4] != null ? t[4] : "-" %></td>
                    <td><%= t[5] != null ? t[5] : "-" %></td>
                    <td><%= t[6] != null ? t[6] : "-" %></td>
                    <td><%= t[7] != null ? t[7] : "-" %></td>
                    <td><%= t[8] != null ? t[8] : "-" %></td>
                    <td>
                        <button class="tbl-btn tbl-edit"
                                onclick="showEdit('t-edit-<%= tId %>','t-row-<%= tId %>')">✏️ Edit</button>
                        <button class="tbl-btn tbl-delete"
                                onclick="confirmDelete('deleteTeacherForm','deleteTeacherId','<%= tId %>','<%= t[2] %>')">🗑️</button>
                    </td>
                </tr>
                <!-- Edit row -->
                <tr id="t-edit-<%= tId %>" class="edit-row" style="display:none;">
                    <td colspan="10">
                        <form action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post">
                            <input type="hidden" name="action" value="editTeacher">
                            <input type="hidden" name="id"     value="<%= tId %>">
                            <div class="edit-grid edit-grid-3">
                                <div>
                                    <span class="edit-lbl">Full Name</span>
                                    <input class="edit-input" type="text" name="fullName" value="<%= t[2] %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">IC Number (XXXXXX-XX-XXXX)</span>
                                    <input class="edit-input" type="text" name="icNumber"
                                           value="<%= t[3] != null ? t[3] : "" %>"
                                           pattern="\d{6}-\d{2}-\d{4}" title="Format: 900101-14-5678"
                                           placeholder="900101-14-5678">
                                </div>
                                <div>
                                    <span class="edit-lbl">Email</span>
                                    <input class="edit-input" type="email" name="email"
                                           value="<%= t[4] != null ? t[4] : "" %>" required>
                                </div>
                                <div>
                                    <span class="edit-lbl">Phone</span>
                                    <input class="edit-input" type="tel" name="phone"
                                           value="<%= t[5] != null ? t[5] : "" %>" placeholder="+60 12-345 6789">
                                </div>
                                <div>
                                    <span class="edit-lbl">Qualification</span>
                                    <input class="edit-input" type="text" name="qualification"
                                           value="<%= t[6] != null ? t[6] : "" %>" placeholder="e.g. Bachelor of Education">
                                </div>
                                <div>
                                    <span class="edit-lbl">Teaching Experience</span>
                                    <input class="edit-input" type="text" name="teachingExperience"
                                           value="<%= t[7] != null ? t[7] : "" %>" placeholder="e.g. 5 years">
                                </div>
                            </div>
                            <div>
                                <span class="edit-lbl">Subjects Taught</span>
                                <input class="edit-input" type="text" name="subject"
                                       value="<%= t[8] != null ? t[8] : "" %>" placeholder="e.g. Mathematics, Science">
                            </div>
                            <div class="edit-save-row">
                                <button type="submit" class="tbl-btn btn-save-inline">💾 Save</button>
                                <button type="button" class="tbl-btn btn-cancel-inline"
                                        onclick="hideEdit('t-edit-<%= tId %>','t-row-<%= tId %>')">✖ Cancel</button>
                            </div>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div><!-- end container -->

<!-- Hidden delete forms -->
<form id="deleteParentForm"  action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteParent">
    <input type="hidden" name="id" id="deleteParentId">
</form>
<form id="deleteTeacherForm" action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteTeacher">
    <input type="hidden" name="id" id="deleteTeacherId">
</form>
<form id="deleteStudentForm" action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteStudent">
    <input type="hidden" name="id" id="deleteStudentId">
</form>


<!-- Delete Confirmation Modal -->
<div id="deleteModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45);
     z-index:9999; align-items:center; justify-content:center;">
    <div style="background:white; border-radius:22px; padding:28px 32px; max-width:380px; width:90%;
                box-shadow:0 12px 40px rgba(0,0,0,0.3); text-align:center;">
        <div style="font-size:44px; margin-bottom:10px;">🗑️</div>
        <h2 style="margin:0 0 10px; color:#b71c1c; font-size:18px;">Delete Account</h2>
        <p style="margin:0 0 6px; color:#555; font-size:14px;">
            Are you sure you want to delete this account?
        </p>
        <p id="modalName" style="font-weight:700; color:#333; font-size:15px; margin:0 0 22px;"></p>
        <p style="color:#e65100; font-size:12px; margin:0 0 22px;">
            ⚠️ This action cannot be undone.
        </p>
        <div style="display:flex; gap:12px; justify-content:center;">
            <button onclick="cancelDelete()"
                    style="padding:12px 26px; border-radius:16px; border:3px solid #ddd;
                           background:#f5f5f5; font-family:'Quicksand',sans-serif;
                           font-weight:700; font-size:15px; cursor:pointer;">
                ✖ Cancel
            </button>
            <button id="modalConfirmBtn" onclick="executeDelete()"
                    style="padding:12px 26px; border-radius:16px; border:none;
                           background:#d32f2f; color:white;
                           font-family:'Quicksand',sans-serif; font-weight:700;
                           font-size:15px; cursor:pointer; box-shadow:0 4px 0 #b71c1c;">
                🗑️ Delete
            </button>
        </div>
    </div>
</div>

<script>
var _pendingFormId, _pendingInputId, _pendingId;

function showEdit(editId, rowId) {
    document.getElementById(rowId).style.display  = 'none';
    document.getElementById(editId).style.display = 'table-row';
}
function hideEdit(editId, rowId) {
    document.getElementById(editId).style.display = 'none';
    document.getElementById(rowId).style.display  = 'table-row';
}
function confirmDelete(formId, inputId, id, name) {
    _pendingFormId  = formId;
    _pendingInputId = inputId;
    _pendingId      = id;
    document.getElementById('modalName').textContent = '"' + name + '"';
    var modal = document.getElementById('deleteModal');
    modal.style.display = 'flex';
}
function cancelDelete() {
    document.getElementById('deleteModal').style.display = 'none';
    _pendingFormId = _pendingInputId = _pendingId = null;
}
function executeDelete() {
    if (!_pendingFormId) return;
    document.getElementById(_pendingInputId).value = _pendingId;
    document.getElementById(_pendingFormId).submit();
}
// Close modal on backdrop click
document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) cancelDelete();
});
</script>
</body>
</html>
