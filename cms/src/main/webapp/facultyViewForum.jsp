<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Faculty Forum View</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
	<a href="facultyHome.jsp"
		style="text-align: center; text-decoration: none; color: blue; border: 1px; padding: 20px; border-radius: 10px;">
		Back To Home </a>
	<div class="container mt-4">
		<h2>Forum</h2>
		<table class="table table-hover">
			<thead>
				<tr>
					<th scope="col">Action</th>
					<th scope="col">Sender Name</th>
					<th scope="col">Subject</th>
					<th scope="col">Message Preview</th>
				</tr>
			</thead>
			<tbody>
				<%
				Connection con = null;
				PreparedStatement ps = null;
				ResultSet rs = null;
				try {
					Class.forName("com.mysql.jdbc.Driver");
					// con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
					String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
					String dbUser = "avnadmin";
					String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
					con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
					String sql = "SELECT id, sender_name, subject, message, isFacultyReply FROM forum WHERE parentId IS NULL";
					ps = con.prepareStatement(sql);
					rs = ps.executeQuery();

					while (rs.next()) {
						int id = rs.getInt("id");
						String senderName = rs.getString("sender_name");
						String subject = rs.getString("subject");
						String message = rs.getString("message");
						boolean isFacultyReply = rs.getBoolean("isFacultyReply");
				%>
				<tr>
					<td>
						<button class="btn btn-primary btn-sm"
							onclick="openReplyModal('<%=id%>', '<%=senderName%>', '<%=subject%>')">Reply</button>
						<button class="btn btn-warning btn-sm"
							onclick="openEditModal('<%=id%>', '<%=senderName%>', '<%=subject%>', '<%=message%>')">Edit</button>
						<button class="btn btn-danger btn-sm"
							onclick="deleteMessage('<%=id%>')">Delete</button>
					</td>
					<td><%=senderName%></td>
					<td><%=subject%></td>
					<td><%=message.length() > 40 ? message.substring(0, 40) + "..." : message%></td>
				</tr>
				<%
				// Fetch replies for this question
				String replySql = "SELECT sender_name, message FROM forum WHERE parentId = ?";
				PreparedStatement replyPs = con.prepareStatement(replySql);
				replyPs.setInt(1, id);
				ResultSet replyRs = replyPs.executeQuery();

				while (replyRs.next()) {
					String replySenderName = replyRs.getString("sender_name");
					String replyMessage = replyRs.getString("message");
				%>
				<tr style="background-color: #f9f9f9;">
					<td></td>
					<td><strong>Reply from <%=replySenderName%></strong></td>
					<td colspan="2"><%=replyMessage%></td>
				</tr>
				<%
				}
				replyRs.close();
				replyPs.close();
				}
				} catch (Exception e) {
				e.printStackTrace();
				} finally {
				if (rs != null)
				rs.close();
				if (ps != null)
				ps.close();
				if (con != null)
				con.close();
				}
				%>
			</tbody>
		</table>
	</div>

	<!-- Reply Modal -->
	<div class="modal fade" id="replyModal" tabindex="-1" role="dialog"
		aria-labelledby="replyModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="replyModalLabel">Reply to Question</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="replyForm" action="fpostReply.jsp" method="post">
						<input type="hidden" id="replyId" name="parentId">
						<div class="form-group">
							<label for="replySenderName">Your Name</label> <input type="text"
								class="form-control" id="replySenderName" name="senderName"
								required>
						</div>
						<div class="form-group">
							<label for="replySubject">Subject</label> <input type="text"
								class="form-control" id="replySubject" name="subject" readonly>
						</div>
						<div class="form-group">
							<label for="replyMessage">Message</label>
							<textarea class="form-control" id="replyMessage" name="message"
								rows="4" required></textarea>
						</div>
						<button type="submit" class="btn btn-primary">Post Reply</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script>
		function openReplyModal(id, senderName, subject) {
			$('#replyId').val(id);
			$('#replySenderName').val('Faculty'); // or use the faculty's actual name if available
			$('#replySubject').val(subject);
			$('#replyMessage').val('');
			$('#replyModal').modal('show');
		}

		function openEditModal(id, senderName, subject, message) {
			// Populate the edit form with the existing data
			$('#editId').val(id);
			$('#editSenderName').val(senderName); // If you allow changing the sender name
			$('#editSubject').val(subject);
			$('#editMessage').val(message);

			// Show the edit modal
			$('#editModal').modal('show');
			e
		}

		function deleteMessage(id) {
			if (confirm('Are you sure you want to delete this message?')) {
				$.ajax({
					type : 'POST',
					url : 'fdeleteForum.jsp',
					data : {
						id : id
					},
					success : function(response) {
						if (response.trim() === 'success') {
							alert('Message deleted successfully!');
							location.reload();
						} else {
							alert('Error deleting message.');
						}
					},
					error : function() {
						alert('An error occurred while deleting the message.');
					}
				});
			}
		}
	</script>
	<!-- Edit Modal -->
	<div class="modal fade" id="editModal" tabindex="-1" role="dialog"
		aria-labelledby="editModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editModalLabel">Edit Message</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="editForm" action="fupdateForum.jsp" method="post">
						<input type="hidden" id="editId" name="id">
						<div class="form-group">
							<label for="editSenderName">Sender Name</label> <input
								type="text" class="form-control" id="editSenderName"
								name="senderName" readonly>
						</div>
						<div class="form-group">
							<label for="editSubject">Subject</label> <input type="text"
								class="form-control" id="editSubject" name="subject" required>
						</div>
						<div class="form-group">
							<label for="editMessage">Message</label>
							<textarea class="form-control" id="editMessage" name="message"
								rows="4" required></textarea>
						</div>
						<button type="submit" class="btn btn-primary">Save
							Changes</button>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
