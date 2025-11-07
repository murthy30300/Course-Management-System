<%@ page import="java.sql.*" %>
<%
    String parentId = request.getParameter("parentId");
    String senderName = request.getParameter("senderName");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");
    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
         con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        //con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
        String sql = "INSERT INTO forum (sender_name, subject, message, parentId, isFacultyReply) VALUES (?, ?, ?, ?, 1)";
        ps = con.prepareStatement(sql);
        ps.setString(1, senderName);
        ps.setString(2, subject);
        ps.setString(3, message);
        ps.setInt(4, Integer.parseInt(parentId));
        ps.executeUpdate();
        response.getWriter().write("success");
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("error");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
