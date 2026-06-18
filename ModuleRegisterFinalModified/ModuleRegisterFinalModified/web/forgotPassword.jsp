<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role  = (String) request.getAttribute("role");
    String step  = (String) request.getAttribute("step");
    String aUser = (String) request.getAttribute("accountUser");
    if (role == null) role = "parent";
    if (step == null) step = "lookup";

    // Role display labels
    String roleLabel = "Parent";
    String roleIcon  = "🦖";
    String roleColor = "#2e7d32";
    String headerBg  = "linear-gradient(135deg, #388e3c 0%, #66bb6a 100%)";
    String loginUrl  = request.getContextPath() + "/login.jsp";
    if ("manager".equals(role)) {
        roleLabel = "Manager"; roleIcon = "🛡️"; roleColor = "#bf360c";
        headerBg  = "linear-gradient(135deg, #d84315 0%, #ff7043 100%)";
        loginUrl  = request.getContextPath() + "/login.jsp";
    } else if ("teacher".equals(role)) {
        roleLabel = "Teacher"; roleIcon = "🍎"; roleColor = "#1565c0";
        headerBg  = "linear-gradient(135deg, #1565c0 0%, #0288d1 100%)";
        loginUrl  = request.getContextPath() + "/teacherLogin.jsp";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password – Dino LCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        .fp-header {
            background: <%= headerBg %>;
            border-radius: 20px 20px 0 0;
            padding: 24px 20px;
            display: flex; align-items: center; gap: 16px;
            margin-bottom: 22px;
        }
        .fp-header .icon { font-size: 42px; }
        .fp-header h1   { color: white; margin: 0; font-size: 22px; }
        .fp-header p    { color: rgba(255,255,255,0.85); margin: 4px 0 0; font-size: 14px; }
        .btn-main {
            background: <%= roleColor %>; color: white; width: 100%;
            padding: 15px; border-radius: 22px; border: none;
            font-family: 'Quicksand', sans-serif; font-weight: 700;
            font-size: 17px; cursor: pointer;
            box-shadow: 0 5px 0 rgba(0,0,0,0.25);
        }
        .btn-main:active { transform: translateY(4px); box-shadow: none; }
        .error-banner {
            background: #fff3e0; border: 3px solid #e65100; border-radius: 14px;
            padding: 12px 18px; margin-bottom: 18px; color: #bf360c; font-weight: 700;
        }
        .info-banner {
            background: #e3f2fd; border: 3px solid #1565c0; border-radius: 14px;
            padding: 12px 18px; margin-bottom: 18px; color: #0d47a1; font-weight: 700;
        }
        .back-link {
            display: block; text-align: center; margin-top: 18px;
            color: #888; font-size: 14px; text-decoration: none;
        }
        .back-link:hover { color: <%= roleColor %>; }
        .step-badge {
            display: inline-block; background: rgba(255,255,255,0.25);
            color: white; padding: 3px 12px; border-radius: 12px;
            font-size: 11px; font-weight: 700; margin-top: 6px;
        }
    </style>
</head>
<body>
<div class="dino-container">

    <div class="fp-header">
        <div class="icon"><%= roleIcon %></div>
        <div>
            <h1>Forgot Password</h1>
            <p><%= roleLabel %> account password reset</p>
            <span class="step-badge">
                <%= "reset".equals(step) ? "Step 2 of 2 – Set New Password" : "Step 1 of 2 – Verify Account" %>
            </span>
        </div>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error-banner">❌ <%= request.getAttribute("error") %></div>
    <% } %>

    <% if ("lookup".equals(step)) { %>
        <!-- ── Step 1: Account lookup ── -->
        <div class="info-banner">
            💡 Enter your <strong>username</strong> or <strong>email address</strong> to find your account.
        </div>
        <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
            <input type="hidden" name="action" value="lookup">
            <input type="hidden" name="role"   value="<%= role %>">
            <fieldset class="dino-card">
                <legend>🔍 Find Your Account</legend>
                <div class="input-field">
                    <label for="identifier">Username or Email</label>
                    <input type="text" id="identifier" name="identifier"
                           placeholder="e.g. cikgu_ali or teacher@email.com"
                           required autofocus>
                </div>
            </fieldset>
            <button type="submit" class="btn-main">🔍 Find Account</button>
        </form>

    <% } else { %>
        <!-- ── Step 2: New password form ── -->
        <div class="info-banner">
            ✅ Account found: <strong><%= aUser != null ? aUser : "" %></strong><br>
            Enter your new password below.
        </div>
        <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
            <input type="hidden" name="action" value="reset">
            <input type="hidden" name="role"   value="<%= role %>">
            <fieldset class="dino-card">
                <legend>🔑 Set New Password</legend>
                <div class="input-field">
                    <label for="newPass">New Password *</label>
                    <input type="password" id="newPass" name="newPass"
                           placeholder="Enter new password" required autofocus
                           minlength="6">
                </div>
                <div class="input-field">
                    <label for="confirmPass">Confirm Password *</label>
                    <input type="password" id="confirmPass" name="confirmPass"
                           placeholder="Re-enter new password" required minlength="6">
                </div>
            </fieldset>
            <button type="submit" class="btn-main">🔒 Update Password</button>
        </form>
    <% } %>

    <a class="back-link" href="<%= loginUrl %>">← Back to Login</a>
</div>

<script>
// Client-side password match check before submit
document.querySelector('form').addEventListener('submit', function(e) {
    var np = document.getElementById('newPass');
    var cp = document.getElementById('confirmPass');
    if (np && cp && np.value !== cp.value) {
        e.preventDefault();
        alert('Passwords do not match. Please try again.');
        cp.focus();
    }
});
</script>
</body>
</html>
