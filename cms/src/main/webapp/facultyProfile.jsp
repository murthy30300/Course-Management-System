<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Faculty Profile</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<a href="facultyHome.jsp" class="con-anchor" style="text-decoration: none;"><svg
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
			height="24" color="#000000" fill="none">
    <path
				d="M4.80823 9.44118L6.77353 7.46899C8.18956 6.04799 8.74462 5.28357 9.51139 5.55381C10.4675 5.89077 10.1528 8.01692 10.1528 8.73471C11.6393 8.73471 13.1848 8.60259 14.6502 8.87787C19.4874 9.78664 21 13.7153 21 18C19.6309 17.0302 18.2632 15.997 16.6177 15.5476C14.5636 14.9865 12.2696 15.2542 10.1528 15.2542C10.1528 15.972 10.4675 18.0982 9.51139 18.4351C8.64251 18.7413 8.18956 17.9409 6.77353 16.5199L4.80823 14.5477C3.60275 13.338 3 12.7332 3 11.9945C3 11.2558 3.60275 10.6509 4.80823 9.44118Z"
				stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
				stroke-linejoin="round" />
</svg> back to home</a>
<div class="container mt-5">
    <h1 class="mb-4">Faculty Profile</h1>
    <h3 class="font-weight-light mb-4">
        Welcome, 
        <b>
        <%
            HttpSession fn = request.getSession(false);
            String username = "Guest";
            if (fn != null) {
                username = (String) fn.getAttribute("username");
                if (username == null) {
                    username = "Guest";
                }
            }
            out.print(username);
            String un = username;

            int facultyId = 0;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

           /*  String dbURL = "jdbc:mysql://localhost:3306/db";
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
                out.println("<div class='alert alert-danger' role='alert'>Database connection problem!</div>");
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
        </b>
    </h3>
    <%
        String name = "", department = "", email = "", phone = "", address = "", city = "", state = "", zip = "", country = "", dob = "", gender = "", qualification = "", specialization = "", linkedin = "", website = "";
        int experience = 0;
        boolean isFacultyPresent = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "SELECT * FROM faculty WHERE facultyId = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, facultyId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                isFacultyPresent = true;
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

    <%
        if (isFacultyPresent) {
    %>
        <h2>Faculty Details</h2>
        <table class="table table-bordered">
            <tr>
                <th>Faculty ID</th>
                <td><%= facultyId %></td>
            </tr>
            <tr>
                <th>Name</th>
                <td><%= name %></td>
            </tr>
            <tr>
                <th>Department</th>
                <td><%= department %></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%= email %></td>
            </tr>
            <tr>
                <th>Phone</th>
                <td><%= phone %></td>
            </tr>
            <tr>
                <th>Address</th>
                <td><%= address %></td>
            </tr>
            <tr>
                <th>City</th>
                <td><%= city %></td>
            </tr>
            <tr>
                <th>State</th>
                <td><%= state %></td>
            </tr>
            <tr>
                <th>ZIP</th>
                <td><%= zip %></td>
            </tr>
            <tr>
                <th>Country</th>
                <td><%= country %></td>
            </tr>
            <tr>
                <th>Date of Birth</th>
                <td><%= dob %></td>
            </tr>
            <tr>
                <th>Gender</th>
                <td><%= gender %></td>
            </tr>
            <tr>
                <th>Qualification</th>
                <td><%= qualification %></td>
            </tr>
            <tr>
                <th>Experience</th>
                <td><%= experience %> years</td>
            </tr>
            <tr>
                <th>Specialization</th>
                <td><%= specialization %></td>
            </tr>
            <tr>
                <th>LinkedIn</th>
                <td><%= linkedin %></td>
            </tr>
            <tr>
                <th>Website</th>
                <td><%= website %></td>
            </tr>
        </table>

        <!-- Edit Button -->
        <form action="facultyEdit.jsp" method="get" class="mt-3">
            <input type="hidden" name="facultyId" value="<%= facultyId %>">
            <input type="submit" value="Edit" class="btn btn-secondary">
        </form>

    <%
        } else {
    %>
        <h2>Enter Faculty Details</h2>
        <form action="facultySave.jsp" method="post" class="form-horizontal">
            <input type="hidden" id="facultyId" name="facultyId" value="<%= facultyId %>"/>
            <div class="form-group">
                <label for="name" class="col-sm-2 control-label">Name:</label>
                <div class="col-sm-10">
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="department" class="col-sm-2 control-label">Department:</label>
                <div class="col-sm-10">
                    <input type="text" id="department" name="department" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="email" class="col-sm-2 control-label">Email:</label>
                <div class="col-sm-10">
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="phone" class="col-sm-2 control-label">Phone:</label>
                <div class="col-sm-10">
                    <input type="text" id="phone" name="phone" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="address" class="col-sm-2 control-label">Address:</label>
                <div class="col-sm-10">
                    <input type="text" id="address" name="address" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="city" class="col-sm-2 control-label">City:</label>
                <div class="col-sm-10">
                    <input type="text" id="city" name="city" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="state" class="col-sm-2 control-label">State:</label>
                <div class="col-sm-10">
                    <input type="text" id="state" name="state" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="zip" class="col-sm-2 control-label">ZIP Code:</label>
                <div class="col-sm-10">
                    <input type="text" id="zip" name="zip" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="country" class="col-sm-2 control-label">Country:</label>
                <div class="col-sm-10">
                    <input type="text" id="country" name="country" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="dob" class="col-sm-2 control-label">Date of Birth:</label>
                <div class="col-sm-10">
                    <input type="date" id="dob" name="dob" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="gender" class="col-sm-2 control-label">Gender:</label>
                <div class="col-sm-10">
                    <input type="text" id="gender" name="gender" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="qualification" class="col-sm-2 control-label">Qualification:</label>
                <div class="col-sm-10">
                    <input type="text" id="qualification" name="qualification" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="experience" class="col-sm-2 control-label">Years of Experience:</label>
                <div class="col-sm-10">
                    <input type="text" id="experience" name="experience" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="specialization" class="col-sm-2 control-label">Specialization:</label>
                <div class="col-sm-10">
                    <input type="text" id="specialization" name="specialization" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label for="linkedin" class="col-sm-2 control-label">LinkedIn Profile:</label>
                <div class="col-sm-10">
                    <input type="url" id="linkedin" name="linkedin" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <label for="website" class="col-sm-2 control-label">Personal Website:</label>
                <div class="col-sm-10">
                    <input type="url" id="website" name="website" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="submit" value="Submit" class="btn btn-primary">
                </div>
            </div>
        </form>
    <%
        }
    %>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
