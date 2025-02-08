<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Support - FAQs</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css">
</head>
<body class="support-page">
<jsp:include page="headerver3.jsp"/>
    <!-- Support Header -->
    <div class="support-container">
        <div class="breadcrumb">
            <a href="support.jsp" class="support-title">Support</a>
            <img src="img/arrow.png" alt=">" /> 
            <span class="faq-title">FAQs</span>
        </div>
    </div>

    <!-- FAQ Sections -->
    <div class="support-container">
        <!-- FAQ 1 -->
        <div class="faq-section">
            <h3 class="faq-title">How do I rent a bicycle?</h3>
            <p class="faq-text">
                To rent a bicycle, follow these steps:<br>
                1. Sign up for an account through the rental system.<br>
                2. View a bicycle from the available options near your location.<br>
                3. Unlock the bicycle by registering for rental.<br>
                4. Begin your ride and enjoy!
            </p>
        </div>

        <!-- FAQ 2 -->
        <div class="faq-section">
            <h3 class="faq-title">What should I do if my bicycle breaks down?</h3>
            <p class="faq-text">
                If your bicycle breaks down:<br>
                1. Safely stop and assess the issue.<br>
                2. Contact support through the system.<br>
                3. Submit a report through Contact Support.
            </p>
        </div>

        <!-- FAQ 3 -->
        <div class="faq-section">
            <h3 class="faq-title">How do I return a bicycle?</h3>
            <p class="faq-text">
                Returning your bicycle is simple:<br>
                1. Locate the nearest approved return station or docking area.<br>
                2. Park the bicycle securely before the registered date & time of rental.<br>
                3. Check your Rental List: To return your bicycle, click the 'Return' button next to your rental. If the rental is overdue, a penalty of RM2 will be displayed, and an additional RM1 will be charged for each subsequent hour.<br>
                5. Once the bicycle is returned, your rental status will be updated as "Completed."
            </p>
        </div>
    </div>

</body>
</html>
