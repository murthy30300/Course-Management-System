<%@ page import="java.sql.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage YouTube Videos</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
            max-width: 800px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-block {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<a href="facultyHome.jsp" class="con-anchor" style="text-decoration: none;"><svg
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
			height="24" color="#000000" fill="none">
    <path
				d="M4.80823 9.44118L6.77353 7.46899C8.18956 6.04799 8.74462 5.28357 9.51139 5.55381C10.4675 5.89077 10.1528 8.01692 10.1528 8.73471C11.6393 8.73471 13.1848 8.60259 14.6502 8.87787C19.4874 9.78664 21 13.7153 21 18C19.6309 17.0302 18.2632 15.997 16.6177 15.5476C14.5636 14.9865 12.2696 15.2542 10.1528 15.2542C10.1528 15.972 10.4675 18.0982 9.51139 18.4351C8.64251 18.7413 8.18956 17.9409 6.77353 16.5199L4.80823 14.5477C3.60275 13.338 3 12.7332 3 11.9945C3 11.2558 3.60275 10.6509 4.80823 9.44118Z"
				stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
				stroke-linejoin="round" />
</svg> back to home</a>
    <div class="container">
        <h2 class="text-center">Manage YouTube Videos</h2>
        <form id="videoForm" action="handleVideo.jsp" method="post">
            <div class="form-group">
                <label for="course_id">Select Course:</label>
                <select class="form-control" id="course_id" name="course_id" required>
                    <option value="" disabled selected>Select a course</option>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
                            String dbUser = "avnadmin";
                            String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
                             conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                            //conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                            String sql = "SELECT course_id, course_name FROM courses";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                                int courseId = rs.getInt("course_id");
                                String courseName = rs.getString("course_name");
                                out.println("<option value='" + courseId + "'>" + courseName + "</option>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="operation">Operation:</label>
                <select class="form-control" id="operation" name="operation" required>
                    <option value="" disabled selected>Select an operation</option>
                    <option value="insert">Insert</option>
                    <option value="update">Update</option>
                    <option value="delete">Delete</option>
                    <option value="view">View</option>
                </select>
            </div>
            <div id="videoFields" style="display: none;">
                <div class="form-group">
                    <label for="video_id">Video ID (for Update/Delete):</label>
                    <input type="text" class="form-control" id="video_id" name="video_id">
                </div>
                <div class="form-group">
                    <label for="video_title">Video Title:</label>
                    <input type="text" class="form-control" id="video_title" name="video_title">
                </div>
                <div class="form-group">
                    <label for="video_link">YouTube Video Link:</label>
                    <input type="text" class="form-control" id="video_link" name="video_link">
                </div>
                <div class="form-group">
                    <label for="video_description">Enter Course Description:</label>
                    <textarea class="form-control" id="video_description" name="video_description" rows="4"></textarea>
                </div>
                <div class="form-group">
                    <label for="instructor_description">About Instructor:</label>
                    <textarea class="form-control" id="instructor_description" name="instructor_description" rows="4"></textarea>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $('#operation').on('change', function() {
            if (this.value === 'insert' || this.value === 'update') {
                $('#videoFields').show();
                $('#video_id').attr('required', this.value === 'update');
                $('#video_title').attr('required', true);
                $('#video_link').attr('required', true);
                $('#video_description').attr('required', true);
                $('#instructor_description').attr('required', true);
            } else if (this.value === 'delete') {
                $('#videoFields').show();
                $('#video_id').attr('required', true);
                $('#video_title').attr('required', false);
                $('#video_link').attr('required', false);
                $('#video_description').attr('required', false);
                $('#instructor_description').attr('required', false);
            } else {
                $('#videoFields').hide();
                $('#video_id').attr('required', false);
                $('#video_title').attr('required', false);
                $('#video_link').attr('required', false);
                $('#video_description').attr('required', false);
                $('#instructor_description').attr('required', false);
            }
        });
    </script>
</body>
</html>
