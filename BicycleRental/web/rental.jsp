<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="db.dbconn"%>
<%@page import="java.util.List"%>
<%@page import="process.Rental"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%
    HttpSession sessionObj = request.getSession(false);
    String userEmail = (String) request.getAttribute("userEmail");
    Integer userId = (Integer) request.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Rental Data</title>
    <style>
        body { background-color: #f4f4f9; margin: 0; padding: 0; }
        .container { width: 90%; max-width: 1200px; margin: 30px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: grey; color: #fff; }
        td { background-color: #fafafa; }
        tr:hover td { background-color: #f1f1f1; }
        .info { margin-bottom: 20px; font-size: 18px; color: #555; }
        .return-btn { background-color: #B6FF65; color: black; padding: 10px 15px; border: none; cursor: pointer; border-radius: 5px; }
        .return-btn-complete { background-color: grey; color: white; padding: 10px 15px; border: none; border-radius: 5px; }
        .cancel-btn { background-color: red; color: white; padding: 10px 15px; border: none; border-radius: 5px; }
    </style>
</head>
<body>
    <jsp:include page="headerver3.jsp"/>
    <div class="container">
        <h2>Rental List</h2>
        <div class="info">
            <p><strong>Email:</strong> <%= (userEmail != null) ? userEmail : "Not Logged In" %></p>
            <p><strong>User ID:</strong> <%= (userId != null && userId != -1) ? userId.toString() : "N/A" %></p>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>Bicycle Type</th>
                <th>Tag No</th>
                <th>Rental Hours</th>
                <th>Rental Date</th>
                <th>Rental Time</th>
                <th>Created At</th>
                <th>Amount</th>
                <th>Payment Date</th>
                <th>Rental Status</th>
                <th>Penalty</th>
                <th>Return</th>
            </tr>
            <%
                List<Rental> rentalList = (List<Rental>) request.getAttribute("rentalList");
                if (rentalList != null && !rentalList.isEmpty()) {
                    for (Rental rental : rentalList) {
                        String rentalDateTimeStr = rental.getRentalDate() + " " + rental.getRentalTime();
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime rentalStart = LocalDateTime.parse(rentalDateTimeStr, formatter);
                        LocalDateTime rentalEnd = rentalStart.plusHours(rental.getRentalHours());
                        LocalDateTime currentTime = LocalDateTime.now();

                        double penalty = 0;
                        String timerText = "";
                        
                        // Update rental status and handle penalty or timer
                        if (currentTime.isBefore(rentalStart) && "Upcoming".equals(rental.getRentalStatus())) {
                            rental.setRentalStatus("Upcoming");
                        } else if (currentTime.isAfter(rentalStart) && currentTime.isBefore(rentalEnd)) {
                            rental.setRentalStatus("Ongoing");
                            Duration durationLeft = Duration.between(currentTime, rentalEnd);
                            long hoursLeft = durationLeft.toHours();
                            long minutesLeft = durationLeft.toMinutes() % 60;
                            timerText = "Time left: " + hoursLeft + " hours " + minutesLeft + " minutes";
                        } else if (currentTime.isAfter(rentalEnd) && !"Completed".equals(rental.getRentalStatus())) {
                            rental.setRentalStatus("Overdue");
                            Duration overdue = Duration.between(rentalEnd, currentTime);
                            long overdueHours = overdue.toHours();
                            penalty = 2 + Math.max(0, overdueHours - 1); // RM2 immediate, RM1 per additional hour
                        }
            %>
            <tr>
                <td><%= rental.getId() %></td>
                <td><%= rental.getBicycleType() %></td>
                <td><%= rental.getTagNo() %></td>
                <td><%= rental.getRentalHours() %></td>
                <td><%= rental.getRentalDate() %></td>
                <td><%= rental.getRentalTime() %></td>
                <td><%= rental.getCreatedAt() %></td>
                <td><%= rental.getAmount() %></td>
                <td><%= rental.getPaymentDate() %></td>
                <td><%= rental.getRentalStatus() %></td>
                <td>
                    <% if ("Ongoing".equals(rental.getRentalStatus())) { %>
                        <%= timerText %>
                    <% } else if ("Overdue".equals(rental.getRentalStatus()) && rental.getPenalty() > 0) { %>
                        Penalty: RM <%= rental.getPenalty() %>
                    <% } else if ("Completed".equals(rental.getRentalStatus()) && rental.getPenalty() > 0) { %>
                        Penalty: RM <%= rental.getPenalty() %>
                    <% } else { %>
                        No Penalty
                    <% } %>
                </td>
                                <td>
                    <% if ("Ongoing".equals(rental.getRentalStatus()) || "Overdue".equals(rental.getRentalStatus())) { %>
                        <form action="ReturnRentalServlet" method="POST" onsubmit="return confirm('Are you sure you want to return the bicycle?');">
                            <input type="hidden" name="rentalId" value="<%= rental.getId() %>">
                            <button class="return-btn" type="submit">Return</button>
                        </form>
                    <% } else if ("Upcoming".equals(rental.getRentalStatus())) { %>
                        <form action="CancelRentalServlet" method="POST" onsubmit="return confirmCancel();">
                            <input type="hidden" name="rentalId" value="<%= rental.getId() %>">
                            <button class="cancel-btn" type="submit">Cancel</button>
                        </form>
                    <% } else { %>
                        <button class="return-btn-complete" disabled>Complete</button>
                    <% } %>
                </td>
            </tr>
            <% } } else { %>
            <tr>
                <td colspan="12" style="text-align: center;">No rentals found.</td>
            </tr>
            <% } %>
        </table>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
<script>
    // Confirmation popup for the cancel button
    function confirmCancel() {
        return confirm("Are you sure you want to cancel this rental?");
    }
</script>
</html>
