<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ include file="adminDashboard.jsp" %> 
<%
    HttpSession session7 = request.getSession(false);
    if (session7 == null || session7.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
    }

    String action = request.getParameter("action");
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        //Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        if ("add".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            String insertQuery = "INSERT INTO users (student_id, username, email, password) VALUES (?, ?, ?,?)";
            PreparedStatement stmt = con.prepareStatement(insertQuery);
            stmt.setInt(1, studentId);
            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, password);
            stmt.executeUpdate();
            stmt.close();
            message = "Student added successfully.";
        } else if ("edit".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            String updateQuery = "UPDATE users SET username = ?, email = ?,password=? WHERE student_id = ?";
            PreparedStatement stmt = con.prepareStatement(updateQuery);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setInt(4, studentId);
            stmt.executeUpdate();
            stmt.close();
            message = "Student updated successfully.";
        } else if ("delete".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));

            String deleteQuery = "DELETE FROM users WHERE student_id = ?";
            PreparedStatement stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, studentId);
            stmt.executeUpdate();
            stmt.close();
            message = "Student deleted successfully.";
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
    <title>Student Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
</head>
<body>
<div class="container">
<!-- 		<a href="adminDashboard.jsp">back dashboard</a> -->
    <h2>Student Management</h2>
    
    <div class="alert alert-info"><%= message %></div>
    <div class="row">
        <div class="col-md-4">
            <h3>Add/Edit Student</h3>
            <form action="studentManagement.jsp" method="post">
                <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "add" %>">
                <div class="form-group">
                    <label for="studentId">Student ID:</label>
                    <input type="number" id="studentId" name="studentId" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="text" id="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary"><%= request.getParameter("action") != null ? "Update" : "Add" %> Student</button>
            </form>
        </div>
        <div class="col-md-8">
            <h3>Student List</h3>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                            String query = "SELECT student_id, username, email FROM users";
                            PreparedStatement stmt = con.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("student_id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td>
                            <a href="studentManagement.jsp?action=edit&studentId=<%= rs.getInt("student_id") %>&name=<%= rs.getString("username") %>&email=<%= rs.getString("email") %>" class="btn btn-warning">Edit</a>
                            <a href="studentManagement.jsp?action=delete&studentId=<%= rs.getInt("student_id") %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this student?');">Delete</a>
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
