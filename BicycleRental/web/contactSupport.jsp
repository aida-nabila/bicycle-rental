<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Support</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body class="contact-support-page">

    <!-- Header -->
    <jsp:include page="headerver3.jsp"/>

    <!-- Breadcrumb Navigation -->
    <div class="support-container">
        <div class="breadcrumb">
            <a href="support.jsp" class="support-title">Support</a>
            <img src="img/arrow.png" alt="Arrow Icon">
            <span class="faq-title">Contact Support</span>
        </div>
    </div>

    <!-- Page Title & Description -->
    <h1>What’s the issue?</h1>
    <p>Please provide details about your problem so we can assist you effectively.</p>

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
            <input type="file" id="image-upload" name="image" accept="image/*" hidden>
            <p>Add photos</p>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="contact-submit-btn">Submit</button>
    </form>

    <!-- Show Popup if Report is Submitted -->
    <% if ("true".equals(request.getParameter("success"))) { %>
        <script>
            alert("Report submitted\n\nYour report has been successfully submitted.");
            window.location.href = "contactSupport.jsp"; // Redirect to remove success param
        </script>
    <% } %>

</body>
</html>
