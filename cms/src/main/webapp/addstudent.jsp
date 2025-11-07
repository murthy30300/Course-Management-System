<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ include file="adminDashboard.jsp" %>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Manage Students</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
</head>
<body>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver"); // Load MySQL JDBC Driver
        String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        String action = request.getParameter("action");
        String studentId = request.getParameter("studentId");
        String student_name = request.getParameter("student_name");

        if ("add".equals(action)) {
            String insertSQL = "INSERT INTO students (student_id, student_name) VALUES (?, ?)";
            ps = conn.prepareStatement(insertSQL);
            ps.setString(1, studentId);
            ps.setString(2, student_name);
            ps.executeUpdate();
        } else if ("update".equals(action)) {
            String updateSQL = "UPDATE students SET student_name=? WHERE student_id=?";
            ps = conn.prepareStatement(updateSQL);
            ps.setString(1, student_name);
            ps.setString(2, studentId);
            ps.executeUpdate();
        } else if ("delete".equals(action)) {
            String deleteSQL = "DELETE FROM students WHERE student_id=?";
            ps = conn.prepareStatement(deleteSQL);
            ps.setString(1, studentId);
            ps.executeUpdate();
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */}
        if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */}
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */}
    }
%>

<div class="container">
    <h2>Manage Students</h2>
    <form action="addstudent.jsp" method="post">
        <input type="hidden" name="action" value="<%= request.getParameter("action") != null ? request.getParameter("action") : "add" %>">
        <div class="form-group">
            <label for="studentId">Student ID:</label>
            <input type="number" id="studentId" name="studentId" class="form-control" value="<%= request.getParameter("studentId") %>" required>
        </div>
        <div class="form-group">
            <label for="student_name">Name:</label>
            <input type="text" id="student_name" name="student_name" class="form-control" value="<%= request.getParameter("student_name") %>" required>
        </div>
        <button type="submit" class="btn btn-primary"><%= request.getParameter("action") != null && request.getParameter("action").equals("update") ? "Update" : "Add" %> Student</button>
    </form>

    <h3>Students List</h3>
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <!-- <th>Actions</th> -->
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                    String selectSQL = "SELECT * FROM students";
                    ps = conn.prepareStatement(selectSQL);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String id = rs.getString("student_id");
                        String studentName = rs.getString("student_name");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= studentName %></td>
                <td>
                    <!-- View button (you can implement view details functionality) -->
                    <form action="viewstudent.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="studentId" value="<%= id %>">
                        <!-- <button type="submit" class="btn btn-info">View</button> -->
                    </form>

                    <!-- Edit button -->
                    <form action="addstudent.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="studentId" value="<%= id %>">
                        <input type="hidden" name="student_name" value="<%= studentName %>">
                      <!--   <button type="submit" class="btn btn-secondary">Edit</button> -->
                    </form>

                    <!-- Delete button -->
                    <form action="addstudent.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="studentId" value="<%= id %>">
                        <!-- <button type="submit" class="btn btn-danger">delete</button> -->
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */}
                    if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */}
                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */}
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>
