<%@ page import="java.sql.*,java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Registration Result</title>
</head>
<body>

<%
    String facultyId = request.getParameter("facultyId");
    String name = request.getParameter("name");
    String department = request.getParameter("department");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String zip = request.getParameter("zip");
    String country = request.getParameter("country");
    String dob = request.getParameter("dob");
    String gender = request.getParameter("gender");
    String qualification = request.getParameter("qualification");
    String experience = request.getParameter("experience");
    String specialization = request.getParameter("specialization");
    String linkedin = request.getParameter("linkedin");
    String website = request.getParameter("website");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
/* 
    String dbURL = "jdbc:mysql://localhost:3306/db";
    String dbUser = "root";
    String dbPassword = "admin"; */
    String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
    String dbUser = "avnadmin";
    String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
   

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String checkQuery = "SELECT * FROM faculty WHERE facultyId = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, facultyId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String updateQuery = "UPDATE faculty SET name = ?, department = ?, email = ?, phone = ?, address = ?, city = ?, state = ?, zip = ?, country = ?, dob = ?, gender = ?, qualification = ?, experience = ?, specialization = ?, linkedin = ?, website = ? WHERE facultyId = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, name);
            pstmt.setString(2, department);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, city);
            pstmt.setString(7, state);
            pstmt.setString(8, zip);
            pstmt.setString(9, country);
            pstmt.setDate(10, java.sql.Date.valueOf(dob));  // Assuming dob is in yyyy-mm-dd format
            pstmt.setString(11, gender);
            pstmt.setString(12, qualification);
            pstmt.setInt(13, Integer.parseInt(experience));
            pstmt.setString(14, specialization);
            pstmt.setString(15, linkedin);
            pstmt.setString(16, website);
            pstmt.setString(17, facultyId);

            int row = pstmt.executeUpdate();

            if (row > 0) {
                out.println("<h2>Faculty details have been successfully updated!</h2>");
            } else {
                out.println("<h2>Failed to update faculty details!</h2>");
            }
        } else {
            out.println("<h2>Faculty ID does not exist!</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Database connection problem!</h2>");
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
</body>
</html>


