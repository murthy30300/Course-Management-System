<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register Courses</title>
</head>
<body>
<%
    int studentId = Integer.parseInt(request.getParameter("studentId"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
       // Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        // Debugging: Print connection status
        if (conn != null) {
            out.println("Database connection established.<br>");
        } else {
            out.println("Failed to establish database connection.<br>");
        }

        String insertQuery = "INSERT INTO registrations (student_id, course_id) VALUES (?, ?)";
        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);

        for (int i = 1; i <= 5; i++) {
            String courseParam = request.getParameter("course" + i);
            if (courseParam != null && !courseParam.isEmpty()) {
                int courseId = Integer.parseInt(courseParam);
                insertStmt.setInt(1, studentId);
                insertStmt.setInt(2, courseId);

                // Debugging: Print course being inserted
                out.println("Inserting: Student ID = " + studentId + ", Course ID = " + courseId + "<br>");

                insertStmt.addBatch();
            }
        }

        int[] result = insertStmt.executeBatch();

        // Debugging: Print batch execution results
        out.println("Batch execution results: " + Arrays.toString(result) + "<br>");

        conn.close();
%>
        <h1>Registration Successful</h1>
        <p>You have successfully registered for your courses.</p>
        <a href="courseSelection.jsp">Go Back to Course Selection</a>
<%
    } catch (Exception e) {
        e.printStackTrace(); // Print exception details for debugging
%>
        <h1>Registration Failed</h1>
        <p>There was an error processing your registration. Please try again.</p>
        <a href="courseSelection.jsp">Go Back to Course Selection</a>
<%
    }
%>
</body>
</html>
