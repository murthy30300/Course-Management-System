<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Course Management</title>
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
    <h2 class="mb-4">Course Management</h2>
    <a href="facultyHome.jsp" class="btn btn-secondary mb-3">Back</a>
    <button class="btn btn-primary mb-3" data-toggle="modal" data-target="#insertModal">Insert New Course</button>
    
    <form method="POST" action="facultyaddcourse.jsp">
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Select</th>
                        <th>Course ID</th>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Instructor Name</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                       /*  String url = "jdbc:mysql://localhost:3306/db";
                        String user = "root";
                        String password = "admin";
 */
 String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
 String dbUser = "avnadmin";
 String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
 con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                        // Load MySQL JDBC Driver
                        Class.forName("com.mysql.cj.jdbc.Driver");
                       // con = DriverManager.getConnection(url, user, password);

                        ps = con.prepareStatement("SELECT * FROM courses");
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int cid = rs.getInt("course_id");
                            String ccode = rs.getString("course_code");
                            String cname = rs.getString("course_name");
                            String ciid = rs.getString("instructor_name");
                    %>
                    <tr>
                        <td><input type="checkbox" name="selectedCourses" value="<%= cid %>"></td>
                        <td><%= cid %></td>
                        <td><%= ccode %></td>
                        <td><%= cname %></td>
                        <td><%= ciid %></td>
                        <td>
                            <button type="button" class="btn btn-warning btn-sm" data-toggle="modal" data-target="#updateModal" 
                                    data-id="<%= cid %>" data-ccode="<%= ccode %>" data-cname="<%= cname %>" data-ciid="<%= ciid %>">Update</button>
                        </td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("Error: " + e.getMessage());
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    }
                    %>
                </tbody>
            </table>
        </div>
        <button type="submit" name="delete" class="btn btn-danger">Delete Selected</button>
    </form>
</div>

<!-- Insert Modal -->
<div class="modal fade" id="insertModal" tabindex="-1" role="dialog" aria-labelledby="insertModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form method="POST" action="facultyaddcourse.jsp">
        <div class="modal-header">
          <h5 class="modal-title" id="insertModalLabel">Insert New Course</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label for="cid">Course ID</label>
                <input type="number" class="form-control" id="cid" name="cid" required>
            </div>
            <div class="form-group">
                <label for="ccode">Course Code</label>
                <input type="text" class="form-control" id="ccode" name="ccode" required>
            </div>
            <div class="form-group">
                <label for="cname">Course Name</label>
                <input type="text" class="form-control" id="cname" name="cname" required>
            </div>
            <div class="form-group">
                <label for="ciid">Instructor Name</label>
                <input type="text" class="form-control" id="ciid" name="ciid" required>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Insert</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Update Modal -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form method="POST" action="facultyaddcourse.jsp">
        <div class="modal-header">
          <h5 class="modal-title" id="updateModalLabel">Update Course</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="updateCid" name="updateCid">
            <div class="form-group">
                <label for="updateCcode">Course Code</label>
                <input type="text" class="form-control" id="updateCcode" name="ccode" required>
            </div>
            <div class="form-group">
                <label for="updateCname">Course Name</label>
                <input type="text" class="form-control" id="updateCname" name="cname" required>
            </div>
            <div class="form-group">
                <label for="updateCiid">Instructor Name</label>
                <input type="text" class="form-control" id="updateCiid" name="ciid" required>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Update</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $('#updateModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var cid = button.data('id');
        var ccode = button.data('ccode');
        var cname = button.data('cname');
        var ciid = button.data('ciid');

        var modal = $(this);
        modal.find('#updateCid').val(cid);
        modal.find('#updateCcode').val(ccode);
        modal.find('#updateCname').val(cname);
        modal.find('#updateCiid').val(ciid);
    });
</script>

<%
if (request.getMethod().equalsIgnoreCase("POST")) {
    Connection conn = null;
    PreparedStatement pss = null;

    try {
        String url = "jdbc:mysql://localhost:3306/db";
        String user = "root";
        String password = "admin";

        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        if (request.getParameter("delete") != null) {
            String[] selectedCourses = request.getParameterValues("selectedCourses");
            if (selectedCourses != null) {
                for (String courseId : selectedCourses) {
                    pss = conn.prepareStatement("DELETE FROM courses WHERE course_id = ?");
                    pss.setInt(1, Integer.parseInt(courseId));
                    pss.executeUpdate();
                }
            }
        } else if (request.getParameter("updateCid") != null) {
            int cid = Integer.parseInt(request.getParameter("updateCid"));
            String ccode = request.getParameter("ccode");
            String cname = request.getParameter("cname");
            String ciid = request.getParameter("ciid");

            pss = conn.prepareStatement("UPDATE courses SET course_code = ?, course_name = ?, instructor_name = ? WHERE course_id = ?");
            pss.setString(1, ccode);
            pss.setString(2, cname);
            pss.setString(3, ciid);
            pss.setInt(4, cid);
            
            pss.executeUpdate();
            out.println("Data updated successfully!");
        } else if (request.getParameter("ccode") != null && request.getParameter("cname") != null) {
            int cid = Integer.parseInt(request.getParameter("cid"));
            String ccode = request.getParameter("ccode");
            String cname = request.getParameter("cname");
            String ciid = request.getParameter("ciid");

            pss = conn.prepareStatement("INSERT INTO courses (course_id, course_code, course_name, instructor_name) VALUES (?, ?, ?, ?)");
            pss.setInt(1, cid);
            pss.setString(2, ccode);
            pss.setString(3, cname);
            pss.setString(4, ciid);

            pss.executeUpdate();
            out.println("Data inserted successfully!");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        if (pss != null) ps.close();
        if (conn != null) con.close();
    }
}
%>
</body>
</html>
