<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bicycle Rental - Sign Up</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="signup-container">

           <h2>Sign Up</h2>
           
            <form action="signupServlet" method="post">

                <!-- First Name & Last Name -->
                <div class="row">
                    <div class="group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" placeholder="First Name" required>
                    </div>

                    <div class="group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" placeholder="Last Name" required>
                    </div>
                </div>

                <!-- Email Address -->
                <div class="group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Email" required>
                </div>

                <!-- Phone Number -->
                <div class="group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" placeholder="Phone Number" required>
                </div>

                <!-- Password & Confirm Password -->
                <div class="row">
                    <div class="group">
                        <label for="password">Password</label>
                        <div class="password-wrapper">
                            <input type="password" id="password" name="password" placeholder="Password" required onkeyup="validatePassword()">
                        </div>
                    </div>

                    <div class="group">
                        <label for="confirmPassword">Confirm Password</label>
                        <div class="password-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required onkeyup="validatePassword()">
                        </div>
                    </div>
                </div>
                
                <!-- Checkbox to show/hide password -->
                <div>
                    <label>
                        <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show password
                    </label>
                </div>
                
                <!-- Password Validation Message -->
                <p id="passwordMessage" class="password-hint"></p>
                
                <button type="submit" id="submitBtn">Sign Up</button>

            </form>

            <p>Already have an Account? <a href="login.jsp" class="login-text">Log In</a></p>
        </div>

        <jsp:include page="footer.jsp"/>
        
    </body>
    <script>
        function togglePasswordVisibility() {
            var passwordField = document.getElementById("password");
            var confirmPasswordField = document.getElementById("confirmPassword");
            var checkbox = document.getElementById("showPassword");

            if (checkbox.checked) {
                passwordField.type = "text";
                confirmPasswordField.type = "text";
            } else {
                passwordField.type = "password";
                confirmPasswordField.type = "password";
            }
        }

        function validatePassword() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var message = document.getElementById("passwordMessage");
            var submitBtn = document.getElementById("submitBtn");

            // Password strength requirements
            var minLength = password.length >= 8;
            var hasLetter = /[a-zA-Z]/.test(password);
            var hasNumber = /[0-9]/.test(password);
            var hasSymbol = /[\W_]/.test(password);
            
            // Hide message if password is empty
            if (password.trim() === "") {
                message.style.display = "none";
                submitBtn.disabled = true;
                return;
            } else {
                message.style.display = "inline-block";
            }

            // Check if passwords match
            if (password !== confirmPassword && confirmPassword.trim() !== "") {
                message.classList.remove("strong");
                message.classList.add("error");
                message.innerHTML = "❌ Passwords do not match.";
                submitBtn.disabled = true;
                return;
            }

            // Check if password meets all security requirements
            if (minLength && hasLetter && hasNumber && hasSymbol) {
                if (password === confirmPassword) {
                    message.classList.add("strong");
                    message.classList.remove("error");
                    message.innerHTML = "✔ Strong password and passwords match.";
                    submitBtn.disabled = false;
                } else {
                    message.classList.add("strong");
                    message.classList.remove("error");
                    message.innerHTML = "✔ Strong password.";
                    submitBtn.disabled = true;
                }
            } else {
                message.classList.remove("strong");
                message.classList.remove("error");
                message.innerHTML = "⚠ Use 8+ characters with letters, numbers & symbols.";
                submitBtn.disabled = true;
            }
 
            // Enable button only if conditions are met
            submitBtn.disabled = !(minLength && hasLetter && hasNumber && hasSymbol && password === confirmPassword);
        }
        </script>
</html>