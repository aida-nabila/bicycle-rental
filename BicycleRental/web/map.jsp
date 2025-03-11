<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*" %>
<%@page import="db.dbconn"%>
<%
    // Retrieve the session (don't create a new one if it doesn't exist)
    HttpSession sessionObj = request.getSession(false);
    String userEmail = null;
    Integer userId = null;

    // Check if session exists
    if (sessionObj != null) {
        // Retrieve session attributes
        userEmail = (String) sessionObj.getAttribute("user");
        userId = (Integer) sessionObj.getAttribute("userId");
    }
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // Create a JSON-like structure to hold available bicycles by location
    Map<String, List<String>> bikeAvailabilityMap = new HashMap<String, List<String>>();

    try {
        conn = dbconn.getConnection(); // Get database connection
        
        // SQL query to fetch available bicycles grouped by location
        String query = "SELECT tag_no, bicycle_type, location FROM bicycle WHERE status = 'Available' ORDER BY location";
        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            String location = rs.getString("location");
            String bikeInfo = rs.getString("bicycle_type") + " (" + rs.getString("tag_no") + ")";
            
            // Add to map (if ket exists, append the bike, otherwise create a new list)
            if (!bikeAvailabilityMap.containsKey(location)) {
                bikeAvailabilityMap.put(location, new ArrayList<String>());
            }
            bikeAvailabilityMap.get(location).add(bikeInfo);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bicycle Rental</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="carousel.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>

<body>
    <% if (userEmail != null) { %>
        <!-- User is logged in, include the logged-in header -->
        <jsp:include page="headerver3.jsp"/>
    <% } else { %>
        <!-- User is not logged in, include the default header -->
        <jsp:include page="header.jsp"/>
    <% } %>

    <!-- Heatmap Toggle Button (Now on the right) -->
    <div class="map-controls">
        <button onclick="toggleHeatmap()">Toggle Heatmap</button>
    </div>

    <!-- Map Container -->
    <div id="map"></div>

    <jsp:include page="footer.jsp"/>
    <script>
        // Store available bicycles in a JavaScript object
        var bikeAvailability = {
            <% for (Map.Entry<String, List<String>> entry : bikeAvailabilityMap.entrySet()) { %>
                "<%= entry.getKey() %>": "<%= String.join(", ", entry.getValue()) %>",
            <% } %>
        };
    </script>
    <script>
        function initMap() {
            var center = { lat: 3.1526, lng: 101.7031 }; // Central KL near KLCC

            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 14,
                center: center
            });
            
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var userLat = position.coords.latitude;
                    var userLng = position.coords.longitude;

                    // Center the map on the user's location
                    var userLocation = { lat: userLat, lng: userLng };
                    map.setCenter(userLocation);

                    // Add a marker at the user's location
                    var userMarker = new google.maps.Marker({
                        position: userLocation,
                        map: map,
                        title: "Your Location"
                    });

                    // Optional: Show the user's coordinates in the console
                    console.log("User's Location: Latitude: " + userLat + " Longitude: " + userLng);
                }, function() {
                    // Handle error if geolocation fails
                    console.error("Error: The Geolocation service failed.");
                });
            } else {
                // Handle error if geolocation is not supported
                console.error("Error: Geolocation is not supported by this browser.");
            }

            var geocoder = new google.maps.Geocoder(); // Initialize Geocoder

            var locations = [
                { lat: 3.1555, lng: 101.7102, weight: 5, name: "Bike Station 1" },
                { lat: 3.1538, lng: 101.7051, weight: 3, name: "Bike Station 2" },
                { lat: 3.1502, lng: 101.7043, weight: 4, name: "Bike Station 3" },
                { lat: 3.1495, lng: 101.7098, weight: 2, name: "Bike Station 4" },
                { lat: 3.1510, lng: 101.7036, weight: 5, name: "Bike Station 5" },
                { lat: 3.1564, lng: 101.7012, weight: 1, name: "Bike Station 6" },
                { lat: 3.1527, lng: 101.7009, weight: 4, name: "Bike Station 7" },
                { lat: 3.1548, lng: 101.6981, weight: 3, name: "Bike Station 8" },
                { lat: 3.1589, lng: 101.7053, weight: 5, name: "Bike Station 9" },
                { lat: 3.1487, lng: 101.7062, weight: 1, name: "Bike Station 10" },
                { lat: 3.1533, lng: 101.7091, weight: 4, name: "Bike Station 11" },
                { lat: 3.1560, lng: 101.7040, weight: 3, name: "Bike Station 12" },
                { lat: 3.1518, lng: 101.7022, weight: 1, name: "Bike Station 13" },
                { lat: 3.1551, lng: 101.6995, weight: 4, name: "Bike Station 14" },
                { lat: 3.1573, lng: 101.7074, weight: 3, name: "Bike Station 15" },
                { lat: 3.1532, lng: 101.7030, weight: 5, name: "Bike Station 16" },
                { lat: 3.1490, lng: 101.7017, weight: 2, name: "Bike Station 17" },
                { lat: 3.1508, lng: 101.7079, weight: 3, name: "Bike Station 18" },
                { lat: 3.1570, lng: 101.7029, weight: 4, name: "Bike Station 19" },
                { lat: 3.1542, lng: 101.7088, weight: 5, name: "Bike Station 20" }
            ];

            let markers = [];
            let heatmapData = [];

            locations.forEach(function(location) {
                var marker = new google.maps.Marker({
                    position: { lat: location.lat, lng: location.lng },
                    map: map,
                    title: location.name,
                    icon: { url: "img/parking.png", scaledSize: new google.maps.Size(40, 40) }
                });

                marker.addListener("click", function() {
                    // Use Google's Geocoder API
                    geocoder.geocode({ location: { lat: location.lat, lng: location.lng } }, function(results, status) {
                        let address = "Address not available"; // Default message if Geocoder fails

                        if (status === "OK" && results.length > 0) {
                            address = results[1].formatted_address; // Use the second address result
                        }
                        
                        // Get available bicycles for this bike station
                        let availableBikes = bikeAvailability[location.name] || "No bicycles available";

                        // Close any existing InfoWindow before creating a new one
                        if (typeof infoWindow !== "undefined" && infoWindow !== null) {
                            infoWindow.close();
                        }

                        // Create and open InfoWindow dynamically with improved design
                        var infoWindow = new google.maps.InfoWindow({
                            content: "<div class='info-window-container'>" +
                                     "<h5 class='info-title'>" + location.name + "</h5>" +
                                     "<hr class='info-separator'>" +
                                     "<p class='info-text'><b>🚲 Available Bicycles:</b> <i>" + availableBikes + "</i></p>" + 
                                     "<p class='info-text'><b>📍 Address:</b> <i>" + address + "</i></p>" + 
                                     "<p class='info-text'><b>🌍 Coordinates:</b> Latitude: " + location.lat + ", Longitude: " + location.lng + "</p>" +
                                     "</div>"
                        });

                        // Adding custom styles for the InfoWindow
                        var style = document.createElement('style');
                        style.innerHTML = `
                            .info-window-container {
                                font-family: 'Arial', sans-serif;
                                color: #333;
                                text-align: center;
                                padding: 15px;
                                min-width: 250px;
                                background-color: #f9f9f9;
                                border-radius: 8px;
                                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            }

                            .info-title {
                                font-size: 16px;
                                margin: 0;
                                color: #007BFF;
                                font-weight: bold;
                            }

                            .info-subtitle {
                                font-size: 13px;
                                color: #777;
                                margin: 5px 0 12px;
                            }

                            .info-separator {
                                border: 0;
                                height: 1px;
                                background-color: #ddd;
                                margin: 12px 0;
                            }

                            .info-text {
                                font-size: 12px;
                                color: #555;
                                margin: 5px 0;
                                text-align: left;
                            }

                            .info-text b {
                                color: #333;
                            }

                            .info-text i {
                                font-style: italic;
                                color: #666;
                            }
                        `;
                        document.head.appendChild(style);

                        // Display the InfoWindow
                        infoWindow.open(map, marker);
                    });
                });

                markers.push(marker);

                  if (location.weight > 0) {
                      heatmapData.push({
                          location: new google.maps.LatLng(location.lat, location.lng),
                          weight: location.weight
                      });
                  }
              });

                // Heatmap Layer with Color Variation (Red for high activity, Blue for lower)
                heatmap = new google.maps.visualization.HeatmapLayer({
                    data: heatmapData,
                    dissipating: true,
                    radius: 50,
                    opacity: 0.7,
                    gradient: [
                        "rgba(0, 0, 255, 0)", // Transparent Blue (low activity)
                        "rgba(0, 0, 255, 1)", // Blue
                        "rgba(0, 255, 0, 1)", // Green
                        "rgba(255, 255, 0, 1)", // Yellow
                        "rgba(255, 0, 0, 1)" // Red (high activity)
                    ]
                });

                heatmap.setMap(map);
            }

        // Toggle Heatmap Function
        function toggleHeatmap() {
            if (heatmap) {
                heatmap.setMap(heatmap.getMap() ? null : map);
            }
        }
    </script>

    <!-- Google Maps API with Heatmap -->
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyALFnm0aAgAEbH5uSPnSC27myAE_xoEPdE&libraries=visualization&callback=initMap"></script>

    <div style="
        position: fixed;
        bottom: 50px;
        left: 20px;
        background: rgba(255, 255, 255, 0.9);
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.3);
        font-size: 14px;
        z-index: 1000;
    ">
    <b>Navigation Guide:</b><br>
    <img src="img/parking.png" alt="Parking Icon" style="width: 20px; height: 20px; vertical-align: middle;">
    Indicates <b>Bike</b> locations<br>
</div>    
</body>
</html>
