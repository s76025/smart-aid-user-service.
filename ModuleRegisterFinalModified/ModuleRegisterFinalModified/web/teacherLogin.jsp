<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    String flashOk = (String) session.getAttribute("flashSuccess");
    if (flashOk != null) session.removeAttribute("flashSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Login – Dino LCMS</title>
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
        .success-banner {
            background: #e8f5e9; border: 3px solid var(--leaf-green); border-radius: 15px;
            padding: 12px 18px; margin-bottom: 18px; color: var(--dark-jungle); font-weight: 700;
        }
        .error-banner {
            background: #fff3e0; border: 3px solid var(--volcano); border-radius: 15px;
            padding: 12px 18px; margin-bottom: 18px; color: #bf360c; font-weight: 700;
        }
        .footer-links { text-align: center; margin-top: 18px; font-size: 13px; color: #888; }
        .footer-links a { color: #1565c0; font-weight: 700; text-decoration: none; margin: 0 8px; }
        .footer-links a:hover { text-decoration: underline; }
        .forgot-link { text-align:right; font-size:12px; margin-top:6px; }
        .forgot-link a { color:#1565c0; text-decoration:none; }
        .forgot-link a:hover { text-decoration:underline; }
    </style>
</head>
<body>
    <div class="dino-container">
        <header class="dino-header teacher-header">
            <div class="dino-mascot">🍎</div>
            <div class="header-text">
                <h1 style="color:white;">Teacher Login</h1>
                <p style="color:#e3f2fd;">Welcome back, educator! 📚</p>
            </div>
        </header>

        <% if (flashOk != null) { %>
            <div class="success-banner">✅ <%= flashOk %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-banner">✅ ${success}</div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-banner">❌ ${error}</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/TeacherServlet" method="post">
            <input type="hidden" name="action" value="login">
            <fieldset class="dino-card teacher-card">
                <legend>🔑 Teacher Credentials</legend>
                <div class="input-field">
                    <label for="user">Username</label>
                    <input type="text" id="user" name="user" placeholder="Enter your username" required>
                </div>
                <div class="input-field">
                    <label for="pass">Password</label>
                    <input type="password" id="pass" name="pass" placeholder="Enter your password" required>
                </div>
                <div class="forgot-link">
                    <a href="${pageContext.request.contextPath}/ForgotPasswordServlet?role=teacher">
                        Forgot password?
                    </a>
                </div>
            </fieldset>
            <div class="dino-actions">
                <button type="submit" class="btn-teacher">Login 🍎</button>
                <button type="button" class="btn-stone"
                        onclick="location.href='${pageContext.request.contextPath}/login.jsp'">
                    Back
                </button>
            </div>
        </form>

        <div class="footer-links">
            <span>Don't have an account? Contact your Manager to register.</span>
        </div>
    </div>
</body>
</html>
