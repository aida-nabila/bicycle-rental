package process;

import db.dbconn;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/processPaymentServlet")
public class processPaymentServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Retrieve parameters from form
        String cardHolderName = request.getParameter("cardHolderName");
        String cardNumber = request.getParameter("cardNumber").replaceAll("\\s", ""); 
        String expiryMonth = request.getParameter("expiryMonth");
        String expiryYear = request.getParameter("expiryYear");
        String cvv = request.getParameter("cvv");
        String cost = request.getParameter("cost");
        String rentalId = request.getParameter("rentalId");  // Retrieve rental_id
        
        // Validate inputs (Basic Checks)
        if (cardNumber == null || cardNumber.length() != 16 || !cardNumber.matches("\\d+")) {
            response.sendRedirect("payment.jsp?status=error");
            return;
        }
        if (cvv == null || cvv.length() != 3 || !cvv.matches("\\d+")) {
            response.sendRedirect("payment.jsp?status=error");
            return;
        }
        
        // Database Insertion
        try (Connection conn = dbconn.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO payments (card_holder_name, card_number, expiry_month, expiry_year, cvv, amount, payment_date, rental_id) VALUES (?, ?, ?, ?, ?, ?, NOW(), ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, cardHolderName);
                    stmt.setString(2, cardNumber);
                    stmt.setInt(3, Integer.parseInt(expiryMonth));
                    stmt.setInt(4, Integer.parseInt(expiryYear));
                    stmt.setInt(5, Integer.parseInt(cvv));
                    stmt.setDouble(6, Double.parseDouble(cost));
                    stmt.setInt(7, Integer.parseInt(rentalId));  // Insert rental_id into payments table
                    
                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        response.sendRedirect("payment.jsp?status=success");
                    } else {
                        response.sendRedirect("payment.jsp?status=error");
                    }
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("payment.jsp?status=error");
        }
    }
}
