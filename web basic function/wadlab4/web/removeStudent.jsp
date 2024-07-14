<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<%
    String studentID = request.getParameter("studentID");
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
    	Class.forName("com.mysql.jdbc.Driver");
    	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
    	String dbusername = "root";
        String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
        conn = DriverManager.getConnection(url, dbusername, dbPassword);

        // Delete the student from the database
        String sql = "DELETE FROM student WHERE StudentID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentID);
        pstmt.executeUpdate();
        out.println("Student removed successfully.");
        Thread.sleep(2000);//2000ms = 2s
        response.sendRedirect("Student.jsp");
        
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
