<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <!-- Header -->
    <jsp:include page="headerver3.jsp"/>

    <div class="support-container">
        <h1 class="support-title">Support</h1>
        <p class="support-description">
            Need help with your bicycle rental? Find answers to common questions below or contact us for further assistance.
        </p>

        <!-- FAQs Section -->
        <h2 class="faq-title">FAQs</h2>
        <p>FAQs to get you started</p>

        <div class="faq-container">
            <a href="faq.jsp" class="faq-box">
                <h3 class="faq-heading">How do I rent a bicycle?</h3>
                <p class="faq-text">Step-by-step instructions on renting a bicycle, from signing up to choosing your ride.</p>
            </a>
            <a href="faq.jsp" class="faq-box">
                <h3 class="faq-heading">What should I do if my bicycle breaks down?</h3>
                <p class="faq-text">Guidelines on handling breakdowns, including contacting support.</p>
            </a>
            <a href="faq.jsp" class="faq-box">
                <h3 class="faq-heading">How do I return a bicycle?</h3>
                <p class="faq-text">Information on returning your rental, including locations and time limits.</p>
            </a>
        </div>

        <!-- Contact Support Section -->
        <h2 class="help-title">Need More Help?</h2>
        <p>Send us a message and we will find the best way to support you.</p>

        <a href="contactSupport.jsp" class="contact-support">
            <div class="contact-box">
                <div class="contact-inner-box">
                    <img src="img/chat-icon.png" alt="Chat Icon">
                    <p class="contact-text">Contact Support</p>
                    <img src="img/arrow-icon.png" alt="Arrow Icon" class="contact-arrow">
                </div>
            </div>
        </a>
    </div>

</body>
</html>
