package com.tutorial.util;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ExamServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // ✅ Retrieve user_id from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                out.println("<h3 style='color:red'>User not logged in. Please log in again.</h3>");
                return;
            }

            int userId = (int) session.getAttribute("user_id");

            // ✅ Get score from form submission
            int score = Integer.parseInt(request.getParameter("score"));

            try (Connection conn = DBConnection.getConnection()) {

                // ✅ Check if record already exists for the user
                String checkQuery = "SELECT * FROM exam_scores WHERE user_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setInt(1, userId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    // ✅ Record exists → UPDATE score and date
                    String updateQuery = "UPDATE exam_scores SET score = ?, exam_date = NOW() WHERE user_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                    updateStmt.setInt(1, score);
                    updateStmt.setInt(2, userId);
                    updateStmt.executeUpdate();

                    // ✅ Also update user's marks in users table
                    String updateUser = "UPDATE users SET marks = ? WHERE id = ?";
                    PreparedStatement updateUserStmt = conn.prepareStatement(updateUser);
                    updateUserStmt.setInt(1, score);
                    updateUserStmt.setInt(2, userId);
                    updateUserStmt.executeUpdate();

                    out.println("<h3 style='color:green'>✅ Exam reattempted! Your score has been updated successfully.</h3>");
                } else {
                    // ✅ Record doesn't exist → INSERT new record
                    String insertQuery = "INSERT INTO exam_scores (user_id, score) VALUES (?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setInt(1, userId);
                    insertStmt.setInt(2, score);
                    insertStmt.executeUpdate();

                    // ✅ Also insert marks into users table
                    String updateUser = "UPDATE users SET marks = ? WHERE id = ?";
                    PreparedStatement updateUserStmt = conn.prepareStatement(updateUser);
                    updateUserStmt.setInt(1, score);
                    updateUserStmt.setInt(2, userId);
                    updateUserStmt.executeUpdate();

                    out.println("<h3 style='color:green'>✅ Exam completed successfully! Your score has been saved.</h3>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color:red'>Database Error: " + e.getMessage() + "</h3>");
        }
    }
}
