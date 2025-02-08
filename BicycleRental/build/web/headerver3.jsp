<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Retrieve session and check if user is logged in
    HttpSession sessionObj = request.getSession(false);
    String userEmail = (sessionObj != null) ? (String) sessionObj.getAttribute("user") : null;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bicycle Rental</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>/* Logo Styling */
        .navbar .logo a {
            text-decoration: none;
            font-family: 'Roboto Mono', monospace !important; /* Force Roboto Mono font */
            font-size: 36px;
            font-weight: bold;
            color: white;
        }
        </style>
    </head>
    <body>
        <nav class="navbar">
            <div class="logo">
                <a href="index.jsp">Bicycle Rental</a>
            </div>
            <ul class="nav-links">
                <li><a href="rent.jsp">Rent</a></li>
                <li><a href="map.jsp">Map</a></li>
                <li><a href="support.jsp">Support</a></li>
                <li><a href="RentalServlet">Rental</a></li>

                <% if (userEmail != null) { %>
                    <li><span class="welcome-text">Welcome, <%= userEmail %>!</span></li>
                    <li><a href="logoutServlet"><button>Log Out</button></a></li>
                <% } else { %>
                    <li><a href="signup.jsp"><button>Sign Up</button></a></li>
                    <li><a href="login.jsp"><button>Log In</button></a></li>
                <% } %>
            </ul>
        </nav>
    </body>
</html>
