<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Prevent back-button access after logout
    response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    // Consume flash messages
    String flashOk  = (String) session.getAttribute("flashSuccess");
    if (flashOk  != null) session.removeAttribute("flashSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dino LCMS – Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        .role-selector { display:flex; gap:10px; margin-bottom:20px; }
        .role-btn {
            flex:1; padding:13px 8px; border-radius:18px;
            border:3px solid #e0e0e0; background:#f9f9f9;
            font-family:'Quicksand',sans-serif; font-weight:700;
            font-size:14px; cursor:pointer; transition:all 0.2s; color:#555;
        }
        .role-btn.active-parent  { border-color:var(--leaf-green); background:#e8f5e9; color:var(--dark-jungle); box-shadow:0 4px 0 var(--dark-jungle); }
        .role-btn.active-manager { border-color:var(--volcano);    background:#fff3e0; color:#bf360c;            box-shadow:0 4px 0 #bf360c; }
        .or-divider { text-align:center; color:#aaa; font-size:13px; margin:12px 0; }
        .teacher-direct-btn {
            display:block; width:100%; padding:14px; border-radius:20px;
            background:#1565c0; color:white; border:none;
            font-family:'Quicksand',sans-serif; font-weight:700; font-size:16px;
            cursor:pointer; box-shadow:0 5px 0 #0d47a1; text-align:center;
            text-decoration:none;
        }
        .teacher-direct-btn:active { transform:translateY(4px); box-shadow:none; }
        .forgot-link { text-align:right; font-size:12px; margin-top:6px; }
        .forgot-link a { color:#888; text-decoration:none; }
        .forgot-link a:hover { color:var(--leaf-green); text-decoration:underline; }
        .forgot-link a.mgr { color:#bf360c; }
        .success-banner {
            background:#e8f5e9; border:3px solid var(--leaf-green); border-radius:15px;
            padding:12px 18px; margin-bottom:18px; color:var(--dark-jungle); font-weight:700;
        }
    </style>
</head>
<body>
    <div class="dino-container">
        <header class="dino-header">
            <div class="dino-mascot">🌋</div>
            <div class="header-text">
                <h1>Dino LCMS Login</h1>
                <p>Welcome back, explorer!</p>
            </div>
        </header>

        <% if (flashOk != null) { %>
            <div class="success-banner">✅ <%= flashOk %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="dino-card volcano-orange" style="margin-bottom:15px;">
                <p style="color:#b71c1c; margin:0;">${error}</p>
            </div>
        <% } %>

        <!-- Role toggle -->
        <div class="role-selector">
            <button type="button" class="role-btn active-parent" id="btnParent"
                    onclick="selectRole('parent')">🦖 Parent</button>
            <button type="button" class="role-btn" id="btnManager"
                    onclick="selectRole('manager')">🛡️ Manager</button>
        </div>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="hidden" name="role" id="roleInput" value="parent">
            <fieldset class="dino-card jungle-green" id="credentialCard">
                <legend id="credLegend">🔑 Parent Credentials</legend>
                <div class="input-field">
                    <label>Username</label>
                    <input type="text" name="user" required>
                </div>
                <div class="input-field">
                    <label>Password</label>
                    <input type="password" name="pass" required>
                </div>
                <div class="forgot-link" id="forgotDiv">
                    <a href="${pageContext.request.contextPath}/ForgotPasswordServlet?role=parent"
                       id="forgotLink">Forgot password?</a>
                </div>
            </fieldset>
            <div class="dino-actions">
                <button type="submit" class="btn-leaf" id="loginBtn">Login! 🐾</button>
                <button type="button" class="btn-stone"
                        onclick="location.href='${pageContext.request.contextPath}/parentRegister.jsp'">
                    Register
                </button>
            </div>
        </form>

        <div class="or-divider">── or ──</div>

        <a class="teacher-direct-btn"
           href="${pageContext.request.contextPath}/teacherLogin.jsp">
            🍎 Login as Teacher
        </a>
    </div>

    <script>
        function selectRole(role) {
            const btnParent  = document.getElementById('btnParent');
            const btnManager = document.getElementById('btnManager');
            const card       = document.getElementById('credentialCard');
            const legend     = document.getElementById('credLegend');
            const loginBtn   = document.getElementById('loginBtn');
            const forgotLink = document.getElementById('forgotLink');
            document.getElementById('roleInput').value = role;
            if (role === 'parent') {
                btnParent.className  = 'role-btn active-parent';
                btnManager.className = 'role-btn';
                card.className       = 'dino-card jungle-green';
                legend.textContent   = '🔑 Parent Credentials';
                loginBtn.textContent = 'Login as Parent 🐾';
                forgotLink.href      = '${pageContext.request.contextPath}/ForgotPasswordServlet?role=parent';
                forgotLink.className = '';
            } else {
                btnParent.className  = 'role-btn';
                btnManager.className = 'role-btn active-manager';
                card.className       = 'dino-card volcano-orange';
                legend.textContent   = '🛡️ Manager Credentials';
                loginBtn.textContent = 'Login as Manager 🛡️';
                forgotLink.href      = '${pageContext.request.contextPath}/ForgotPasswordServlet?role=manager';
                forgotLink.className = 'mgr';
            }
        }
    </script>
</body>
</html>
