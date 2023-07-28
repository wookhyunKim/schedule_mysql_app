<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String url_mysql = "jdbc:mysql://localhost/scheduler?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
    String id_mysql = "root";
    String pw_mysql = "qwer1234";
	String uid = request.getParameter("uid");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    int amount = Integer.parseInt(request.getParameter("amount"));
    String duedate = request.getParameter("date");
    int state = Integer.parseInt(request.getParameter("state"));
    String WhereDefault = "insert into accountbook (ab_uid, ab_title, ab_content, ab_amount, ab_confirmdate, ab_confirm, ab_insertdate) value (?,?,?,?,?,?,now())";

    JSONObject jsonList = new JSONObject();
    JSONArray itemList = new JSONArray();
    PreparedStatement ps = null;
    ResultSet rs = null; // Declare the ResultSet

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
        
        ps.setString(1, uid); // Set the parameter on the PreparedStatement
        ps.setString(2, title); // Set the parameter on the PreparedStatement
        ps.setString(3, content); // Set the parameter on the PreparedStatement
        ps.setInt(4, amount); // Set the parameter on the PreparedStatement
        ps.setString(5, duedate); // Set the parameter on the PreparedStatement
        ps.setInt(6, state); // Set the parameter on the PreparedStatement

        ps.executeUpdate();
	
        conn_mysql.close();
%>
{"result":"OK"}	
<%			
    } 
    catch (Exception e){
%>		
{"result":"ERROR"}	
<%		
    }
%>
