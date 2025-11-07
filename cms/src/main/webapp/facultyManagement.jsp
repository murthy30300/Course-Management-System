<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ include file="adminDashboard.jsp" %> 
<%
    HttpSession session8 = request.getSession(false);
    if (session8 == null || session8.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
    }

    String action = request.getParameter("action");
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
      //  Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
		String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        if ("add".equals(action)) {
            int facultyId = Integer.parseInt(request.getParameter("facultyId"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            String insertQuery = "INSERT INTO faculty_user (faculty_id, faculty_username, f_password) VALUES (?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(insertQuery);
            stmt.setInt(1, facultyId);
            stmt.setString(2, username);
            stmt.setString(3, password);
            stmt.executeUpdate();
            stmt.close();
            message = "Faculty added successfully.";
        } else if ("edit".equals(action)) {
            int facultyId = Integer.parseInt(request.getParameter("facultyId"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            String updateQuery = "UPDATE faculty_user SET faculty_username = ?, f_password = ? WHERE faculty_id = ?";
            PreparedStatement stmt = con.prepareStatement(updateQuery);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setInt(3, facultyId);
            stmt.executeUpdate();
            stmt.close();
            message = "Faculty updated successfully.";
        } else if ("delete".equals(action)) {
            int facultyId = Integer.parseInt(request.getParameter("facultyId"));

            String deleteQuery = "DELETE FROM faculty_user WHERE faculty_id = ?";
            PreparedStatement stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, facultyId);
            stmt.executeUpdate();
            stmt.close();
            message = "Faculty deleted successfully.";
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
    <title>Faculty Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h2>Faculty Management</h2>
<!--     <a href="adminDashboard.jsp">back dashboard</a> -->
    <div class="alert alert-info"><%= message %></div>
    <div class="row">
        <div class="col-md-4">
            <h3>Add/Edit Faculty</h3>
            <form action="facultyManagement.jsp" method="post">
                <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "add" %>">
                <div class="form-group">
                    <label for="facultyId">Faculty ID:</label>
                    <input type="number" id="facultyId" name="facultyId" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary"><%= request.getParameter("action") != null ? "Update" : "Add" %> Faculty</button>
            </form>
        </div>
        <div class="col-md-8">
            <h3>Faculty List</h3>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Faculty ID</th>
                        <th>Username</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                            String query = "SELECT faculty_id, faculty_username FROM faculty_user";
                            PreparedStatement stmt = con.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("faculty_id") %></td>
                        <td><%= rs.getString("faculty_username") %></td>
                        <td>
                            <a href="facultyManagement.jsp?action=edit&facultyId=<%= rs.getInt("faculty_id") %>&username=<%= rs.getString("faculty_username") %>" class="btn btn-warning">Edit</a>
                            <a href="facultyManagement.jsp?action=delete&facultyId=<%= rs.getInt("faculty_id") %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this faculty member?');">Delete</a>
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
