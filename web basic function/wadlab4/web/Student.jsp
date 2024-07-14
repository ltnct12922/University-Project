<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Management</title>
<script>
        function removeStudent(studentID) {
            var confirmed = confirm("Are you sure you want to remove this student?");
            if (confirmed) {
                window.location.href = "removeStudent.jsp?studentID=" + studentID;
            }
        }

    </script>
</head>
<body>
<div class="content">
        <h1>Student Management</h1>
        <h2>Student List</h2>

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

                // If admin authentication succeeds, display student table%>

                    <%-- Check for update success or error messages --%>
                    <%
                        boolean updateSuccess = "true".equals(request.getParameter("updateSuccess"));
                        boolean updateError = "true".equals(request.getParameter("updateError"));
                        String errorMessage = request.getParameter("errorMessage");
                    %>

                    <%-- Display success or error messages if present --%>
                    <% if (updateSuccess) { %>
                        <p class="success-message">Courses updated successfully!</p>
                    <% } else if (updateError) { %>
                        <p class="error-message">Error updating courses: <%= errorMessage %></p>
                    <% } %>
                    
                    <%-- Student Table --%>
                    <table id="studentTable">
                        <tr>
                            <th>Student ID</th>
                            <th>Student Name</th>
                            <th>Action</th>
                        </tr>
                        <% 
                            // Retrieve student information
                            String sql = "SELECT s.StudentID, s.StudentName, COUNT(sc.CourseID) AS CourseCount " +
                                  "FROM student s LEFT JOIN studentcourse sc ON s.StudentID = sc.StudentID " +
                                  "GROUP BY s.StudentID, s.StudentName";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();

                            // Display student information
                            while (rs.next()) {
                        %>
                                <tr>
                                    <td><%= rs.getInt("StudentID") %></td>
                                    <td><%= rs.getString("StudentName") %></td>
                                    <td>
                                        <a href="#" onclick="removeStudent(<%= rs.getInt("StudentID") %>)" class="remove-link">Remove</a> | 
                                        <a href="editStudent.jsp?studentID=<%= rs.getInt("StudentID") %>" class="edit-link">Edit</a>
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
        <a href="addStudent.jsp">New Student</a> <br>
        <a href="homepage.jsp">Homepage</a> <br>
        <a href="Course.jsp">Course Management</a>
    </div>
</body>
</html>