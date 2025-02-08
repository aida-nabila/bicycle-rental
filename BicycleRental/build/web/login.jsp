<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bicycle Rental - Login</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
   <body>
       <jsp:include page="header.jsp"/>
        <div class="login-container">
            
           <h2>Log In</h2>
           
            <form action="loginServlet" method="post">
                
                <div class="group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Email" required>
                </div>
                
                <div class="group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" placeholder="Password" required>
                    </div>
                </div>

                <div class="row">
                    <div class="actions">
                        <!-- Show Password Checkbox -->
                        <label class="show-password">
                            <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show password
                        </label>

                        <!-- Forgot Password Link -->
                        <a href="forgotPassword.jsp" class="forgot-password">Forgot Password?</a>
                    </div>
                </div>
                
                <button type="submit">Login</button>
            </form>

            <p>Don't have an Account? <a href="signup.jsp">Sign Up</a></p>
        </div>

        <jsp:include page="footer.jsp"/>
        
    </body>
        <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var checkbox = document.getElementById("showPassword");

            if (checkbox.checked) {
                passwordField.type = "text";
            } else {
                passwordField.type = "password";
            }
        }
    </script>
</html>