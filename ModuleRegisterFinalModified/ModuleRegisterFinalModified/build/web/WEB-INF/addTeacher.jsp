<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Guard: manager only
    if (session == null || !"manager".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Teacher – Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        .teacher-header { background: linear-gradient(135deg, #1565c0 0%, #0288d1 100%); border-color: #0288d1; }
        .teacher-card   { border-color: #1565c0; }
        .btn-teacher {
            background: #1565c0; color: white; flex: 2; padding: 18px;
            border-radius: 25px; border: none; font-weight: 700; font-size: 18px;
            cursor: pointer; box-shadow: 0 6px 0 #0d47a1;
            font-family: 'Quicksand', sans-serif;
        }
        .btn-teacher:active { transform: translateY(4px); box-shadow: none; }
        .error-banner {
            background: #fff3e0; border: 3px solid var(--volcano); border-radius: 15px;
            padding: 12px 18px; margin-bottom: 18px; color: #bf360c; font-weight: 700;
        }
        .admin-badge {
            display: inline-block; background: #1565c0; color: white;
            font-size: 12px; font-weight: 700; padding: 3px 12px;
            border-radius: 12px; margin-left: 10px; vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="dino-container">
        <header class="dino-header teacher-header">
            <div class="dino-mascot">🍎</div>
            <div class="header-text">
                <h1 style="color:white;">Add New Teacher <span class="admin-badge">🛡️ Manager Only</span></h1>
                <p style="color:#e3f2fd;">Register a teacher account on their behalf.</p>
            </div>
        </header>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-banner">❌ ${error}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/ManagerDashboardServlet" method="post">
            <input type="hidden" name="action" value="registerTeacher">

            <fieldset class="dino-card teacher-card">
                <legend>🔑 Login Credentials</legend>
                <div class="row">
                    <div class="input-field">
                        <label for="user">Teacher Username *</label>
                        <input type="text" id="user" name="user" placeholder="e.g. cikgu_ali" required>
                    </div>
                    <div class="input-field">
                        <label for="pass">Teacher Password *</label>
                        <input type="password" id="pass" name="pass" placeholder="Create a password" required>
                    </div>
                </div>
            </fieldset>

            <fieldset class="dino-card jungle-green">
                <legend>👤 Personal Information</legend>
                <div class="input-field">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" placeholder="e.g. Cikgu Ali Bin Ahmad" required>
                </div>
                <div class="row">
                    <div class="input-field">
                        <label for="icNumber">IC Number</label>
                        <input type="text" id="icNumber" name="icNumber" placeholder="e.g. 900101-14-5678"
                               pattern="\d{6}-\d{2}-\d{4}" title="Format: 900101-14-5678">
                    </div>
                    <div class="input-field">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" placeholder="teacher@email.com" required>
                    </div>
                </div>
                <div class="input-field">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" placeholder="+60 12-345 6789">
                </div>
            </fieldset>

            <fieldset class="dino-card">
                <legend>🎓 Professional Details</legend>
                <div class="row">
                    <div class="input-field">
                        <label for="qualification">Qualification</label>
                        <input type="text" id="qualification" name="qualification"
                               placeholder="e.g. Bachelor of Education">
                    </div>
                    <div class="input-field">
                        <label for="teachingExperience">Teaching Experience</label>
                        <input type="text" id="teachingExperience" name="teachingExperience"
                               placeholder="e.g. 5 years">
                    </div>
                </div>
                <div class="input-field">
                    <label for="subject">Subjects Taught</label>
                    <input type="text" id="subject" name="subject"
                           placeholder="e.g. Mathematics, Science, Class K4-A">
                </div>
            </fieldset>

            <div class="dino-actions">
                <button type="submit" class="btn-teacher">Register Teacher 🍎</button>
                <button type="button" class="btn-stone"
                        onclick="location.href='${pageContext.request.contextPath}/ManagerDashboardServlet'">
                    ← Back to Dashboard
                </button>
            </div>
        </form>
    </div>
</body>
</html>
