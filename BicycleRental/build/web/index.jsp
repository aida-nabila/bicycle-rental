<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Bicycle Rental</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="styles.css" rel="stylesheet" type="text/css"/>
        <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: white;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        h2 {
            background-color: #B6FF65;
            display: inline-block; /* Ensures background color only covers the text */
            padding: 2px 5px; /* Optional: adds a bit of space around the text */
        }
        
        .quote {
            background-color: #F3F3F3;
        }

        /* Intro Box */
        .intro-section {
            position: relative;
            width: 100%;
        }

        .intro-section img {
            width: 100%;
            height: auto;
        }

        .intro-box {
            position: absolute;
            top: 25%;
            left: 25%;
            transform: translateX(-50%);
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black background for readability */
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 10px;
            width: 600px;
            height: 350px;
        }

        .intro-box h1 {
            font-size: 48px;
            font-weight: bold;
            margin-left: 20px;
            margin-bottom: 20px;
            text-align: left; 
        }

        .intro-box p {
            font-size: 16px;
            margin-bottom: 20px;
            margin-left: 20px;
            text-align: left; 
        }

        /* Rent Now Button and SVG Container */
        .rent-container, .home-signup-container {
            display: flex;
            align-items: center;
            gap: 10px;  /* Space between the Rent Now/Sign Up button and the SVG */
        }
        
        .rent-now, .signup-now {
            margin-left: 20px;
            color: #B6FF65;
            text-decoration: none;
            transition: transform 0.3s ease;
        }
        
        .arrow-icon img {
            width: 20px;  /* Adjust the size of the SVG to match the button */
            height: 20px;
            pointer-events: none;
            transition: transform 0.3s ease;
        }

        /* Hover effect on Rent Now button and arrow together */
        .rent-container:hover .rent-now, .home-signup-container:hover .signup-now {
            transform: translateX(5px);  /* Move Rent Now/Sign Up button to the right */
        }

        .rent-container:hover .arrow-icon img, .home-signup-container:hover .arrow-icon img {
            transform: translateX(5px);  /* Move the arrow to the right */
        }
        
        /* Section Styling */
        .section {
            width: 100%;
            max-width: 900px;
            padding: 20px;
            text-align: center;
            margin-bottom: 40px;
        }

        .gray-background-small {
            background-color: #f1f1f1;
            padding: 15px;
            font-size: 1.5rem;
            font-weight: bold;
            margin-top: 40px;
        }

        /* Flex Container */
        .flex-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: space-between;
            padding: 20px 20px;
        }

        .bordered-box {
            background-color: #fff;
            border: 1px solid #ddd;
            padding: 25px;
            border-radius: 12px;
            width: 48%;
            text-align: center;
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .bordered-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .bordered-box img {
            width: 100%;
            max-width: 250px;
            border-radius: 10px;
        }

        .bordered-box h3 {
            margin-top: 15px;
            font-size: 1.6rem;
            color: #333;
        }

        .bordered-box p {
            margin-top: 10px;
            font-size: 1.1rem;
            color: #666;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .flex-container {
                flex-direction: column;
                align-items: center;
            }

            .bordered-box {
                width: 90%;
                margin-bottom: 20px;
            }

            .intro-box h1 {
                font-size: 2rem;
            }

            .intro-box p {
                font-size: 1.1rem;
            }
        }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp"/>

        <!-- Intro Section -->
        <div class="intro-section">
            <img src="img/Banner.png" alt=""/>
            <div class="intro-box">
                <h1>Welcome to <br> Bicycle Rental</h1>
                <p>Explore the easiest way to rent, ride, <br> and return bicycles while enjoying <br> flexible and affordable rentals.</p>

                <!-- Rent Now Button and SVG -->
                <div class="rent-container">
                    <a href="rent.jsp" class="rent-now" style="color: #B6FF65">Rent Now</a>
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
                <a href="signup.jsp" class="signup-now" style="color: black"><b>Sign Up Quickly</b></a>
                <a href="icon/arrow-up-right-svgrepo-com-default.svg" class="arrow-icon">
                    <img src="icon/arrow-up-right-svgrepo-com-default.svg" alt="Arrow Icon">
                </a>
                <p>Create your account in just a few taps.</p>
            </div>
        </section>
        
        <section>
            <h1 class="quote">With us, you're not just renting a <br> bike - you're joining a movement <br> toward greener, healthier living!</h1>
        </section>

        <!-- Ride & Return Section -->
        <section class="section">
            <h2>Ride & Return Easily</h2>
            <p>Enjoy the ride and return at a designated station.</p>
        </section>

        <!-- How to Ride & Park Section -->
        <section class="section">
            <h2>How to Ride & Park?</h2>
            <p>Explore the easiest way to rent, ride, and return bicycles while enjoying flexible and affordable rentals.</p>

            <div class="flex-container">
                <!-- How to Ride Box -->
                <div class="bordered-box">
                    <img src="bike.png" alt=""/>
                    <h3>How to Ride</h3>
                    <p>Unlock the bike, wear a helmet, and start pedaling. Follow road rules and enjoy your ride!</p>
                </div>
                <!-- How to Park Box -->
                <div class="bordered-box">
                    <img src="img/map.png" alt=""/>
                    <h3>How to Park</h3>
                    <p>Park only in designated areas shown on the map. Make sure the bike is securely locked.</p>
                </div>
            </div>
        </section>
    </body>
</html>
