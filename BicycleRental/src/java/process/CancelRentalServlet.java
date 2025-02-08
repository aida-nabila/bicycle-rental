/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package process;

import db.dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ai
 */
@WebServlet("/CancelRentalServlet")
public class CancelRentalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int rentalId = Integer.parseInt(request.getParameter("rentalId"));
        
        try (Connection conn = dbconn.getConnection()) {
            // First, delete the payment record from the payments table
            String deletePaymentSql = "DELETE FROM payments WHERE rental_id = ?";
            try (PreparedStatement psDeletePayment = conn.prepareStatement(deletePaymentSql)) {
                psDeletePayment.setInt(1, rentalId);
                int paymentRowsAffected = psDeletePayment.executeUpdate();
                
                if (paymentRowsAffected > 0) {
                    // Now, delete the rental record from the bicycle_rentals table
                    String deleteRentalSql = "DELETE FROM bicycle_rentals WHERE rental_id = ?";
                    try (PreparedStatement psDeleteRental = conn.prepareStatement(deleteRentalSql)) {
                        psDeleteRental.setInt(1, rentalId);
                        int rentalRowsAffected = psDeleteRental.executeUpdate();
                        
                        if (rentalRowsAffected > 0) {
                            // Redirect to the rental list page or show success message
                            response.sendRedirect("RentalServlet");
                        } else {
                            response.getWriter().println("Error: Rental not found.");
                        }
                    }
                } else {
                    response.getWriter().println("Error: Payment record not found.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}

