<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dino Parent Registration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500;700&display=swap" rel="stylesheet">
    <style>
        textarea {
            width: 100%;
            padding: 12px;
            border: 3px solid #e0e0e0;
            border-radius: 15px;
            box-sizing: border-box;
            font-family: 'Quicksand', sans-serif;
            font-size: 15px;
            resize: vertical;
            min-height: 80px;
            transition: border-color 0.3s;
        }
        textarea:focus { border-color: var(--leaf-green); outline: none; }
    </style>
</head>
<body>
    <div class="dino-container">
        <header class="dino-header">
            <div class="dino-mascot">🦖</div>
            <div class="header-text">
                <h1>Parent Signup</h1>
                <p>Join our prehistoric family!</p>
            </div>
        </header>
        <form action="${pageContext.request.contextPath}/ParentServlet" method="post">

            <fieldset class="dino-card jungle-green">
                <legend>🦕 Account Details</legend>
                <div class="input-field">
                    <label>Username *</label>
                    <input type="text" name="user" required>
                </div>
                <div class="input-field">
                    <label>Password *</label>
                    <input type="password" name="pass" required>
                </div>
            </fieldset>

            <fieldset class="dino-card volcano-orange">
                <legend>🪪 Personal Info</legend>
                <div class="row">
                    <div class="input-field">
                        <label>IC Number *</label>
                        <input type="text" name="ic" placeholder="e.g. 900101-14-5678" required>
                    </div>
                    <div class="input-field">
                        <label>Age *</label>
                        <input type="number" name="age" placeholder="e.g. 35" min="18" max="99" required>
                    </div>
                </div>
                <div class="input-field">
                    <label>Occupation *</label>
                    <input type="text" name="occupation" placeholder="e.g. Engineer" required>
                </div>
                <div class="input-field">
                    <label>Home Address *</label>
                    <textarea name="address" placeholder="e.g. No. 12, Jalan Damai, 21000 Kuala Terengganu" required></textarea>
                </div>
            </fieldset>

            <fieldset class="dino-card forest-green">
                <legend>📱 Contact Info</legend>
                <div class="input-field">
                    <label>Email *</label>
                    <input type="email" name="email" required>
                </div>
                <div class="input-field">
                    <label>Phone *</label>
                    <input type="tel" name="phone" placeholder="+60 12-345 6789" required>
                </div>
            </fieldset>

            <div class="dino-actions">
                <button type="submit" class="btn-leaf">Sign Up! 🐾</button>
                <button type="button" class="btn-stone"
                        onclick="history.back()">
                    ✖ Cancel
                </button>
            </div>
        </form>
    </div>
</body>
</html>