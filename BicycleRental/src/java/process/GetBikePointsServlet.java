package process;

import db.dbconn;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GetBikePointsServlet", urlPatterns = {"/GetBikePointsServlet"})
public class GetBikePointsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        ArrayList<String> bikePoints = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = dbconn.getConnection();
            String sql = "SELECT DISTINCT location FROM bicycle WHERE location IS NOT NULL ORDER BY CAST(SUBSTRING_INDEX(location, ' ', -1) AS UNSIGNED)";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                bikePoints.add(rs.getString("location"));
            }

            // Convert list to JSON manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < bikePoints.size(); i++) {
                json.append("\"").append(bikePoints.get(i)).append("\"");
                if (i < bikePoints.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
