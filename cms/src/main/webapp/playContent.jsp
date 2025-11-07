<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%-- <%@ include file="viewcontent.jsp"%> --%>

<%
     HttpSession satt = request.getSession(false);
    String uatt = (session != null) ? (String) satt.getAttribute("username") : null; 
    
   /*  HttpSession session1 = request.getSession(false);  // Retrieve existing session if it exists
    if (session1 != null) {
        String uatt = (String) session1.getAttribute("username");
        // Use username as needed
    } */

    String courseIdParam = request.getParameter("courseId");
    int courseId = 0;

    if (uatt != null && courseIdParam != null) {
        try {
            courseId = Integer.parseInt(courseIdParam);
            
            Class.forName("com.mysql.cj.jdbc.Driver");
           // Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String videoQuery = "SELECT cv.video_id, cv.video_title, cv.video_link, cv.course_description, cv.instructor_details FROM course_videos cv WHERE cv.course_id = ?";
            PreparedStatement videoStmt = conn.prepareStatement(videoQuery);
            videoStmt.setInt(1, courseId);
            ResultSet videoRs = videoStmt.executeQuery();

            List<String[]> videos = new ArrayList<>();
            String courseDescription = "";
            String instructorDetails = "";
            while (videoRs.next()) {
                if (courseDescription.isEmpty() && instructorDetails.isEmpty()) {
                    // Retrieve course and instructor details from the first row
                    courseDescription = videoRs.getString("course_description");
                    instructorDetails = videoRs.getString("instructor_details");
                }
                String[] video = { String.valueOf(videoRs.getInt("video_id")), videoRs.getString("video_title"), videoRs.getString("video_link") };
                videos.add(video);
            }

            conn.close();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Course Videos</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .video-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .sidebar {
            margin-top: 20px;
        }
        .toc a {
            display: block;
            margin-bottom: 10px;
        }
         body {
            display: flex;
            font-family: Arial, sans-serif;
            margin: 0;
        }
        .sidebar, .content {
            padding: 20px;
            box-sizing: border-box;
        }
        .sidebar {
            width: 20%;
            background-color: #f7f7f7;
            height: 100vh;
            overflow-y: auto;
        }
        .content {
            width: 80%;
            display: flex;
            flex-direction: column;
        }
        .video-container {
            flex: 9;
            background-color: #000;
        }
        .video-container iframe {
            width: 100%;
            height: 100%;
        }
        .video-title {
            flex: 1;
            font-size: 24px;
            font-weight: bold;
            padding: 10px 0;
        }
        .details {
            overflow-y: auto;
        }
        .description, .instructor {
            margin: 20px 0;
        }
        .toc a {
            display: block;
            padding: 10px;
            color: #000;
            text-decoration: none;
        }
        .toc a:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="video-container">
            <iframe id="video-player" src="<%=videos.get(0)[2]%>" frameborder="0" allowfullscreen></iframe>
        </div>
        <div class="video-title" id="video-title"><%=videos.get(0)[1]%></div>
        <div class="details">
            <div class="description">
                <h2>Course Description</h2>
                <p><%= courseDescription %></p>
            </div>
            <hr>
            <div class="instructor">
                <h2>Instructor Details</h2>
                <p><%= instructorDetails %></p>
            </div>
        </div>
    </div>
    <div class="sidebar toc">
        <h2>Course Content</h2>
        <%
            for (int i = 1; i < videos.size(); i++) {
                String[] video = videos.get(i);
        %>
        <a href="#" data-video="<%=video[2]%>" data-title="<%=video[1]%>"><%=video[1]%></a>
        <%
            }
        %>
    </div>

    <script>
        document.querySelectorAll('.toc a').forEach(link => {
            link.addEventListener('click', function(event) {
                event.preventDefault();
                document.getElementById('video-player').src = this.getAttribute('data-video');
                document.getElementById('video-title').textContent = this.getAttribute('data-title');
            });
        });
    </script>
</body>
</html>
<%
        } catch (Exception e) {
            e.printStackTrace();
%>
<div class="alert alert-danger" role="alert">Error retrieving video information.</div>
<%
        }
    } else {
%>
<div class="alert alert-warning" role="alert">You are not logged in or no course selected. Please log in and select a course to view the videos.</div>
<%
    }
%>
