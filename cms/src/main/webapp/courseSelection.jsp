<%@ page import="java.sql.*, java.util.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="1base.jsp" %> 

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="style.css">
<link rel="shortcut icon"
	href="https://e7.pngegg.com/pngimages/1003/697/png-clipart-teacher-illustration-training-expert-management-education-learning-skills-certificate-icon-miscellaneous-blue-thumbnail.png"
	type="image/x-icon">
<title>Course management</title>
<style>.right-course {
	display: flex;
	position: absolute;
	top: 182px;
	width: 50%;
	
}
</style>

</head>

<body>

		<div class="right-course">
			
				<div
					style="font-family: 'arial', sans-serif !important; text-align: center; font-size: 20px; margin-top: 30px;">
					<h3 style="font-weight: 30px;">
						<!-- Welcome --><b> <%
 //HttpSession pk = request.getSession(false); 
 String username = (pk != null) ? (String) pk.getAttribute("username") : "Guest";
 //out.print((username != null) ? username : "Guest"); 

/*  HttpSession session = request.getSession(false);   Retrieve existing session if it exists
//String username=null;
if (session1 != null) {
     username = (String) session.getAttribute("username");
     //Use username as needed
}  */

 %>
						</b>
					</h3>
				</div>
			

			<%
			int studentId = 0; // Assume this is retrieved from session or login context
			List<String[]> selectedCourses = new ArrayList<>();
			String us = (pk != null) ? (String) pk.getAttribute("username") : null;

			if (username != null) {
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
			        String dbUser = "avnadmin";
			        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
			        
					try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
				String idQuery = "SELECT students.student_id FROM users INNER JOIN students ON users.student_id = students.student_id WHERE users.username = ?";
				try (PreparedStatement pstmt = conn.prepareStatement(idQuery)) {
					pstmt.setString(1, us);
					try (ResultSet rst = pstmt.executeQuery()) {
						if (rst.next()) {
							studentId = rst.getInt("student_id");
						} else {
							throw new Exception("Student not found for the given username.");
						}
					}
				}

				String checkQuery = "SELECT c.course_code, c.course_name, c.instructor_name FROM registrations r JOIN courses c ON r.course_id = c.course_id WHERE r.student_id = ?";
				try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
					checkStmt.setInt(1, studentId);
					try (ResultSet rs = checkStmt.executeQuery()) {
						while (rs.next()) {
							String[] courseDetails = new String[3];
							courseDetails[0] = rs.getString("course_code");
							courseDetails[1] = rs.getString("course_name");
							courseDetails[2] = rs.getString("instructor_name");
							selectedCourses.add(courseDetails);
						}
					}
				}

				if (selectedCourses.isEmpty()) {
					String query = "SELECT course_id, course_code, course_name FROM courses";
					try (Statement stmt = conn.createStatement(); ResultSet courseRs = stmt.executeQuery(query)) {
						List<String> courses = new ArrayList<>();
						while (courseRs.next()) {
							courses.add(courseRs.getString("course_id") + "," + courseRs.getString("course_code") + " - "
									+ courseRs.getString("course_name"));
						}

						int[][] courseRanges = { { 0, 2 }, { 2, 5 }, { 5, 8 }, { 8, 10 }, { 10, 12 } };
			%>

			<form action="registerCourses.jsp" method="post" class="form-group-1">
				<h1>Select Your Courses</h1>
				<input type="hidden" name="studentId" value="<%=studentId%>" />
				<%
				for (int i = 0; i < 5; i++) {
				%>
				<div>
					<label for="course<%=i + 1%>">Course <%=i + 1%>:
					</label> <select name="course<%=i + 1%>">
						<%
						int start = courseRanges[i][0];
						int end = courseRanges[i][1];
						for (int j = start; j < end && j < courses.size(); j++) {
							String[] courseDetails = courses.get(j).split(",");
						%>
						<option value="<%=courseDetails[0]%>"><%=courseDetails[1]%></option>
						<%
						}
						%>
					</select>
				</div>
				<%
				}
				%>
				<input type="submit" value="Register" class="reg-btn">
			</form>
			<%
			}
			} else {
			%>
			<div class="warning">
<h2>You have already registered these
					courses! contact administrator for modifications</div>
				</h2>
			<table>
				
				<tr>
					<th>Course Code</th>
					<th>Course Name</th>
					<th>Instructor</th>
				</tr>
				<%
				for (String[] course : selectedCourses) {
				%>
				<tr>
					<td><%=course[0]%></td>
					<td><%=course[1]%></td>
					<td><%=course[2]%></td>
				</tr>
				<%
				}
				%>
			</table>
			<%
			}
			}
			} catch (Exception e) {
			e.printStackTrace();
			}
			} else {
			out.print("No valid user session found.");
			}
			%>
		</div>
</body>

</html>

