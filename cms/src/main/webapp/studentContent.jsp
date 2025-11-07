<%@ page import="java.sql.*, java.util.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ include file="viewcontent.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Content</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
.content-container {
	margin: 20px;
}

.assignment-section {
	margin-top: 20px;
}

.assignment-dropdown {
	margin-bottom: 10px;
}

.breadcrumb {
	background-color: transparent;
}

.breadcrumb-item+.breadcrumb-item::before {
	content: ">";
}

body {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	height: 100vh;
	margin: 0;
	font-family: Arial, sans-serif;
}

.center-align {
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
	font-size: 1.5em;
}

.center-align svg {
	margin-left: 10px;
	fill: #000;
}

a {
	text-decoration: none;
	color: black;
}
</style>
</head>
<body>
	<div class="container">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="studenthome.jsp">Home</a></li>
				<li class="breadcrumb-item"><a href="viewcontent.jsp">My
						courses</a></li>
				<li class="breadcrumb-item active" aria-current="page">
					<%
					HttpSession stp = request.getSession(false);
					String utp = (stp != null) ? (String) stp.getAttribute("username") : null;

					/* String username=null;

					HttpSession session1 = request.getSession(false);  // Retrieve existing session if it exists
					if (session1 != null) {
					    username = (String) session.getAttribute("username");
					    // Use username as needed
					} */

					String courseIdParam = request.getParameter("courseId");
					int courseId = 0;

					if (utp != null && courseIdParam != null) {
						try {
							courseId = Integer.parseInt(courseIdParam);
							Class.forName("com.mysql.cj.jdbc.Driver");
							//Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
							String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
							String dbUser = "avnadmin";
							String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
							Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
							// Get course_name from courses table
							String courseQuery = "SELECT course_name FROM courses WHERE course_id = ?";
							PreparedStatement courseStmt = conn.prepareStatement(courseQuery);
							courseStmt.setInt(1, courseId);
							ResultSet courseRs = courseStmt.executeQuery();

							if (courseRs.next()) {
						String courseName = courseRs.getString("course_name");
						out.print(courseName);
							} else {
						out.println("Course not found");
							}
							conn.close();
						} catch (Exception e) {
							e.printStackTrace();
						}
					} else {
						out.println("Course not found");
					}
					%>
				</li>
			</ol>
		</nav>
	</div>
	<div class="container content-container">
		<h2 class="text-center">Assignments</h2>
		<div class="assignment-section">
			<!-- Assignments section here -->
			<div class="assignment-dropdown">
				<button
					class="btn btn-primary btn-block d-flex justify-content-between align-items-center"
					type="button" data-toggle="collapse" data-target="#allAssignments"
					aria-expanded="false" aria-controls="allAssignments">
					<span>All Assignments</span>
				</button>
			</div>
			<div class="collapse" id="allAssignments">
				<div class="card card-body">
					<ul>
						<%
						if (utp != null && courseId != 0) {
							try {
								Class.forName("com.mysql.cj.jdbc.Driver");
								Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");

								String assignmentQuery = "SELECT a.assignment_title, a.assignment_description, a.deadline, s.submission FROM assignments a LEFT JOIN submissions s ON a.assignment_id = s.assignment_id AND s.student_id = ? WHERE a.course_id = ?";
								PreparedStatement assignmentStmt = conn.prepareStatement(assignmentQuery);
								assignmentStmt.setInt(1, getStudentId(username, conn)); // Function to get student_id
								assignmentStmt.setInt(2, courseId);
								ResultSet assignmentRs = assignmentStmt.executeQuery();

								while (assignmentRs.next()) {
							String title = assignmentRs.getString("assignment_title");
							String description = assignmentRs.getString("assignment_description");
							String submission = assignmentRs.getString("submission");
						%>
						<li><strong>Title:</strong> <%=title%> <br> <strong>Description:</strong>
							<%=description%> <br> <strong>Deadline:</strong> <%=assignmentRs.getDate("deadline")%>
							<br> <strong>Submission:</strong> <%=(submission != null) ? "Submitted" : "Pending"%>
						</li>
						<hr>
						<%
						}
						conn.close();
						} catch (Exception e) {
						e.printStackTrace();
						}
						} else {
						out.println("<p>Please login to view your assignments.</p>");
						}
						%>
					</ul>
				</div>
			</div>
		</div>
		<div class="assignment-dropdown">
			<button
				class="btn btn-success btn-block d-flex justify-content-between align-items-center"
				type="button" data-toggle="collapse"
				data-target="#submittedAssignments" aria-expanded="false"
				aria-controls="submittedAssignments">
				<span>Submitted Assignments</span>
			</button>
		</div>
		<div class="collapse" id="submittedAssignments">
			<div class="card card-body">
				<ul>
					<%
					if (username != null && courseId != 0) {
						try {
							Class.forName("com.mysql.cj.jdbc.Driver");
							Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");

							String submittedQuery = "SELECT a.assignment_title, a.assignment_description, a.deadline, s.submission FROM assignments a JOIN submissions s ON a.assignment_id = s.assignment_id WHERE s.student_id = ? AND a.course_id = ?";
							PreparedStatement submittedStmt = conn.prepareStatement(submittedQuery);
							submittedStmt.setInt(1, getStudentId(username, conn)); // Function to get student_id
							submittedStmt.setInt(2, courseId);
							ResultSet submittedRs = submittedStmt.executeQuery();

							while (submittedRs.next()) {
						String title = submittedRs.getString("assignment_title");
						String description = submittedRs.getString("assignment_description");
						String submission = submittedRs.getString("submission");
					%>
					<li><strong>Title:</strong> <%=title%> <br> <strong>Description:</strong>
						<%=description%> <br> <strong>Deadline:</strong> <%=submittedRs.getDate("deadline")%>
						<br> <strong>Submission:</strong> <%=(submission != null) ? "Submitted" : "Pending"%>
					</li>
					<hr>
					<%
					}
					conn.close();
					} catch (Exception e) {
					e.printStackTrace();
					}
					} else {
					out.println("<p>Please login to view your assignments.</p>");
					}
					%>
				</ul>
			</div>
		</div>
		<div class="assignment-dropdown">
			<button
				class="btn btn-warning btn-block d-flex justify-content-between align-items-center"
				type="button" data-toggle="collapse"
				data-target="#pendingAssignments" aria-expanded="false"
				aria-controls="pendingAssignments">
				<span>Pending Assignments</span>
			</button>
		</div>
		<div class="collapse" id="pendingAssignments">
			<div class="card card-body">
				<ul>
					<%
					if (username != null && courseId != 0) {
						try {
							Class.forName("com.mysql.cj.jdbc.Driver");
							Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");

							String pendingQuery = "SELECT a.assignment_title, a.assignment_description, a.deadline FROM assignments a WHERE a.assignment_id NOT IN (SELECT assignment_id FROM submissions WHERE student_id = ?) AND a.course_id = ?";
							PreparedStatement pendingStmt = conn.prepareStatement(pendingQuery);
							pendingStmt.setInt(1, getStudentId(username, conn)); // Function to get student_id
							pendingStmt.setInt(2, courseId);
							ResultSet pendingRs = pendingStmt.executeQuery();

							while (pendingRs.next()) {
						String title = pendingRs.getString("assignment_title");
						String description = pendingRs.getString("assignment_description");
					%>
					<li><strong>Title:</strong> <%=title%> <br> <strong>Description:</strong>
						<%=description%> <br> <strong>Deadline:</strong> <%=pendingRs.getDate("deadline")%>
					</li>
					<hr>
					<%
					}
					conn.close();
					} catch (Exception e) {
					e.printStackTrace();
					}
					} else {
					out.println("<p>Please login to view your assignments.</p>");
					}
					%>
				</ul>
			</div>
		</div>

	</div>
	<h3 class="center-align">
		<a href="playContent.jsp?courseId=<%=courseId%>">Need help with
			this concept? Watch our lecture video <svg
				xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
				height="24" color="#000000" fill="none">
            <path
					d="M3.42847 3.52383C5.4919 1.30171 21.0128 6.74513 21 8.73253C20.9855 10.9862 14.9387 11.6795 13.2626 12.1497C12.2548 12.4325 11.9848 12.7223 11.7524 13.7792C10.6999 18.5657 10.1715 20.9464 8.96711 20.9997C7.04737 21.0845 1.41472 5.69242 3.42847 3.52383Z"
					stroke="currentColor" stroke-width="1.5" />
        </svg>
		</a>
	</h3>



	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%!private int getStudentId(String username, Connection conn) throws SQLException {
		String studentQuery = "SELECT student_id FROM users WHERE username = ?";
		PreparedStatement studentStmt = conn.prepareStatement(studentQuery);
		studentStmt.setString(1, username);
		ResultSet studentRs = studentStmt.executeQuery();
		if (studentRs.next()) {
			return studentRs.getInt("student_id");
		} else {
			throw new SQLException("Student ID not found for username: " + username);
		}
	}%>
