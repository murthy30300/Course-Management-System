<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.sql.*,java.util.*" %>
<html>
<head>
    <title>View Assignment Scores</title>
</head>
<body>
    <h2>My Assignment Scores</h2>
    <table border="1">
        <tr>
            <th>Course Code</th>
            <th>Assignment Title</th>
            <th>Feedback</th>
            <th>Score</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
           // int studentId = Integer.parseInt(session.getAttribute("student_id").toString());
           int studentId=4; 
         
           

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
               // conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                String sql = "SELECT c.course_code, a.assignment_title, sub.feedback, sub.score " +
                             "FROM submissions sub " +
                             "JOIN assignments a ON sub.assignment_id = a.assignment_id " +
                             "JOIN courses c ON a.course_id = c.course_id " +
                             "WHERE sub.student_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, studentId);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    String courseCode = rs.getString("course_code");
                    String assignmentTitle = rs.getString("assignment_title");
                    String feedback = rs.getString("feedback");
                    int score = rs.getInt("score");
        %>
        <tr>
            <td><%= courseCode %></td>
            <td><%= assignmentTitle %></td>
            <td><%= feedback %></td>
            <td><%= score %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>

</body>
</html>