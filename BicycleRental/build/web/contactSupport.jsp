<%-- 
    Document   : contactSupport
    Created on : 29 Jan 2025, 4:32:05 am
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Support</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to existing CSS -->
</head>
<body class="contact-support-page">
<jsp:include page="headerver3.jsp"/>
    <!-- Breadcrumb Navigation (Using existing styles) -->
    <div class="support-container">
        <div class="breadcrumb">
            <a href="support.jsp" class="support-title">Support</a>
            <img src="img/arrow.png" alt=">" /> 
            <span class="faq-title">Contact Support</span>
        </div>
    </div>

    <!-- Page Title -->
    <h1 class="contact-heading">What’s the issue?</h1>
    <p class="contact-description">
        Please provide details about your problem so we can assist you effectively.
    </p>

    <!-- Support Form -->
    <form class="contact-support-form" action="SubmitSupportServlet" method="POST" enctype="multipart/form-data">
        
        <!-- Issue Type Dropdown -->
        <select name="issue_type" class="contact-issue-type" required>
            <option value="" disabled selected>Select an issue type</option>
            <option value="Payment Issue">Payment Issue</option>
            <option value="Bike Malfunction">Bike Malfunction</option>
            <option value="Account Problem">Account Problem</option>
            <option value="Rental Problem">Rental Problem</option>
            <option value="Other">Other</option>
        </select>

        <!-- Issue Description -->
        <textarea name="issue_desc" class="contact-issue-desc" placeholder="Explain your issue" required></textarea>

        <!-- Image Upload -->
        <div class="contact-upload-container">
            <label for="image-upload" class="contact-upload-box">
                <span>+</span>
            </label>
            <input type="file" id="image-upload" name="image" accept="image/*" style="display: none;">
            <p class="contact-upload-text">Add photos</p>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="contact-submit-btn">Submit</button>
    </form>

    <!-- Show Popup if Report is Submitted -->
    <%
        String success = request.getParameter("success");
        if ("true".equals(success)) {
    %>
        <script>
            alert("Report submitted\n\nYour report has been successfully submitted.");
            window.location.href = "contactSupport.jsp"; // Redirect to remove success param
        </script>
    <%
        }
    %>

</body>
</html>