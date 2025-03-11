<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bicycle Rental - Login</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <!-- Header -->
    <jsp:include page="header.jsp"/>

    <!-- Login Container -->
    <div class="login-container">
        <h2>Log In</h2>

        <form action="loginServlet" method="post">
            
            <!-- Email Input -->
            <div>
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <!-- Password Input with Show Password Option -->
            <div>
                <label for="password">Password</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
            </div>

            <!-- Show Password & Forgot Password -->
            <div class="actions">
                <label class="show-password">
                    <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show password
                </label>
                <a href="forgotPassword.jsp" class="forgot-password">Forgot Password?</a>
            </div>

            <!-- Login Button -->
            <button type="submit">Login</button>
        </form>

        <!-- Sign Up Link -->
        <p>
            Don't have an account? <a href="signup.jsp" class="signup-text">Sign Up</a>
        </p>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp"/>

    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            passwordField.type = document.getElementById("showPassword").checked ? "text" : "password";
        }
    </script>

</body>
</html>
