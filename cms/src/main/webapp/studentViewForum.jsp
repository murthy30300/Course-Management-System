<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forum</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<a href="studenthome.jsp" style="text-align:center;text-decoration: none;color:blue;border: 1px;padding:20px;border-radius:10px;"><svg
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24"
			height="24" color="#000000" fill="none">
    <path
				d="M4.80823 9.44118L6.77353 7.46899C8.18956 6.04799 8.74462 5.28357 9.51139 5.55381C10.4675 5.89077 10.1528 8.01692 10.1528 8.73471C11.6393 8.73471 13.1848 8.60259 14.6502 8.87787C19.4874 9.78664 21 13.7153 21 18C19.6309 17.0302 18.2632 15.997 16.6177 15.5476C14.5636 14.9865 12.2696 15.2542 10.1528 15.2542C10.1528 15.972 10.4675 18.0982 9.51139 18.4351C8.64251 18.7413 8.18956 17.9409 6.77353 16.5199L4.80823 14.5477C3.60275 13.338 3 12.7332 3 11.9945C3 11.2558 3.60275 10.6509 4.80823 9.44118Z"
				stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
				stroke-linejoin="round" />
</svg>Back To Home</a>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Forum</h2>
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#composeModal">Compose</button>
        <button id="deleteSelected" class="btn btn-danger">Delete Selected</button>
        <button id="editSelected" class="btn btn-warning">Edit Selected</button>
    </div>

    <table class="table table-hover">
        <thead>
        <tr>
            <th scope="col"><input type="checkbox" id="selectAll"></th>
            <th scope="col">Sender Name</th>
            <th scope="col">Subject</th>
            <th scope="col">Message Preview</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
                String dbUser = "avnadmin";
                String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
                 con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
               // con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT id, sender_name, subject, message FROM forum");

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String senderName = rs.getString("sender_name");
                    String subject = rs.getString("subject");
                    String message = rs.getString("message");
        %>
        <tr data-toggle="modal" data-target="#viewMessageModal" data-id="<%= id %>" data-sender="<%= senderName %>" data-subject="<%= subject %>" data-message="<%= message %>">
            <td><input type="checkbox" class="delete-checkbox" value="<%= id %>"></td>
            <td><%= senderName %></td>
            <td><%= subject %></td>
            <td><%= message.length() > 40 ? message.substring(0, 40) + "..." : message %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
        </tbody>
    </table>
</div>

<!-- Compose Modal -->
<div class="modal fade" id="composeModal" tabindex="-1" role="dialog" aria-labelledby="composeModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="composeModalLabel">Compose Query</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="composeForm" action="studentForumAction.jsp" method="post">
                    <div class="form-group">
                        <label for="senderName">Sender Name</label>
                        <input type="text" class="form-control" id="senderName" name="senderName" required>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" class="form-control" id="subject" name="subject" required>
                    </div>
                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea class="form-control" id="message" name="message" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Post</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- View Message Modal -->
<div class="modal fade" id="viewMessageModal" tabindex="-1" role="dialog" aria-labelledby="viewMessageModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewMessageModalLabel">View Message</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h5 id="viewSenderName"></h5>
                <h6 id="viewSubject"></h6>
                <p id="viewMessage"></p>
            </div>
        </div>
    </div>
</div>

<script>$(document).ready(function () {
    $('#selectAll').click(function () {
        $('.delete-checkbox').prop('checked', this.checked);
    });

    $('#viewMessageModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var sender = button.data('sender');
        var subject = button.data('subject');
        var message = button.data('message');

        var modal = $(this);
        modal.find('#viewSenderName').text(sender);
        modal.find('#viewSubject').text(subject);
        modal.find('#viewMessage').text(message);
    });

    $('#composeForm').submit(function (event) {
        event.preventDefault();
        $.ajax({
            type: 'POST',
            url: 'studentForumAction.jsp',
            data: $(this).serialize(),
            success: function (response) {
                if (response.trim() === 'success') {
                    $('#composeModal').modal('hide');
                    alert('Question has been posted successfully!');
                    location.reload();
                } else {
                    alert('An error occurred. Please try again.');
                }
            },
            error: function () {
                alert('An error occurred. Please try again.');
            }
        });
    });

    $('#deleteSelected').click(function () {
        var selectedIds = $('.delete-checkbox:checked').map(function() {
            return $(this).val();
        }).get();

        if (selectedIds.length > 0) {
            if (confirm('Are you sure you want to delete the selected messages?')) {
                $.ajax({
                    type: 'POST',
                    url: 'deleteMessage.jsp',
                    data: { ids: selectedIds },
                    success: function (response) {
                        if (response.trim() === 'success') {
                            alert('Messages have been deleted successfully!');
                            location.reload();
                        } else {
                            alert('An error occurred. Please try again.');
                        }
                    },
                    error: function () {
                        alert('An error occurred. Please try again.');
                    }
                });
            }
        } else {
            alert('Please select at least one message to delete.');
        }
    });

    $('#editSelected').click(function () {
        var selectedCheckboxes = $('.delete-checkbox:checked');
        if (selectedCheckboxes.length === 1) {
            var row = selectedCheckboxes.closest('tr');
            var id = row.data('id');
            var sender = row.data('sender');
            var subject = row.data('subject');
            var message = row.data('message');

            $('#editId').val(id);
            $('#editSenderName').val(sender);
            $('#editSubject').val(subject);
            $('#editMessage').val(message);
            $('#editMessageModal').modal('show');
        } else if (selectedCheckboxes.length > 1) {
            alert('Please select only one message to edit.');
        } else {
            alert('Please select a message to edit.');
        }
    });

    $('#editForm').submit(function (event) {
        event.preventDefault();
        $.ajax({
            type: 'POST',
            url: 'editMessage.jsp',
            data: $(this).serialize(),
            success: function (response) {
                if (response.trim() === 'success') {
                    $('#editMessageModal').modal('hide');
                    alert('Message has been updated successfully!');
                    location.reload();
                } else {
                    alert('An error occurred. Please try again.');
                }
            },
            error: function () {
                alert('An error occurred. Please try again.');
            }
        });
    });

});

</script>

<!-- Edit Message Modal -->
<div class="modal fade" id="editMessageModal" tabindex="-1" role="dialog" aria-labelledby="editMessageModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editMessageModalLabel">Edit Message</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="editForm" action="editMessage.jsp" method="post">
                    <input type="hidden" id="editId" name="id">
                    <div class="form-group">
                        <label for="editSenderName">Sender Name</label>
                        <input type="text" class="form-control" id="editSenderName" name="senderName" required>
                    </div>
                    <div class="form-group">
                        <label for="editSubject">Subject</label>
                        <input type="text" class="form-control" id="editSubject" name="subject" required>
                    </div>
                    <div class="form-group">
                        <label for="editMessage">Message</label>
                        <textarea class="form-control" id="editMessage" name="message" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-warning">Update</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
