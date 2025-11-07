<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ include file="adminDashboard.jsp" %> 
<%
    HttpSession session9 = request.getSession(false);
    if (session9 == null || session9.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
    }

    String action = request.getParameter("action");
    String message = "";

    try {
    	String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        if ("add".equals(action)) {
        	
            String courseCode = request.getParameter("courseCode");
            String courseName = request.getParameter("courseName");
            String instructorName = request.getParameter("instructorName");

            String insertQuery = "INSERT INTO courses (course_code, course_name, instructor_name) VALUES (?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(insertQuery);
            stmt.setString(1, courseCode);
            stmt.setString(2, courseName);
            stmt.setString(3, instructorName);
            stmt.executeUpdate();
            stmt.close();
            message = "Course added successfully.";
        } else if ("edit".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String courseCode = request.getParameter("courseCode");
            String courseName = request.getParameter("courseName");
            String instructorName = request.getParameter("instructorName");

            String updateQuery = "UPDATE courses SET course_code = ?, course_name = ?, instructor_name = ? WHERE course_id = ?";
            PreparedStatement stmt = con.prepareStatement(updateQuery);
            stmt.setString(1, courseCode);
            stmt.setString(2, courseName);
            stmt.setString(3, instructorName);
            stmt.setInt(4, courseId);
            stmt.executeUpdate();
            stmt.close();
            message = "Course updated successfully.";
        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String deleteQuery = "DELETE FROM courses WHERE course_id = ?";
            PreparedStatement stmt = con.prepareStatement(deleteQuery);
            stmt.setInt(1, courseId);
            stmt.executeUpdate();
            stmt.close();
            message = "Course deleted successfully.";
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
    <title>Course Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h2>Course Management</h2>
<!--     <a href="adminDashboard.jsp">Back to Dashboard</a> -->
    <div class="alert alert-info"><%= message %></div>
    <div class="row">
        <div class="col-md-4">
            <h3>Add/Edit/Delete Course</h3>
            <form action="courseManagement.jsp" method="post">
                <input type="hidden" name="action" value="<%= action != null ? action : "add" %>">
                <div class="form-group">
                    <label for="courseAction">Action:</label>
                    <select id="courseAction" name="action" class="form-control" required>
                        <option value="add" <%= "add".equals(action) ? "selected" : "" %>>Add</option>
                        <option value="edit" <%= "edit".equals(action) ? "selected" : "" %>>Edit</option>
                        <option value="delete" <%= "delete".equals(action) ? "selected" : "" %>>Delete</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="courseId">Course ID:</label>
                    <input type="text" id="courseId" name="courseId" class="form-control" value="<%= request.getParameter("courseId") %>" required>
                </div>
                <div class="form-group">
                    <label for="courseCode">Course Code:</label>
                    <input type="text" id="courseCode" name="courseCode" class="form-control" value="<%= request.getParameter("courseCode") %>" required>
                </div>
                <div class="form-group">
                    <label for="courseName">Course Name:</label>
                    <input type="text" id="courseName" name="courseName" class="form-control" value="<%= request.getParameter("courseName") %>" required>
                </div>
                <div class="form-group">
                    <label for="instructorName">Instructor Name:</label>
                    <input type="text" id="instructorName" name="instructorName" class="form-control" value="<%= request.getParameter("instructorName") %>" required>
                </div>
                <button type="submit" class="btn btn-primary"><%= action != null ? "Update" : "Add" %> Course</button>
            </form>
        </div>
        <div class="col-md-8">
            <h3>Course List</h3>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Course ID</th>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Instructor Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                            String query = "SELECT course_id, course_code, course_name, instructor_name FROM courses";
                            PreparedStatement stmt = con.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("course_id") %></td>
                        <td><%= rs.getString("course_code") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getString("instructor_name") %></td>
                        <td>
                            <a href="courseManagement.jsp?action=edit&courseId=<%= rs.getInt("course_id") %>&courseCode=<%= rs.getString("course_code") %>&courseName=<%= rs.getString("course_name") %>&instructorName=<%= rs.getString("instructor_name") %>" class="btn btn-warning">Edit</a>
                            <a href="courseManagement.jsp?action=delete&courseId=<%= rs.getInt("course_id") %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this course?');">Delete</a>
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
