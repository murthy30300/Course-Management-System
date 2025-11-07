<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Faculty Profile</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">Edit Faculty Profile</h1>
    <%
        String facultyId = request.getParameter("facultyId");
        if (facultyId == null) {
            out.println("Faculty ID is missing.");
            return;
        }

      /*   String dbURL = "jdbc:mysql://localhost:3306/db";
        String dbUser = "root";
        String dbPassword = "admin"; */

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
       
        String name = "", department = "", email = "", phone = "", address = "", city = "", state = "", zip = "", country = "", dob = "", gender = "", qualification = "", specialization = "", linkedin = "", website = "";
        int experience = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
             conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "SELECT * FROM faculty WHERE facultyId = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, facultyId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                department = rs.getString("department");
                email = rs.getString("email");
                phone = rs.getString("phone");
                address = rs.getString("address");
                city = rs.getString("city");
                state = rs.getString("state");
                zip = rs.getString("zip");
                country = rs.getString("country");
                dob = rs.getString("dob");
                gender = rs.getString("gender");
                qualification = rs.getString("qualification");
                experience = rs.getInt("experience");
                specialization = rs.getString("specialization");
                linkedin = rs.getString("linkedin");
                website = rs.getString("website");
            } else {
                out.println("Faculty details not found.");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger' role='alert'>Database connection problem!</div>");
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

    <form action="facultyUpdate.jsp" method="post" class="form-horizontal">
        <input type="hidden" name="facultyId" value="<%= facultyId %>"/>
        <div class="form-group">
            <label for="name" class="col-sm-2 control-label">Name:</label>
            <div class="col-sm-10">
                <input type="text" id="name" name="name" class="form-control" value="<%= name %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="department" class="col-sm-2 control-label">Department:</label>
            <div class="col-sm-10">
                <input type="text" id="department" name="department" class="form-control" value="<%= department %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="email" class="col-sm-2 control-label">Email:</label>
            <div class="col-sm-10">
                <input type="email" id="email" name="email" class="form-control" value="<%= email %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="phone" class="col-sm-2 control-label">Phone:</label>
            <div class="col-sm-10">
                <input type="text" id="phone" name="phone" class="form-control" value="<%= phone %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="address" class="col-sm-2 control-label">Address:</label>
            <div class="col-sm-10">
                <input type="text" id="address" name="address" class="form-control" value="<%= address %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="city" class="col-sm-2 control-label">City:</label>
            <div class="col-sm-10">
                <input type="text" id="city" name="city" class="form-control" value="<%= city %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="state" class="col-sm-2 control-label">State:</label>
            <div class="col-sm-10">
                <input type="text" id="state" name="state" class="form-control" value="<%= state %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="zip" class="col-sm-2 control-label">ZIP Code:</label>
            <div class="col-sm-10">
                <input type="text" id="zip" name="zip" class="form-control" value="<%= zip %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="country" class="col-sm-2 control-label">Country:</label>
            <div class="col-sm-10">
                <input type="text" id="country" name="country" class="form-control" value="<%= country %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="dob" class="col-sm-2 control-label">Date of Birth:</label>
            <div class="col-sm-10">
                <input type="date" id="dob" name="dob" class="form-control" value="<%= dob %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="gender" class="col-sm-2 control-label">Gender:</label>
            <div class="col-sm-10">
                <input type="text" id="gender" name="gender" class="form-control" value="<%= gender %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="qualification" class="col-sm-2 control-label">Qualification:</label>
            <div class="col-sm-10">
                <input type="text" id="qualification" name="qualification" class="form-control" value="<%= qualification %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="experience" class="col-sm-2 control-label">Years of Experience:</label>
            <div class="col-sm-10">
                <input type="number" id="experience" name="experience" class="form-control" value="<%= experience %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="specialization" class="col-sm-2 control-label">Specialization:</label>
            <div class="col-sm-10">
                <input type="text" id="specialization" name="specialization" class="form-control" value="<%= specialization %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="linkedin" class="col-sm-2 control-label">LinkedIn Profile:</label>
            <div class="col-sm-10">
                <input type="url" id="linkedin" name="linkedin" class="form-control" value="<%= linkedin %>">
            </div>
        </div>
        <div class="form-group">
            <label for="website" class="col-sm-2 control-label">Personal Website:</label>
            <div class="col-sm-10">
                <input type="url" id="website" name="website" class="form-control" value="<%= website %>">
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <input type="submit" value="Update" class="btn btn-primary">
            </div>
        </div>
    </form>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
