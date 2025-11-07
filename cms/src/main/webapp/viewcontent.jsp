<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<title>Course Registration</title>
<style>
.con-anchor {
	text-decoration: none;
	color:black;
}
</style>
<!-- <link rel="stylesheet" href="style.css"> -->
</head>
<body>
	<a href="studenthome.jsp" class="con-anchor"><svg
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
			height="24" color="#000000" fill="none">
    <path
				d="M4.80823 9.44118L6.77353 7.46899C8.18956 6.04799 8.74462 5.28357 9.51139 5.55381C10.4675 5.89077 10.1528 8.01692 10.1528 8.73471C11.6393 8.73471 13.1848 8.60259 14.6502 8.87787C19.4874 9.78664 21 13.7153 21 18C19.6309 17.0302 18.2632 15.997 16.6177 15.5476C14.5636 14.9865 12.2696 15.2542 10.1528 15.2542C10.1528 15.972 10.4675 18.0982 9.51139 18.4351C8.64251 18.7413 8.18956 17.9409 6.77353 16.5199L4.80823 14.5477C3.60275 13.338 3 12.7332 3 11.9945C3 11.2558 3.60275 10.6509 4.80823 9.44118Z"
				stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
				stroke-linejoin="round" />
</svg> back to home</a>
	<%
	HttpSession se = request.getSession(false);
	String username = (se != null) ? (String) se.getAttribute("username") : "Guest";
	out.print((username != null) ? username : "Guest");
	/* HttpSession session = request.getSession(false);  // Retrieve existing session if it exists
	if (session != null) {
	    String username = (String) session.getAttribute("username");
	    // Use username as needed
	} */

	if (username != null && !username.equals("Guest")) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			//Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
			String studentQuery = "SELECT student_id FROM users WHERE username = ?";
			PreparedStatement studentStmt = conn.prepareStatement(studentQuery);
			studentStmt.setString(1, username);
			ResultSet studentRs = studentStmt.executeQuery();

			int studentId = 0;
			if (studentRs.next()) {
		studentId = studentRs.getInt("student_id");
			}

			String courseQuery = "SELECT c.course_id, c.course_name, c.course_code, c.instructor_name FROM registrations r JOIN courses c ON r.course_id = c.course_id WHERE r.student_id = ?";
			PreparedStatement courseStmt = conn.prepareStatement(courseQuery);
			courseStmt.setInt(1, studentId);
			ResultSet courseRs = courseStmt.executeQuery();

			List<String[]> courses = new ArrayList<>();
			while (courseRs.next()) {
		String[] course = { String.valueOf(courseRs.getInt("course_id")), courseRs.getString("course_name"),
				courseRs.getString("course_code"), courseRs.getString("instructor_name") };
		courses.add(course);
			}

			conn.close();
	%>

	<div class="container">
		<div class="row">
			<%
			String[] colors = { "primary", "secondary", "success", "danger", "warning" };
			for (int i = 0; i < courses.size(); i++) {
				String[] course = courses.get(i);
			%>

			<div class="col-md-4">
				<a href="studentContent.jsp?courseId=<%=course[0]%>"
					class="con-anchor">
					<div class="card text-bg-<%=colors[i % colors.length]%> mb-3"
						style="max-width: 18rem;">
						<div class="card-header">
							Course:
							<%=course[2]%></div>
						<div class="card-body">
							<h5 class="card-title"><%=course[1]%></h5>
							<p class="card-text">
								Instructor:
								<%=course[3]%></p>
						</div>
					</div>
				</a>
			</div>

			<%
			}
			%>
		</div>
	</div>
	<%
	} catch (Exception e) {
	e.printStackTrace();
	%>
	<div class="alert alert-danger" role="alert">Error retrieving
		course information.</div>
	<%
	}
	} else {
	%>
	<div class="alert alert-warning" role="alert">You are not logged
		in. Please log in to view your courses.</div>
	<%
	}
	%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
		crossorigin="anonymous"></script>

</body>
</html>
