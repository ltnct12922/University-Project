<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Course Registration Demo</title>

</head>
<body>
     <div class="content">
    <h1>Course Registration Demo</h1>

    <form action="homepage.jsp" method="post">
        Student ID: <input type="text" name="studentID"/>
        <input type="submit" value="Submit"/>
    </form>

    <% 
        String studentID = request.getParameter("studentID");
        if (studentID != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean showSaveButton = false; // Flag to show Save button
            
            try {
            	Class.forName("com.mysql.jdbc.Driver");
            	String url = "jdbc:mysql://localhost:3306/wadl4?useSSL=false&serverTimezone=UTC&";  
            	String dbusername = "root";
                String dbPassword = "1a2b3c4d5e6f"; 
                conn = DriverManager.getConnection(url, dbusername, dbPassword);

                // Retrieve student information
                String sqlStudent = "SELECT * FROM student WHERE StudentID = ?";
                pstmt = conn.prepareStatement(sqlStudent);
                pstmt.setInt(1, Integer.parseInt(studentID));
                rs = pstmt.executeQuery();

                // Display student information
                if (rs.next()) {
    %>
                    <h2>Student's Details</h2>
                    <p>Student ID: <%= rs.getInt("StudentID") %></p>
                    <p>Student Name: <%= rs.getString("StudentName") %></p>
    <%
                }

                // Form to choose a course
    %>
                <form action="homepage.jsp" method="post">
                    <input type="hidden" name="studentID" value="<%= studentID %>"/>
                    <label for="courseID">Choose a Course:</label>
                    <select name="courseID" id="courseID">
    <%
                    // Retrieve course information
                    String sqlCourses = "SELECT * FROM course";
                    pstmt = conn.prepareStatement(sqlCourses);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
    %>
                        <option value="<%= rs.getInt("CourseID") %>"><%= rs.getString("CourseName") %></option>
    <%
                    }
    %>
                    </select>
                    <input type="submit" name="addCourse" value="Add"/>
                </form>
    <%
                // Handle adding course
                String addCourseID = request.getParameter("courseID");
                if (addCourseID != null && request.getParameter("addCourse") != null) {
                    // Check if the course is already registered for the student
                    String checkCourseQuery = "SELECT * FROM studentcourse WHERE StudentID = ? AND CourseID = ?";
                    pstmt = conn.prepareStatement(checkCourseQuery);
                    pstmt.setInt(1, Integer.parseInt(studentID));
                    pstmt.setInt(2, Integer.parseInt(addCourseID));
                    ResultSet existingCourse = pstmt.executeQuery();
                    if (!existingCourse.next()) { // If course is not already registered
                        // Insert the course into the studentcourse table
                        String sqlAddCourse = "INSERT INTO studentcourse (StudentID, CourseID) VALUES (?, ?)";
                        pstmt = conn.prepareStatement(sqlAddCourse);
                        pstmt.setInt(1, Integer.parseInt(studentID));
                        pstmt.setInt(2, Integer.parseInt(addCourseID));
                        pstmt.executeUpdate();
                        showSaveButton = true; // Set flag to show Save button
                    }
                }

                // Handle removing course
                String removeCourseID = request.getParameter("removeCourseID");
                if (removeCourseID != null) {
                    String sqlRemoveCourse = "DELETE FROM studentcourse WHERE StudentID = ? AND CourseID = ?";
                    pstmt = conn.prepareStatement(sqlRemoveCourse);
                    pstmt.setInt(1, Integer.parseInt(studentID));
                    pstmt.setInt(2, Integer.parseInt(removeCourseID));
                    pstmt.executeUpdate();
                    showSaveButton = true; // Set flag to show Save button
                }

                // Display registered courses
                String sqlRegisteredCourses = "SELECT c.CourseID, c.CourseName FROM course c INNER JOIN studentcourse sc ON c.CourseID = sc.CourseID WHERE sc.StudentID = ?";
                pstmt = conn.prepareStatement(sqlRegisteredCourses);
                pstmt.setInt(1, Integer.parseInt(studentID));
                rs = pstmt.executeQuery();
                if (rs.next()) {
    %>
                    <h2>Registered Courses</h2>
                    <form action="homepage.jsp" method="post"> <!-- Form to show final form -->
                    <table border="1" size="60">
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Action</th>
                        </tr>
    <%
                    // Display registered courses
                    do {
    %>
                        <tr>
                            <td><%= rs.getInt("CourseID") %></td>
                            <td><%= rs.getString("CourseName") %></td>
                            <td><a href="homepage.jsp?studentID=<%= studentID %>&removeCourseID=<%= rs.getInt("CourseID") %>">Remove</a></td>
                        </tr>
    <%
                    } while (rs.next());
    %>
                    </table>
                    <% if (showSaveButton) { %> <!-- Show Save button if a course was added or removed -->
                        <input type="hidden" name="studentID" value="<%= studentID %>"/>
                        <input type="submit" name="saveCourses" value="Save"/>
                    <% } %>
                    </form>
                    <% if (request.getParameter("saveCourses") != null) { %> <!-- Show registration saved message if Save button was clicked -->
                        <p>Course registration saved!</p>
                    <% } %>
    <%
                }
            } catch (Exception e) {
                out.println("<h2>Error</h2>");
                out.println("An error occurred: " + e.getMessage());
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>
        <h2>Manager</h2>
        <a href="Student.jsp">Students Manager</a><br/>
        <a href="Course.jsp">Courses Manager</a>
</div>
</body>
</html>