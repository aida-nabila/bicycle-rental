/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;

/**
 *
 * @author User
 */
@WebServlet(name = "UpdateDetailsServlet", urlPatterns = {"/UpdateDetailsServlet"})
public class UpdateDetailsServlet extends HttpServlet {
 private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); // Redirect if user is not logged in
            return;
        }

        // Retrieve email from session
        String userEmail = (String) session.getAttribute("user");

        // Retrieve updated name and contact
        String updatedName = request.getParameter("name");
        String updatedContact = request.getParameter("contact");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = dbconn.getConnection();
            String sql = "UPDATE user SET firstname = ?, phone = ? WHERE email = ?";
            pstmt = conn.prepareStatement(sql);

            // Split full name into first name and last name
            String[] nameParts = updatedName.split(" ", 2);
            String firstName = nameParts[0]; 
            String lastName = (nameParts.length > 1) ? nameParts[1] : "";

            pstmt.setString(1, firstName);
            pstmt.setString(2, updatedContact);
            pstmt.setString(3, userEmail);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Update session attributes
                session.setAttribute("name", updatedName);
                session.setAttribute("contact", updatedContact);

                request.setAttribute("successMessage", "Details updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Update failed! No changes made.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "SQL error: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        // Retrieve other rental details from request
        String rentalId = request.getParameter("rentalId");
        String bicycleType = request.getParameter("bicycleType");
        String tagNo = request.getParameter("tagNo");
        String rentalHours = request.getParameter("rentalHours");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        // Fixed rate per hour
        double ratePerHour = 10.00;

        // Calculate total cost
        double totalCost = (rentalHours != null && !rentalHours.isEmpty()) ? Integer.parseInt(rentalHours) * ratePerHour : 0;

        // Pass all attributes to confirmation.jsp.Jsp
        request.setAttribute("rentalId", rentalId);
        request.setAttribute("name", updatedName);
        request.setAttribute("contact", updatedContact);
        request.setAttribute("bicycleType", bicycleType);
        request.setAttribute("tagNo", tagNo);
        request.setAttribute("rentalHours", rentalHours);
        request.setAttribute("date", date);
        request.setAttribute("time", time);
        request.setAttribute("rate", ratePerHour);
        request.setAttribute("cost", totalCost);

        // Forward to confirmation.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("confirmation.jsp");
        dispatcher.forward(request, response);
    }
}