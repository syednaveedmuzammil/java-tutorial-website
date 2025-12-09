<%@ page import="java.sql.*" %>
<%@ page import="com.tutorial.util.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (username == null || userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    Integer latestScore = null;
    String examDate = null;

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT score, exam_date FROM exam_scores WHERE user_id = ? ORDER BY exam_date DESC LIMIT 1";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            latestScore = rs.getInt("score");
            java.sql.Timestamp ts = rs.getTimestamp("exam_date");
            examDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(ts);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<html>
<head>
    <title>Student Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #b3e5fc, #e1bee7);
            margin: 0;
            padding: 0;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        header {
            background-color: #0059b3;
            color: white;
            width: 100%;
            text-align: center;
            padding: 25px 0;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
        }

        header h1 {
            margin: 0;
            font-size: 28px;
        }

        main {
            background-color: #ffffff;
            margin-top: 50px;
            padding: 40px 60px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
            max-width: 700px;
        }

        h2 {
            color: #0059b3;
            font-size: 26px;
            margin-bottom: 10px;
        }

        p {
            font-size: 17px;
            color: #555;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .btn-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        a.button {
            display: inline-block;
            background-color: #0059b3;
            color: white;
            text-decoration: none;
            padding: 14px 28px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        a.button:hover {
            background-color: #003d80;
            transform: translateY(-3px) scale(1.05);
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

        footer {
            margin-top: auto;
            background-color: #0059b3;
            color: white;
            text-align: center;
            padding: 15px 0;
            width: 100%;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome to Your Learning Journey, <%= username %>!</h1>
    </header>

    <main>
        <h2>Keep Going Strong </h2>
        <p>
            Every expert was once a beginner. Keep practicing and stay curious 
            success comes to those who keep learning.
        </p>

        <div class="btn-container">
            <a href="Modules/home.html" class="button"> Go to Module 1</a>
            <a href="Modules/exam.html" class="button"> Take Final Exam</a>
            <a href="logout" class="button" style="background-color:#e53935;"> Logout</a>
        </div>

        <% if (latestScore != null) { %>
        <h2 style="margin-top: 40px;"> Your Latest Exam Result</h2>
        <table>
            <tr>
                <th>Score</th>
                <th>Exam Date</th>
            </tr>
            <tr>
                <td><%= latestScore %>%</td>
                <td><%= examDate %></td>
            </tr>
        </table>
        <% } else { %>
        <p style="margin-top: 30px;">No exam records found yet. Take the final exam to see your results here!</p>
        <% } %>
    </main>

    <footer>
        © 2025 Java Tutorial Portal | Keep Learning. Keep Growing.
    </footer>
</body>
</html>
