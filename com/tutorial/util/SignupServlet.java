package com.tutorial.util;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read data from form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        response.setContentType("text/html");

        try (Connection conn = DBConnection.getConnection()) {
            // Prepare SQL
            String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, role.toLowerCase()); // store as lowercase

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.getWriter().println("<h3>✅ Registration successful!</h3>");
                response.getWriter().println("<a href='login.html'>Go to Login</a>");
            } else {
                response.getWriter().println("<h3>⚠️ Signup failed. Try again.</h3>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Database Error: " + e.getMessage() + "</h3>");
        }
    }
}
