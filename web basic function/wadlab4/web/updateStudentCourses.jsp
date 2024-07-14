<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update Student Courses</title>
 
</head>
<body>
    <div class="content">
        <h1>Update Student Courses</h1>

        <%
            // Retrieve student ID and course IDs from the request parameters
            int studentID = Integer.parseInt(request.getParameter("studentID"));
            String[] courseIDs = request.getParameterValues("courseIDs");

            // Database connection
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
            	String dbusername = "root";
                String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
                conn = DriverManager.getConnection(url, dbusername, dbPassword);
                // Remove all existing courses for the student
                String deleteSQL = "DELETE FROM studentcourse WHERE StudentID = ?";
                pstmt = conn.prepareStatement(deleteSQL);
                pstmt.setInt(1, studentID);
                pstmt.executeUpdate();

                // Add the selected courses for the student
                if (courseIDs != null) {
                    for (String courseID : courseIDs) {
                        String insertSQL = "INSERT INTO studentcourse (StudentID, CourseID) VALUES (?, ?)";
                        pstmt = conn.prepareStatement(insertSQL);
                        pstmt.setInt(1, studentID);
                        pstmt.setInt(2, Integer.parseInt(courseID));
                        pstmt.executeUpdate();
                    }
                }

                // Redirect back to editStudentCourses.jsp with success message
                response.sendRedirect("Student.jsp?studentID=" + studentID + "&success=true");
            } catch (Exception e) {
                out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
    </div>
</body>
</html>
