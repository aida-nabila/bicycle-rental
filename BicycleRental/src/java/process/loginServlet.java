package process;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import db.dbconn;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "loginServlet", urlPatterns = {"/loginServlet"})
public class loginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean loginSuccess = false;

        try (Connection conn = dbconn.getConnection()) {
            String query = "SELECT password FROM user WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (password.equals(storedPassword)) {
                    loginSuccess = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (loginSuccess) {
            HttpSession session = request.getSession();
            session.setAttribute("user", email); // Store user email in session
            response.sendRedirect("rent.jsp");
        } else {
            response.getWriter().println("<script>alert('Invalid email or password!');</script>");
            response.getWriter().println("<script>window.location.href='login.jsp';</script>");
        }
    }
}
