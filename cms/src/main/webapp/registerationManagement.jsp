<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ include file="adminDashboard.jsp" %> 
<%
    HttpSession session10 = request.getSession(false);
    if (session10 == null || session10.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
    }

    String action = request.getParameter("action");
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
       // Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        if ("add".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String insertQuery = "INSERT INTO registrations (student_id, course_id) VALUES (?, ?)";
            PreparedStatement stmt = con.prepareStatement(insertQuery);
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            stmt.executeUpdate();
            stmt.close();
            message = "Registration added successfully.";
        } else if ("edit".equals(action)) {
            int registrationId = Integer.parseInt(request.getParameter("registrationId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String updateQuery = "UPDATE registrations SET student_id = ?, course_id = ? WHERE registration_id = ?";
            PreparedStatement stmt = con.prepareStatement(updateQuery);
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            stmt.setInt(3, registrationId);
            stmt.executeUpdate();
            stmt.close();
            message = "Registration updated successfully.";
        } else if ("delete".equals(action)) {
            int registrationId = Integer.parseInt(request.getParameter("registrationId"));

            String deleteQuery = "DELETE FROM registrations WHERE registration_id = ?";
            PreparedStatement stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, registrationId);
            stmt.executeUpdate();
            stmt.close();
            message = "Registration deleted successfully.";
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
</head>
<body>
<div class="container">
<!-- 	<a href="adminDashboard.jsp">back dashboard</a> -->
    <h2>Registration Management</h2>
    <div class="alert alert-info"><%= message %></div>
    <div class="row">
        <div class="col-md-4">
            <h3>Add/Edit Registration</h3>
            <form action="registrationManagement.jsp" method="post">
                <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "add" %>">
                <div class="form-group">
                    <label for="studentId">Student ID:</label>
                    <input type="number" id="studentId" name="studentId" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="courseId">Course ID:</label>
                    <input type="number" id="courseId" name="courseId" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary"><%= request.getParameter("action") != null ? "Update" : "Add" %> Registration</button>
            </form>
        </div>
        <div class="col-md-8">
            <h3>Registration List</h3>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Registration ID</th>
                        <th>Student ID</th>
                        <th>Course ID</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                            String query = "SELECT registration_id, student_id, course_id FROM registrations";
                            PreparedStatement stmt = con.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("registration_id") %></td>
                        <td><%= rs.getInt("student_id") %></td>
                        <td><%= rs.getInt("course_id") %></td>
                        <td>
                            <a href="registrationManagement.jsp?action=edit&registrationId=<%= rs.getInt("registration_id") %>&studentId=<%= rs.getInt("student_id") %>&courseId=<%= rs.getInt("course_id") %>" class="btn btn-warning">Edit</a>
                            <a href="registrationManagement.jsp?action=delete&registrationId=<%= rs.getInt("registration_id") %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this registration?');">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            con.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
