<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.tutorial.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Faculty Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f6ff;
            padding: 30px;
        }
        h2 {
            color: #003366;
            text-align: center;
        }
        table {
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0px 0px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 10px 15px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #0059b3;
            color: white;
        }
        a.button {
            display: inline-block;
            background-color: #0059b3;
            color: white;
            padding: 10px 20px;
            margin: 10px auto;
            text-decoration: none;
            border-radius: 5px;
        }
        a.button:hover {
            background-color: #003d80;
        }
    </style>
</head>
<body>

<h2>📊 Faculty Dashboard</h2>
<a href="exportCSV.jsp" class="button">⬇️ Download CSV</a>

<table>
    <tr>
        <th>Student ID</th>
        <th>Username</th>
        <th>Score</th>
        <th>Exam Date</th>
    </tr>

<%
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT u.id, u.username, e.score, e.exam_date " +
                     "FROM exam_scores e JOIN users u ON e.user_id = u.id " +
                     "ORDER BY e.exam_date DESC";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getInt("score") %></td>
        <%
            java.sql.Timestamp ts = rs.getTimestamp("exam_date");
            String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(ts);
        %>
        <td><%= formattedDate %></td>


    </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
</table>

</body>
</html>
