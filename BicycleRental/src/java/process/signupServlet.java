/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package process;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import db.dbconn;
/**
 *
 * @author User
 */
@WebServlet(name = "signupServlet", urlPatterns = {"/signupServlet"})
public class signupServlet extends HttpServlet {

       private static final long serialVersionUID = 1L;

       @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form data from the request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate if passwords match
        if (!password.equals(confirmPassword)) {
            response.getWriter().println("<script>alert('Passwords do not match!'); window.location = 'signup.jsp';</script>");
            return;
        }

        // Database insertion logic
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Get database connection from dbconn
            conn = dbconn.getConnection();

            if (conn != null) {
                String query = "INSERT INTO user (firstname, lastname, email, phone, password) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, password);

                int rowsInserted = pstmt.executeUpdate();

                if (rowsInserted > 0) {
                    response.getWriter().println("<script>alert('Sign-up successful!'); window.location = 'login.jsp';</script>");
                } else {
                    response.getWriter().println("<script>alert('Sign-up failed! Please try again.'); window.location = 'signup.jsp';</script>");
                }
            } else {
                response.getWriter().println("<script>alert('Database connection failed!'); window.location = 'signup.jsp';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('An error occurred! Please try again.'); window.location = 'signup.jsp';</script>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}