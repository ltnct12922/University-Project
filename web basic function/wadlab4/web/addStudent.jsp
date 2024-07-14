<%-- 
    Document   : addStudent
    Created on : May 15, 2024, 7:51:32 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<title>Insert title here</title>
</head>
<body>
 <div align="center">
  <h1>User Adding Form</h1>
  <form action="<%= request.getContextPath() %>/register" method="post">
   <table style="with: 80%">
    <tr>
     <td>ID: </td>
     <td><input type="text" name="ID2" /></td>
    </tr>
    <tr>
     <td>Full Name: </td>
     <td><input type="text" name="Fullname" /></td>
    </tr>
   </table>
   <input type="submit" value="Submit" />
  </form>
 </div>
</body>
</html>