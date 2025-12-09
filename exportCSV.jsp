<%@ page import="java.sql.*, com.tutorial.util.DBConnection" %>
<%@ page contentType="text/csv" %>
<%
    response.setHeader("Content-Disposition", "attachment; filename=\"exam_scores.csv\"");

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT u.id, u.username, e.score, e.exam_date " +
                     "FROM exam_scores e JOIN users u ON e.user_id = u.id " +
                     "ORDER BY e.exam_date DESC";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        out.println("Student ID,Username,Score,Exam Date");

        while (rs.next()) {
            out.println(
                rs.getInt("id") + "," +
                rs.getString("username") + "," +
                rs.getInt("score") + "," +
                rs.getTimestamp("exam_date")
            );
        }

    } catch (Exception e) {
        out.println("Error," + e.getMessage());
    }
%>
