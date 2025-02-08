package process;

import db.dbconn;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RentalServlet")
public class RentalServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("user") : null;
        int userId = -1;
        List<Rental> rentalList = new ArrayList<>();

        if (userEmail != null) {
            try (Connection conn = dbconn.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("SELECT user_id FROM user WHERE email = ?")) {
                pstmt.setString(1, userEmail);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("user_id");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (userId > 0) {
            try (Connection conn = dbconn.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                "SELECT br.rental_id, br.bicycle_id, b.bicycle_type, b.tag_no, br.rental_hours, br.rental_date, br.rental_time, " +
                "br.created_at, br.penalty, br.rental_status, p.amount, p.payment_date " +
                "FROM bicycle_rentals br " +
                "JOIN bicycle b ON br.bicycle_id = b.bicycle_id " +
                "LEFT JOIN payments p ON br.rental_id = p.rental_id " +
                "WHERE br.user_id = ?")) {

                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        int rentalId = rs.getInt("rental_id");
                        int bicycleId = rs.getInt("bicycle_id");
                        String rentalDate = rs.getString("rental_date");
                        String rentalTime = rs.getString("rental_time");
                        String rentalStatus = rs.getString("rental_status");

                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                        LocalDateTime rentalStartDateTime = LocalDateTime.parse(rentalDate + " " + rentalTime, formatter);
                        LocalDateTime rentalEndDateTime = rentalStartDateTime.plusHours(rs.getInt("rental_hours"));
                        LocalDateTime currentTime = LocalDateTime.now();

                        double penalty = 0;

                        // Calculate penalty for overdue rental
                        if (currentTime.isAfter(rentalEndDateTime) && !"Completed".equals(rentalStatus)) {
                            // Calculate overdue hours
                            Duration overdueDuration = Duration.between(rentalEndDateTime, currentTime);
                            long overdueHours = overdueDuration.toHours();
                            penalty = 2 + Math.max(0, overdueHours - 1); // RM2 immediately, RM1 per additional hour

                            // Update penalty in the database
                            updateRentalPenalty(rentalId, penalty);

                            rentalStatus = "Overdue"; // Update status to Overdue
                        }

                        rentalList.add(new Rental(
                                rentalId,
                                rs.getString("bicycle_type"),
                                rs.getString("tag_no"),
                                rs.getInt("rental_hours"),
                                rentalDate,
                                rentalTime,
                                rs.getString("created_at"),
                                rs.getDouble("amount"),
                                rs.getString("payment_date") != null ? rs.getString("payment_date") : "N/A",
                                rentalStatus,
                                rs.getDouble("penalty")
                        ));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("userEmail", userEmail);
        request.setAttribute("userId", userId);
        request.setAttribute("rentalList", rentalList);
        request.getRequestDispatcher("rental.jsp").forward(request, response);
    }
    
        // Method to update penalty in the database
    private void updateRentalPenalty(int rentalId, double penalty) {
        try (Connection conn = dbconn.getConnection()) {
            String updatePenaltySql = "UPDATE bicycle_rentals SET penalty = ? WHERE rental_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updatePenaltySql)) {
                ps.setDouble(1, penalty);
                ps.setInt(2, rentalId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateRentalStatus(int rentalId, String rentalStatus, int bicycleId, String bicycleStatus) {
        try (Connection conn = dbconn.getConnection()) {
            // Update rental status in bicycle_rentals
            try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE bicycle_rentals SET rental_status = ? WHERE rental_id = ?")) {
                pstmt.setString(1, rentalStatus);
                pstmt.setInt(2, rentalId);
                pstmt.executeUpdate();
            }

            // Update bicycle status in bicycle table
            try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE bicycle SET status = ? WHERE bicycle_id = ?")) {
                pstmt.setString(1, bicycleStatus);
                pstmt.setInt(2, bicycleId);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
