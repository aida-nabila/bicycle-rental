<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bicycle Rental</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="styles.css" rel="stylesheet" type="text/css"/>
</head>
<body>

    <!-- Header -->
    <jsp:include page="header.jsp"/>

    <div class="home">

        <!-- Intro Section -->
        <div class="intro-section">
            <img src="img/Banner.png" alt="Bicycle Rental Banner">
            <div class="intro-box">
                <h1>Welcome to <br> Bicycle Rental</h1>
                <p>
                    Explore the easiest way to rent, ride, <br> 
                    and return bicycles while enjoying <br> 
                    flexible and affordable rentals.
                </p>

                <!-- Rent Now Button -->
                <div class="rent-container">
                    <a href="rent.jsp" class="rent-now">Rent Now</a>
                    <a href="icon/arrow-up-right-svgrepo-com.svg" class="arrow-icon">
                        <img src="icon/arrow-up-right-svgrepo-com.svg" alt="Arrow Icon">
                    </a>
                </div>
            </div>
        </div>

        <!-- How It Works Section -->
        <section class="section">
            <h2>How it works</h2>
            <div class="home-signup-container">
                <p>Create your account in just a few taps.</p>
                <a href="signup.jsp" class="signup-now"><b>Sign Up Quickly</b></a>
                <a href="icon/arrow-up-right-svgrepo-com-default.svg" class="arrow-icon">
                    <img src="icon/arrow-up-right-svgrepo-com-default.svg" alt="Arrow Icon">
                </a>
            </div>
        </section>

        <!-- Quote Section -->
        <section>
            <h1 class="quote">
                With us, you're not just renting a <br> 
                bike - you're joining a movement <br> 
                toward greener, healthier living!
            </h1>
        </section>

        <!-- Ride & Return Section -->
        <section class="section">
            <h2>Ride & Return Easily</h2>
            <p>Enjoy the ride and return at a designated station.</p>
        </section>

        <!-- How to Ride & Park Section -->
        <section class="section">
            <h2>How to Ride & Park?</h2>
            <p>
                Explore the easiest way to rent, ride, and return bicycles 
                while enjoying flexible and affordable rentals.
            </p>

            <div class="flex-container">
                <!-- How to Ride Box -->
                <div class="bordered-box">
                    <img src="img/bike.png" alt="How to Ride">
                    <h3>How to Ride</h3>
                    <p>Unlock the bike, wear a helmet, and start pedaling. Follow road rules and enjoy your ride!</p>
                </div>

                <!-- How to Park Box -->
                <div class="bordered-box">
                    <img src="img/map.png" alt="How to Park">
                    <h3>How to Park</h3>
                    <p>Park only in designated areas shown on the map. Make sure the bike is securely locked.</p>
                </div>
            </div>
        </section>

    </div>

</body>
</html>
