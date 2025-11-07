<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Faculty Login</title>
</head>
<body>
	<%
	String username = request.getParameter("fusername");
	String password = request.getParameter("fpassword");
	response.setContentType("text/html");

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		//Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
		PreparedStatement ps = con.prepareStatement("SELECT * FROM faculty_user WHERE faculty_username=? AND f_password=?");
		ps.setString(1, username);
		ps.setString(2, password);

		ResultSet rs = ps.executeQuery();

		if (rs.next()) {

			int fid = rs.getInt("fid");
			HttpSession s = request.getSession();
			session.setAttribute("fid", fid);
			session.setAttribute("username", username);
			response.sendRedirect("facultyHome.jsp");
		} else {
			//request.setAttribute("errorMessage", "Invalid email or password");
			out.println("Invalid credentials");

		}
	} catch (ClassNotFoundException e) { // TODO Auto-generated catch block
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	%>

</body>
</html>