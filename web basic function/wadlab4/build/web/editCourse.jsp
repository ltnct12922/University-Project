<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Course</title>
   
</head>
<body>
    <div class="container">
        <h1>Edit Course</h1>

        <% 
            // Retrieve the course ID parameter from the request
            String courseID = request.getParameter("courseID");

            // Database connection and fetching course details
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
            	String dbusername = "root";
                String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
                conn = DriverManager.getConnection(url, dbusername, dbPassword);
                // Retrieve course details
                String courseQuery = "SELECT CourseName FROM course WHERE CourseID = ?";
                pstmt = conn.prepareStatement(courseQuery);
                pstmt.setString(1, courseID);
                rs = pstmt.executeQuery();

                // Check if course exists
                if (rs.next()) {
                    String courseName = rs.getString("CourseName");
        %>
                    <h2>Course Name: <%= courseName %></h2>

                    <form action="updateCourse.jsp" method="post">
                        <input type="hidden" name="courseID" value="<%= courseID %>">
                        <h3>Students Enrolled:</h3>
                        <%
                            // Retrieve students enrolled in the course
                            String studentQuery = "SELECT s.StudentID, s.StudentName FROM student s " +
                                                  "INNER JOIN studentcourse sc ON s.StudentID = sc.StudentID " +
                                                  "WHERE sc.CourseID = ?";
                            pstmt = conn.prepareStatement(studentQuery);
                            pstmt.setString(1, courseID);
                            rs = pstmt.executeQuery();

                            // Display students enrolled in the course
                            while (rs.next()) {
                                String studentID = rs.getString("StudentID");
                                String studentName = rs.getString("StudentName");
                        %>
                                <div class="student-item"> 
                                    <input type="checkbox" name="studentsToRemove" value="<%= studentID %>">
                                    <p><%= studentName %></p>
                                </div>
                        <%      
                            }
                        %>
                        <br>
                        <input type="submit" value="Remove Selected Students" name="removeStudents">
                    </form>
        <%      
                } else {
                    out.println("<p class='error-message'>Course not found.</p>");
                }
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
