<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bicycle Rental - Confirmation Summary</title>
    <link rel="stylesheet" type="text/css" href="summary-styles.css">
    <script>
        function enableEdit() {
            document.getElementById("name").removeAttribute("readonly");
            document.getElementById("contact").removeAttribute("readonly");
            document.getElementById("name").focus();
        }
    </script>
</head>
<body>

    <jsp:include page="headerver3.jsp"/>

    <h2 class="summary-title">Confirmation Summary</h2>

    <%-- Display Success or Error Message --%>
    <% if (request.getAttribute("successMessage") != null) { %>
        <p style="color: green;"><%= request.getAttribute("successMessage") %></p>
    <% } else if (request.getAttribute("errorMessage") != null) { %>
        <p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <%
        
        // Retrieve rental details from request
        String name =(String) request.getAttribute("name");
        String contact = (String) request.getAttribute("contact");
        String bicycleType = (String) request.getAttribute("bicycleType");
        String tagNo = (String) request.getAttribute("tagNo");
        String rentalHours = (request.getAttribute("rentalHours") != null) ? request.getAttribute("rentalHours").toString() : "";
        String date = (String) request.getAttribute("date");
        String time = (String) request.getAttribute("time");

        // Fixed rate per hour
        double ratePerHour = 10.00;

        // Calculate total cost
        double totalCost = (rentalHours != null && !rentalHours.isEmpty()) ? Integer.parseInt(rentalHours) * ratePerHour : 0;
    %>

    <form action="UpdateDetailsServlet" method="post">
        <div class="summary-container">
            <p><strong>Rental ID:</strong> ${rentalId}</p>
            <input type="hidden" name="rentalId" value="<%= request.getAttribute("rentalId") %>" />
            <!-- Name & Contact (Editable) -->
            <div class="summary-row">
                <div class="summary-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" value="<%= name %>" readonly>
                </div>
                <div class="summary-group">
                    <label for="contact">Contact Number:</label>
                    <input type="text" id="contact" name="contact" value="<%= contact %>" readonly>
                </div>
            </div>

            <!-- Rental Details -->
            <div class="summary-row">
                <div class="summary-group">
                    <label for="bicycleType">Bicycle Type:</label>
                    <input type="text" id="bicycleType" name="bicycleType" value="<%= bicycleType %>" readonly>
                </div>
                <div class="summary-group">
                    <label for="tagNo">Bicycle Tag Number:</label>
                    <input type="text" id="tagNo" name="tagNo" value="<%= tagNo %>" readonly>
                </div>
            </div>

            <div class="summary-row">
                <div class="summary-group">
                    <label for="rentalHours">Rental Hours:</label>
                    <input type="text" id="rentalHours" name="rentalHours" value="<%= rentalHours %>" readonly>
                </div>
                <div class="summary-group">
                    <label for="date">Date of Rental:</label>
                    <input type="text" id="date" name="date" value="<%= date %>" readonly>
                </div>
            </div>

            <div class="summary-row">
                <div class="summary-group">
                    <label for="time">Time of Rental:</label>
                    <input type="text" id="time" name="time" value="<%= time %>" readonly>
                </div>
                <div class="summary-group">
                    <label for="rate">Rate per Hour (RM):</label>
                    <input type="text" id="rate" name="rate" value="<%= ratePerHour %>" readonly>
                </div>
            </div>

            <div class="summary-row">
                <div class="summary-group">
                    <label for="cost">Total Cost (RM):</label>
                    <input type="text" id="cost" name="cost" value="<%= totalCost %>" readonly>
                </div>
            </div>

            <div class="summary-row">
                <div class="summary-group"></div>
                <div class="summary-button-container">
                    <button type="button" class="summary-edit-button" onclick="enableEdit()">Edit</button>
                    <button type="submit" class="summary-confirm-button">Confirm</button>
                </div>
            </div>
        </div>
    </form>

    <jsp:include page="footer.jsp"/>

</body>
</html>
