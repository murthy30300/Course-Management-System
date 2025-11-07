<%@ page import="java.sql.*,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
    int submissionId = Integer.parseInt(request.getParameter("submission_id"));
    String feedback = request.getParameter("feedback");
    int score = Integer.parseInt(request.getParameter("score"));

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the connection to the database
       // conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        // Prepare the SQL query to update feedback and score
        String sql = "UPDATE submissions SET feedback = ?, score = ? WHERE submission_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, feedback);
        pstmt.setInt(2, score);
        pstmt.setInt(3, submissionId);

        // Execute the update
        int row = pstmt.executeUpdate();
        if (row > 0) {
            out.println("Feedback and score submitted successfully.");
        } else {
            out.println("Error submitting feedback and score.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Exception occurred: " + e.getMessage());
    } finally {
        // Close the PreparedStatement and Connection
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>