<%@ page language="java" 
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ include file="adminDashboard.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Manage Faculty</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">Manage Faculty</h1>

    <!-- Form to add faculty -->
    <form action="facultyAction.jsp" method="post" class="mb-5">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label for="facultyId">Faculty ID:</label>
            <input type="number" id="facultyId" name="facultyId" class="form-control" required>
        </div>
        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Faculty</button>
    </form>

    <!-- Table to display and delete faculty -->
    <h2>Delete Faculty</h2>
    <form action="facultyAction.jsp" method="post">
        <input type="hidden" name="action" value="delete">
        <div class="form-group">
            <label for="facultySelect">Select Faculty to Delete:</label>
            <select id="facultySelect" name="facultyId" class="form-control" required>
                <option value="">Select Faculty</option>
                <%
                String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
                String dbUser = "avnadmin";
                String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        String query = "SELECT facultyId, name FROM faculty";
                        pstmt = conn.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            String id = rs.getString("facultyId");
                            String name = rs.getString("name");
                %>
                <option value="<%= id %>"><%= id %> - <%= name %></option>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
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
            </select>
        </div>
        <button type="submit" class="btn btn-danger">Delete Faculty</button>
    </form>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
