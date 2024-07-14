<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<%
    String[] studentsToRemove = request.getParameterValues("studentsToRemove");
    String courseID = request.getParameter("courseID");

    if (studentsToRemove != null && studentsToRemove.length > 0) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
        	Class.forName("com.mysql.jdbc.Driver");
        	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
        	String dbusername = "root";
            String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
            conn = DriverManager.getConnection(url, dbusername, dbPassword);
            // Remove students from the course
            String deleteQuery = "DELETE FROM studentcourse WHERE StudentID IN (";
            for (int i = 0; i < studentsToRemove.length; i++) {
                deleteQuery += "?";
                if (i < studentsToRemove.length - 1) {
                    deleteQuery += ",";
                }
            }
            deleteQuery += ") AND CourseID = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            for (int i = 0; i < studentsToRemove.length; i++) {
                pstmt.setString(i + 1, studentsToRemove[i]);
            }
            pstmt.setString(studentsToRemove.length + 1, courseID);
            int rowsAffected = pstmt.executeUpdate();

            // Redirect back to Course.jsp with data updated
            response.sendRedirect("Course.jsp");
        } catch (Exception e) {
            out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    } else {
        out.println("<p class='error-message'>No students selected.</p>");
    }
%>
