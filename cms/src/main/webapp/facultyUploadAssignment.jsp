<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Upload Assignment</title>
</head>
<body>
   <%
   
   int courseId = Integer.parseInt(request.getParameter("course_id"));
   String title = request.getParameter("assignment_title");
   String description = request.getParameter("assignment_description");
   String deadline = request.getParameter("deadline");

   Connection conn = null;
   PreparedStatement pstmt = null;
  // ResultSet rs = null;

   try {
       Class.forName("com.mysql.jdbc.Driver");
      // conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
       String sql = "INSERT INTO assignments (course_id, assignment_title, assignment_description, deadline) VALUES (?, ?, ?, ?)";
      
       pstmt = conn.prepareStatement(sql);
       pstmt.setInt(1, courseId);
       pstmt.setString(2, title);
       pstmt.setString(3, description);
       pstmt.setDate(4, java.sql.Date.valueOf(deadline));

       int row = pstmt.executeUpdate();
       if (row > 0) {
           out.println("Assignment uploaded successfully.");
       } else {
           out.println("Error uploading assignment.");
       }
   } catch (Exception e) {
       e.printStackTrace();
   } finally {
       if (pstmt != null) pstmt.close();
       if (conn != null) conn.close();
   }
%>



</body>
</html>
