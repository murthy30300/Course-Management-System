<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String senderName = request.getParameter("senderName");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");

    Connection con = null;
    PreparedStatement ps = null;
    String responseMessage = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
       // con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
       String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        String sql = "INSERT INTO forum (sender_name, subject, message) VALUES (?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, senderName);
        ps.setString(2, subject);
        ps.setString(3, message);
        ps.executeUpdate();
        responseMessage = "success";
    } catch (Exception e) {
        e.printStackTrace();
        responseMessage = "error";
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }

    response.setContentType("text/plain");
    response.getWriter().write(responseMessage);
%>
