<%@ page import="java.util.*,java.sql.*" %>
<%

    HttpSession session12 = request.getSession(false);
    if (session12 == null || session12.getAttribute("admin") == null) {
        response.sendRedirect("index.jsp");
    }

    String message = "";
    String action = request.getParameter("action");

    if ("update".equals(action)) {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String existingPassword = request.getParameter("existingPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Password validation logic
        boolean valid = true;
        if (newPassword.length() < 8) {
            message = "Password must be at least 8 characters long.";
            valid = false;
        } else if (!newPassword.matches(".*[A-Z].*")) {
            message = "Password must contain at least one uppercase letter.";
            valid = false;
        } else if (!newPassword.matches(".*[a-z].*")) {
            message = "Password must contain at least one lowercase letter.";
            valid = false;
        } else if (!newPassword.matches(".*\\d.*")) {
            message = "Password must contain at least one number.";
            valid = false;
        } else if (!newPassword.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            message = "Password must contain at least one special character.";
            valid = false;
        } else if (!newPassword.equals(confirmPassword)) {
            message = "New password and confirmation password do not match.";
            valid = false;
        }

        if (valid) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                //Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                // Validate existing password
                String checkPasswordQuery = "SELECT password FROM users WHERE student_id = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkPasswordQuery);
                checkStmt.setInt(1, studentId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    String currentPassword = rs.getString("password");

                    if (currentPassword.equals(existingPassword)) {
                        // Update password
                        String updatePasswordQuery = "UPDATE users SET password = ? WHERE student_id = ?";
                        PreparedStatement updateStmt = con.prepareStatement(updatePasswordQuery);
                        updateStmt.setString(1, newPassword);
                        updateStmt.setInt(2, studentId);
                        updateStmt.executeUpdate();
                        updateStmt.close();
                        message = "Password updated successfully.";
                    } else {
                        message = "Existing password is incorrect.";
                    }
                } else {
                    message = "Student ID not found.";
                }

                rs.close();
                checkStmt.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            }
        }
    }
%>
