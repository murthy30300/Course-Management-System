<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String senderName = request.getParameter("senderName");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");

    Connection con = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://mysql-1811be34-slack-to-surplus.k.aivencloud.com:26890/db?sslmode=require";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_dn_iG7IFkq48bsf3Mzl";
        con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        //con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "admin");
        String sql = "UPDATE forum SET sender_name = ?, subject = ?, message = ? WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, senderName);
        pstmt.setString(2, subject);
        pstmt.setString(3, message);
        pstmt.setInt(4, id);
        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("error");
    } finally {
        if (pstmt != null) pstmt.close();
        if (con != null) con.close();
    }
%>