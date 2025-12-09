package com.tutorial.util;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // end session
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('You have been logged out successfully!'); window.location='login.html';</script>");
    }
}
