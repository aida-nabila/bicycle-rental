<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <a href="#home">Bicycle Rental</a>
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="rent.jsp">Rent</a></li>
                <li><a href="map.jsp">Map</a></li>
                <li><a href="signup.jsp"><button>Sign Up</button></a></li>
                <li><a href="login.jsp"><button>Log In</button></a></li>
            </ul>
        </nav>
    </body>
</html>