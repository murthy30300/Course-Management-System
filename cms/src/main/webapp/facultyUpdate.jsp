<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Faculty Details</title>
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
        int experience = Integer.parseInt(request.getParameter("experience"));
        String specialization = request.getParameter("specialization");
        String linkedin = request.getParameter("linkedin");
        String website = request.getParameter("website");

     /*    String dbURL = "jdbc:mysql://localhost:3306/db";
        String dbUser = "root";
        String dbPassword = "admin"; */
        String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        //Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "UPDATE faculty SET name=?, department=?, email=?, phone=?, address=?, city=?, state=?, zip=?, country=?, dob=?, gender=?, qualification=?, experience=?, specialization=?, linkedin=?, website=? WHERE facultyId=?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, department);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, city);
            pstmt.setString(7, state);
            pstmt.setString(8, zip);
            pstmt.setString(9, country);
            pstmt.setString(10, dob);
            pstmt.setString(11, gender);
            pstmt.setString(12, qualification);
            pstmt.setInt(13, experience);
            pstmt.setString(14, specialization);
            pstmt.setString(15, linkedin);
            pstmt.setString(16, website);
            pstmt.setString(17, facultyId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<div class='alert alert-success' role='alert'>Faculty details updated successfully.</div>");
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Failed to update faculty details.</div>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger' role='alert'>Database connection problem!</div>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <a href="facultyProfile.jsp?facultyId=<%= facultyId %>">Back to Profile</a>
</body>
</html>
