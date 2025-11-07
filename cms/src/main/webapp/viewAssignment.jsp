<%@ page import="java.sql.*,java.util.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="1base.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Assignments</title>
<!-- <link rel="stylesheet" href="style.css"> --> 
<style>
/* General Styles */
body {
	font-family: 'Arial', sans-serif;
	background-color: #f4f4f4;
	color: #333;
	margin: 0;
	padding: 0;
}

.header {
	background-color: #0044cc;
    color: white;
    padding: 6px;
    text-align: center;
    position: absolute;
    width: auto;
    margin-left: 0%;
    margin-top: 10%;
    display: grid;
    grid-template-columns: 48% 1fr;
    left: 51%;
    top: -3%
}

.header .btn {
	margin-top: 10px;
	padding: 10px 20px;
	background-color: #0066cc;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	transition: background-color 0.3s ease;
}

.header .btn:hover {
	background-color: #0055aa;
}

.container {
	display: flex;
	min-height: 100vh;
}

.sidebar {
	background-color: #002a80;
	width: 20%;
	padding: 20px;
	color: white;
}

.sidebar a {
	display: block;
	padding: 10px;
	color: #80bfff;
	text-decoration: none;
	border-radius: 5px;
	margin-bottom: 10px;
	transition: background-color 0.3s ease;
}

.sidebar a:hover {
	background-color: #0044cc;
}

.content {
	flex-grow: 1;
	padding: 40px;
	background-color: #eef4ff;
}

.assignments-container {
	display: flex;
	flex-wrap: wrap;
	gap: 7px;
	justify-content: center;
	position: absolute;
/*  	margin-left: 17%;*/
/* 	margin-top: 19%; */
	width: 70%;
	left: 25%;
	top:35%;
}

.assignment-card {
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	width: 300px;
	padding: 20px;
	transition: transform 0.3s ease;
}

.assignment-card:hover {
	transform: translateY(-5px);
}

.assignment-card h3 {
	margin-top: 0;
}

.assignment-card p {
	margin: 5px 0;
}

.submission {
	margin-top: 10px;
}

.submission a, .submission .upload-btn {
	display: block;
	text-align: center;
	padding: 10px;
	background-color: #28a745;
	color: white;
	border-radius: 5px;
	text-decoration: none;
	transition: background-color 0.3s ease;
}

.submission a:hover, .submission .upload-btn:hover {
	background-color: #218838;
}

.submission .upload-btn {
	border: none;
	cursor: pointer;
}

@media ( max-width : 768px) {
	.container {
		flex-direction: column;
	}
	.sidebar {
		width: 100%;
	}
	.content {
		padding: 20px;
	}
}
</style>
</head>
<body>

	<div class="header">
		<h2>Assignments</h2>
		<a href="viewcontent.jsp" class="btn">View Your Courses</a>
	</div>
	 

	<div class="assignments-container">
		<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int studentId = 0;
		HttpSession se = request.getSession(false);
		String username = (session != null) ? (String) session.getAttribute("username") : null;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
		String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
			// Get student ID from username
			String idQuery = "SELECT students.student_id FROM users INNER JOIN students ON users.student_id = students.student_id WHERE users.username = ?";
			pstmt = conn.prepareStatement(idQuery);
			pstmt.setString(1, username);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				studentId = rs.getInt("student_id");
			} else {
				throw new Exception("Student not found for the given username.");
			}
			rs.close();
			pstmt.close();

			// Get assignments for registered courses
			String sql = "SELECT c.course_code, a.assignment_id, a.assignment_title, a.assignment_description, a.deadline "
			+ "FROM assignments a JOIN courses c ON a.course_id = c.course_id "
			+ "JOIN registrations r ON r.course_id = c.course_id WHERE r.student_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, studentId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String courseCode = rs.getString("course_code");
				int assignmentId = rs.getInt("assignment_id");
				String title = rs.getString("assignment_title");
				String description = rs.getString("assignment_description");
				//Date deadline = rs.getDate("deadline");

				String submissionCheckSql = "SELECT submission FROM submissions WHERE student_id = ? AND assignment_id = ?";
				PreparedStatement pstmt2 = conn.prepareStatement(submissionCheckSql);
				pstmt2.setInt(1, studentId);
				pstmt2.setInt(2, assignmentId);
				ResultSet rs2 = pstmt2.executeQuery();

				String submissionLink = null;
				if (rs2.next()) {
			submissionLink = rs2.getString("submission");
				}
				rs2.close();
				pstmt2.close();
		%>
		 <%-- <a href="viewStudentScore.jsp?studentId=<%= studentId %>" class="btn">View Your score</a> --%>
		<div class="assignment-card">
			<h3><%=title%></h3>
			<p>
				<strong>Course Code:</strong>
				<%=courseCode%></p>
			<p>
				<strong>Description:</strong>
				<%=description%></p>
			<p>
				<strong>Deadline:</strong>
				<%=rs.getDate("deadline")%></p>
			<div class="submission">
				<%
				if (submissionLink != null) {
				%>
				<a href="<%=submissionLink%>" target="_blank">View your
					submission</a>
				<%
				} else {
				%>
				<form action="submitSolution.jsp" method="post">
					<input type="hidden" name="assignment_id" value="<%=assignmentId%>">
					<input type="hidden" name="student_id" value="<%=studentId%>">
					<input type="text" name="url" placeholder="Enter solution URL"
						required> <input type="submit" value="Upload"
						class="upload-btn">
				</form>
				<%
				}
				%>
			</div>
		</div>
		<%
		}
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		try {
		if (rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();
		if (conn != null)
			conn.close();
		} catch (SQLException e) {
		e.printStackTrace();
		}
		}
		%>
	</div>

	<script>
		// You can add JavaScript here if needed for further interactivity
	</script>

</body>
</html>
