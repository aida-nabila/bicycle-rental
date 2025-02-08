<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sessionObj = request.getSession(false);
    String userEmail = (String) request.getAttribute("userEmail");
    Integer userId = (Integer) request.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bicycle Rental - Payment</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('status') === 'success') {
                    alert("Payment Successful!");
                    window.location.href = "rent.jsp"; // Redirect to rental.jsp after success
                } else if (urlParams.get('status') === 'error') {
                    alert("Payment Failed! Please try again.");
                    window.location.href = "rent.jsp"; // Redirect to rent.jsp after failure
                }
            };

            function formatCardNumber(input) {
                // Remove all non-digit characters
                let value = input.value.replace(/\D/g, '');

                // Limit to 16 digits
                value = value.substring(0, 16);

                // Add spaces after every 4 digits
                let formattedValue = value.replace(/(\d{4})/g, '$1 ').trim();

                // Set the formatted value back to the input field
                input.value = formattedValue;
            }
        </script>
    </head>
    <body>
        <jsp:include page="headerver3.jsp"/>

        <div class="payment-container">
            <h2>Payment</h2>

            <%
                String cost = request.getParameter("cost"); // Retrieve from POST data
                String rentalId = request.getParameter("rentalId");
            %>
            
            <p><strong>Rental ID:</strong> <%= rentalId %></p>

            <form action="processPaymentServlet" method="post" class="payment-form">
                <!-- Accepted Cards Section -->
                <div class="header">
                    <div class="div">We accept</div>
                    <div class="div-2">
                        <img class="img" src="img/visa.png" alt="Visa">
                        <img class="img" src="img/master-card.png" alt="MasterCard">
                    </div>
                </div>

                <!-- Card Number -->
                <div class="form-group">
                    <label for="cardNumber" class="text-wrapper-2">Card Number *</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="xxxx xxxx xxxx xxxx" required class="text-input"  maxlength="19" oninput="formatCardNumber(this)">
                </div>

                <!-- Expiry Date and CVV -->
                <div class="div-4">
                    <div class="form-group">
                        <label for="expiryMonth" class="text-wrapper-2">Expiry date *</label>
                        <div class="div-6">
                            <input type="text" id="expiryMonth" name="expiryMonth" placeholder="Month" required class="text-input">
                            <input type="text" id="expiryYear" name="expiryYear" placeholder="Year" required class="text-input">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="cvv" class="text-wrapper-2">CVV/CVC *</label>
                        <input type="text" id="cvv" name="cvv" placeholder="CVV" required class="text-input">
                    </div>
                </div>

                <!-- Cardholder Name -->
                <div class="form-group">
                    <label for="cardHolderName" class="text-wrapper-2">Card holder name *</label>
                    <input type="text" id="cardHolderName" name="cardHolderName" placeholder="Name on card" required class="text-input">
                </div>

                <!-- Price Section -->
                <div class="price-section">
                    <h3>Total Price</h3>
                    <p>RM <%= cost%></p>
                </div>

                <!-- Hidden Fields to Pass Data -->
                <input type="hidden" name="cost" value="<%= cost%>">
                <input type="hidden" name="rentalId" value="<%= rentalId %>">


                <!-- Payment Buttons -->
                <div class="div-7">
                    <button type="button" class="button-2">Cancel</button>
                    <button type="submit" class="button-3">Pay RM <%= cost%> Now</button>
                </div>
            </form>
        </div>

        <jsp:include page="footer.jsp"/>
    </body>
</html>
