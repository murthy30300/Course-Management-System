<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieve parameters from the request
    int id = Integer.parseInt(request.getParameter("id"));
    String senderName = request.getParameter("senderName");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");

    Connection con = null;
    PreparedStatement ps = null;
    String responseMessage = "";

    try {
        // Load the MySQL driver
        Class.forName("com.mysql.jdbc.Driver");
        // Establish connection to the database
        //con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        // SQL query to update the forum entry
        String sql = "UPDATE forum SET sender_name = ?, subject = ?, message = ? WHERE id = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, senderName);
        ps.setString(2, subject);
        ps.setString(3, message);
        ps.setInt(4, id);
        
        // Execute the update
        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            responseMessage = "success";
        } else {
            responseMessage = "error";
        }
    } catch (Exception e) {
        e.printStackTrace();
        responseMessage = "error";
    } finally {
        // Close the database resources
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }

    // Send response back to the client
    response.setContentType("text/plain");
    response.getWriter().write(responseMessage);
%>
