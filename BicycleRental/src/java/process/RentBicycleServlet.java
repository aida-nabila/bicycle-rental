package process;

import db.dbconn;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "RentBicycleServlet", urlPatterns = {"/RentBicycleServlet"})
public class RentBicycleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve rental details from the form
        String bicycleType = request.getParameter("bicycleType");
        String tagNo = request.getParameter("tagNo");
        String rentalHoursStr = request.getParameter("rentalHours");
        String rentalDate = request.getParameter("date");
        String rentalTime = request.getParameter("time");
        
        String errorMessage = "";

        // Date validation
        try {
            LocalDate today = LocalDate.now(); // Current date
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate rentalLocalDate = LocalDate.parse(rentalDate, formatter);

            if (rentalLocalDate.isBefore(today)) {
                errorMessage = "The rental date cannot be in the past.";
                request.setAttribute("errorMessage", errorMessage);
                RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
                dispatcher.forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Error processing the date. Please try again.";
            request.setAttribute("errorMessage", errorMessage);
            RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Rental Hours validation
        int rentalHours;
        try {
            rentalHours = Integer.parseInt(rentalHoursStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid rental hours! Please enter a valid number.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
            dispatcher.forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("user") : null;
        String name = "";
        String contact = "";
        int bicycleId = -1;

        if (userEmail != null) {
            try (Connection conn = dbconn.getConnection()) {
                String sql = "SELECT user_id, firstname, phone FROM user WHERE email = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userEmail);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    name = rs.getString("firstname");
                    contact = rs.getString("phone");
                    int userId = rs.getInt("user_id");

                    // Get the bicycle_id based on the tag_no
                    String bicycleSql = "SELECT bicycle_id FROM bicycle WHERE tag_no = ?";
                    PreparedStatement bicyclePstmt = conn.prepareStatement(bicycleSql);
                    bicyclePstmt.setString(1, tagNo);
                    ResultSet bicycleRs = bicyclePstmt.executeQuery();

                    if (bicycleRs.next()) {
                        bicycleId = bicycleRs.getInt("bicycle_id");
                    } else {
                        errorMessage = "Bicycle with the provided tag number not found.";
                        request.setAttribute("errorMessage", errorMessage);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }

                    // Check if the bicycle is in use (Before proceeding with the rental)
                    String bicycleStatusSql = "SELECT br.rental_status, b.status " +
                                               "FROM bicycle b INNER JOIN bicycle_rentals br ON b.bicycle_id = br.bicycle_id " +
                                               "WHERE br.rental_status = 'Ongoing' AND b.status = 'In Use' AND br.bicycle_id = ?";
                    PreparedStatement bicycleStatusPstmt = conn.prepareStatement(bicycleStatusSql);
                    bicycleStatusPstmt.setInt(1, bicycleId);
                    ResultSet statusRs = bicycleStatusPstmt.executeQuery();

                    boolean isBicycleInUse = false;
                    if (statusRs.next()) {
                        isBicycleInUse = true;
                    }

                    // If bicycle is in use, show the error message and stop further processing
                    if (isBicycleInUse) {
                        request.setAttribute("errorMessage", "This bicycle is currently in use and cannot be rented.");
                        request.setAttribute("isBicycleInUse", true); // Set attribute for JSP
                        RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }

                    // Proceed with inserting rental details into the database
                    String insertSql = "INSERT INTO bicycle_rentals (bicycle_id, rental_hours, rental_date, rental_time, user_id, rental_status, penalty) VALUES (?, ?, ?, ?, ?, 'Upcoming', 0)";
                    PreparedStatement insertPstmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);

                    insertPstmt.setInt(1, bicycleId);
                    insertPstmt.setInt(2, rentalHours);
                    insertPstmt.setString(3, rentalDate);
                    insertPstmt.setString(4, rentalTime);
                    insertPstmt.setInt(5, userId);

                    int rowsInserted = insertPstmt.executeUpdate();

                    if (rowsInserted > 0) {
                        // Retrieve the generated rental_id
                        try (ResultSet generatedKeys = insertPstmt.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                int rentalId = generatedKeys.getInt(1);
                                request.setAttribute("rentalId", rentalId);
                            }
                        }

                        // Forward to summary.jsp
                        request.setAttribute("name", name);
                        request.setAttribute("contact", contact);
                        request.setAttribute("bicycleType", bicycleType);
                        request.setAttribute("tagNo", tagNo);
                        request.setAttribute("rentalHours", rentalHours);
                        request.setAttribute("date", rentalDate);
                        request.setAttribute("time", rentalTime);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("summary.jsp");
                        dispatcher.forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Database error! Please try again.");
                        RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
                        dispatcher.forward(request, response);
                    }
                    insertPstmt.close();
                    bicyclePstmt.close();
                } else {
                    request.setAttribute("errorMessage", "User not found. Please log in again.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                    dispatcher.forward(request, response);
                }
                rs.close();
                pstmt.close();

                // Query for bicycles in use
                String bicycleInUseSql = "SELECT tag_no FROM bicycle b INNER JOIN bicycle_rentals br ON b.bicycle_id = br.bicycle_id WHERE br.rental_status = 'Ongoing' AND b.status = 'In Use'";
                PreparedStatement bicycleInUsePstmt = conn.prepareStatement(bicycleInUseSql);
                ResultSet bicycleInUseRs = bicycleInUsePstmt.executeQuery();

                Set<String> bicyclesInUse = new HashSet<>();
                while (bicycleInUseRs.next()) {
                    bicyclesInUse.add(bicycleInUseRs.getString("tag_no"));
                }

                // Pass the list of bicycles in use to the JSP
                request.setAttribute("bicyclesInUse", bicyclesInUse);

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "SQL error: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("rent.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Session expired! Please log in again.");
            response.sendRedirect("login.jsp");
        }
    }
}
