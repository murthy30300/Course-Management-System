<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*,java.io.*" %>
    <%
            HttpSession fn = request.getSession(false);
            if (fn != null) {
                String username = (String) fn.getAttribute("username");
                if (username != null) {
                    out.print(username);
                } else {
                    out.print("Guest");
                }
            } else {
                out.print("Guest");
            }
            String un = (String) fn.getAttribute("username");
           
            int facultyId = 0;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

         /*    String dbURL = "jdbc:mysql://localhost:3306/db";
            String dbUser = "root";
            String dbPassword = "admin"; */

            String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
            String dbUser = "avnadmin";
            String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String query = "SELECT u.facultyId FROM faculty u INNER JOIN faculty_user fu ON u.facultyId = fu.faculty_id WHERE fu.faculty_username = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, un);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    
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
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

</body>
</html>