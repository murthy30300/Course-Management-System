<%@ page import="java.sql.*,java.util.*"%>
<html>
<head>
<title>View Course Videos</title>
<script type="text/javascript">
	function loadVideo(videoLink) {
		var videoFrame = document.getElementById("videoFrame");
		videoFrame.src = videoLink + "?autoplay=1";
		videoFrame.style.display = "block";
	}
</script>
</head>
<body>
	<h2>Course Videos</h2>
	<table border="1">
		<tr>
			<th>Course Code</th>
			<th>Video Title</th>
			<th>Watch Video</th>
		</tr>
		<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int studentId = 1;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
			String sql = "SELECT c.course_code, v.video_title, v.video_link " + "FROM course_videos v "
			+ "JOIN courses c ON v.course_id = c.course_id " + "JOIN registrations r ON c.course_id = r.course_id "
			+ "WHERE r.student_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, studentId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String courseCode = rs.getString("course_code");
				String videoTitle = rs.getString("video_title");
				String videoLink = rs.getString("video_link");
				out.println(videoLink);
		%>
		<tr>
			<td><%=courseCode%></td>
			<td><%=videoTitle%></td>
			<td>
			<a href="javascript:void(0);"
				onclick="loadVideo('<%= videoLink%>');">Watch
				Video</a>
			<br>
			<br>
			<iframe id="videoFrame" width="560" height="315"
				style="display: none;" frameborder="0" allowfullscreen></iframe></td>
		</tr>



		<%
		}
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		if (rs != null)
		rs.close();
		if (pstmt != null)
		pstmt.close();
		if (conn != null)
		conn.close();
		}
		%>
	</table>
	<br>
	<iframe id="videoFrame" width="560" height="315" style="display: none;"
		frameborder="0" allowfullscreen></iframe>
</body>
</html>