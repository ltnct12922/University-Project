<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Student Course</title>
</head>
<body>
<div class="content">
        <h1>Edit Student Courses</h1>

        <% 
            // Retrieve student ID from the request parameter
            int studentID = Integer.parseInt(request.getParameter("studentID"));

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

                // Retrieve student information
                String sql = "SELECT * FROM student WHERE StudentID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, studentID);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Display student information
        %>
                    <h2>Edit Courses for <%= rs.getString("StudentName") %></h2>
                    <form action="updateStudentCourses.jsp" method="post">
                        <input type="hidden" name="studentID" value="<%= studentID %>">
                        <table>
                            <tr>
                                <th>Course ID</th>
                                <th>Course Name</th>
                                <th>Registered</th>
                            </tr>
                            <% 
                                // Retrieve courses
                                sql = "SELECT * FROM course";
                                pstmt = conn.prepareStatement(sql);
                                rs = pstmt.executeQuery();

                                // Display courses
                                while (rs.next()) {
                                    // Check if the student is registered for this course
                                    boolean registered = false;
                                    sql = "SELECT * FROM studentcourse WHERE StudentID = ? AND CourseID = ?";
                                    PreparedStatement pstmt2 = conn.prepareStatement(sql);
                                    pstmt2.setInt(1, studentID);
                                    pstmt2.setInt(2, rs.getInt("CourseID"));
                                    ResultSet rs2 = pstmt2.executeQuery();
                                    if (rs2.next()) {
                                        registered = true;
                                    }
                            %>
                                    <tr>
                                        <td><%= rs.getInt("CourseID") %></td>
                                        <td><%= rs.getString("CourseName") %></td>
                                        <td><input type="checkbox" name="courseIDs" value="<%= rs.getInt("CourseID") %>" <% if(registered) { %>checked<% } %>></td>
                                    </tr>
                            <% 
                                }
                            %>
                        </table>
                        <br>
                        <input type="submit" value="Update Courses">
                    </form>
        <% 
                } else {
        %>
                    <p class="error-message">Student not found.</p>
        <% 
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