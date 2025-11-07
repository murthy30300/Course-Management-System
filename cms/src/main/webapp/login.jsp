<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Course management system</title>
</head>
<body>
  <%
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  response.setContentType("text/html");

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    //Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND password=?");
    ps.setString(1, username);
    ps.setString(2, password);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
      
         int uid = rs.getInt("uid");
               /* HttpSession s = request.getSession();
              session.setAttribute("uid", uid);
              session.setAttribute("username", username);
              response.sendRedirect("studenthome.jsp"); */
              HttpSession session1 = request.getSession();
              session1.setAttribute("uid", uid);
              session1.setAttribute("username", username);
              session1.setMaxInactiveInterval(260);
              response.sendRedirect("studenthome.jsp");
    } else {
      request.setAttribute("errorMessage", "Invalid email or password");
     // out.println("Invalid credentials");

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