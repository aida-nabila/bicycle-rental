<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bicycle Rental- Rental Registration</title>
        <link href="styles.css" rel="stylesheet" type="text/css"/>
        <script>
            // Function to update the tag numbers based on the selected bicycle type
            function updateTagNumbers() {
                var bicycleType = document.getElementById("bicycleType").value;
                var tagNo = document.getElementById("tagNo");
                tagNo.innerHTML = ""; // Clear previous options

                // Add the "Choose Tag Number" option back to the dropdown
                var defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.disabled = true;
                defaultOption.selected = true;
                defaultOption.text = "Choose Tag Number";
                tagNo.appendChild(defaultOption);

                var tagNumbers = [];
                var bicyclesInUse = <%= request.getAttribute("bicyclesInUse") != null ? request.getAttribute("bicyclesInUse") : "[]" %>;

                // Set tag numbers based on bicycle type
                if (bicycleType === "City Bike") {
                    tagNumbers = ["CB10001", "CB10002", "CB10003", "CB10004", "CB10005", "CB10006", "CB10007", "CB10008", "CB10009", "CB10010"];
                } else if (bicycleType === "Hybrid Bike") {
                    tagNumbers = ["HB20001", "HB20002", "HB20003", "HB20004", "HB20005", "HB20006", "HB20007", "HB20008", "HB20009", "HB20010"];
                } else if (bicycleType === "Electric Bike") {
                    tagNumbers = ["EB30001", "EB30002", "EB30003", "EB30004", "EB30005", "EB30006", "EB30007", "EB30008", "EB30009", "EB30010"];
                } else if (bicycleType === "Cruiser Bike") {
                    tagNumbers = ["CB40001", "CB40002", "CB40003", "CB40004", "CB40005", "CB40006", "CB40007", "CB40008", "CB40009", "CB40010"];
                } else if (bicycleType === "Folding Bike") {
                    tagNumbers = ["FB50001", "FB50002", "FB50003", "FB50004", "FB50005", "FB50006", "FB50007", "FB50008", "FB50009", "FB50010"];
                }

                // Populate the tag numbers dropdown, disabling options that are in use
                for (var i = 0; i < tagNumbers.length; i++) {
                    var option = document.createElement("option");
                    option.value = tagNumbers[i];
                    option.text = tagNumbers[i];

                    // Disable options that are in use
                    if (bicyclesInUse.includes(tagNumbers[i])) {
                        option.disabled = true;
                        option.style.backgroundColor = "#d3d3d3"; // Optional: Change background color to grey for disabled options
                    }

                    tagNo.appendChild(option);
                }
            }

            window.onload = function() {
                // Show error popup if errorMessage is set
                <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
                var errorMessage = "<%= errorMessage != null ? errorMessage : "" %>";
                if (errorMessage.trim() !== "") {
                    alert(errorMessage);
                }

                // Update tag numbers on page load if a bicycle type is already selected
                updateTagNumbers();
            };
        </script>
    </head>
    <body>
        <jsp:include page="headerver3.jsp"/>
        <h2 class="title">Rental Registration</h2>
        <form action="RentBicycleServlet" method="post">
            <div class="rental-container">

                <!-- Bicycle Type Section -->
                <div class="group">
                    <label for="bicycleType">Bicycle Type</label>
                    <div class="from-to-group">
                        <select id="bicycleType" name="bicycleType" required onchange="updateTagNumbers()">
                            <option value="" disabled selected>Choose Bicycle Type</option>
                            <option value="City Bike">City Bike</option>
                            <option value="Hybrid Bike">Hybrid Bike</option>
                            <option value="Electric Bike">Electric Bike</option>
                            <option value="Cruiser Bike">Cruiser Bike</option>
                            <option value="Folding Bike">Folding Bike</option>
                        </select>
                    </div>
                </div>

                <!-- Bicycle Tag Number -->
                <div class="group">
                    <label for="tagNo">Bicycle Tag No.</label>
                    <select id="tagNo" name="tagNo" required>
                        <!-- The default option "Choose Tag Number" will be added dynamically -->
                    </select>
                </div>

                <!-- Rental Hours -->
                <div class="group">
                    <label for="rentalHours">Rental Hours</label>
                    <input type="number" id="rentalHours" name="rentalHours" placeholder="Rental Hours" min="1" required>
                </div>

                <!-- Date of Rental -->
                <div class="group">
                    <label for="date">Date of Rental</label>
                    <input type="date" id="date" name="date" required>
                </div>

                <!-- Time of Rental -->
                <div class="group">
                    <label for="time">Time of Rental</label>
                    <input type="time" id="time" name="time" required>
                </div>
            </div>
            <!-- Submit Button -->
            <div class="rent-button-container">
                <button type="submit" class="rent-button"> Rent</button>
            </div>
        </form>   
        <jsp:include page="footer.jsp"/>
    </body>
</html>
