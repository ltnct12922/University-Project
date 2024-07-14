<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Course Management</title>
</head>
<body>
    <div class="content">
        <h1>Course Management</h1>
        <h2>Course List</h2>

        <% 
            // Check admin credentials
            
            // Database connection and admin authentication
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
            	String dbusername = "root";
                String dbPassword = "1a2b3c4d5e6f"; // No password for the root user
                conn = DriverManager.getConnection(url, dbusername, dbPassword);

                // If admin authentication succeeds, display course table%>
                    <%-- Course Table --%>
                    <table>
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Action</th>
                        </tr>
                        <% 
                            // Retrieve course information
                            String sql = "SELECT c.CourseID, c.CourseName, COUNT(sc.StudentID) AS StudentCount " +
                                  "FROM course c LEFT JOIN studentcourse sc ON c.CourseID = sc.CourseID " +
                                  "GROUP BY c.CourseID, c.CourseName";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery(); 

                            // Display course information
                            while (rs.next()) {
                        %>
                                <tr>
                                    <td><%= rs.getString("CourseID") %></td>
                                    <td><%= rs.getString("CourseName") %></td>
                                    <td>
                                        <a href="#" onclick="removeCourse('<%= rs.getString("CourseID") %>')" class="remove-link">Remove</a> |
                                        <a href="editCourse.jsp?courseID=<%= rs.getString("CourseID") %>" class="edit-link">Edit</a>
                                        
                                            
                                    </td>
                                    </td>
                                </tr>
                        <%      }
                        %>
                    </table>

                <%
            } catch (Exception e) {
                out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>

        <br>
        
        <a href="addCourse.jsp">New Course</a> <br>
        <a href="homepage.jsp">Homepage</a> <br>
        <a href="Student.jsp">Student Management</a>
    </div>

    <script>
        function removeCourse(courseID) {
            var confirmed = confirm("Are you sure you want to remove this course?");
            if (confirmed) {
                // Send removal request to the server
                window.location.href = "removeCourse.jsp?courseID=" + courseID;
            }
        }
    </script>
</body>
</html>
