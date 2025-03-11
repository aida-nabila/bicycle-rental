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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ReturnRentalServlet")
public class ReturnRentalServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rentalIdStr = request.getParameter("rentalId");
        String returnLocation = request.getParameter("returnLocation");
        String tagNo = request.getParameter("tagNo");

        // Check if rentalId is missing or empty
        if (rentalIdStr == null || rentalIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rental ID");
            return;
        }

        int rentalId = Integer.parseInt(rentalIdStr);

        Connection conn = null;
        PreparedStatement pstmtFetch = null;
        PreparedStatement pstmtUpdateRental = null;
        PreparedStatement pstmtUpdateBike = null;
        ResultSet rs = null;

        try {
            conn = dbconn.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Fetch rental details to determine if it's overdue
            String fetchSql = "SELECT rental_date, rental_time, rental_hours, bicycle_id FROM bicycle_rentals WHERE rental_id = ?";
            pstmtFetch = conn.prepareStatement(fetchSql);
            pstmtFetch.setInt(1, rentalId);
            rs = pstmtFetch.executeQuery();

            if (rs.next()) {
                LocalDateTime rentalEnd = LocalDateTime.parse(
                        rs.getString(1) + " " + rs.getString(2),
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                ).plusHours(rs.getInt(3));

                LocalDateTime currentTime = LocalDateTime.now();
                double penalty = 0;
                
                // Only apply RM2 penalty if the rental is overdue
                if (currentTime.isAfter(rentalEnd)) {
                    Duration overdueDuration = Duration.between(rentalEnd, currentTime);
                    long overdueHours = overdueDuration.toHours();
                    penalty = 2 + Math.max(0, overdueHours - 1); // RM2 initially, then RM1 per extra hour
                }
                
                // Update rental status
                String updateRentalSql = "UPDATE bicycle_rentals SET rental_status = 'Completed', penalty = ? WHERE rental_id = ?";
                pstmtUpdateRental = conn.prepareStatement(updateRentalSql);
                pstmtUpdateRental.setDouble(1, penalty);
                pstmtUpdateRental.setInt(2, rentalId);
                pstmtUpdateRental.executeUpdate();

                // Update bicycle location and status
                String updateBikeSql = "UPDATE bicycle SET location = ?, status = 'Available' WHERE tag_no = ?";
                pstmtUpdateBike = conn.prepareStatement(updateBikeSql);
                pstmtUpdateBike.setString(1, returnLocation);
                pstmtUpdateBike.setString(2, tagNo);
                pstmtUpdateBike.executeUpdate();
                
                conn.commit(); // Commit transaction immediately
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmtFetch != null) pstmtFetch.close();
                if (pstmtUpdateRental != null) pstmtUpdateRental.close();
                if (pstmtUpdateBike != null) pstmtUpdateBike.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("RentalServlet");
    }
}

