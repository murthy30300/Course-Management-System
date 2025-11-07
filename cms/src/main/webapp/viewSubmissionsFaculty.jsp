<%@ page import="java.sql.*,java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Submissions</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        h2 {
            margin-bottom: 20px;
        }
        table {
            background-color: #fff;
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
        <h2 class="text-center">Submissions</h2>
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Download Solution</th>
                    <th>Feedback</th>
                    <th>Score</th>
                    <th>Submit Feedback</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        //conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                        String sql = "SELECT s.student_id, s.student_name, sub.submission_id, sub.submission " +
                                     "FROM submissions sub " +
                                     "JOIN students s ON sub.student_id = s.student_id " +
                                     "WHERE sub.feedback IS NULL OR sub.feedback = '' " +
                                     "AND sub.score IS NULL OR sub.score = 0";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int studentId = rs.getInt("student_id");
                            String studentName = rs.getString("student_name");
                            int submissionId = rs.getInt("submission_id");
                            String submissionLink = rs.getString("submission");
                %>
                <tr>
                    <td><%= studentId %></td>
                    <td><%= studentName %></td>
                    <td><a href="<%= submissionLink %>" target="_blank">Download</a></td>
                    <td>
                        <form action="submit_feedback.jsp" method="post">
                            <input type="hidden" name="submission_id" value="<%= submissionId %>">
                            <textarea class="form-control" name="feedback" rows="2"></textarea>
                    </td>
                    <td>
                            <input type="number" class="form-control" name="score" min="0" max="100">
                    </td>
                    <td>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </td>
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
            </tbody>
        </table>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
