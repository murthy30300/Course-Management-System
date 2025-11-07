<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Handle Video</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
<%@ page import="java.sql.*" %>
<%
    String operation = request.getParameter("operation");
    int courseId = Integer.parseInt(request.getParameter("course_id"));
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
       // conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        if ("insert".equals(operation)) {
            String videoTitle = request.getParameter("video_title");
            String videoLink = request.getParameter("video_link");
            String videoDescription = request.getParameter("video_description");
            String instructorDescription = request.getParameter("instructor_description");
            
            String sql = "INSERT INTO course_videos (course_id, video_title, video_link, course_description, instructor_details) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.setString(2, videoTitle);
            pstmt.setString(3, videoLink);
            pstmt.setString(4, videoDescription);
            pstmt.setString(5, instructorDescription);

            int row = pstmt.executeUpdate();
            if (row > 0) {
                out.println("<p class='alert alert-success'>Video link successfully uploaded.</p>");
            } else {
                out.println("<p class='alert alert-danger'>Error uploading video link.</p>");
            }
        } else if ("update".equals(operation)) {
            int videoId = Integer.parseInt(request.getParameter("video_id"));
            String videoTitle = request.getParameter("video_title");
            String videoLink = request.getParameter("video_link");
            String videoDescription = request.getParameter("video_description");
            String instructorDescription = request.getParameter("instructor_description");

            String sql = "UPDATE course_videos SET video_title = ?, video_link = ?, course_description = ?, instructor_details = ? WHERE video_id = ? AND course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, videoTitle);
            pstmt.setString(2, videoLink);
            pstmt.setString(3, videoDescription);
            pstmt.setString(4, instructorDescription);
            pstmt.setInt(5, videoId);
            pstmt.setInt(6, courseId);

            int row = pstmt.executeUpdate();
            if (row > 0) {
                out.println("<p class='alert alert-success'>Video link successfully updated.</p>");
            } else {
                out.println("<p class='alert alert-danger'>Error updating video link.</p>");
            }
        } else if ("delete".equals(operation)) {
            int videoId = Integer.parseInt(request.getParameter("video_id"));
            String sql = "DELETE FROM course_videos WHERE video_id = ? AND course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, videoId);
            pstmt.setInt(2, courseId);

            int row = pstmt.executeUpdate();
            if (row > 0) {
                out.println("<p class='alert alert-success'>Video link successfully deleted.</p>");
            } else {
                out.println("<p class='alert alert-danger'>Error deleting video link.</p>");
            }
        } else if ("view".equals(operation)) {
            String sql = "SELECT * FROM course_videos WHERE course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            rs = pstmt.executeQuery();
            out.println("<h3>Video List</h3>");
            out.println("<table class='table table-bordered'><tr><th>Video ID</th><th>Title</th><th>Link</th><th>Description</th><th>Instructor Details</th></tr>");
            while (rs.next()) {
                int videoId = rs.getInt("video_id");
                String videoTitle = rs.getString("video_title");
                String videoLink = rs.getString("video_link");
                String videoDescription = rs.getString("course_description");
                String instructorDescription = rs.getString("instructor_details");
                out.println("<tr><td>" + videoId + "</td><td>" + videoTitle + "</td><td>" + videoLink + "</td><td>" + videoDescription + "</td><td>" + instructorDescription + "</td></tr>");
            }
            out.println("</table>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p class='alert alert-danger'>Exception occurred: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<a href="upload.jsp" class="btn btn-primary">Back to Form</a>
</div>
</body>
</html>
