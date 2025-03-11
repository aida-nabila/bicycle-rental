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
                conn.setAutoCommit(true);
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
            try (Connection conn = dbconn.getConnection()) {
                conn.setAutoCommit(false);

                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT br.rental_id, br.bicycle_id, b.bicycle_type, b.tag_no, br.rental_hours, " +
                    "br.rental_date, br.rental_time, br.created_at, br.penalty, br.rental_status, " +
                    "p.amount, p.payment_date FROM bicycle_rentals br " +
                    "JOIN bicycle b ON br.bicycle_id = b.bicycle_id " +
                    "LEFT JOIN payments p ON br.rental_id = p.rental_id " +
                    "WHERE br.user_id = ?"
                );

                pstmt.setInt(1, userId);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    int rentalId = rs.getInt("rental_id");
                    int bicycleId = rs.getInt("bicycle_id");
                    String rentalStatus = rs.getString("rental_status");

                    String rentalDateTimeStr = rs.getString("rental_date") + " " + rs.getString("rental_time");
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    LocalDateTime rentalStart = LocalDateTime.parse(rentalDateTimeStr, formatter);
                    LocalDateTime rentalEnd = rentalStart.plusHours(rs.getInt("rental_hours"));
                    LocalDateTime currentTime = LocalDateTime.now();

                    double penalty = rs.getDouble("penalty");

                    // Always fetch the latest rental status from the database
                    String fetchUpdatedStatus = "SELECT rental_status FROM bicycle_rentals WHERE rental_id = ?";
                    try (PreparedStatement pstmtStatus = conn.prepareStatement(fetchUpdatedStatus)) {
                        pstmtStatus.setInt(1, rentalId);
                        try (ResultSet rsStatus = pstmtStatus.executeQuery()) {
                            if (rsStatus.next()) {
                                rentalStatus = rsStatus.getString("rental_status"); // Use the latest status
                            }
                        }
                    }
                    
                    if ("Upcoming".equals(rentalStatus) && currentTime.isAfter(rentalStart)) {
                        rentalStatus = "Ongoing";
                        updateRentalStatus(rentalId, "Ongoing", bicycleId, "In Use", conn);
                    }

                    if ("Overdue".equals(rentalStatus)) {
                        Duration overdueDuration = Duration.between(rentalEnd, currentTime);
                        long overdueHours = overdueDuration.toHours();
                        penalty = 2 + Math.max(0, overdueHours - 1);
                        updateRentalPenalty(rentalId, penalty, conn);
                    }

                    rentalList.add(new Rental(
                        rentalId,
                        rs.getString("bicycle_type"),
                        rs.getString("tag_no"),
                        rs.getInt("rental_hours"),
                        rs.getString("rental_date"),
                        rs.getString("rental_time"),
                        rs.getString("created_at"),
                        rs.getDouble("amount"),
                        rs.getString("payment_date") != null ? rs.getString("payment_date") : "N/A",
                        rentalStatus,
                        penalty
                    ));
                }

                conn.commit();

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("userEmail", userEmail);
        request.setAttribute("userId", userId);
        request.removeAttribute("rentalList"); // Ensure old data is removed
        request.setAttribute("rentalList", rentalList); // Fetch latest data

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        request.getRequestDispatcher("rental.jsp").forward(request, response);
    }

    // Update rental status & bicycle status
    private void updateRentalStatus(int rentalId, String rentalStatus, int bicycleId, String bicycleStatus, Connection conn) {
        try {
            conn.setAutoCommit(false); // Start transaction
        
            // Update rental status
            try (PreparedStatement pstmt = conn.prepareStatement("UPDATE bicycle_rentals SET rental_status = ? WHERE rental_id = ?")) {
                pstmt.setString(1, rentalStatus);
                pstmt.setInt(2, rentalId);
                pstmt.executeUpdate();
            }

            // Update bicycle status
            try (PreparedStatement pstmt = conn.prepareStatement("UPDATE bicycle SET status = ? WHERE bicycle_id = ?")) {
                pstmt.setString(1, bicycleStatus);
                pstmt.setInt(2, bicycleId);
                pstmt.executeUpdate();
            }
            
            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update penalty 
    private void updateRentalPenalty(int rentalId, double penalty, Connection conn) {
        try {
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
}
