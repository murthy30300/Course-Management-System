<%@ page
	import="java.sql.*, java.io.*, javax.servlet.http.*, javax.servlet.*,java.nio.*,javax.servlet.annotation.*,java.nio.file.*"%>
	
 <%@ include file="1base.jsp" %> .
<html>

<head>
<title>View Assignments</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%
	int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));

	int studentId = Integer.parseInt(request.getParameter("student_id"));
	String url = request.getParameter("url");

	
	Connection conn = null;
	PreparedStatement pstmt = null;

	//Class.forName("com.mysql.cj.jdbc.Driver");

	try {
		//conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
			String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        	String dbUser = "avnadmin";
        	String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
		 String sql = "INSERT INTO submissions (assignment_id, student_id, submission) VALUES (?, ?, ?)";
         pstmt = conn.prepareStatement(sql);
         pstmt.setInt(1, assignmentId);
         pstmt.setInt(2, studentId);
         pstmt.setString(3, url);
		
	 pstmt.execute();
		

	} catch (Exception e) {
		e.printStackTrace();
	} 
	
	%>
</body>
</html>

