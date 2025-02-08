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
        int rentalId = Integer.parseInt(request.getParameter("rentalId"));

        Connection conn = null;
        PreparedStatement pstmtFetch = null;
        PreparedStatement pstmtUpdate = null;
        ResultSet rs = null;

        try {
            conn = dbconn.getConnection();
            String fetchSql = "SELECT rental_date, rental_time, rental_hours, bicycle_id FROM bicycle_rentals WHERE rental_id = ?";
            pstmtFetch = conn.prepareStatement(fetchSql);
            pstmtFetch.setInt(1, rentalId);
            rs = pstmtFetch.executeQuery();

            if (rs.next()) {
                LocalDateTime rentalEnd = LocalDateTime.parse(rs.getString(1) + " " + rs.getString(2), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).plusHours(rs.getInt(3));
                double penalty = Math.max(0, Duration.between(rentalEnd, LocalDateTime.now()).toHours() - 1) + 2;

                String updateSql = "UPDATE bicycle_rentals SET rental_status = 'Completed', penalty = ? WHERE rental_id = ?";
                pstmtUpdate = conn.prepareStatement(updateSql);
                pstmtUpdate.setDouble(1, penalty);
                pstmtUpdate.setInt(2, rentalId);
                pstmtUpdate.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Close resources manually
            try {
                if (rs != null) rs.close();
                if (pstmtFetch != null) pstmtFetch.close();
                if (pstmtUpdate != null) pstmtUpdate.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("RentalServlet");
    }
}
