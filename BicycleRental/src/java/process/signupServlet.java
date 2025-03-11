package process;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import db.dbconn;
import java.util.logging.Level;
import java.util.logging.Logger;

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

        // Hash the password securely before storing it
        String hashedPassword = hashPassword(password);

        // Database insertion logic
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = dbconn.getConnection();
            if (conn != null) {
                String query = "INSERT INTO user (firstname, lastname, email, phone, password) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, hashedPassword); // Store the hashed password

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
            response.getWriter().println("<script>alert('An error occurred! Please try again.'); window.location = 'signup.jsp';</script>");
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(signupServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /**
     * Hashes a password using SHA-256 for security.
     * @param password The password to hash.
     * @return The hashed password in hexadecimal format.
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}
