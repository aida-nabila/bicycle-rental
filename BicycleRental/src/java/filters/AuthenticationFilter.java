package filters;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Apply this filter to specific paths
// @WebFilter({"/searchflight.jsp", "/profile.jsp", "/protected/*"}) 
@WebFilter({ "/contactSupport.jsp", "/rent.jsp", "/summary.jsp", "/payment.jsp"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get the session, but do not create one if it doesn't exist
        HttpSession session = httpRequest.getSession(false);

        // Define paths that don't require authentication
        String loginPage = httpRequest.getContextPath() + "/login.jsp";
        String loginServlet = httpRequest.getContextPath() + "/loginServlet";

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginPage)
                || httpRequest.getRequestURI().equals(loginServlet);

        // Allow access if the user is logged in or accessing login resources
        if (isLoggedIn || isLoginRequest) {
            chain.doFilter(request, response); // Continue with the request
        } else {
            // Redirect to login page if the user is not authenticated
            httpResponse.sendRedirect(loginPage);
        }
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
