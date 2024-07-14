<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<%
    // Retrieve the course ID parameter from the request
    String courseID = request.getParameter("courseID");
    
    // Database connection and course removal
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
    	Class.forName("com.mysql.jdbc.Driver");
    	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
    	String dbusername = "root";
        String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
        conn = DriverManager.getConnection(url, dbusername, dbPassword);

        // Remove related records from the studentcourse table
        String deleteRecordsSQL = "DELETE FROM studentcourse WHERE CourseID = ?";
        pstmt = conn.prepareStatement(deleteRecordsSQL);
        pstmt.setString(1, courseID);
        pstmt.executeUpdate();
        
        // Remove the course from the course table
        String deleteCourseSQL = "DELETE FROM course WHERE CourseID = ?";
        pstmt = conn.prepareStatement(deleteCourseSQL);
        pstmt.setString(1, courseID);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Course removed successfully
            response.sendRedirect("Course.jsp");
        } else {
            // Course not found
            out.println("<p>Course not found.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
