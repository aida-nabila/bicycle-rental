<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rental Confirmation</title>
        <link rel="stylesheet" type="text/css" href="confirmation-styles.css">
    </head>
    <body>
        <jsp:include page="headerver3.jsp"/>

        <h2 class="confirmation-title">Rental Confirmation</h2>

        <%
            String rentalId = (String) request.getAttribute("rentalId");
            String name = (String) request.getAttribute("name");
            String contact = (String) request.getAttribute("contact");
            String bicycleType = (String) request.getAttribute("bicycleType");
            String tagNo = (String) request.getAttribute("tagNo");
            String rentalHours = (request.getAttribute("rentalHours") != null) ? request.getAttribute("rentalHours").toString() : "";
            String date = (String) request.getAttribute("date");
            String time = (String) request.getAttribute("time");
            String rate = (request.getAttribute("rate") != null) ? request.getAttribute("rate").toString() : "10.00";
            String cost = (request.getAttribute("cost") != null) ? request.getAttribute("cost").toString() : "";
        %>

        <div class="confirmation-container">
            <p>Thank you, <strong><%= name %></strong>! Your bicycle rental has been successfully registered.</p>

            <div class="confirmation-details">
                <h3>Rental Details:</h3>
                <p><strong>Rental ID:</strong> <%= rentalId %></p>
                <p><strong>Contact Number:</strong> <%= contact %></p>
                <p><strong>Bicycle Type:</strong> <%= bicycleType %></p>
                <p><strong>Bicycle Tag No.:</strong> <%= tagNo %></p>
                <p><strong>Rental Hours:</strong> <%= rentalHours %></p>
                <p><strong>Rate per Hour:</strong> RM <%= rate %></p>
                <p><strong>Date of Rental:</strong> <%= date %></p>
                <p><strong>Time of Rental:</strong> <%= time %></p>
                <p><strong>Total Cost:</strong> RM <%= cost %></p>
            </div>

            <!-- Back to Home Button -->
            <form action="payment.jsp" method="post">
               <div class="confirmation-button-container">
                   <input type="hidden" name="cost" value="<%= cost %>">
                   <!-- Make sure rentalId is passed as a hidden field in the confirmation form -->
                   <input type="hidden" name="rentalId" value="<%= rentalId %>">
                   <button type="submit" class="confirmation-button">Proceed to Payment</button>
               </div>
           </form>
        </div>

        <jsp:include page="footer.jsp"/>
    </body>
</html>
