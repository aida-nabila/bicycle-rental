package process;

import db.dbconn;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.FileInputStream;
import java.io.IOException;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)

@WebServlet(name = "SubmitSupportServlet", urlPatterns = {"/SubmitSupportServlet"})
public class SubmitSupportServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads"; // Folder name inside webapps

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("user") : null;
        int userId = -1; // Default invalid user ID
        
        if (userEmail != null) {
            // Query the database to retrieve user_id based on the email
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

        // Fix parameter names
        String issueType = request.getParameter("issue_type"); // Matches JSP form
        String issueDescription = request.getParameter("issue_desc");

        // Set the real path for uploads directory
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create uploads directory if it doesn't exist
        }

        // Handle file upload
        String fileName = null;
        Part filePart = request.getPart("image"); // Matches JSP form input name
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            File file = new File(uploadPath, fileName);

            try (InputStream fileContent = filePart.getInputStream();
                 FileOutputStream fos = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }
            System.out.println("File uploaded successfully: " + file.getAbsolutePath());
        } else {
            System.out.println("No file uploaded.");
        }

        // Insert into database
        try (Connection conn = dbconn.getConnection()) {
            if (conn != null) {
                String sql = "INSERT INTO support_tickets (issue_type, user_id, issue_desc, image_path) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, issueType);  // Set issue type
                    stmt.setInt(2, userId);         // Set user_id as the second parameter
                    stmt.setString(3, issueDescription);  // Set issue description
                    stmt.setString(4, fileName != null ? UPLOAD_DIR + "/" + fileName : null);  // Set image path

                    stmt.executeUpdate();
                    System.out.println("Support ticket saved to database.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirect to JSP with success parameter
        response.sendRedirect("contactSupport.jsp?success=true");
    }
}
