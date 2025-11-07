<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Faculty Home</title>
<link rel="stylesheet" href="faculty.css">
</head>
<body>
	<div class="stats">
			<a href="userlogout.jsp" style="text-decoration: none; display:right;">Logout</a>
		</div>
	<%
	HttpSession fn = request.getSession(false);
	String username = "Guest";
	if (fn != null) {
		username = (String) fn.getAttribute("username");
		if (username == null) {
			username = "Guest";
		}
	}

	String un = username;
	String facultyName = "NA";
	int facultyId = 0;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	/* String dbURL = "jdbc:mysql://localhost:3306/db";
	String dbUser = "root";
	String dbPassword = "admin"; */
	String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
    String dbUser = "avnadmin";
    String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

		String query = "SELECT u.name, u.facultyId FROM faculty u INNER JOIN faculty_user fu ON u.facultyId = fu.faculty_id WHERE fu.faculty_username = ?";
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, un);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			facultyName = rs.getString("name");
			facultyId = rs.getInt("facultyId");
		} else {
			out.println("Faculty not found.");
			return;
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<h2>Database connection problem!</h2>");
		return;
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

	<div class="container">
		<div class="header">
		
		
	
			<div class="logo">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
					width="24" height="24" color="#000000" fill="none">
    <circle cx="12" cy="12" r="10" stroke="currentColor"
						stroke-width="1.5" />
    <path
						d="M7.5 17C9.8317 14.5578 14.1432 14.4428 16.5 17M14.4951 9.5C14.4951 10.8807 13.3742 12 11.9915 12C10.6089 12 9.48797 10.8807 9.48797 9.5C9.48797 8.11929 10.6089 7 11.9915 7C13.3742 7 14.4951 8.11929 14.4951 9.5Z"
						stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
</svg>
			</div>
			<div class="search-bar">
				<input type="text" placeholder="Search...">
			</div>
			<div class="user-info">
				<div class="user-initials"><%=username.substring(0, 1)%></div>
				<div class="user-name"><%=username%></div>
			</div>
			<div class="stats">
		
	</div>
		</div>
		<div class="main">
			<div class="sidebar">
				<ul>
					<li><a href="facultyProfile.jsp?faculty_id=<%=facultyId%>"
						class="active"><svg xmlns="http://www.w3.org/2000/svg"
								viewBox="0 0 24 24" width="32" height="32" color="#ffffff"
								fill="none">
    <path d="M14 8.99988H18" stroke="currentColor" stroke-width="1.5"
									stroke-linecap="round" />
    <path d="M14 12.4999H17" stroke="currentColor" stroke-width="1.5"
									stroke-linecap="round" />
    <rect x="2" y="2.99988" width="20" height="18" rx="5"
									stroke="currentColor" stroke-width="1.5"
									stroke-linejoin="round" />
    <path d="M5 15.9999C6.20831 13.4188 10.7122 13.249 12 15.9999"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
									stroke-linejoin="round" />
    <path
									d="M10.5 8.99988C10.5 10.1044 9.60457 10.9999 8.5 10.9999C7.39543 10.9999 6.5 10.1044 6.5 8.99988C6.5 7.89531 7.39543 6.99988 8.5 6.99988C9.60457 6.99988 10.5 7.89531 10.5 8.99988Z"
									stroke="currentColor" stroke-width="1.5" />
</svg>Profile</a></li>
					<li><a href="facultyUploadAssignment.html"> <svg
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								width="28" height="28" color="#ffffff" fill="none">
    <path
									d="M17.4776 9.01106C17.485 9.01102 17.4925 9.01101 17.5 9.01101C19.9853 9.01101 22 11.0294 22 13.5193C22 15.8398 20.25 17.7508 18 18M17.4776 9.01106C17.4924 8.84606 17.5 8.67896 17.5 8.51009C17.5 5.46695 15.0376 3 12 3C9.12324 3 6.76233 5.21267 6.52042 8.03192M17.4776 9.01106C17.3753 10.1476 16.9286 11.1846 16.2428 12.0165M6.52042 8.03192C3.98398 8.27373 2 10.4139 2 13.0183C2 15.4417 3.71776 17.4632 6 17.9273M6.52042 8.03192C6.67826 8.01687 6.83823 8.00917 7 8.00917C8.12582 8.00917 9.16474 8.38194 10.0005 9.01101"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
									stroke-linejoin="round" />
    <path
									d="M12 13L12 21M12 13C11.2998 13 9.99153 14.9943 9.5 15.5M12 13C12.7002 13 14.0085 14.9943 14.5 15.5"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
									stroke-linejoin="round" />
</svg>Upload Assignments
					</a></li>
					<li><a href="facultyUploadVideo.jsp"><svg
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								width="28" height="28" color="#ffffff" fill="none">
    <path d="M11 8L13 8" stroke="currentColor" stroke-width="1.5"
									stroke-linecap="round" />
    <path
									d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z"
									stroke="currentColor" stroke-width="1.5" />
    <path
									d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
</svg>Upload Video Lectures</a></li>
					<li><a href="viewSubmissionsFaculty.jsp"><svg
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								width="28" height="28" color="#ffffff" fill="none">
    <path
									d="M21.544 11.045C21.848 11.4713 22 11.6845 22 12C22 12.3155 21.848 12.5287 21.544 12.955C20.1779 14.8706 16.6892 19 12 19C7.31078 19 3.8221 14.8706 2.45604 12.955C2.15201 12.5287 2 12.3155 2 12C2 11.6845 2.15201 11.4713 2.45604 11.045C3.8221 9.12944 7.31078 5 12 5C16.6892 5 20.1779 9.12944 21.544 11.045Z"
									stroke="currentColor" stroke-width="1.5" />
    <path
									d="M15 12C15 10.3431 13.6569 9 12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15C13.6569 15 15 13.6569 15 12Z"
									stroke="currentColor" stroke-width="1.5" />
</svg>View Submissions</a></li>
					<li><a href="facultyaddcourse.jsp"><svg
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								width="36" height="36" color="#ffffff" fill="none">
    <path
									d="M20.0002 15C20.0002 16.8638 20.0002 17.7956 19.6957 18.5307C19.2897 19.5108 18.511 20.2895 17.5309 20.6955C16.7958 21 15.8639 21 14.0002 21H11.0002C7.22898 21 5.34334 21 4.17177 19.8284C3.00019 18.6568 3.00021 16.7712 3.00024 12.9999L3.0003 6.99983C3.00032 4.79078 4.79112 3 7.00017 3"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
									stroke-linejoin="round" />
    <path
									d="M10.0002 8.5L10.4339 12.4689C10.4753 12.8007 10.6792 13.0899 10.9864 13.2219C11.6724 13.5165 12.9572 14 14.0002 14C15.0433 14 16.3281 13.5165 17.0141 13.2219C17.3213 13.0899 17.5252 12.8007 17.5666 12.4689L18.0002 8.5M20.5002 7.5V11.2692M14.0002 4L7.00024 7L14.0002 10L21.0002 7L14.0002 4Z"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
									stroke-linejoin="round" />
</svg> View Courses</a></li>
<li><a href="facultyViewForum.jsp">
<svg
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								width="28" height="28" color="#ffffff" fill="none">
    <path d="M11 8L13 8" stroke="currentColor" stroke-width="1.5"
									stroke-linecap="round" />
    <path
									d="M2 11C2 7.70017 2 6.05025 3.02513 5.02513C4.05025 4 5.70017 4 9 4H10C13.2998 4 14.9497 4 15.9749 5.02513C17 6.05025 17 7.70017 17 11V13C17 16.2998 17 17.9497 15.9749 18.9749C14.9497 20 13.2998 20 10 20H9C5.70017 20 4.05025 20 3.02513 18.9749C2 17.9497 2 16.2998 2 13V11Z"
									stroke="currentColor" stroke-width="1.5" />
    <path
									d="M17 8.90585L17.1259 8.80196C19.2417 7.05623 20.2996 6.18336 21.1498 6.60482C22 7.02628 22 8.42355 22 11.2181V12.7819C22 15.5765 22 16.9737 21.1498 17.3952C20.2996 17.8166 19.2417 16.9438 17.1259 15.198L17 15.0941"
									stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
</svg>Forum</a></li>
<a href="facultyViewForum.jsp">Forum</a>
				</ul>
			</div>
			<div class="content">
				<h1>
					Welcome,
					<%=facultyName%>!
				</h1>
				<div class="stats">
					<div class="stat">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="24" height="24" color="#000000" fill="none">
    <path
								d="M4 3H3C2.44772 3 2 3.44772 2 4V18L3.5 21L5 18V4C5 3.44772 4.55228 3 4 3Z"
								stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
    <path
								d="M21 12.0013V8.00072C21 5.64336 21 4.46468 20.2678 3.73234C19.5355 3 18.357 3 16 3H13C10.643 3 9.46447 3 8.73223 3.73234C8 4.46468 8 5.64336 8 8.00072V16.0019C8 18.3592 8 19.5379 8.73223 20.2703C9.35264 20.8908 10.2934 20.9855 12 21"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
    <path d="M12 7H17" stroke="currentColor" stroke-width="1.5"
								stroke-linecap="round" stroke-linejoin="round" />
    <path d="M12 11H17" stroke="currentColor" stroke-width="1.5"
								stroke-linecap="round" stroke-linejoin="round" />
    <path d="M14 19C14 19 15.5 19.5 16.5 21C16.5 21 18 17 22 15"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
    <path d="M2 7H5" stroke="currentColor" stroke-width="1.5"
								stroke-linecap="round" stroke-linejoin="round" />
</svg>
						<p>Upload Assignment</p>
					</div>
					<div class="stat">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="24" height="24" color="#000000" fill="none">
    <path d="M4.5 21.5L8.5 17.5M10.5 17.5L14.5 21.5M9.5 17.5L9.5 22.5"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
    <path
								d="M2 11.875C2 9.81261 2 8.78141 3.02513 8.1407C4.05025 7.5 5.70017 7.5 9 7.5H10C13.2998 7.5 14.9497 7.5 15.9749 8.1407C17 8.78141 17 9.81261 17 11.875V13.125C17 15.1874 17 16.2186 15.9749 16.8593C14.9497 17.5 13.2998 17.5 10 17.5H9C5.70017 17.5 4.05025 17.5 3.02513 16.8593C2 16.2186 2 15.1874 2 13.125V11.875Z"
								stroke="currentColor" stroke-width="1.5" />
    <path
								d="M17 10.2495L17.1259 10.174C19.2417 8.90435 20.2996 8.26954 21.1498 8.57605C22 8.88257 22 9.89876 22 11.9312V13.0685C22 15.1009 22 16.1171 21.1498 16.4236C20.2996 16.7301 19.2417 16.0953 17.1259 14.8257L17 14.7501"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
    <circle cx="12.5" cy="5" r="2.5" stroke="currentColor"
								stroke-width="1.5" />
    <circle cx="7" cy="4.5" r="3" stroke="currentColor"
								stroke-width="1.5" />
</svg>
						<p>Upload Video</p>
					</div>
					<div class="stat">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="24" height="24" color="#000000" fill="none">
    <path
								d="M20.9977 12.5032C20.9977 12.5032 21 12.0338 21 11.5029C21 7.02321 21 4.78334 19.6088 3.39167C18.2175 2 15.9783 2 11.5 2C7.02166 2 4.78249 2 3.39124 3.39167C2 4.78334 2 7.02321 2 11.5029C2 15.9827 2 18.2225 3.39124 19.6142C4.55785 20.7812 6.32067 20.9696 9.5 21"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
    <path d="M2 7H21" stroke="currentColor" stroke-width="1.5"
								stroke-linejoin="round" />
    <path d="M6 16H7M10 12H15M6 12H7" stroke="currentColor"
								stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
    <path d="M17 18.5H17.009" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round" />
    <path
								d="M21.772 18.0225C21.924 18.2357 22 18.3422 22 18.5C22 18.6578 21.924 18.7643 21.772 18.9775C21.089 19.9353 19.3446 22 17 22C14.6554 22 12.911 19.9353 12.228 18.9775C12.076 18.7643 12 18.6578 12 18.5C12 18.3422 12.076 18.2357 12.228 18.0225C12.911 17.0647 14.6554 15 17 15C19.3446 15 21.089 17.0647 21.772 18.0225Z"
								stroke="currentColor" stroke-width="1.5" />
</svg>
						<p>View Submissions</p>
					</div>
					<div class="stat">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="36" height="36" color="#000000" fill="none">
    <path
								d="M20.0002 15C20.0002 16.8638 20.0002 17.7956 19.6957 18.5307C19.2897 19.5108 18.511 20.2895 17.5309 20.6955C16.7958 21 15.8639 21 14.0002 21H11.0002C7.22898 21 5.34334 21 4.17177 19.8284C3.00019 18.6568 3.00021 16.7712 3.00024 12.9999L3.0003 6.99983C3.00032 4.79078 4.79112 3 7.00017 3"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
    <path
								d="M10.0002 8.5L10.4339 12.4689C10.4753 12.8007 10.6792 13.0899 10.9864 13.2219C11.6724 13.5165 12.9572 14 14.0002 14C15.0433 14 16.3281 13.5165 17.0141 13.2219C17.3213 13.0899 17.5252 12.8007 17.5666 12.4689L18.0002 8.5M20.5002 7.5V11.2692M14.0002 4L7.00024 7L14.0002 10L21.0002 7L14.0002 4Z"
								stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
								stroke-linejoin="round" />
</svg>
						<p>Course</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<a href="facultyViewForum.jsp">forum</a>
</body>
</html>
